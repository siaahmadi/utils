function j = jitter(m, radius)
%JITTER Generate uniformly distributed random numbers
%
% j = JITTER(m, radius)
%
%   m is the mean around which the jitter should be generated (DEFAULT=1).
%
%   radius is 1/2 the interval over which the jitter should be generated(DEFAULT=0.05).

% Siavash Ahmadi
% 12/21/2015 10:47 PM

if ~exist('m', 'var') || isempty(m)
	m = 1;
end
if ~exist('radius', 'var') || isempty(radius)
	radius = .05;
end

n = numel(m);

j = rand(n, 1) - .5;

j = j*radius*2;

j = j + m;