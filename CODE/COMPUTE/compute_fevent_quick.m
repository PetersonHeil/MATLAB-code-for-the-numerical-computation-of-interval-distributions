function fevent = compute_fevent_quick(npoints, nBinsPerCycle, pevent, doDisplay)

    % If the event rate is periodic, the results only need to be computed for 
    % i=1:nBinsPerCycle. Otherwise results need to be computed for i=1:npoints.
    if nBinsPerCycle < npoints
        ncompute = nBinsPerCycle;
        if doDisplay
            disp('       > Using periodicity shortcut to compute fevent.')
        end
    else
        nBinsPerCycle = npoints;
        ncompute = npoints;
    end

    fevent = zeros(npoints, npoints);
    % Compute for i values in the first cycle...
    fevent(1:ncompute,:) = compute_fevent(pevent, ncompute);

    % Then copy those results to the cycles that follow...
    if ncompute == nBinsPerCycle
        for iBin=(nBinsPerCycle+1):npoints
            iCopy = rem(iBin, nBinsPerCycle);
            iCopy = iCopy + ~iCopy*nBinsPerCycle; % Replace zero with nBinsPerCycle
            fevent(iBin,1:npoints-iBin+1) = fevent(iCopy,1:npoints-iBin+1);
        end
    end

end
