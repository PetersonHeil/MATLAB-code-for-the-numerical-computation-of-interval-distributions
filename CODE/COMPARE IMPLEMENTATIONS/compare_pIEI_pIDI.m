function compare_pIEI_pIDI(vars)

    pIEI = zeros(1,vars.interval.npoints);
    pIDI = zeros(1,vars.interval.npoints);
    clear i;
    clear k;
    m = vars.window.npoints;
    for k=1:m-1
        i = 1:vars.interval.npoints;
        pIDI(k) = sum(vars.window.pdetection(i) .* vars.recurrence.fdetection(i,k)');
        pIEI(k) = sum(vars.window.pevent(i) .* vars.recurrence.fevent(i,k)');
    end
    pIDI = pIDI./vars.interval.nIDIs;
    pIEI = pIEI./vars.interval.nIEIs;

    discrepency_pIEI = vars.interval.pIEI' - pIEI';
    if max(abs(discrepency_pIEI)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> pIEI comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pIEI))))])
        end
    else
       error(['   --> pIEI comparison failed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pIEI))))])
    end
    
    discrepency_pIDI = vars.interval.pIDI' - pIDI';
    if max(abs(discrepency_pIDI)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> pIDI comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pIDI))))])
        end
    else
       error(['   --> pIDI comparison failed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pIDI))))])
    end    

    if vars.settings.doPlotSteps
        figure;
        sub = subplotter();
        sub.add(1,1,'size',[225 225]);
        sub.add(1,2,'size',[225 225]);
        sub.add(2,1,'size',[225 225]);
        sub.add(2,2,'size',[225 225]);
        sub.build();

        sub.select(1,1); hold all;
        ylog();
        plot(vars.interval.pIEI, '-r', 'LineWidth', 1)
        plot(pIEI, '--k', 'LineWidth', 1)
        xlabel('Interevent interval (bins)')
        ylabel('p_{IEI}')
        legend('Optimized', 'Equation 9')

        sub.select(1,2); hold all;
        plot(discrepency_pIEI, '-r', 'LineWidth', 1)
        xlabel('Interevent interval (bins)')
        ylabel('Difference')
        yaxis_symmetric();
        ylim([-0.00001 0.00001])
        
        sub.select(2,1); hold all;
        ylog();
        plot(vars.interval.pIDI, '-r', 'LineWidth', 1)
        plot(pIDI, '--k', 'LineWidth', 1)
        xlabel('Interdetection interval (bins)')
        ylabel('p_{IDI}')
        legend('Optimized', 'Equation 10')

        sub.select(2,2); hold all;
        plot(discrepency_pIDI, '-r', 'LineWidth', 1)
        xlabel('Interdetection interval (bins)')
        ylabel('Difference')
        yaxis_symmetric();
        ylim([-0.00001 0.00001])

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'COMPARE_pIEI_pIDI.fig'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_pIEI_pIDI.svg'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_pIEI_pIDI.png'])
        end
        
        if vars.settings.doClose
            close gcf;
        end
    end

end