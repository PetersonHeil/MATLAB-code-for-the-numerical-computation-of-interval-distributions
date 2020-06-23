function vars = setup_given_rate(vars)

    % Get specified rate function
    switch lower(vars.settings.Rtype)

        case 'event'

            % Setup event rate according to specified rate function
            vars.window.Revent = vars.settings.Rfunction(vars);
            % Scale event rate to event probability
            vars.window.pevent = vars.window.Revent.*vars.window.dt./1000;

            % If event rate is periodic (i.e., values separated by some fixed integer 
            % number of bins are *exactly* the same), then it is possible to use a 
            % computational shortcut when computing fevent and fdetection. Determine 
            % whether periodicity exists and get the number of bins per cycle.
            vars.window.nBinsPerCycle = get_periodicity(vars.window.Revent, vars.settings.TolCompare);

        case 'detection'

            % Setup detection rate according to specified rate function
            vars.window.Rdetection = vars.settings.Rfunction(vars);
            % Scale detection rate to detection probability
            vars.window.pdetection = vars.window.Rdetection.*vars.window.dt./1000;

    end

end