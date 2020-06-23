function [pdead, pdetection] = compute_pdead_and_pdetection(t, pevent, Sdead)

    pdead = zeros(size(t));
    pdetection = pevent;
    for i=2:numel(Sdead)
        pdead(i:end) = pdead(i:end) + Sdead(1:end-i+1).*pdetection(i-1);
        pdetection(i) = (1-pdead(i)) .* pevent(i);
    end

end