%% Get OTF from PSF layers
function mm = getOTF(m)
global zeroImageEx;
global exsize;

mmid = floor(size(m)/2);
m = zeroPad(m, zeroImageEx);
mc = 1 + mmid;
me = mc + exsize - 1;
m = exindex(m, mc(1):me(1), mc(2):me(2), 'circular');
mm = fft2(m);

end

function arr = exindex(arr, varargin)
% Sort out arguments
[exindices, rules, nd, sz] = getinputs(arr, varargin{:});
consts = cellfun(@iscell, rules);  % Check for constants, as can be
constused = any(consts);           % more efficient if there are none

% Setup for constant padding
if constused
    tofill = cell(1, nd);
end

% Main loop over subscript arguments, transforming them into valid
% subscripts into arr using the rule for each dimension
if constused
    for i = 1:nd
        [exindices{i}, tofill{i}] = extend(exindices{i}, rules{i}, sz(i));
    end
else % no need for information for doing constants
    for i = 1:nd
        exindices{i} = extend(exindices{i}, rules{i}, sz(i));
    end
end

% Create the new array by indexing into arr. If there are no constants,
% this does the whole job
arr = arr(exindices{:});

% Fill areas that need constants
if constused
    % Get full range of output array indices
    ranges = arrayfun(@(x) {1:x}, size(arr));
    for i = nd:-1:1    % order matters
        if consts(i)
            ranges{i} = tofill{i};      % don't overwrite original
            c = rules{i};               % get constant and fill ...
            arr(ranges{:}) = c{1};      % we've checked c is scalar
            ranges{i} = ~tofill{i};     % don't overwrite
        end
    end
end

end

% -------------------------------------------------------------------------

function [exindices, rules, nd, sz] = getinputs(arr, varargin)
% Sort out and check arguments. Inputs are as given in the help comments
% for exindex. Outputs are cell arrays; each element of exindices is a
% set of integer extended indices which has been checked for validity; each
% element of rules is a rule which has not been checked for validity.

% Use index/rules arguments only to establish no. dimensions - ndims(arr)
% is no use, as trailing singleton dimensions truncated and vectors can be
% 2D or 1D
nd = length(varargin);
if nd == 0
    error('exindex:missingargs', 'Not enough arguments');
elseif nd == 1
    exindices = varargin;
    rules = {{0}};
elseif ~(isnumeric(varargin{2}) || strcmp(varargin{2}, ':'))
    % have alternating indices and rule
    nd = nd/2;
    if round(nd) ~= nd
        error('exindex:badnumargs', ...
            'Odd number of arguments after initial index/rule pair');
    end
    exindices = varargin(1:2:end);
    rules = varargin(2:2:end);
elseif nd > 2 && ~(isnumeric(varargin{end}) || strcmp(varargin{end}, ':'))
    % have a general rule at end
    nd = nd - 1;
    exindices = varargin(1:nd);
    [rules{1:nd}] = deal(varargin{end});
else
    % no rule is specified
    exindices = varargin;
    [rules{1:nd}] = deal({0});
end

% Sort out mismatch of apparent array size and number of dimensions
% indexed
sz = size(arr);
ndarr = ndims(arr);
if nd < ndarr
    if nd == 1 && ndarr == 2
        % Matlab allows vectors to be indexed with a single subscript and
        % to retain their shape. In all other cases (including scalars) a
        % single subscript causes the output to take the same shape as the
        % subscript array - we can't deal with this.
        if sz(1) == 1 && sz(2) > 1
            % have a row vector
            exindices = [{1} exindices {1}];
            rules = [rules rules];  % 1st rule doesn't matter
        elseif sz(2) == 1 && sz(1) > 1
            % have a column vector
            exindices = [exindices {1}];
            rules = [rules rules];  % 2nd rule doesn't matter
        else
            error('exindex:wantvector', ...
                'Only one index but array is not a vector');
        end
    else
        error('exindex:toofewindices', ...
            'Array has more dimensions than there are index arguments');
    end
    nd = 2;
elseif nd > ndarr
    % Effective array size
    sz = [sz ones(1, nd-ndarr)];
end

% Expand any colons now to simplify checking.
% It's tempting to allow the 'end' keyword here: easy to substitute the
% size of the dimension. However, to be worthwhile it would be necessary to
% use evalin('caller',...) so that expressions using end could be given as
% in normal indexing. This would mean moving the code up to exindex itself,
% and evalin makes for inefficiency and fragility, so this hasn't been
% done.
colons = strcmp(exindices, ':');
if any(colons)  % saves a little time
    exindices(colons) = arrayfun(@(x) {1:x}, sz(colons));
end

% Check the indices (rules are checked as required in extend)
checkindex = @(ind) validateattributes(ind, {'numeric'}, ...
    {'integer'}, 'exindex', 'index');
cellfun(checkindex, exindices);

end

% -------------------------------------------------------------------------

function [ind, tofill] = extend(ind, rule, s)
% The core function: maps extended array subscripts into valid input array
% subscripts.

if ischar(rule)    % pad with rule
    
    tofill = [];  % never used
    switch rule
        case 'replicate'
            ind = min( max(1,ind), s );
        case 'circular'
            ind = mod(ind-1, s) + 1;
        case 'symmetric'
            ind = mod(ind-1, 2*s) + 1;
            ott = ind > s;
            ind(ott) = 2*s + 1 - ind(ott);
        otherwise
            error('exindex:badopt', 'Unknown option');
    end
    
elseif iscell(rule) && isscalar(rule)     % pad with constant
    
    % The main messiness is due to constant padding. This can't be done
    % with indexing into the original array, but we want the indexing
    % structure to be preserved, so for now we index to element 1 on each
    % dimension, and record the indices of the regions that need to be
    % fixed.
    
    tofill = ind < 1 | ind > s;
    ind(tofill) = 1;
    
else
    
    error('exindex:badconst', 'Expecting string or scalar cell');
    
end

end



