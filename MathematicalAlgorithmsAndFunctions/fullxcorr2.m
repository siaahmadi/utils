function C = fullxcorr2(A)
% A must be a 3 dimensional, m by n by k matrix
% C will be a k by k matrix of non-displacement, cross correlations of
% pages of A

C = nan(size(A, 3));

for j = 1:size(C, 2)
	for i = j:size(C, 1)
		try
			c = (normxcorr2(A(:, :, i), A(:, :, j))); c = c(size(A, 1), size(A, 2));
		catch
			continue;
		end
		C(i, j) = c;
		C(j, i) = c;
	end
end