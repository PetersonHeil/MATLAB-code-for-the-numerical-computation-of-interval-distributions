function out = calculateDistributionFromIntervals(IEIs, varargin)
    vars.dt = [];
    vars.dt_hist = [];
    vars.max_hist = 500;
    vars.histEdges = [];
    vars.type = 'PDF';
    vars = updateVars(vars, varargin);

    % Calculate intervals
    IEIs = decround(IEIs, vars.dt);
    
    if isempty(vars.histEdges)
        vars.histEdges = 0:vars.dt_hist:vars.max_hist;
        vars.histEdges = decround(vars.histEdges, vars.dt_hist);
    end

    counts = histcounts(IEIs, vars.histEdges);

    PDF = histcounts(IEIs, vars.histEdges, 'Normalization', 'PDF');         % Units of "per ms"
    PMF = histcounts(IEIs, vars.histEdges, 'Normalization', 'probability'); % Units of "per bin"

    % Compute the CDF
    CDF = histcounts(IEIs, vars.histEdges, 'Normalization', 'CDF');

    % The survivor function for a discrete random variable can be obtained by
    % taking the complement of the CDF for X-1 (not for X). The subtraction 
    % of 1 from the X index is needed to yield the correct pevent value. 
    % Uncomment and execute the following for a demonstration of this fact:
%     pevent = 0.1;
%     X = 0:1:20;
%     P = geopdf(X,pevent);
%     S_naive = 1-geocdf(X,pevent);
%     S_corrected = 1-geocdf(X-1,pevent);
%     figure; hold all;
%     plot(X, P./S_naive);
%     plot(X, P./S_corrected);
%     legend('S(X) computed from CDF(X)', 'S(X) computed from CDF(X-1)')
%     ylim([0 1])

    % Compute the survivor function. Leading by a zero element is
    % equivalent to the X-1 shift demonstrated immediately above.
    SF = 1-[0 CDF(1:end-1)]; 

    % Comptue hazard rate function
    HRF = PDF./SF;

    % Due to normalization, the hazard rate and PDF have units of "per ms"
    % You would need to multiply this by 1000 to get units of "per second"

    out.HRF = HRF;
    out.CDF = CDF;
    out.PMF = PMF;
    out.PDF = PDF;
    out.SF = SF;
    out.counts = counts;
    out.binCenters = vars.histEdges(1:end-1)+vars.dt_hist/2;
    out.vars = vars;

end