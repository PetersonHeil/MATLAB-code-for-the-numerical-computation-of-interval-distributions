function vars = compute_plot_limits(vars)

    % Apply various criteria to automatically compute vertical limits
    % for each of the plotted quantities

    % Figure 2 axis limits
    Rmax = max([vars.window.Revent vars.window.Rdetection]);
    Rmax_order_of_magnitude = floor(log10(Rmax));
    round_to = (10^Rmax_order_of_magnitude)/10;
    vars.settings.ylims.Rdetection = [0 decround(max(vars.window.Revent)*1.2, round_to, @ceil)];
    vars.settings.ylims.pdetection = vars.settings.ylims.Rdetection.*vars.window.dt./1000;
    
    % Figure 3 axis limits
    vars.settings.ylims.Gdead = [0 1];
    vars.settings.ylims.Sdead = [0 1];
    vars.settings.ylims.gdead = [0 decround(max(vars.deadtime.gdead).*1.2, 0.05, @ceil)];
    
    % Figure 4 axis limits
    vars.settings.ylims.pdead_contributions = vars.settings.ylims.pdetection;
    vars.settings.ylims.pdead = [0 1];
    vars.settings.ylims.Revent = vars.settings.ylims.Rdetection;
    vars.settings.ylims.pevent = vars.settings.ylims.pdetection;
    
    % Figure 5 axis limits
    vars.settings.ylims.fevent = vars.settings.ylims.pevent;
    
    % Figure 6 axis limits
    vars.settings.ylims.fdetection_contributions = vars.settings.ylims.pevent.*max(vars.deadtime.gdead);
    vars.settings.ylims.fdetection = vars.settings.ylims.pevent;

    % Figure 7 axis limits
    Rmax = max([vars.interval.RIEI vars.interval.RIDI]);
    Rmax_order_of_magnitude = floor(log10(Rmax));
    round_to = (10^Rmax_order_of_magnitude)/10;
    vars.settings.ylims.RIEI = [0 decround(Rmax*1.2, round_to, @ceil)];
    vars.settings.ylims.RIDI = vars.settings.ylims.RIEI;
    % (Log insets)
    Rmin = min([vars.interval.RIEI(vars.interval.RIEI>0) vars.interval.RIDI(vars.interval.RIDI>0)]);
    Rmin_order_of_magnitude = floor(log10(Rmin));
    Rmax_order_of_magnitude = ceil(log10(Rmax));
    vars.settings.ylims.logRIEI = [10^Rmin_order_of_magnitude 10^(Rmax_order_of_magnitude)];
    vars.settings.ylims.logRIDI = vars.settings.ylims.logRIEI;

end