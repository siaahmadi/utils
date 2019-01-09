function C = mycov(X)

C = nan(size(X, 2));
for i = 1:size(X, 2)
	for j = i:size(X, 2)
		buffer = cov(X(:, i) / max(max(X(:, [i j]))), X(:, j) / max(max(X(:, [i j]))));
		C(i,j) = buffer(2);
		C(j,i) = buffer(2);
	end
end