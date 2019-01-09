function r = ratio(x)
%RATIO Ratio of subsequent array elements
%
% See also: diff()

r = x(1:end-1) ./ x(2:end);