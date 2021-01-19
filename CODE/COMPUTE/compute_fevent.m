function fevent = compute_fevent(pevent, ncompute)

    npoints_window = numel(pevent);
    npoints_recurrence = npoints_window - 1;
    pNoEvent = 1 - pevent;

    % Compute survivor functions for each time point
    pNoEventYet = cumprod(triu(repmat(pNoEvent, npoints_window, 1)) + tril(ones(npoints_window),-1),2);    

	% Compute fevent (loop order optimizes for MATLAB's column-major matrix layout)
    fevent = zeros(ncompute,npoints_recurrence);
    for k=1:npoints_recurrence
        for i=1:min(ncompute, npoints_window-k)
            fevent(i,k) = pevent(i+k) .* pNoEventYet(i+1,k+i-1);
        end
    end

%     % Equivalent (loop order does not optimize for column-major matrix layout)
%     fevent2 = zeros(ncompute,npoints_recurrence);
%     for i=1:ncompute
%         for k=1:npoints_recurrence-i+1
%             fevent2(i,k) = pevent(i+k) .* pNoEventYet(i+1,k+i-1);
%         end
%     end

end


