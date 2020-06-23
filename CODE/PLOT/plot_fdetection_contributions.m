function vars = plot_fdetection_contributions(vars)

    nToPlot = numel(vars.settings.iPlotRecurrence);
    if nToPlot > 0

        Cbase = [0.7 0.7 0.7; 0.8 0.8 0.8];
        C = repmat(Cbase, ceil(vars.recurrence.npoints/size(Cbase,1)),1);

        % Create figure
        figure;
        sub = subplotter('vpadding', 100, 'tmargin', 30);
        for idx = 1:numel(vars.settings.iPlotRecurrence)
            sub.add(1,idx,'size',[225 225])
        end
        sub.build();

        for iPlot = vars.settings.iPlotRecurrence
            % Compute contributions to fdetection
            vars.recurrence.fdetection_contributions = get_fdetection_contributions(vars, iPlot);
            if any(vars.recurrence.fdetection(iPlot,:) - sum(vars.recurrence.fdetection_contributions,1) > vars.settings.TolCompare)
                error('ERROR: Discrepency between vars.recurrence.fdetection(1,:) and vars.recurrence.fdetection_BIG.')
            end

            iCol = find(iPlot==vars.settings.iPlotRecurrence);
            sub.select(1,iCol); hold all; %#ok
            
            if vars.window.npoints > 500
                warning(['Warning: there are too many points (' num2str(vars.window.npoints) '); the plot of individual contributions to p_{detection} has been skipped.'])
                xlabel('Waiting time w (ms)')
                ylabel(['Contribution to f_{detection} (t_{' num2str(iPlot) '} = ' num2str(vars.window.t(iPlot)) ' ms, w)'])
                text(0.1, 0.5, 'Plot skipped!', 'Color', 'r', 'FontSize', 14)
                box off;
            else
                for i=iPlot:size(vars.recurrence.fdetection_contributions,1)
                    plot(vars.recurrence.w(i-iPlot+1:end-iPlot+1), vars.recurrence.fdetection_contributions(i,i-iPlot+1:end-iPlot+1), '-', 'MarkerSize', 2, 'Color', C(i,:))
                    plot(vars.recurrence.w(i-iPlot+1), vars.recurrence.fdetection_contributions(i,i-iPlot+1), 'ok', 'MarkerFaceColor', 'w', 'MarkerSize', 3, 'LineWidth', 0.5)                
                end
                xlabel('Waiting time w (ms)')
                ylabel(['Contribution to f_{detection} (t_{' num2str(iPlot) '} = ' num2str(vars.window.t(iPlot)) ' ms, w)'])
                box off;
                h = fill([vars.recurrence.w(end-iPlot+1) vars.recurrence.w(end-iPlot+1) vars.window.tmax+vars.window.dt vars.window.tmax+vars.window.dt], [-0.1 1.1 1.1 -0.1], [0.85 0.85 0.85], 'EdgeColor', [0.6 0.6 0.6], 'LineWidth', 0.1, 'FaceAlpha', 1);
                uistack(h,'bottom');
                xlim([0 vars.window.tmax-vars.window.tmin])
                if isfield(vars.settings, 'ylims') && isfield(vars.settings.ylims, 'fdetection_contributions')
                    ylim(vars.settings.ylims.fdetection_contributions)
                end

                set(gca,'Color','none')
                ax2 = axes('Position',get(gca,'Position'), 'XAxisLocation','top', 'YTick',[]);
                uistack(ax2,'bottom')
                set(ax2, 'XLim', [vars.window.t(iPlot) vars.window.tmax+vars.window.t(iPlot)])
                xlabel(ax2, 'Time t (ms)');
                ax2.XTick = ax2.XTick(ax2.XTick <= vars.window.tmax+vars.window.dt);
            end

        end

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'fdetection contributions for i=[' strrep(num2str(vars.settings.iPlotRecurrence),'  ',', ') '].fig'])
            saveas(gcf, [vars.strings.savePath 'fdetection contributions for i=[' strrep(num2str(vars.settings.iPlotRecurrence),'  ',', ') '].svg'])
            saveas(gcf, [vars.strings.savePath 'fdetection contributions for i=[' strrep(num2str(vars.settings.iPlotRecurrence),'  ',', ') '].png'])
        end

        if vars.settings.doClose
            close gcf;
        end

    end

end
