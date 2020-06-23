function plot_f(vars, fType)

    nToPlot = numel(vars.settings.iPlotRecurrence);
    if nToPlot > 0

        switch lower(fType)
            case 'event'
                f = vars.recurrence.fevent;
            case 'detection'
                f = vars.recurrence.fdetection;
        end

        % Create figure
        figure;
        sub = subplotter('vpadding', 100, 'tmargin', 30);
        for idx = 1:nToPlot
            sub.add(1,idx,'size',[225 225])
        end
        sub.build();

        % Plot f function for each specified point
        for idx = 1:nToPlot
            i = vars.settings.iPlotRecurrence(idx);
            sub.select(1,idx); hold all;
            plot(vars.recurrence.w(1:end-i+1), f(i,1:end-i+1), 'o-k', 'LineWidth', 0.5, 'MarkerSize', 3, 'MarkerFaceColor', 'w')
            xlabel('Waiting time w (ms)')
            ylabel(['f_{' lower(fType) '} (t_{' num2str(i) '} = ' num2str(vars.window.t(i)) ' ms, w)'])
            axis tight
            box off;
            h = fill([vars.recurrence.w(end-i+1) vars.recurrence.w(end-i+1) vars.window.tmax+vars.window.dt vars.window.tmax+vars.window.dt], [-0.1 1.1 1.1 -0.1], [0.85 0.85 0.85], 'EdgeColor', [0.6 0.6 0.6], 'LineWidth', 0.1, 'FaceAlpha', 1);
            uistack(h,'bottom');
            xlim([0 vars.window.tmax-vars.window.tmin])
            if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, ['f' lower(fType)])
                ylim([vars.settings.ylims.(['f' lower(fType)])])
            end

            set(gca,'Color','none')
            ax2 = axes('Position',get(gca,'Position'), 'XAxisLocation','top', 'YTick',[]);
            uistack(ax2,'bottom')
            set(ax2, 'XLim', [vars.window.t(i) vars.window.tmax+vars.window.t(i)])
            xlabel(ax2, 'Time t (ms)');
            ax2.XTick = ax2.XTick(ax2.XTick <= vars.window.tmax+vars.window.dt);
        end

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'f' lower(fType) '.fig'])
            saveas(gcf, [vars.strings.savePath 'f' lower(fType) '.svg'])
            saveas(gcf, [vars.strings.savePath 'f' lower(fType) '.png'])
        end

        if vars.settings.doClose
            close gcf;
        end
        
    end

end

