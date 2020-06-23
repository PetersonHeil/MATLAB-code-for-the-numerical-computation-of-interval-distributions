function compare_implementations(vars)

    % Check algorithm used to compute pdead and pdetection in publication
    compare_pdead_pdetection_pevent(vars);

    % Check algorithm used to compute fevent in publication
    compare_fevent(vars);
    
    % Check algorithm used to compute fdetection in publication
    compare_fdetection(vars);

    % Check algorithm used to compute RIDI in publication
    compare_pIEI_pIDI(vars);

end