function [x, y] = matpos2xy(posmat)

if ~isvector(posmat) || numel(posmat) ~= 4
	error('Invalid position matrix.');
end

x = [posmat(1), posmat(1), posmat(1) + posmat(3), posmat(1) + posmat(3), posmat(1)];
y = [posmat(2), posmat(2) + posmat(4), posmat(2) + posmat(4), posmat(2), posmat(2)];

if nargout < 2
	x = [x(:), y(:)];
end