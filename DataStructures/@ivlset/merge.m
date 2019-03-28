function masterIvl = merge(obj, varargin)
%masterIvl = MERGE(obj, varargin)
%
% Combine two or more ivlset objects

if nargin > 1
	masterIvl = [obj; cat(1, varargin{:})];
end

if numel(obj) == 1
	return;
else
	[b, e] = arrayfun(@toIvl, obj, 'un', 0);
	masterIvl = ivlset(cat(1, b{:}), cat(1, e{:}));
end