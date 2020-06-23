function R = R_randwalk(vars)

    % Extract supplied parameter values
    R1 = vars.settings.Rparams.R1;                   % Initial rate
    Rrange = vars.settings.Rparams.Rrange;           % Width of noise distribution

    % Validate supplied parameter values
    if ~isscalar(R1) || ~isnumeric(R1)
        error('R1 must be a scalar value.')
    end
    if ~isscalar(Rrange) || ~isnumeric(Rrange)
        error('Rrange must be a scalar value.')
    end

    % Compute rate function
    dRate = Rrange.*(rand(1,numel(vars.window.t)-1)-0.5);
    R = cumsum([R1 dRate]);
    R(R<0) = 0;

end