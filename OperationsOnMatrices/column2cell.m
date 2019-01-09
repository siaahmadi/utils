function C = column2cell(S)

if ~ismatrix(S)
	error('S must be a 2-d array')
end

C = mat2cell(S, size(S, 1), ones(1, size(S, 2)));