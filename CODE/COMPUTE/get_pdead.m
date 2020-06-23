function vars = get_pdead(vars)

    % Start timer
    timer_tic = tic;

    switch vars.settings.Rtype

        case 'event'

            % Given that pevent is known, compute pdead and pdetection
            [vars.window.pdead, vars.window.pdetection] = compute_pdead_and_pdetection(vars.window.t, vars.window.pevent, vars.deadtime.Sdead);
            % Scale detection rate to detection probability
            vars.window.Rdetection = vars.window.pdetection./vars.window.dt.*1000;

        case 'detection'
            
            % Given that pdetection is known, compute pdead and pevent
            [vars.window.pdead, vars.window.pevent] = compute_pdead_and_pevent(vars.window.t, vars.window.pdetection, vars.deadtime.Sdead);            
            % Scale event rate to event probability
            vars.window.Revent = vars.window.pevent./vars.window.dt.*1000;

            % If event rate is periodic (i.e., values separated by some fixed integer 
            % number of bins are *exactly* the same), then it is possible to use a 
            % computational shortcut when computing fevent and fdetection. Determine 
            % whether periodicity exists and get the number of bins per cycle.
            vars.window.nBinsPerCycle = get_periodicity(vars.window.Revent, vars.settings.TolCompare);

    end

    % End timer and display
    vars.time.Step1 = toc(timer_tic);
    if vars.settings.doDisplay
        disp(['   --> Step 1 took ' num2str(vars.time.Step1) ' s to compute ''pdetection'' and ''pdead''.'])
    end

end
