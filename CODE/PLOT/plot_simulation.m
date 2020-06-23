function sub = plot_simulation(vars)

    % If simulations were performed, compare simulation results to numerical results
    if vars.sim.nreps > 0

        figure();
        sub = subplotter('hpadding',70, 'vpadding', 50, 'tmargin', 10);
        sub.add(1,1,'size',[225 225]);
        sub.add(1,2,'size',[225 225]);
        sub.add(1,3,'size',[225 225]);
        sub.add(1,4,'size',[225 225]);
        sub.build();
        
        % PLOT OBSERVATION WINDOW
        % -----------------------------------------
        sub.select(1,1); hold all;
        h1 = plot(vars.window.t, vars.sim.window.Revent, 'Color', [0.8 0.8 0.8], 'LineWidth', 3);
        plot(vars.window.t, vars.sim.window.Rdetection, 'Color', [0.8 0.8 0.8], 'LineWidth', 3);
        h2 = plot(vars.window.t, vars.window.Revent, '--k', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
        plot(vars.window.t, vars.window.Rdetection, '--k', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
        text(vars.window.t(end), max(vars.window.Revent), 'Event ', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')
        text(vars.window.t(end), min(vars.window.Rdetection), 'Detection ', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top')
        legend([h1 h2], {'Simulated', 'Numerical'}, 'Location', 'SE');
        xlabel('Time t (ms)');
        ylabel('Rate (1/s)');
        strTitle = {'(Panel not shown in paper)' [num2str(vars.sim.nreps) ' simulation reps']};
        title(strTitle);
        box off;
        xlim([vars.window.tmin vars.window.tmax])
        if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'Revent')
            ylim(vars.settings.ylims.Revent)
        end        

        
        % PLOT PDF OF IEIs
        % -----------------------------------------
        sub.select(1,2); hold all;
        h1 = plot(vars.interval.w, vars.sim.interval.RIEI, '-', 'Color', [0.8 0.8 0.8], 'LineWidth', 3);
        h2 = plot(vars.interval.w, vars.interval.RIEI, '--k', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
        xlabel('Interevent interval w (ms)');
        ylabel('R_{IEI}(w) (intervals/s)');
        box off;
        Y = max(vars.interval.RIDI(1:end-1));
        Ymax = decround(Y,2000,@ceil);
        set(gca,'YTick', 0:500:Ymax,'YTickLabels', getLabel(0:500:Ymax))
        legend([h1 h2], 'Simulated', 'Numerical');
        xlim([0 vars.window.tmax-vars.window.tmin])
        if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'RIEI')
            ylim(vars.settings.ylims.RIEI)
        end
        
        
        % PLOT LOG PDF of IEIs (INSET)
        % -----------------------------------------    
        parent_position = getpixelposition(gca);
        h = axes('Units', 'pixels');
        set(h, 'Position', parent_position+[110 75 -125 -125], 'Units', 'pixels')
        hold all;
        plot(vars.interval.w, vars.sim.interval.RIEI, '-', 'Color', [0.8 0.8 0.8], 'LineWidth', 3);
        plot(vars.interval.w, vars.interval.RIEI, '--k', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
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
        sub.select(1,3); hold all;
        plot(vars.interval.w, vars.sim.interval.RIDI, '-', 'Color', [0.8 0.8 0.8], 'LineWidth', 3)
        plot(vars.interval.w, vars.interval.RIDI, '--k', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
        xlabel('Interdetection interval w (ms)');
        ylabel('R_{IDI}(w) (intervals/s)');
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
        set(h, 'Position', parent_position+[110 75 -125 -125], 'Units', 'pixels')
        hold all;
        plot(vars.interval.w, vars.sim.interval.RIDI, '-', 'Color', [0.8 0.8 0.8], 'LineWidth', 3)
        plot(vars.interval.w, vars.interval.RIDI, '--k', 'LineWidth', 1, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
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


        % PLOT RATIO OF SIMULATION TO MODEL
        % -----------------------------------------
        sub.select(1,4); hold all;
        Y = vars.sim.interval.RIDI./vars.interval.RIDI;
        plot([vars.interval.w(1) vars.interval.w(end)], [1 1], '--k', 'LineWidth', 1);
        plot(vars.interval.w, Y, '-', 'Color', [0.8 0.8 0.8], 'LineWidth', 3, 'MarkerSize', 3, 'MarkerFaceColor', 'w');
        ylog
        set(gca,'YTick',[0.5 1 2],'YTickLabel',getLabel([0.5 1 2]))
        xlabel('Interdetection interval w (ms)');            
        ylabel('Simulated/numerical IDI distr.');
        xlim([0 vars.window.tmax-vars.window.tmin])
        ylim([0.5 2])
        title('(Panel not shown in paper)')
        box off

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'simulation, nreps=' num2str(vars.sim.nreps) '.fig'])
            saveas(gcf, [vars.strings.savePath 'simulation, nreps=' num2str(vars.sim.nreps) '.svg'])
            saveas(gcf, [vars.strings.savePath 'simulation, nreps=' num2str(vars.sim.nreps) '.png'])
            saveas(gcf, [vars.strings.savePath 'simulation, nreps=' num2str(vars.sim.nreps) '.eps'])
        end

        if vars.settings.doClose
            close gcf;
        end

    end

end