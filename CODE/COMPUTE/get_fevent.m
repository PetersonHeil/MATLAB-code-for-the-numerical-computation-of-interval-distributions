function vars = get_fevent(vars)

    % Start timer
    timer_tic = tic;
    
    % Compute fevent
    vars.recurrence.fevent = compute_fevent_quick(vars.recurrence.npoints, vars.window.nBinsPerCycle, vars.window.pevent, vars.settings.doDisplay);

    % End timer and display
    vars.time.Step2 = toc(timer_tic);
    if vars.settings.doDisplay
        disp(['   --> Step 2 took ' num2str(vars.time.Step2) ' s to compute ''fevent''.'])
    end

end