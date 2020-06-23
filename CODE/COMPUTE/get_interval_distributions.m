function vars = get_interval_distributions(vars)

    % Start timer
    timer_tic = tic;

    % Compute RIEI and RIDI
    [vars.interval.RIDI, vars.interval.pIDI, vars.interval.nIDIs] = compute_interval_distribution(vars.window.pevent, vars.window.pdetection, vars.recurrence.fdetection, vars.window.dt, vars.window.tmax-vars.window.tmin);
    [vars.interval.RIEI, vars.interval.pIEI, vars.interval.nIEIs] = compute_interval_distribution(vars.window.pevent, vars.window.pevent, vars.recurrence.fevent, vars.window.dt, vars.window.tmax-vars.window.tmin);

    % End timer and display
    vars.time.Step4 = toc(timer_tic);
    if vars.settings.doDisplay
        disp(['   --> Step 4 took ' num2str(vars.time.Step4) ' s to compute ''RIEI'' and ''RIDI''.'])
    end

end
