function fevent = compute_fevent(pevent, ncompute)

    npoints_window = numel(pevent);
    npoints_recurrence = npoints_window - 1;
    pNoEvent = 1 - pevent;

    pNoEventYet = cumprod(triu(repmat(pNoEvent, npoints_window, 1)) + tril(ones(npoints_window),-1),2);    

    fevent = zeros(ncompute,npoints_recurrence);
    for i=1:ncompute
        for w=1:npoints_recurrence-i+1
            fevent(i,w) = pevent(i+w) .* pNoEventYet(i+1,w+i-1);
        end
    end

end


