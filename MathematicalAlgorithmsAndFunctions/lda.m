function [W, y, D, bestDiscriminant, y1D] = lda(X, l)
%LDA Perform Fisher's Linear Discriminant Analysis
%	
% INPUT:
% X:
%	N x D matrix where N is the number of observations and D is the number of
%	variables (dimensions)
%
% l:
%	Vector of length N with two distinct labels for two classes.
%	If there are more than two distinct labels an error will be issued.
%
%
% OUTPUT:
% W:
%	The transformation matrix (D x D)
%
% y:
%	The matrix X transformed into the new basis
%
% D:
%	Matrix of eigenvalues (scores) of the new basis with the scores on the
%	diagonal
%
% bestDiscriminant:
%	Identical to W(:, 1)
%
% y1D:
%	The data (X) projected onto the 1-dimensional subspace spanned by
%	W(:, 1)
%
%   See also pca

uniqueLabels = unique(l);
if numel(uniqueLabels) ~= 2
	error('The number of distinct labels in L must be exactly 2. This function can only handle 2 classes!')
end

l = l>mean(uniqueLabels); % convert label to logicals

X_centered = zscore(X);
x1 = X_centered(l, :); % N1 x d, where N1 = numel(class 1)
x2 = X_centered(~l, :);% N2 x d, where N2 = numel(class 2)

m = [mean(x1); mean(x2)]; % 2 x d
m_t  = mean(X_centered); % 1 x d

Sb = (m - repmat(m_t, size(m, 1), 1))' * (m - repmat(m_t, size(m, 1), 1));

xc1 = x1 - repmat(m(1, :), size(x1, 1), 1); % N1 x d
xc2 = x2 - repmat(m(2, :), size(x2, 1), 1); % N2 x d
Sw = xc1'*xc1 + xc2'*xc2; %[xc1;xc2]' * [xc1;xc2];

[W, D] = eig(Sw \ Sb);

[eigV, eigOrder] = sort(diag(D));

[U, S, W] = svd(Sw \ Sb); 
bestDiscriminant = W(:, 1:end-1);
y = X * W;

% y = X*W(:, eigOrder);
% bestDiscriminant = W(:, eigOrder(1));
% y1D = X * bestDiscriminant;