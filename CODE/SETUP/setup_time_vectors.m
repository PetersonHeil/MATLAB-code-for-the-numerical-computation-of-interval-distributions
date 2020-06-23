function vars = setup_time_vectors(vars)

    tmin = vars.window.tmin;
    tmax = vars.window.tmax;
    dt = vars.window.dt;
    
    if tmin>=tmax
        error('The specified ''tmin'' is not smaller than the specified ''tmax''.')
    end
    
    if rem(tmax-tmin,dt)
        error('The specified ''dt'' does not fit an interger number of times into the observation window.')
    end

    % In MATLAB's histogram or histcounts functions, a value falls into a bin when it 
    % is GREATER THAN OR EQUAL to the left edge and LESS THAN the right edge. Here, 
    % I use the opposite, such that a value falls into a bin when it is GREATER THAN 
    % the left edge and LESS THAN OR EQUAL TO the right edge. One exception is the first 
    % bin, which also includes values equal to the left edge. There isn't really any 
    % true 'binning' applied in this numerical method; I explain this only so that 
    % the approach is conceptually clear. The histcounts function is used for the
    % simulation results, so care has been made to ensure that MATLAB does it how I
    % want.

	% Setup values for observation window
    vars.window.npoints = (tmax-tmin)/dt;                                           % Compute number of bins
    vars.window.edges = tmin:dt:tmax;                                               % Bin edges
    vars.window.edges = decround(vars.window.edges, dt);                            % Round to ensure precision
    vars.window.t = vars.window.edges(2:end);                                       % Time vector t

 	% Setup values for deadtime distribution
    vars.deadtime.d = dt:dt:(tmax-tmin);                                            % Dead-time vector d
    vars.deadtime.d = decround(vars.deadtime.d, dt);                                % Round to the nearest time step
    vars.deadtime.npoints = numel(vars.deadtime.d);                                 % Number of bins

    % Setup values for recurrence distributions
    vars.recurrence.w = dt:dt:(tmax-tmin-dt);                                       % Time vector t
    vars.recurrence.w = decround(vars.recurrence.w, dt);                            % Round to the nearest time step
    vars.recurrence.npoints = numel(vars.recurrence.w);                             % Number of bins
    vars.recurrence.edges = dt:dt:(tmax-tmin);  % Bin edges
    vars.recurrence.edges = decround(vars.recurrence.edges, dt);                    % Round to nearest timestep

    % Setup values for interval distributions
    vars.interval.w = dt:dt:(tmax-tmin-dt);                                         % Time vector t
    vars.interval.w = decround(vars.interval.w, dt);                                % Round to the nearest time step
    vars.interval.npoints = numel(vars.interval.w);                                 % Number of bins
    vars.interval.edges = dt:dt:(tmax-tmin);                                        % Bin edges
    vars.interval.edges = decround(vars.interval.edges, dt);                        % Round to the nearest time step

end
