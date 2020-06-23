function R = R_constant(vars)

    % Extract supplied parameter values
    R = vars.settings.Rparams.R;

    % Validate supplied parameter values
    if ~isscalar(R) || ~isnumeric(R) || R<=0
        error('R must be a positive scalar value.')
    end

    % Compute rate function
    R = repmat(R, size(vars.window.t));

end
