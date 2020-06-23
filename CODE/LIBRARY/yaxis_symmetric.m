function yaxis_symmetric(varargin)
    vars.drawZeroLine = true;
    vars = updateVars(vars, varargin);
    
    % Make y axis symmetric
    ylim([-max(abs(ylim(gca))), max(abs(ylim(gca)))])
    
    % Draw in zero line
    if vars.drawZeroLine
        xlim = get(gca,'xlim');  %Get x range 
        hold on;
        hLine = plot([xlim(1) xlim(2)],[0 0],'-k');
        uistack(hLine, 'bottom')
    end
end