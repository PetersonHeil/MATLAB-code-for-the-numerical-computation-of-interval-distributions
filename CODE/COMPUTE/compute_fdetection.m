function fdetection = compute_fdetection(npoints_recurrence, gdead, fevent, ncompute, doUseMEX)

    % Setup fevent matrix
    fevent_rearranged = zeros(size(fevent));
    for iRow = 1:npoints_recurrence
        fevent_rearranged(iRow,:) = circshift(fevent(iRow,:),iRow-1);        
    end

    % Setup gdead matrix
    gdead_expanded = repmat(gdead(1:npoints_recurrence)',1,npoints_recurrence);

    % Get result where each row is the dot-product of progressive submatrices 
    % in which X shrinks toward lower right and Y shrinks toward upper left
    if doUseMEX
        fdetection = xymult_quick(fevent_rearranged, gdead_expanded, ncompute);
    else
        fdetection = xymult_slow(fevent_rearranged, gdead_expanded, ncompute);
    end

end
