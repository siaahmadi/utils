function [x, y] = spike2pos(s, t, x, y, dt)
%[x, y] = SPIKE2POS(s, t, x, y) Convert spike times to position (x, y)
%coordinates by interpolation
%
% Restricts |s| to the time stamps. Specifically, to interval [t(1)-dt/2,
% t(end)+dt/2], where dt = mean(diff(t)), or dt = 1/60 if t is a scalar.
%
% SYNTAX:
%	XY = SPIKE2POS(S, T, X, Y)		Return (x, y) coordinates in a Nx2
%									matrix
% 
%	[X, Y] = SPIKE2POS(S, T, X, Y)	Return x- and y-coordinates in two
%									vectors X, Y.
%
% See also: spike2xy

% Siavash Ahmadi
% 12/17/2015 10:04 PM

if ~exist('dt', 'var') && length(t)>1
	dt = mean(diff(t));
elseif ~exist('dt', 'var')
	dt = 1/60;
end

s = restr(s, t(1)-dt/2, t(end)+dt/2);
% x = interp1(t, x, s, 'linear', 'extrap');
% y = interp1(t, y, s, 'linear', 'extrap');
idx = abs(binsearch_approx(t, s, 1));
x = x(idx);
y = y(idx);

if nargout == 1
	x = [x(:), y(:)];
end