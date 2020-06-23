function vars = get_fdetection(vars)

    % Start timer
    timer_tic = tic;

    % Compute fdetection
    vars.recurrence.fdetection = compute_fdetection_quick(vars.recurrence.npoints, vars.window.nBinsPerCycle, vars.deadtime.gdead, vars.recurrence.fevent, vars.settings.doDisplay, vars.settings.doUseMEX);

    % Save execution time
    vars.time.Step3 = toc(timer_tic);

    % End timer and display
    if vars.settings.doDisplay
        disp(['   --> Step 3 took ' num2str(vars.time.Step3) ' s to compute ''fdetection''.'])
    end

end