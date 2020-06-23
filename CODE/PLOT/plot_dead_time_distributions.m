function plot_dead_time_distributions(vars)

    figure();
    sub = subplotter('hpadding',70, 'vpadding', 50, 'tmargin', 50);
    sub.add(1,1,'size',[225 225]);
    sub.add(1,2,'size',[225 225]);
    sub.add(1,3,'size',[225 225]);
    sub.build();

    sub.select(1,1); hold all;
    plot(vars.deadtime.d, vars.deadtime.Gdead, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Duration d (ms)');            
    ylabel('G_{dead}(d)');
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'Gdead')
        ylim([vars.settings.ylims.Gdead])
    end
    box off
    
    sub.select(1,2); hold all;
    plot(vars.deadtime.d, vars.deadtime.Sdead, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Duration d (ms)');            
    ylabel('S_{dead}(d)');
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'Sdead')
        ylim([vars.settings.ylims.Sdead])
    end
    box off
     
    sub.select(1,3); hold all;
    plot(vars.deadtime.d, vars.deadtime.gdead, 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
    xlabel('Duration d (ms)');            
    ylabel('g_{dead}(d)');
    xlim([0 vars.window.tmax-vars.window.tmin])
    if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'gdead')
        ylim([vars.settings.ylims.gdead])
    end
    box off
    
    if vars.settings.doSave
        saveas(gcf, [vars.strings.savePath 'Gdead Sdead gdead.fig'])
        saveas(gcf, [vars.strings.savePath 'Gdead Sdead gdead.svg'])
        saveas(gcf, [vars.strings.savePath 'Gdead Sdead gdead.png'])
    end
    
    if vars.settings.doClose
        close gcf;
    end

end