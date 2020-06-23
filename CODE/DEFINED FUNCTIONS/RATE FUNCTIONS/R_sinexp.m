function R = R_sinexp(vars)

    % Extract supplied parameter values
    A = vars.settings.Rparams.A;                     % Exponential scale factor (in 1/s)
    B = vars.settings.Rparams.B;                     % Exponential slope factor
    f = vars.settings.Rparams.f;                     % Frequency (in Hertz)
    
    % Validate supplied parameter values
    if ~isscalar(f) || ~isnumeric(f) || f<=0
        error('f must be a positive scalar value.')
    end
    if ~isscalar(A) || ~isnumeric(A) || A<=0
        error('A must be a positive scalar value.')
    end
    if ~isscalar(B) || ~isnumeric(B) || B<=0
        error('B must be a positive scalar value.')
    end

    % Compute rate function
    R = A*exp(B.*sin(2*pi*f*vars.window.t/1000));

end