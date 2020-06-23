function compare_fevent(vars)

    fevent = zeros(vars.recurrence.npoints, vars.recurrence.npoints);
    for i=1:vars.recurrence.npoints
        k = 1;
        fevent(i,k) = vars.window.pevent(i+k);

        for k=2:vars.window.npoints-i
            h = i+1:i+k-1;
            fevent(i,k) = vars.window.pevent(i+k) .* prod(1-vars.window.pevent(h));
        end
    end
    
    discrepency = vars.recurrence.fevent - fevent;
    if max(abs(discrepency)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> fevent comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency))))])  
        end
    else
       error(['   --> fevent comparison failed with a maximum discrepency of ' num2str(max(max(abs(discrepency))))])  
    end
    
    if vars.settings.doPlotSteps
        figure;
        sub = subplotter();
        sub.add(1,1,'size',[225 225]);
        sub.add(1,2,'size',[225 225]);
        sub.build();

        sub.select(1,1); hold all;
        ylog
        h1 = plot(vars.recurrence.fevent', '-r', 'LineWidth', 1);
        h2 = plot(fevent', '--k', 'LineWidth', 1);
        xlabel('Waiting time (bins)')
        ylabel('f_{event}')
        legend([h1(1) h2(2)], 'Optimized', 'Equation 7')

        sub.select(1,2); hold all;
        % If all differences yield zero, just plot one; otherwise plot all
        if ~any(any(discrepency))
            plot(discrepency(1,:), '-r', 'LineWidth', 1)
        else
            plot(discrepency, '-r', 'LineWidth', 1)
        end
        xlabel('Waiting time (bins)')
        ylabel('Difference')
        yaxis_symmetric();
        ylim([-0.00001 0.00001])

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'COMPARE_fevent.fig'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_fevent.svg'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_fevent.png'])
        end

        if vars.settings.doClose
            close gcf;
        end
    end

end
