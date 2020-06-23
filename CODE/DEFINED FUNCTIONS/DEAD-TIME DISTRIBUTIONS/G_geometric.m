function vars = G_geometric(vars)

    % Copy 'deadtime' from vars structure
    deadtime = vars.deadtime;

    % Extract supplied parameter values
    dfixed = vars.settings.Gparams.dfixed;
    murand = vars.settings.Gparams.murand;
    
    % Validate supplied parameter values
    if ~isscalar(dfixed) || ~isnumeric(dfixed) || dfixed<0
        error('dfixed must be a nonnegative scalar value.')
    end
    if ~isscalar(murand) || ~isnumeric(murand) || murand<0
        error('murand must be a nonnegative scalar value.')
    end

    % Compute CDF of dead times
    if murand == 0
        deadtime.Gdead = (vars.deadtime.d>dfixed).*ones(size(vars.deadtime.d));
    else
        p = vars.window.dt / murand;
        k = (vars.deadtime.d-dfixed) / vars.window.dt;
        deadtime.Gdead = (vars.deadtime.d>=dfixed).*(1-(1-p).^(k));
    end

    % Save 'deadtime' back to vars structure
    vars.deadtime = deadtime;

end