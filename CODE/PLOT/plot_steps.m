function vars = plot_steps(vars)

    % Give warning message if combination of settings makes no sense
    if vars.settings.doClose && ~vars.settings.doSave
        warning('Figures are created and immediately closed without saving. Perhaps reconsider ''vars.settings.doClose'', and ''vars.settings.doSave''?')
    end

    % Plot Gdead, Sdead, and gdead
    plot_dead_time_distributions(vars)

    % Plot pdead and pdetection
    vars = plot_pdead_pevent_pdetection(vars);
    
    % Plot fevent for bins specified in vars.settings.iPlotRecurrence
    plot_fevent(vars)

    % Plot contributions to fdetection for bins specified in vars.settings.iPlotRecurrence
    vars = plot_fdetection_contributions(vars);

    % Plot resulting fdetection for bins specified in vars.settings.iPlotRecurrence
    plot_fdetection(vars)

    % Plot RIEI and RIDI distributions
    plot_interval_distributions(vars)

end