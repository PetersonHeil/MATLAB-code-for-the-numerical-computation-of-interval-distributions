function vars = setup_dead_time_distribution(vars)

    % Obtain specified CDF of dead times
    vars = vars.settings.Gfunction(vars);

    % Compute survivor function of dead times
    vars.deadtime.Sdead = 1 - vars.deadtime.Gdead;

    % Compute PMF of dead times using finite difference method
    vars.deadtime.gdead = [vars.deadtime.Gdead(1) diff(vars.deadtime.Gdead)];

end