function dead_times = draw_dead_times(Gdead, d, N)

    % Prepare Gdead and d for use with the approach implemented here
    [Gdead, d] = helper_prepare_Gdead_and_d(Gdead, d);

    % Draw N uniformly distributed probabilities
    rand_p = rand(N,1);

    % Map probabilities to duration d via binning
    [~,~,idx] = histcounts(rand_p, Gdead);
    dead_times = d(idx);

end



function [Gdead, d] = helper_prepare_Gdead_and_d(Gdead, d)

    % Remove any excess 1's at the end of Gdead, leaving only the first instance
    iEnd = find(Gdead==1, 1, 'first');
    if ~isempty(iEnd)
        Gdead = Gdead(1:iEnd);
        d = d(1:iEnd);
    end

    % Remove adjacent duplicates from Gdead, leaving only the last instance of each
    iDel = ~diff(Gdead);
    Gdead(iDel) = [];
    d(iDel) = [];
    
    % If Gdead does not end at 1, then add one more point to make sure it does
    if Gdead(end) < 1
        Gdead = [Gdead 1];
        d = [d inf];
    end
    
    % If Gdead does not start at 0, then add one more point to make sure it does
    if Gdead(1) > 0
        Gdead = [0 Gdead];
        d = [-inf d];
    end
    
end
