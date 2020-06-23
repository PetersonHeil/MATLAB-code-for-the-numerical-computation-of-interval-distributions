function fdetection = compute_fdetection_quick(npoints, nBinsPerCycle, gdead, fevent, doDisplay, doUseMEX)

    % If the event rate is periodic, the results only need to be computed for 
    % i=1:nBinsPerCycle. Otherwise results need to be computed for i=1:npoints.
    if nBinsPerCycle < npoints
        ncompute = nBinsPerCycle;
        if doDisplay
            disp('       > Using periodicity shortcut to compute fdetection.')
        end
    else
        ncompute = npoints;
    end

    % Compute for all bins in the first cycle of the histogram
    fdetection = compute_fdetection(npoints, gdead, fevent, ncompute, doUseMEX);

    % Then copy those results to the cycles that follow...
    if ncompute == nBinsPerCycle
        for iBin=(nBinsPerCycle+1):npoints
            iCopy = rem(iBin, nBinsPerCycle);
            iCopy = iCopy + ~iCopy*nBinsPerCycle; % Replace zero with nBinsPerCycle
            fdetection(iBin,1:npoints-iBin+1) = fdetection(iCopy,1:npoints-iBin+1);
        end
    end

end