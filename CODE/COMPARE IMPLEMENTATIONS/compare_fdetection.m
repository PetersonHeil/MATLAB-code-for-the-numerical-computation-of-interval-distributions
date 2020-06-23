function compare_fdetection(vars)

    fdetection = zeros(vars.recurrence.npoints,vars.recurrence.npoints);
    gdead = vars.deadtime.gdead;

    sz = size(fdetection);
    for i=1:vars.recurrence.npoints
        for k=1:vars.window.npoints-i
            j = 1:k;
            linear_indices = sub2ind(sz, i+j-1, k-j+1);
            fdetection(i,k) = sum(gdead(j).*vars.recurrence.fevent(linear_indices));
        end
    end

    discrepency = vars.recurrence.fdetection' - fdetection';
    if max(abs(discrepency)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> fdetection comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency))))])  
        end
    else
        error(['   --> fdetection comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency))))])  
    end
    
    if vars.settings.doPlotSteps
        figure;
        sub = subplotter();
        sub.add(1,1,'size',[225 225]);
        sub.add(1,2,'size',[225 225]);
        sub.build();

        sub.select(1,1); hold all;
        ylog
        h1 = plot(vars.recurrence.fdetection', '-r', 'LineWidth', 1);
        h2 = plot(fdetection', '--k', 'LineWidth', 1);
        xlabel('Waiting time (bins)')
        ylabel('f_{detection}')
        legend([h1(1) h2(2)], 'Optimized', 'Equation 8')

        sub.select(1,2); hold all;
        plot(discrepency, '-r', 'LineWidth', 1)
        xlabel('Waiting time (bins)')
        ylabel('Difference')
        yaxis_symmetric();
        ylim([-0.00001 0.00001])

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'COMPARE_fdetection.fig'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_fdetection.svg'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_fdetection.png'])
        end
        
        if vars.settings.doClose
            close gcf;
        end
    end
    
end
