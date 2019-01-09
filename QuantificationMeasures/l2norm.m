function d = l2norm(X)
% computes L-2 norm for pairs of X's columns

d = zeros(size(X, 2));
for i = 1:length(d)
	for j = i:length(d)
		d(i,j) = norm(X(:, i)-X(:,j), 2);
		d(j,i) = d(i,j);
	end
end