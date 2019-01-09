function [x, y] = spike2xy(spikeTrain, videoTS, videoX, videoY)
%[x, y] = SPIK2XY(spikeTrain, videoTS, videoX, videoY) Convert spike times to position (x, y)
%coordinates by interpolation
%
% Restricts |spikeTrain| to the time stamps. Specifically, to interval [t(1)-dt/2,
% t(end)+dt/2], where dt = mean(diff(t)), or dt = 1/60 if t is a scalar.
%
% SYNTAX:
%   XY = SPIKE2XY(S, T, X, Y)       Return (x, y) coordinates in a Nx2
%                                   matrix
% 
%   [X, Y] = SPIKE2XY(S, T, X, Y)   Return x- and y-coordinates in two
%                                   vectors X, Y.
%
% See also: spike2pos

[x, y] = spike2pos(spikeTrain, videoTS, videoX, videoY);

if nargin < 2
	x = [x(:), y(:)];
end