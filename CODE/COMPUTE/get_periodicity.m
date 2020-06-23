% Determines whether a vector is periodic and returns the number of bins per period
function nBinsPerCycle = get_periodicity(Y, tolerance)

    % Count the number of points in Y
    n = numel(Y);
    
    % Assume by default that Y is not periodic
    nBinsPerCycle = n;

    % Try out different potential lags and stop if one works
    for lag=1:n
        % First expand (i.e., pad) Y with nans so it can be reshaped for current lag
        nexpanded = int64(decround(n, lag, @ceil));
        Yexpanded = nan(1, nexpanded);
        Yexpanded(1:n) = Y;
        
        % Reshape Y for the current lag
        ncycles = int64(nexpanded/lag);
        Yexpanded = reshape(Yexpanded, lag, ncycles);

        % Check periodicity by computing differences between lagged bins
        diff_result = diff(Yexpanded,1,2);
        diff_result(abs(diff_result) < tolerance) = 0;
        isPeriodic = ~nansum(diff_result(:));

        % If periodicity is found then save the lag and stop looking
        if isPeriodic
            nBinsPerCycle = lag;
            break;
        end
    end

end