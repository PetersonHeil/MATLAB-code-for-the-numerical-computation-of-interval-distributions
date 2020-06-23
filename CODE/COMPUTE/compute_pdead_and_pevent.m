function [pdead, pevent] = compute_pdead_and_pevent(t, pdetection, Sdead)
    
    pdead = zeros(size(t));
    pevent = zeros(size(pdetection));
    pevent(1) = pdetection(1);

    % Compute pdead and limit its value to 1
    for i=2:numel(pevent)
        h = 1:i-1;
        pdead(i) = sum(pdetection(h).*Sdead(i-h));
    end
    pdead = min(pdead, 1);

    % Compute pevent
    pevent = pdetection./(1-pdead);
    
    % Replace NaNs by zero (they arise when pdead is 1, which can happen when pdetection is 1 and the dead time has a positive minimum duration)
    pevent(isnan(pevent)) = 0;
    
    % Check that resulting pevent is valid (not less than pdetection or greater than 1)
    if any(pevent < pdetection)
        error('Dead-time parameters are not viable and would result in some points having pevent < pdetection, which is not reasonable.')
    end
    if any(pevent > 1)
        error('The parameters provided would result in some points having pevent > 1. Decrease the time step, the mean rate, or the mean duration of the dead time.')
    end

end
