function [ivl, ivl2] = toIvl(obj, Uniform, beginOrEnd) % main retrieval function: returns the delimters of the interval
% Uniform determines whether a cell array or a numeric array
% should be returned. If Uniform==true (default) then a single
% integer array will be returned with the intervals
% concatenated back to back, and in order.

if isempty(obj)
	ivl = [NaN, NaN];
	if nargout == 2
		ivl2 = ivl(:, 2);
		ivl = ivl(:, 1);
	end
	return;
end

validBeginOrEnd = {'begin', 'end', 'both'};

if nargin < 2
	if ~exist('Uniform', 'var')
		Uniform = true;
	end
	if ~exist('beginOrEnd', 'var')
		beginOrEnd = 'both';
	end
elseif nargin < 3 % First argument provded
	if exist('Uniform', 'var') && islogical(Uniform)
		beginOrEnd = 'both';
	elseif ischar(Uniform)
		beginOrEnd = Uniform;
		Uniform = true;
	else
		error('IvlSet:toIvl:InvalidArgument:Type', 'Provide either a logical value or a string from set {''begin'', ''end''}.')
	end
elseif nargin < 4 % Both arguments provided
	if (~isempty(Uniform) && ~islogical(Uniform)) || ~ischar(beginOrEnd) || ~any(strcmp(validBeginOrEnd, beginOrEnd))
		error('IvlSet:toIvl:InvalidArgument:Type', 'Provide a logical value as first argument (or pass on an empty matrix) and a string from set {''begin'', ''end''} as the second argument.')
	end
end

if isempty(Uniform)
	Uniform = true;
end
if isempty(beginOrEnd)
	beginOrEnd = 'both';
end

if strcmpi(beginOrEnd, 'begin')
	ivl = obj.Begin(:);
elseif strcmpi(beginOrEnd, 'end')
	ivl = obj.End(:);
elseif strcmpi(beginOrEnd, 'both')
	ivl = [obj.Begin(:), obj.End(:)];
else
	error('');
end

if nargout == 2 && ~strcmpi(beginOrEnd, 'both')
	error('IvlSet:toIvl:IncompatibleInAndOutArgs', 'When two outputs are provided, the beginOrEnd input argument must be set to ''both''.');
end
if ~Uniform && ~strcmpi(beginOrEnd, 'both')
	error('IvlSet:toIvl:IncompatibleInArgs', 'When non-uniform (cell array) output is requested, the beginOrEnd input argument must be set to ''both''.');
end

if nargout == 2
	ivl2 = ivl(:, 2);
	ivl = ivl(:, 1);
end

if ~Uniform
	if nargout < 2
		ivl = mat2cell(ivl, ones(size(ivl, 1), 1), 2);
	elseif nargout == 2
		ivl = num2cell(ivl);
		ivl2 = num2cell(ivl2);
	end
end