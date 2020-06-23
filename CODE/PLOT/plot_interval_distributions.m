function plot_interval_distributions(vars)

    figure();
    sub = subplotter('hpadding',70, 'vpadding', 50, 'tmargin', 10);
    sub.add(1,1,'size',[225 225]);
    sub.add(1,2,'size',[225 225]);
    sub.build();

    
    % PLOT PDF of IEIs 
    % -----------------------------------------
    sub.select(1,1); hold all;
    plot(vars.interval.w, vars.interval.RIEI, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Interevent interval w (ms)');
    ylabel('R_{IEI}(w) (IEIs/s)');
    box off;
    Y = max(vars.interval.RIDI(1:end-1));
    Ymax = decround(Y,2000,@ceil);
    set(gca,'YTick', 0:500:Ymax,'YTickLabels', getLabel(0:500:Ymax))
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'RIEI')
        ylim(vars.settings.ylims.RIEI)
    end
    
    
    % PLOT LOG PDF of IEIs (INSET)
    % -----------------------------------------    
    parent_position = getpixelposition(gca);
    h = axes('Units', 'pixels');
    set(h, 'Position', parent_position+[110 110 -125 -125], 'Units', 'pixels')
    hold all;
    plot(vars.interval.w, vars.interval.RIEI, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    box off;
    ylog
    Y = vars.interval.RIDI(1:end-1);
    set(gca,'YTick', 10.^(-1:ceil(log10(max(Y)))+1),'YTickLabels', getLabel(10.^(-1:ceil(log10(max(Y)))+1)))
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'logRIEI')
        ylim(vars.settings.ylims.logRIEI)
    end
    set(gca,'TickLength',[0.03 0.03])
    set(gca,'XTickLabel', '')
    set(gca,'YTickLabel', '')

    
    % PLOT PDF of IDIs 
    % -----------------------------------------
    sub.select(1,2); hold all;
    plot(vars.interval.w, vars.interval.RIDI, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Interdetection interval w (ms)');
    ylabel('R_{IDI}(w) (IDIs/s)');
    box off;
    set(gca,'YTick', 0:500:Ymax,'YTickLabels', getLabel(0:500:Ymax))
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'RIDI')
        ylim(vars.settings.ylims.RIDI)
    end
    
    
    % PLOT LOG PDF of IDIs (INSET)
    % -----------------------------------------    
    parent_position = getpixelposition(gca);
    h = axes('Units', 'pixels');
    set(h, 'Position', parent_position+[110 110 -125 -125], 'Units', 'pixels')
    hold all;
    plot(vars.interval.w, vars.interval.RIDI, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    box off;
    ylog
    Y = vars.interval.RIDI(1:end-1);
    set(gca,'YTick', 10.^(-1:ceil(log10(max(Y)))+1),'YTickLabels', getLabel(10.^(-1:ceil(log10(max(Y)))+1)))
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'logRIEI')
        ylim(vars.settings.ylims.logRIEI)
    end
    set(gca,'TickLength',[0.03 0.03])
    set(gca,'XTickLabel', '')
    set(gca,'YTickLabel', '')

    if vars.settings.doSave
        saveas(gcf, [vars.strings.savePath 'RIEI RIDI.fig'])
        saveas(gcf, [vars.strings.savePath 'RIEI RIDI.svg'])
        saveas(gcf, [vars.strings.savePath 'RIEI RIDI.png'])
        saveas(gcf, [vars.strings.savePath 'RIEI RIDI.eps'])
    end

    if vars.settings.doClose
        close gcf;
    end

end