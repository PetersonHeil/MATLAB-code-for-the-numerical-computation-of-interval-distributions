function fdetection_contributions = get_fdetection_contributions(vars, iPlot)

    iShift = iPlot-1;
    fdetection_contributions = zeros(vars.recurrence.npoints);

    for i=1:vars.recurrence.npoints-iShift
        fdetection_contributions(i+iShift,i:vars.recurrence.npoints-iShift) = vars.recurrence.fevent(i+iShift,1:vars.recurrence.npoints-i-iShift+1) .* vars.deadtime.gdead(i);
    end

end