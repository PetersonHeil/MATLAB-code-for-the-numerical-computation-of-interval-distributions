% Written by Adam J. Peterson
%
% NOTES: 
%
% (1) Due to possible precision errors in MATLAB's computations, it is necessary to 
% round any potential IDI to the nearest time step before comparing it to the dead 
% time. Frequent rounding is computationally expensive, so I use a different (but 
% equivalent) approach. Instead of computing IDIs by subtacting TIMES, I compute them 
% by subtracting NUMBERS OF TIME BINS/STEPS and then looking up the duration in d 
% (which was previously rounded to be free from MATLAB's precision errors). To 
% demonstrate this issue, find the section below marked "DEMONSTRATION".
%
% (2) The prefix "bin" is used when referring to the integer NUMBER OF TIME BINS of 
% width dt fitting in a value of a given time point t (referrenced to 0, such that
% t=[dt, 2dt, 3dt, ..., ndt] respectively correspond to bin=[1, 2, 3, ..., n]).
%
% (3) The prefix "i" is used whenever something (e.g., repetitions, event times, or
% dead times) is stepped through one at a time.

function tDetections = apply_dead_times(tEvents, Gdead, d, dt)

    % If event times are a single column (many reps, one element each), then the 
    % input is probably meant to be a single row (one rep, many elements). Issue 
    % a warning to the user.
    if iscolumn(tEvents) && numel(tEvents)>1
        warning('Each repetition has only a single element. If you have only one repetition, then transpose tEvents.')
    end

    % Count the number of repetitions
    nReps = size(tEvents,1);

    % Draw first pool of random dead times (drawing dead times in bulk is much more 
    % efficient than drawing them one-by-one)
    nPerDeadTimePool = 100000;
    deadTimePool = draw_dead_times(Gdead, d, nPerDeadTimePool);
    iNextDeadTime = 1;

    % Count the number of events per repetition, which is used below to avoid looping
    % through all the NaNs padding the ends of most repetitions
	nEventsPerRep = sum(~isnan(tEvents),2);
    
	% Compute integer number of time bins fitting into each event time
	binEvents = round(tEvents./dt);
    
    % Apply stochastic dead-time effects to each repetition
    for iRep = 1:nReps

        % Assume detector is not in dead state at start of each observation window
        ddead = 0;
        
        % There is no "previous detection" yet, but for the purpose of calculating
        % the IDI for the first event in the repetition, initialize the bin of the 
        % previous detection to the bin just prior to the first event. The first
        % event will be detected no matter what, because ddead is initialzied to 0.
        binPreviousDetection = binEvents(iRep,1)-1;

        % Apply refractory effects
        for iEvent = 1:nEventsPerRep(iRep)

            % Get the bin of the current event
            binCurrentEvent = binEvents(iRep,iEvent);

            % Compute interval between previous detection and current event
            try
                IDI = d(binCurrentEvent - binPreviousDetection);

                % DEMONSTRATION: compute intervals by subtracting times instead of by
                % subtracting the number of time bins as above. The final argument in
                % the function below determines whether to round the IDI to the nearest 
                % time step. If TRUE, it will produce the correct result, but at enornous 
                % computational cost if called many tmies. If FALSE, it will produce tiny
                % numerical imprecision for some IDIs and mess up the comparison to the 
                % dead time. Uncomment one of the following lines to demonstrate this:
                % IDI = helper_compute_IDI_imprecisely(d, binCurrentEvent, binPreviousDetection, dt, false);
                % IDI = helper_compute_IDI_imprecisely(d, binCurrentEvent, binPreviousDetection, dt, true);  
            catch ex
                error('There was an unexpected error while computing a potential IDI.')
            end

            % Check whether the dead time exceeds the potential IDI (i.e., check 
            % whether the current event is detected)
            if ddead >= IDI
                % Current event is not detected
                
                % Remove current event from the list
                tEvents(iRep,iEvent) = NaN;
            else
                % Current event is detected
                
                % Update the bin of the previous detection
                binPreviousDetection = binCurrentEvent;

                % Check whether current pool of dead-times is used up
                if iNextDeadTime == nPerDeadTimePool+1
                    % Draw next pool of random dead times
                    deadTimePool = draw_dead_times(Gdead, d, nPerDeadTimePool);
                    iNextDeadTime = 1;
                end

                % Select the next dead time from the dead-time pool
                ddead = deadTimePool(iNextDeadTime);
                iNextDeadTime = iNextDeadTime+1;

            end
        end
    end

    % Sort remaining (i.e., detected) events so NaNs are at the end of each repetition
    tDetections = sort(tEvents,2);

    % Remove all columns with only NaNs
    tDetections = tDetections(:,~all(isnan(tDetections),1));

end


% Function to compute IDIs by subtracting times (rather than by subtacting numbers of
% time steps). The final argument determines whether to round the IDI to the nearest 
% time step. Overall, you should not compute IDIs with this function; it is included 
% here only to demonstrate why a subtraction of numbers of time steps is preferable.
function IDI = helper_compute_IDI_imprecisely(d, binCurrentEvent, binPreviousDetection, dt, doRound)

    if binPreviousDetection==0
        % If evaluating the first event of the repetition, just return inf (we could 
        % actually return any positive value; it just needs to be something longer 
        % than the inital 'dead time' of 0 ms)
        IDI = inf;
    else
        % If evaluating subsequent events in the repetition, compute the interval
        % by subtracting the previous detection time from the current event time
        IDI = d(binCurrentEvent) - d(binPreviousDetection);
        
        % Rounding this value fixes the numerical error, but it's very slow if this 
        % has to be done many times. Uncomment to include rounding:
        if doRound
            IDI = decround(IDI, dt);
        end
    end

end
