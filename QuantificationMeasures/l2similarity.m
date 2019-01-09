function s = l2similarity(X)

norms = cellfun(@(x) norm(x,2), mat2cell(X, size(X,1), ones(size(X,2), 1)));

s = 1-(l2norm(X)./normsum(X)); % reciprocal of normalized L2-normed differences

function mm = maxmat(X)

mm = eye(length(X));

mm(mm==1) = X;

for i = 1:size(mm, 1)
	for j = i:size(mm, 2)
		mm(i,j) = (mm(i, i)+ mm(j, j));
		mm(j,i) = mm(i,j);
	end
end

function mm = normsum(X)

mm = nan(size(X, 2));

for i = 1:size(mm, 1)
	for j = i:size(mm, 2)
		mm(i,j) = norm(X(:, i)+X(:,j), 2);
		mm(j,i) = mm(i,j);
	end
end
