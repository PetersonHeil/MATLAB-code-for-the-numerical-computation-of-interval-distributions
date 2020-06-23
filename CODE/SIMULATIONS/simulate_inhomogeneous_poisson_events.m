% Written by Adam J. Peterson
%
% SIMULATE_INHOMOGENEOUS_POISSON_EVENTS Generates random event times from 
% a rate-varying stochastic point process.
%
% tEvents = SIMULATE_INHOMOGENEOUS_POISSON_EVENTS(pevent, t, dt, nreps)
% generates event times for nreps repetitions of the stochastic process 
% defined by time points t (in ms), event probability vector pevent (in 
% probability per time step), and time step dt (in ms). Note that 
% pevent and t must be row vectors of identical size and dt and nreps 
% must be scalars.
%
% See also SIMULATE_INHOMOGENEOUS_POISSON_EVENTS_VIA_THINNING, SIMULATE_HOMOGENEOUS_POISSON_EVENTS, APPLY_DEAD_TIMES.

function tEvents = simulate_inhomogeneous_poisson_events(pevent, t, dt, nreps)
    % This function includes several design choices which might seem somewhat odd.
    % However, from start to finish, every major choice was made in an attempt to 
    % maximize performance. The code could certainly be implemented in a more 
    % straightforard way, but I have found no way that is more efficient. If it is 
    % still too slow, try to simulate the process by 'thinning'.

    % Check that pevent is valid
    if any(pevent>1)
        error('''pevent'' must not exceed 1 at any time point.');
    end

    % Check that rate and time vectors have the same number of elements
    if ~isequal(size(pevent), size(t))
        error('''pevent'' and ''t'' must have the same number of elements.');
    end
    
    % Check that dt and nreps are valid
    if numel(dt)~=1 || numel(nreps)~=1
        error('Both ''dt'' and ''nreps'' must be scalars.')
    end

    % Preallocate matrix to hold event times assuming MEAN(n)+2*STD(n) per repetition
    % (see wikipedia.org/wiki/Poisson_binomial_distribution for equations)
    mean_count = ceil(nansum(pevent));
    std_count = ceil(sqrt(nansum((1-pevent).*pevent)));
    npreallocate = mean_count + 2*std_count;
    tEvents = nan(nreps, npreallocate);

    % Count number of time points
    npoints = numel(t);

	% Compute how many blocks of repetitions to simulate, how many repetitions per block, etc.    
    [n_blocks, n_reps_per_block, idxStart, idxEnd] = helper_plan_blocks(npoints, nreps);
    
    % Save the current random number generator to revert back to after execution
    original_rng = rng;

    try
        % Use the simdTwister random number generator, faster than the default one        
        rng('shuffle','simdTwister');

        % Simulate each block
        for iBlock=1:n_blocks

            % Draw random numbers to determine whether event occurs at each point
            boolHasEvent = bsxfun(@gt, pevent, rand(n_reps_per_block(iBlock), npoints));

            % Extract event times
            tEvents_block = t.*boolHasEvent;
            tEvents_block(tEvents_block==0) = NaN;

            % If t=0 is allowed, add them back in (the previous step set them to NaN)
            tEvents_block(boolHasEvent(:, t==0),t==0) = 0;

            % Sort event times to put all NaNs at the end
            tEvents_block = sort(tEvents_block,2);

            % Remove all columns with no events (e.g., with only NaNs)
            tEvents_block = tEvents_block(:,any(tEvents_block,1));

            % Count the columns in the new block of results
            nCols_curr = size(tEvents_block,2);

            % Count the columns in tEvents before inserting new block of results
            nCols_prev = size(tEvents,2);

            % Compute row and column indices for inserting new block of results
            idxReps = idxStart(iBlock):idxEnd(iBlock);
            idxCols = 1:size(tEvents_block,2);
            
            % Insert new block results
            tEvents(idxReps,idxCols) = tEvents_block;

            % For prior blocks, changes any zeros from matrix expansion to NaN
            tEvents(1:idxStart(iBlock)-1, nCols_prev+1:end) = NaN;

            % For current block, change zeros from unused columns to NaN
            tEvents(idxReps, nCols_curr+1:nCols_prev) = NaN;

        end
    catch
        % Set the random number generator back to whatever it was before running 
        % this code (some people will have reasons to care about this)
        rng(original_rng);
        error('Exception thrown in simulate_inhomogeneous_poisson_events.m')
    end
    
    % Set the random number generator back to whatever it was before running 
    % this code (some people will have reasons to care about this)
    rng(original_rng);

end





function [n_blocks, n_reps_per_block, idxStart, idxEnd] = helper_plan_blocks(npoints, nreps)

    % Specify constants
    GB_allowed_per_block = 0.5;                                                     % GB of RAM allowed to be used per block
    bytes_per_element = 8;                                                          % Size of a double
    bytes_per_GB = 1e+9;                                                            % Size of a GB

    % Compute number of GB needed per repetition
    GB_per_rep = npoints*bytes_per_element./bytes_per_GB;

    % Compute number of repetitions per block
    n_reps_per_block = min(nreps, max(1, floor(GB_allowed_per_block/GB_per_rep)));

    % Compute indices of start and end of each block
    idxStart = 1:n_reps_per_block:nreps;
    idxEnd = (n_reps_per_block:n_reps_per_block:nreps);
    if idxEnd(end) < nreps
        idxEnd = [idxEnd nreps];
    end
    
    % Recompute n_reps_per_block, but now for each block (the final one might 
    % have fewer than the others)
    n_reps_per_block = idxEnd-idxStart+1;

    % Compute number of blocks to perform
    n_blocks = numel(idxStart);

end