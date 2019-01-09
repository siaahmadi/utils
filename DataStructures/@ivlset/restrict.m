function [idx, varargout] = restrict(obj, sorted, refValues, varargin)
%RESTRICT Restrict values to within the intervals of the ivlset object
%
% [idx, varargout] = RESTRICT(obj, sorted, refValues, varargin[, make_idx])
%
%  INPUT:
%  sorted    Can take only one value 'unsorted'. Indicate this if refValues
%            are unsorted. Otherwise, it will be assumed that they are
%            sorted.
%
%  refValues must be in the same unit as the intervals of the ivlset object
%  
%  an arbitrary number of inputs may follow refValues. Each such input must
%  be the same size as refValues. refValues will be treated as the "time
%  stamps" into each input.
%
%  make_idx  If true, it will generate an idx cell array as output that's
%  the length of the number of intervals in obj, with each entry being a
%  logical array of length(refValues), DEFAULT: false (for memory
%  efficiency)
%
% OUTPUT:
% idx     binary indexing into refValues that fall within the intervals of
%         the ivlset object
% 
% each output after idx will be the restricted values taken from the
% corresponding input values.
%
% EXAMPLE:
% [idx, valid_timestamps] = ivl.restrict(T, T);
%
% after this we have:
% valid_timestamps == T(idx);

% Siavash Ahmadi


if numel(obj) > 1
	idx = arrayfun(@(o) o.restrict(refValues), obj, 'un', 0);
	return;
end

make_idx = false;

if ischar(sorted) && strcmpi(sorted, 'unsorted')
	sorted = false;
elseif isnumeric(sorted)
	if exist('refValues', 'var')
		if ~isequal(size(varargin{end}), size(refValues))
			make_idx = varargin{end};
			varargin = varargin{1:end-1};
		end
		varargin = [{refValues}, varargin{:}];
	end
	refValues = sorted;
	sorted = true;
else
	error('|sorted| must either be specified as ''unsorted'' or skipped.');
end

iCollapsed = false;

if ~obj.iscollapsed()
	obj.collapse('|');
	iCollapsed = true;
end

[b, e] = obj.toIvl();

if sorted
	[inlineIdx, idx] = findStartEnd(refValues, b, e, make_idx);
else
	idx = arrayfun(@(b, e) b <= refValues(:) & refValues(:) <= e, b, e, 'UniformOutput', false);
	inlineIdx = sum(cat(2, idx{:}), 2)>0;
end

varargout = cell(size(varargin));
for i = 1:nargin - 2 - double(~sorted)
	varargout{i} = varargin{i}(inlineIdx);
end

if iCollapsed
	obj.uncollapse();
end

function [inlineIdx, idx] = findStartEnd(refValues, b, e, make_idx)
inlineIdx = false(size(refValues));
idx = [];
if make_idx
	idx = repmat({false(size(inlineIdx))}, length(b), 1);
end

if isempty(refValues)
	return;
elseif numel(refValues) == 1
	if make_idx
		idx = arrayfun(@(b, e) b <= refValues(:) & refValues(:) <= e, b, e, 'UniformOutput', false);
	end
	inlineIdx = sum(cat(2, idx{:}), 2)>0;
	return;
end

% find indices
idx_begin = binsearch_approx(refValues, b);
minus_infinity = b == -Inf;
plus_infinity = b == Inf;
idx_begin(minus_infinity) = 1;
idx_begin(plus_infinity) = length(refValues);
% idx_begin elements can be negative (approximate values found), positive
% (exact values found), or 0 (out-of-range values).
% For positives, all good.
% For negatives, make them positive and add an index so only least value
% larger than b(i) will be included for idx_begin(i) < 0
idx_begin(idx_begin<0) = abs(idx_begin(idx_begin<0))+1;
% For out-of-range values set them to 1 only if they fall to the left of
% the refValues:
ilt = b(idx_begin==0)<refValues(1); % ilt==index of less-than
idx_begin(ilt) = 1;

idx_end = abs(binsearch_approx(refValues, e, 1));
minus_infinity = e == -Inf;
plus_infinity = e == Inf;
idx_end(minus_infinity) = 1;
idx_end(plus_infinity) = length(refValues);
% in a similar fashion to idx_begin, only set those idx_end's that are to the right of
% refValues:
igt = e(idx_end==0)>refValues(end); % igt==index of greater-than
idx_end(igt) = length(refValues);

for i = 1:length(idx_begin)
	if idx_begin(i) > 0 && idx_end(i) > 0 && idx_end(i) >= idx_begin(i) % if binsearch_approx's return values are valid indices (i.e. keys found)
		inlineIdx(idx_begin(i):idx_end(i)) = true;
		if make_idx
			idx{i}(idx_begin(i):idx_end(i)) = true;
		end
	end
end