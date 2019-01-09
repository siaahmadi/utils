function sm_mat = smoothrows(A, By)

if nargin == 1
	By = 5;
end

a = size(A);

sm_mat = reshape(smooth(A', By), fliplr(a))';