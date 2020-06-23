% Written by Adam J. Peterson
%
% SIMULATE_INHOMOGENEOUS_POISSON_EVENTS_VIA_THINNING Generates random event times from 
% a rate-varying stochastic point process using the 'thinning' method.
%
% tEvents = SIMULATE_INHOMOGENEOUS_POISSON_EVENTS_VIA_THINNING(pevent, t, dt, nreps)
% generates event times for nreps repetitions of the stochastic process 
% defined by time points t (in ms), event probability vector pevent (in 
% probability per time step), and time step dt (in ms). Note that 
% pevent and t must be row vectors of identical size and dt and nreps 
% must be scalars.
%
% See also SIMULATE_INHOMOGENEOUS_POISSON_EVENTS_VIA_THINNING, SIMULATE_HOMOGENEOUS_POISSON_EVENTS, APPLY_DEAD_TIMES.

function tEvents = simulate_inhomogeneous_poisson_events_via_thinning(pevent, t, dt, nreps)

    % Check that pevent is valid
    if any(pevent>1)
        error('''pevent'' must not exceed 1 at any time point.');
    end

    % Simulate homogeneous process with a constant rate equal to the maximum rate
    hom_pevent = repmat(max(pevent), size(t));
    tEvents = simulate_homogeneous_poisson_events(hom_pevent, t, dt, nreps);
    idxEvents = round(tEvents/dt - (t(1)-dt)/dt);

    pEvents = nan(size(idxEvents));
    idxNotNaN = find(~isnan(idxEvents));
    pEvents(idxNotNaN) = pevent(idxEvents(idxNotNaN));

    try
        % Use the simdTwister random number generator, faster than the default one        
        rng('shuffle','simdTwister');

        % Thin homogeneous process to yield inhomogeneous process
        % Based on https://hpaulkeeler.com/simulating-an-inhomogeneous-poisson-point-process/
        p_removed = 1-pEvents./max(pevent);
        bool_removed = rand(size(pEvents)) < p_removed;        
        tEvents(bool_removed) = NaN;

        % Sort event times
        tEvents = sort(tEvents,2);

        % Remove columns with no events
        tEvents = tEvents(:,any(tEvents,1));

    catch
        % Set the random number generator back to whatever it was before running 
        % this code (some people will have reasons to care about this)
        rng(original_rng);
        error('Exception thrown in simulate_inhomogeneous_poisson_events_via_thinning.m')
    end

    % Set the random number generator back to whatever it was before running 
    % this code (some people will have reasons to care about this)
    rng(original_rng);

end
