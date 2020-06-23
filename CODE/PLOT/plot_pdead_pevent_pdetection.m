function vars = plot_pdead_pevent_pdetection(vars)

    % Compute individual contributions to pdead
    vars = get_pdead_contributions(vars);

    Cbase = [0.7 0.7 0.7; 0.8 0.8 0.8];
    C = repmat(Cbase, ceil(size(vars.window.pdead_contributions,1)/size(Cbase,1)),1);

    figure;
    sub = subplotter('vpadding', 50, 'tmargin', 30);
    sub.add(1,1,'size',[225 225])
    sub.add(2,1,'size',[225 225])
    sub.add(2,2,'size',[225 225])
    sub.add(2,3,'size',[225 225])
    sub.build();

    
    sub.select(1,1); hold all;
    plot(vars.window.t, vars.window.Rdetection, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Time t (ms)')
    ylabel('R_{detection}(t) (detections/s)')
    xlim([vars.window.tmin vars.window.tmax])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'Rdetection')
        ylim(vars.settings.ylims.Rdetection)
    end
    box off;
    
    ylimits = ylim;
    set(gca,'Color','none')
    ax2 = axes('Position',get(gca,'Position'), 'YAxisLocation','right', 'XTick',[]);
    uistack(ax2,'bottom')
    uistack(ax2,'bottom')
    ylabel(ax2, 'p_{detection}(t)', 'Rotation', -90, 'VerticalAlignment', 'bottom')
    set(ax2, 'YAxisLocation','right');
    set(ax2, 'YLim', ylimits.*vars.window.dt./1000)
    
    sub.select(2,1); hold all;
    if vars.window.npoints > 100
        warning(['Warning: there are too many points (' num2str(vars.window.npoints) '); the plot of individual contributions to p_{dead} has been skipped.'])
        xlabel('Time t (ms)')
        ylabel('Contribution to p_{dead}')
        text(0.1, 0.5, 'Plot skipped!', 'Color', 'r', 'FontSize', 14)
        box off;
    else
        for i=1:size(vars.window.pdead_contributions,1)
            plot(vars.window.t(i:size(vars.window.pdead_contributions,1)), vars.window.pdead_contributions(i,i:end)', '-', 'LineWidth', 0.5, 'Color', C(i,:))
            plot(vars.window.t(i), vars.window.pdead_contributions(i,i), 'ok', 'MarkerFaceColor', 'w', 'MarkerSize', 3, 'LineWidth', 0.5)
        end
        xlabel('Time t (ms)')
        ylabel('Contribution to p_{dead}(t)')
        xlim([vars.window.tmin vars.window.tmax])
        if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'pdead_contributions')
            ylim(vars.settings.ylims.pdead_contributions);
        end
        box off;
    end
    
    
    sub.select(2,2); hold all;
    plot(vars.window.t, vars.window.pdead, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Time t (ms)')
    ylabel('p_{dead}(t)')
    xlim([vars.window.tmin vars.window.tmax])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'pdead')
        ylim(vars.settings.ylims.pdead);
    end
    box off;
    
    
    sub.select(2,3); hold all;
    plot(vars.window.t, vars.window.Revent, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Time t (ms)')
    ylabel('R_{event}(t) (events/s)')
    xlim([vars.window.tmin vars.window.tmax])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'Revent')
        ylim(vars.settings.ylims.Revent)
    end
    box off;

    ylimits = ylim;
    set(gca,'Color','none')
    ax2 = axes('Position',get(gca,'Position'), 'YAxisLocation','right', 'XTick',[]);
    uistack(ax2,'bottom')
    uistack(ax2,'bottom')
    ylabel(ax2, 'p_{event}(t)', 'Rotation', -90, 'VerticalAlignment', 'bottom')
    set(ax2, 'YAxisLocation','right');
    set(ax2, 'YLim', ylimits.*vars.window.dt./1000)
    
    if vars.settings.doSave
        saveas(gcf, [vars.strings.savePath 'pdead pdetection.fig'])
        saveas(gcf, [vars.strings.savePath 'pdead pdetection.svg'])
        saveas(gcf, [vars.strings.savePath 'pdead pdetection.png'])
    end
    
    if vars.settings.doClose
        close gcf;
    end

end
