function A = cellrotinpcon(A)
%cellrotinpcon(A) (rot)ate (in p)lace and (con)solidate (cell) arrays
%
% Transposes matrix in each cell within its location and
% consolidates the resulting cell array along the second
% dimension

A = mat2cell(reshape(cell2mat(A)', size(A{1}, 2), size(A, 2)*size(A, 1)), size(A{1}, 2), repmat(size(A, 2), size(A, 1), 1))';