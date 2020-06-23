% Written by Adam J. Peterson
%
% SIMULATE_HOMOGENEOUS_POISSON_EVENTS Generates random event times from 
% a constant-rate stochastic point process.
%
% tEvents = SIMULATE_HOMOGENEOUS_POISSON_EVENTS(pevent, t, dt, nreps)
% generates event times for nreps repetitions of the stochastic process 
% defined by time points t (in ms), scalar event probability pevent (in 
% probability per time step), and time step dt (in ms). Note that 
% t must be a row vector and pevent, dt, and nreps must be scalars.
%
% See also SIMULATE_INHOMOGENEOUS_POISSON_EVENTS, SIMULATE_INHOMOGENEOUS_POISSON_EVENTS_VIA_THINNING, APPLY_DEAD_TIMES.

function tEvents = simulate_homogeneous_poisson_events(pevent, t, dt, nreps)

    % Check that pevent is valid
    if numel(pevent)~=1
        error('''pevent'' must be scalar.');
    end
    if any(pevent>1)
        error('''pevent'' must not exceed 1 at any time point.');
    end

    % Check that dt and nreps are valid
    if numel(dt)~=1 || numel(nreps)~=1
        error('Both ''dt'' and ''nreps'' must be scalars.')
    end

    % Compute number of IEIs to simulate per repetition assuming MEAN(n)+2*STD(n)
    % (see wikipedia.org/wiki/Poisson_binomial_distribution for equations)
    mean_count = ceil(sum(pevent));
    std_count = ceil(sqrt(sum((1-pevent).*pevent)));
    nsim = mean_count + 2*std_count;

    tmin = t(1)-dt;

    % Save the current random number generator to revert back to after execution
    original_rng = rng;

    try
        % Use the simdTwister random number generator, faster than the default one        
        rng('shuffle','simdTwister');

        % Draw random IEIs from geometric distribution (discrete equivalent to exp)
        IEIs = dt.*(1+geornd(pevent,nreps, nsim));
        tEvents = tmin+cumsum(IEIs,2);
        
        % Determine whether more IEIs are needed to reach the end of the process
        boolProlong = decround(tEvents(:,end),dt) < t(end);

        % Check if process needs to be prolonged to reach end of observation window
        while any(boolProlong)
            % Add more IEIs and recompute the event times
            nprolong = sum(boolProlong);
            nextra = max(2,ceil(nsim/10));
            idxCols = size(IEIs,2)+(1:nextra);
            IEIs(boolProlong,idxCols) = dt.*(1+geornd(pevent,nprolong, nextra));
            IEIs(~boolProlong,idxCols(1)) = NaN;
            tEvents(:,idxCols) = tEvents(:,end)+cumsum(IEIs(:,idxCols),2);

            % Determine whether more IEIs are needed to reach the end of the process
            boolProlong = decround(tEvents(:,end),dt) < t(end);
        end

        % Round to nearest time step in case of MATLAB imprecision
        tEvents = decround(tEvents, dt);

        % Remove events outside of the observation window
        tEvents(tEvents>t(end)) = NaN;

        % Remove columns with no events
        tEvents = tEvents(:,any(tEvents,1));

    catch
        % Set the random number generator back to whatever it was before running 
        % this code (some people will have reasons to care about this)
        rng(original_rng);
        error('Exception thrown in simulate_homogeneous_poisson_events.m')
    end

    % Set the random number generator back to whatever it was before running 
    % this code (some people will have reasons to care about this)
    rng(original_rng);

end
