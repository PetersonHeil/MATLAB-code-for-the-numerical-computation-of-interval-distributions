% Define the deadtime distribution

function vars = define_G(vars, Gfunction, varargin)

    % Get parameter values
    Gparams = getVars(varargin);

    % Handle to CDF of dead-time distribution
    vars.settings.Gfunction = Gfunction;
    
    % Parameters of CDF of dead-time distribution
    vars.settings.Gparams = Gparams;

end