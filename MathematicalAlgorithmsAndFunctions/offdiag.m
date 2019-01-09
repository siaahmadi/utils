function [Z, Y] = offdiag(X)
%OFFDIAG Return off-diagonal elements of matrix X
%
% [Z, Y] = OFFDIAG(X)
%
% Z: list of off-diagonal elemnets
% Y: set diagonal of X to 0

M = size(X, 1);
N = size(X, 2);
idx = eye(M,N);
Y = (1-idx).*X;
Z = X(~idx);