function vars = get_simulation(vars)

    % Start timer
    timer_tic = tic;

    % Check if there are repetitions to simulate
    if vars.sim.nreps > 0

        % Create a copy of 'sim'
        sim = vars.sim;

        % Simulate event times
        if vars.window.nBinsPerCycle==1
            % Homogeneous process (the homogeneous implementation is usually
            % more efficient than the inhomogeneous one, although either would work)
            if vars.settings.doDisplay
                disp('       > Simulating homogeneous event process.')
            end
            sim.process.tEvents = simulate_homogeneous_poisson_events(vars.window.pevent(1), vars.window.t, vars.window.dt, sim.nreps);
        else
            % Inhomogeneous process
            if vars.settings.doDisplay
                disp('       > Simulating inhomogeneous event process.')
            end

            % If no simulation method is specified, use the default
            if ~isfield(sim, 'process') || ~isfield(sim.process, 'type')
                sim.process.type = 'default';
            end
            
            % Execute specified simulation method
            switch sim.process.type
                case 'default'
                    % Simulate process by drawing random number for each time step (usually not the fastest method, but not always the slowest!)
                    sim.process.tEvents = simulate_inhomogeneous_poisson_events(vars.window.pevent, vars.window.t, vars.window.dt, sim.nreps);
                case 'thinning'
                    % Simulate process via thinning of a homogeneous process
                    sim.process.tEvents = simulate_inhomogeneous_poisson_events_via_thinning(vars.window.pevent, vars.window.t, vars.window.dt, sim.nreps);
                otherwise
                    error('Invalid simulation method specified. Options are ''default'', ''thinning'', and ''rescaling''.')
            end
        end

        % Compute IEIs and round to nearest time step in case of MATLAB imprecision
        sim.interval.IEIs = diff(sim.process.tEvents,1,2);
        sim.interval.IEIs = decround(sim.interval.IEIs, vars.window.dt);

        % Draw and apply random dead times to obtain detection times
        if vars.settings.doDisplay
            disp('       > Applying random dead times.')
        end
        sim.process.tDetections = apply_dead_times(sim.process.tEvents, vars.deadtime.Gdead, vars.deadtime.d, vars.window.dt);

        % Compute IDIs and round to nearest time step in case of MATLAB imprecision
        sim.interval.IDIs = diff(sim.process.tDetections,1,2);
        sim.interval.IDIs = decround(sim.interval.IDIs, vars.window.dt);
 
        % Compute IEI distribution
        DIST = calculateDistributionFromIntervals(sim.interval.IEIs(~isnan(sim.interval.IEIs)), 'dt', vars.window.dt, 'dt_hist', vars.window.dt, 'histEdges', vars.interval.edges, 'type', 'PDF', 'tmax', vars.window.tmax-vars.window.dt);
        sim.interval.RIEI = DIST.PDF.*1000;

        % Compute IDI distribution
        DIST = calculateDistributionFromIntervals(sim.interval.IDIs(~isnan(sim.interval.IDIs)), 'dt', vars.window.dt, 'dt_hist', vars.window.dt, 'histEdges', vars.interval.edges, 'type', 'PDF', 'tmax', vars.window.tmax-vars.window.dt);
        sim.interval.RIDI = DIST.PDF.*1000;

        % SIM: CALC COUNTS, RATES, PROBABILITIES FOR THE OBSERVATION WINDOW
        % Note: a small value (here, 1/100th of the time step) is subtracted from all
        % simulated event and detection times to ensure that values fall into the 
        % bins we want. We want each time point to be placed into the bin whose right 
        % edge matches it. By default, histcounts would place each into the next bin.
        sim.window.nevent = histcounts(sim.process.tEvents-vars.window.dt/100, 'BinEdges', vars.window.edges);
        sim.window.pevent = sim.window.nevent/sim.nreps;
        sim.window.Revent = sim.window.pevent*1000/vars.window.dt;
        sim.window.ndetection = histcounts(sim.process.tDetections-vars.window.dt/100, 'BinEdges', vars.window.edges);
        sim.window.pdetection = sim.window.ndetection/sim.nreps;
        sim.window.Rdetection = sim.window.pdetection*1000/vars.window.dt;

        % Compute mean number of detections per repetition
        sim.process.nDetection_mean = sum(sim.window.ndetection)./sim.nreps;

        % Compute probability of zero events (or zero detections, same thing)
        sim.process.pzero = sum(all(isnan(sim.process.tDetections),2))./sim.nreps;

        % Save 'sim' back to results structure
        vars.sim = sim;

    end

    % End timer and display
    vars.time.Simulations = toc(timer_tic);
    if vars.settings.doDisplay
        disp(['   --> Simulations took ' num2str(vars.time.Simulations) ' s.'])
    end

end

