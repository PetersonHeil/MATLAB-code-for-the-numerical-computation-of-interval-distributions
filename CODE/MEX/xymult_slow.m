function c = xymult_slow(a,b,nCompute)

    c = zeros(size(a));
    nPoints = size(a,1);

    for k=1:nCompute
        c(k,1:nPoints-k+1) = sum(a(k:end,k:end).*b(1:end-k+1,1:end-k+1));
    end

end