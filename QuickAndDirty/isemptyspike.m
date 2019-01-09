function I = isemptyspike(spike)
% takes a spike struct array with fields t, x, y, p, and d
% returns 1 if spike is a scalar and its fields are empty
% returns 0 otherwise

I = isscalar(spike) && isempty(spike.t);