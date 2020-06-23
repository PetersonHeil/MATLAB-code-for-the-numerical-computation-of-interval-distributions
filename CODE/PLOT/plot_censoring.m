function sub = plot_censoring(vars, wmax_plot)

    figure();
    sub = subplotter('hpadding',70, 'vpadding', 50, 'tmargin', 10);
    sub.add(1,1,'size',[225 225]);
    sub.add(1,2,'size',[225 225]);
    sub.build();


    % PLOT PDFs
    % -----------------------------------------
    sub.select(1,1); hold all;
    plot(vars.interval.w, vars.interval.RIEI, '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
    xlabel('Interevent interval (ms)', 'FontSize', 14);
    ylabel('Probability density (IEIs/s)', 'FontSize', 14);
    box off;
    xlim([0 wmax_plot])
    if isfield(vars, 'ylims') && isfield(vars.ylims, 'logRIEI')
        ylim(vars.ylims.logRIEI)
    end
    ylog
%     ylimits = ylim;
%     set(gca,'YTick', 10.^(log10(ylimits(1)):log10(ylimits(2))),'YTickLabels', getLegendText(10.^(log10(ylimits(1)):log10(ylimits(2)))))    
    set(gca,'YTick', [0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000],'YTickLabel', getLegendText([0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000]))
    ylim([0.001 10000])

    sub.select(1,2); hold all;
    plot(vars.interval.w, vars.interval.RIDI, '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
    xlabel('Interdetection interval (ms)', 'FontSize', 14);
    ylabel('Probability density (IDIs/s)', 'FontSize', 14);
    box off;
    xlim([0 wmax_plot])
    if isfield(vars, 'ylims') && isfield(vars.ylims, 'logRIDI')
        ylim(vars.ylims.logRIDI)
    end
    ylog
%     ylimits = ylim;
%     set(gca,'YTick', 10.^(log10(ylimits(1)):log10(ylimits(2))),'YTickLabels', getLegendText(10.^(log10(ylimits(1)):log10(ylimits(2)))))    
	set(gca,'YTick', [0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000],'YTickLabel', getLegendText([0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000]))
    ylim([0.001 10000])


    if vars.settings.doSave
        saveas(gcf, [vars.strings.savePath 'censoring, tmax=' num2str(vars.tmax) ' ms.fig'])
        saveas(gcf, [vars.strings.savePath 'censoring, tmax=' num2str(vars.tmax) ' ms.svg'])
        saveas(gcf, [vars.strings.savePath 'censoring, tmax=' num2str(vars.tmax) ' ms.png'])
    end

    if vars.settings.doClose
        close gcf;
    end

end


