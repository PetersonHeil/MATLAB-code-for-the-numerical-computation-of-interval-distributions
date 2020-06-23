function vars = execute_method(vars)

    % Start timer
    total_tic = tic;

    % SETUP: Create some strings and save path
    vars = setup_strings(vars);

    % SETUP: Create all time vectors
    vars = setup_time_vectors(vars);

    % PREREQUISITE 1: Compute the given rate function
    vars = setup_given_rate(vars);

    % PREREQUISITE 2: Compute the given dead-time distribution
    vars = setup_dead_time_distribution(vars);

    % STEP 1: Compute 'pdead' (and whichever of 'pevent' and 'pdetection' is unknown)
    vars = get_pdead(vars);

    % STEP 2: Compute 'fEvent' (i.e., recurrence distributions without dead-time effects)
    vars = get_fevent(vars);

    % STEP 3: Compute 'fDetection' (i.e., recurrence distributions with dead-time effects)
    vars = get_fdetection(vars);

    % STEP 4: Compute 'RIEI' and 'RIDI' (i.e., interval distributions)
    vars = get_interval_distributions(vars);

    % Perform stochastic simulations and compute functions to compare to numerical method
    vars = get_simulation(vars);

    % Compute limits for all vertical axes before plotting anything
    vars = compute_plot_limits(vars);

    % Plot result of numerical steps
    if vars.settings.doPlotSteps
        vars = plot_steps(vars);
    end
    
    % Plot interval distributions
    if vars.settings.doPlotSim
        plot_simulation(vars);
    end

    % Compare the various implementations of each step to verify their equivalence
    if vars.settings.doCompare
        compare_implementations(vars)
    end

    % Save 'vars' structure
    if vars.settings.doSave
        save([vars.strings.savePath 'vars (with sim nreps=' num2str(vars.sim.nreps) ')'], 'vars')
    end
    
    % Save execution time
    vars.time.Total = toc(total_tic);
    
    % End timer and display
    if vars.settings.doDisplay
        disp(['   --> TOTAL EXECUTION TIME WAS ' num2str(vars.time.Total) ' s.'])
    end

end