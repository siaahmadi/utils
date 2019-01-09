function [mi, mi_unbiased, mi_normalized] = mutinfo(vec1, vec2)

if nargin == 1 && ismatrix(vec1)
	mi = nan(size(vec1, 2));
	mi_unbiased = mi;
	for col = 1:size(vec1, 2)
		for row = col:size(vec1, 2)
			[mi(row, col), mi_unbiased(row, col)] = mutinfo(vec1(:, row), vec1(:, col));
			mi(col, row) = mi(row, col);
			mi_unbiased(col, row) = mi_unbiased(row, col);
		end
	end
	mi_normalized = normalizetodiag(mi);
	return
elseif nargin == 1 && ~ismatrix(vec1)
	error('vec1 must be a matrix, or else two vectors should be provided.')
end

numBins = 20;

range1 = max(vec1) - min(vec1);
range2 = max(vec2) - min(vec1);

[pxy, xy] = hist3([vec1, vec2], [numBins numBins]); pxy = pxy / sum(sum(pxy));
X = xy{1};
Y = xy{2};
px = histc(vec1, linspace(min(vec1), max(vec1)+1e-10*range1, numBins+1));
px = px(1:end-1) / sum(px);
py = histc(vec2, linspace(min(vec2), max(vec2)+1e-10*range2, numBins+1));
py = py(1:end-1) / sum(py);

i = @(x,y) closestPoint(x, 1:length(x), y); % indexing function
p_XY = @(x, y) pxy(i(X, x), i(Y, y)); % joint probability density
p_X = @(x) px(i(X, x));% probability density of first vector
p_Y = @(y) py(i(Y, y));% probability density of first vector

mi = 0;

for x = X
	for y = Y
		addedInfo = p_XY(x,y) * log2(p_XY(x,y) / (p_X(x) * p_Y(y)));
		if addedInfo > 0
			mi = mi + addedInfo;
		end
	end
end
mi_unbiased = mi - numBins / (2 * length(vec1) * log(2));	% http://ai.stanford.edu/~gal/Research/Redundancy-Reduction/Neuron_suppl/node2.html
															% see also Paninski, L. (2003), Neural Comp.
															
function X = normalizetodiag(X)
for i = 1:size(X, 1)
	for j = i:size(X, 2)
		if i ~= j
			X(i,j) = X(i,j) / min(X(i,i), X(j,j));
			X(j,i) = X(i,j);
		end
	end
end