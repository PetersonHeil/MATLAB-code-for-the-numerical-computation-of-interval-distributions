function vars = get_pdead_contributions(vars)

    pdead = zeros(size(vars.window.t));
    pdetection = vars.window.pevent;
    pdead_contributions = zeros(numel(vars.window.t));
    for i=2:numel(vars.window.pevent)
        pdead(i:end) = pdead(i:end) + (1 - vars.deadtime.Gdead(1:end-i+1)).*pdetection(i-1);
        pdead_contributions(i, i:end) = (1 - vars.deadtime.Gdead(1:end-i+1)).*pdetection(i-1);
        pdetection(i) = (1-pdead(i)) .* vars.window.pevent(i);
    end

    vars.window.pdead_contributions = pdead_contributions;

    % Check that the individual contributions are consistent with pdead
    % calculated more directly.
    discrepency = vars.window.pdead - sum(vars.window.pdead_contributions,1);
    if max(abs(discrepency)) > vars.settings.TolCompare
        error('There is a discrepency between vars.window.pdead and vars.window.pdead_contributions.')
    end

end