function s = sgn(x)
% The sign function

s = x;

s(x > 0) = 1;
s(x < 0) = -1;