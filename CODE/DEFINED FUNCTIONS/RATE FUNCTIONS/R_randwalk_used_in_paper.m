function R = R_randwalk_used_in_paper(vars)

    if vars.window.dt ~= 0.1 || vars.window.tmin~=0 || vars.window.tmax~=5
        error('R_randwalk_fixed requires time parameters to match those used in the paper (dt=0.1, tmin=0, tmax=5).');
    elseif vars.settings.Rparams.R1~=600 || vars.settings.Rparams.Rrange~=150        
        error('R_randwalk_fixed requires rate parameters to match those used in the paper (R1=600, Rrange=150).');
    end

    mat = load('R_randwalk_used_in_paper.mat');
    R = mat.R;

end