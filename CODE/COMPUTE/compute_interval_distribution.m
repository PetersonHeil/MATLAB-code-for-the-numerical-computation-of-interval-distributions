% This function computes IDI or IEI distribtution, depending on what is passed in:
% To get the IDI distribution: compute_interval_distribution(pevent, pdetection, fdetection...)
% To get the IEI distribution: compute_interval_distribution(pevent, pevent,     fevent...)

function [RIDI, pIDI, nIDIs] = compute_interval_distribution(pevent, pdetection, fdetection, dt_ms, dRep_ms)

    dt_sec = dt_ms./1000;
    dRep_sec = dRep_ms/1000;

    nDetections = dRep_sec .* (mean(pdetection)./dt_sec);
    pzero = prod(1-pevent);
    
    nIDIs = nDetections - 1 + pzero;

    pIDI = pdetection(1:end-1)*fdetection./nIDIs;

    RIDI = pIDI./dt_sec;

end