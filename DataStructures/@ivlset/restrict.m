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
	% todo more...
elseif isnumeric(sorted)
	if exist('refValues', 'var')
		varargin = [{refValues}, varargin];
		if numel(varargin{end}) == 1 && isa(varargin{end}, 'logical') && varargin{end}
			make_idx = varargin{end};
			varargin = varargin(1:end-1);
		end
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
for i = 1:length(varargout)
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
		inlineIdx = sum(cat(2, idx{:}), 2)>0;
	else
		for i = 1:length(b)
			inlineIdx = inlineIdx | (b(i) <= refValues(:) & refValues(:) <= e(i));
		end
	end
	return;
end

% find indices
idx_begin = abs(binsearch_approx(b, refValues));

idx_end = binsearch_approx(e, refValues);
idx_end(idx_end<0) = abs(idx_end(idx_end<0)) + 1;

idx = arrayfun(@(i) idx_begin == idx_end & idx_begin == i, [1:length(b)]', 'un', 0);

inlineIdx = sum(cat(1, idx{:})) > 0;