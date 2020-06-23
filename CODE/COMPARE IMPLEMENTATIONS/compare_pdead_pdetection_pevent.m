function compare_pdead_pdetection_pevent(vars)

    % Initialize result vectors
    pdead = zeros(size(vars.window.pdetection));
    pdetection = zeros(size(vars.window.pdetection));
    pevent = zeros(size(vars.window.pdetection));

    % Assume detector is not in a dead state at the start of the observation window
    pdead(1) = 0;
    pdetection(1) = vars.window.pevent(1);
    pevent(1) = vars.window.pevent(1);

    % Compute pdetection from pevent (which would be the case if only pevent were given)
    for i=2:vars.window.npoints
        h = 1:i-1;
        pdead(i) = sum(pdetection(h).*vars.deadtime.Sdead(i-h));
        pdetection(i) = vars.window.pevent(i)*(1-pdead(i));
    end
    
    % Compute pevent from pdetection (which would be the case if only pdetection were given)
    for i=2:vars.window.npoints
        h = 1:i-1;
        pdead(i) = sum(vars.window.pdetection(h).*vars.deadtime.Sdead(i-h));
        pevent(i) = vars.window.pdetection(i)/(1-pdead(i));
    end

    discrepency_pdead = vars.window.pdead' - pdead';
	if max(abs(discrepency_pdead)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> pdead comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pdead))))])
        end
    else
        error(['   --> pdead comparison failed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pdead))))])
    end

    discrepency_pdetection = vars.window.pdetection' - pdetection';
    if max(abs(discrepency_pdetection)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> pdetection comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pdetection))))])
        end
    else
       error(['   --> pdetection comparison failed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pdetection))))])
    end

    discrepency_pevent = vars.window.pevent' - pevent';
    if max(abs(discrepency_pevent)) <= vars.settings.TolCompare
        if vars.settings.doDisplay
            disp(['   --> pevent comparison passed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pevent))))])
        end
    else
       error(['   --> pevent comparison failed with a maximum discrepency of ' num2str(max(max(abs(discrepency_pevent))))])
    end

    if vars.settings.doPlotSteps
        figure;
        sub = subplotter();
        sub.add(1,1,'size',[225 225]);
        sub.add(1,2,'size',[225 225]);
        sub.add(2,1,'size',[225 225]);
        sub.add(2,2,'size',[225 225]);
        sub.add(3,1,'size',[225 225]);
        sub.add(3,2,'size',[225 225]);
        sub.build();

        sub.select(1,1); hold all;
        plot(vars.window.pdead, '-r', 'LineWidth', 1);
        plot(pdead, '--k', 'LineWidth', 1)
        xlabel('Time in observation window (bins)')
        ylabel('p_{dead}')
        legend('Optimized', 'Equation 4', 'Location', 'SE')
        xlim([0 vars.window.npoints])
        if diff(ylim) < 1e-2
            set(gca,'YTick', mode(vars.window.pdead))
        end

        sub.select(1,2); hold all;
        plot(discrepency_pdead, '-r', 'LineWidth', 1)
        xlabel('Time in observation window (bins)')
        ylabel('Difference')
        xlim([0 vars.window.npoints])
        ylim([-0.00001 0.00001])
        
        sub.select(2,1); hold all;
        plot(vars.window.pdetection, '-r', 'LineWidth', 1);
        plot(pdetection, '--k', 'LineWidth', 1)
        xlabel('Time in observation window (bins)')
        ylabel('p_{detection}')
        legend('Optimized', 'Equation 5')
        xlim([0 vars.window.npoints])
        if diff(ylim) < 1e-2
            set(gca,'YTick', mode(vars.window.pdetection))
        end

        sub.select(2,2); hold all;
        plot(discrepency_pdetection, '-r', 'LineWidth', 1)
        xlabel('Time in observation window (bins)')
        ylabel('Difference')
        xlim([0 vars.window.npoints])
        ylim([-0.00001 0.00001])
        
        sub.select(3,1); hold all;
        plot(vars.window.pevent, '-r', 'LineWidth', 1);
        plot(pevent, '--k', 'LineWidth', 1)
        xlabel('Time in observation window (bins)')
        ylabel('p_{event}')
        legend('Optimized', 'Equation 6')
        xlim([0 vars.window.npoints])
        if diff(ylim) < 1e-2
            set(gca,'YTick', mode(vars.window.pevent))
        end

        sub.select(3,2); hold all;
        plot(discrepency_pevent, '-r', 'LineWidth', 1)
        xlabel('Time in observation window (bins)')
        ylabel('Difference')
        xlim([0 vars.window.npoints])
        ylim([-0.00001 0.00001])

        if vars.settings.doSave
            saveas(gcf, [vars.strings.savePath 'COMPARE_pdead_pdetection_pevent.fig'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_pdead_pdetection_pevent.svg'])
            saveas(gcf, [vars.strings.savePath 'COMPARE_pdead_pdetection_pevent.png'])
        end
        
        if vars.settings.doClose
            close gcf;
        end
    end

end