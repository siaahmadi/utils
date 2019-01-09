function I = isfat(M, byAtLeast)
%ISFAT Is matrix wider than it's tall?
%
% I = ISFAT(M, byAtLeast)    True if M is a row vector or an m-by-n matrix
% where m > n + byAtLeast

if ~exist('byAtLeast', 'var') || isempty(byAtLeast)
	byAtLeast = 1;
end

I = (~isscalar(M) & isrow(M)) | (ismatrix(M) & size(M, 2) >= size(M, 1) + byAtLeast);