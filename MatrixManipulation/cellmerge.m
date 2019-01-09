function c = cellmerge(c, dim)

if ~exist('dim', 'var') || isempty(dim)
	dim = 2;
end

if dim == 1
	c = column2cell(c);
elseif dim == 2
	c = row2cell(c);
end

orientation = 1 + ~all(cellfun(@(x) iscolumn(x) | isempty(x), c{1}));
c = cellfun(@(x) cat(orientation, x{:}), c, 'un', 0);