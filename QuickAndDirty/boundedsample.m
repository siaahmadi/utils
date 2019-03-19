function [s, I] = boundedsample(x, bound)
%[s, I] = BOUNDEDSAMPLE(x, bound) Return a subsample
%                                 of size `min(bound, len(x))` from x
%
% If bound >= numel(x), returns x
% Otherwise, returns a uniform random sample of x's entries, w/ size |bound|
%
% Intended for subsampling MClust spike display for large NTT files

% Sia Ahmadi
% 11/29/2018

if bound >= numel(x)
	s = x;
else
	I = randsample(numel(x), bound);
	s = x(I);
end