% This function takes variables in varargin and determines the key-value
% pairs specified. varargin can include key-value pairs or a struct.
% ----------------------------------------------------------------------------------
function vars = getVars(varargin)

    % Unpack varargin in case it has become buried/nested
    while numel(varargin) == 1 && iscell(varargin{1})
        varargin = varargin{:,:};
    end

    % Initialize outputs
    vars = [];
    
    % Process the input
    if numel(varargin) == 1 && isstruct(varargin{1})
        vars = varargin{1};
    elseif iscell(varargin) && mod(numel(varargin),2) == 0
            for i=1:2:numel(varargin)
                key = varargin{i};
                val = varargin{i+1};
                vars.(key) = val;
            end
    elseif numel(varargin) == 1 && isempty(varargin{:})
        % varargin is empty, no big deal. Just ignore.
    else
        error('Parameters must be passed as key-value pairs or in a structure.');
    end

end