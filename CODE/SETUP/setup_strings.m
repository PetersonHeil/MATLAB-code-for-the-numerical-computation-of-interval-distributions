function vars = setup_strings(vars)

    % Remove trailing slashes from save root
    while strcmp('\', vars.settings.saveRoot(end))
        vars.settings.saveRoot(end) = [];
    end

    % Build string for rate function parameters
    str_Rparams = [];
    RparamNames = fieldnames(vars.settings.Rparams);
    for iParam = 1:numel(RparamNames)
        if iParam>1
            str_Rparams = [str_Rparams ',']; %#ok<*AGROW>
        end
        str_Rparams = [str_Rparams RparamNames{iParam} '=' num2str(vars.settings.Rparams.(RparamNames{iParam}))];
    end
    str_Rparams = [vars.settings.Rtype ',' str_Rparams];

    % Build string for dead-time distribution parameters
    str_Gparams = [];
    GparamNames = fieldnames(vars.settings.Gparams);
    for iParam = 1:numel(GparamNames)
        if iParam>1
            str_Gparams = [str_Gparams ','];
        end
        str_Gparams = [str_Gparams GparamNames{iParam} '=' num2str(vars.settings.Gparams.(GparamNames{iParam}))];
    end

    % Determine path for results directory (just adds 1 to the last one)
    dirList = dir(vars.settings.saveRoot);
    dirNames = {dirList.name};
    dirNums = cellfun(@(x) str2double(x(7:end)), dirNames, 'UniformOutput', false);
    newNum = max(cell2mat(dirNums))+1;
    if isnan(newNum)
        newNum = 1;
    end
    vars.strings.saveName = ['RESULT ' num2str(newNum)];

    % Construct summary text to include in save directory
    vars.strings.saveSummary = {
        'RATE FUNCTION:' ...
        [functiontostring(vars.settings.Rfunction) '(' str_Rparams ')'], ...
        newline ...
        'DEAD-TIME DISTRIBUTION:' ...
        [functiontostring(vars.settings.Gfunction) '(' str_Gparams ') '], ...
        newline ...
        'OBSERVATION WINDOW:' ...
        ['dt=', num2str(vars.window.dt), ', t=[', num2str(vars.window.tmin), ', ', num2str(vars.window.tmax), ']']};

    % Construct save path and create directory
    vars.strings.savePath = [vars.settings.saveRoot '\' vars.strings.saveName '\'];
    if vars.settings.doSave && ~exist(vars.strings.savePath, 'dir')
        mkdir(vars.strings.savePath);
        fid=fopen([vars.strings.savePath 'SUMMARY.txt'],'wt');                      % Open a new file for writing
        fprintf(fid,'%s\n', vars.strings.saveSummary{:});                           % Write summary
        fclose(fid);                                                                % Close file
    end

end
