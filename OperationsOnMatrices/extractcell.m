function C = extractcell(C, dim)

if isempty(C)
	return;
end

if ~exist('dim', 'var') || isempty(dim)
	try
		C = [C{:}];
	catch
		C = cat(1, C{:});
	end
else
	C = cat(dim, C{:});
end