function m = meanw(A, w, dim)
% Calculate weighted average of matrix A
% A is a matrix of real values
%
% w is a vector of weights: if w(i) is in [0, 1) for all i then the entries will be
% regarded as weights, otherwise if w(1) is an integer the entries will be
% regarded as count
%
% dim is the dimension on which A should be averaged
% this version of meanw assumes A is an m x n matrix
%
% EXAMPLE:
% A =
%      5     1     3
%     10     2     6
%      1     3     9
%
% meanw(A, [2 1 2], 1) = 4.4000    2.0000    6.0000
%
% meanw(A, [2 1 2], 2) =
% 						3.4000
% 						6.8000
% 						4.6000

% Version Feb 17, 2013
% copyright (c) 2013 Siavash Ahmadi
% This software is released under GNU GPL
% www.gnu.org/copyleft/gpl.html

if nargin < 2
	m = mean(A);
	return
elseif nargin < 3
	dim = 1;
end

for i = 1:length(w)
	if ~(0 <= w(i) && w(i) < 1)
		w = w/sum(w);
		break;
	end
end

% TODO: check if dim makes sense in A

% this version of meanw assumes A is an m x n matrix
if dim == 2
	for j = 1:size(A, 2)
		A(:, j) = A(:, j) * w(j);
	end
else
	for i = 1:size(A, 1)
		A(i, :) = A(i, :) * w(i);
	end
end
m = mean(A, dim)*size(A, mod(dim+1,2)+1);