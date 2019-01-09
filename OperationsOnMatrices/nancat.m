function C = nancat(dim, varargin)

if dim == 2
	if nargin > 2
		A = varargin(:)';
	else
		C = varargin{1}(:);
		return;
	end
	
	maxRows = max(cellfun(@numel, A));
	C = cellfun(@(x) cat(1, x, NaN(maxRows-numel(x), 1)), A, 'un', 0);
elseif dim == 1
	A = varargin{1}(:);
	
% 	maxCols = max(cellfun(@numel, A));
	maxCols = max(cellfun(@(x) size(x, 2), A));
	C = cellfun(@(x) cat(2, x, NaN(size(x, 1), maxCols-size(x, 2))), A, 'un', 0);
end


C = cell2mat(C);