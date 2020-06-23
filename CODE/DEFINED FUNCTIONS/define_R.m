% Define the rate function

function vars = define_R(vars, Rfunction, Rtype, varargin)

    % Get parameter values
    Rparams = getVars(varargin);

    % Handle to rate function
    vars.settings.Rfunction = Rfunction;

    % Whether rate function describes the 'event' process or 'detection' process
    vars.settings.Rtype = Rtype;

    % Parameters of rate function
    vars.settings.Rparams = Rparams;

end