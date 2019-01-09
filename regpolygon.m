function [px, py] = regpolygon(nSides, radius, enclosingCircle, closeEnd)
%[PX, PY] = POLYGON(NSIDES, RADIUS, CLOSEEND) Generate coordinates for a
% regular polygon with specified number of sides and radius centered at
% origin.
%
% |enclosingCircle| (default = 'circ') specifies whether the radius is the
% polygon's incircle or circumcircle.
%
% |closeEnd| (default = true) closes the polygon by repeating the starting
% point at the end of the px and py matrices.

% Siavash Ahmadi
% 9/17/15

	if nSides < 1 || floor(nSides) ~= nSides
		error('nSides must be a positive integer');
	end
	if nSides == 1 || nSides == 2
		warning('The resulting shape is not a polygon. Choose nSides => 3')
	end
	
	if ~exist('enclosingCircle', 'var')
		enclosingCircle = 'circ';
	end

	if mod(nSides, 2) == 0 % is even
		theta0 = pi/2 - pi/nSides;
		radiusCorrection = radius*(1-sin(theta0));
	else
		theta0 = pi/2;
		radiusCorrection = -radius*(1+sin(2*pi/nSides*(nSides-1)/2+theta0));
	end
	theta = 2*pi/nSides;
	if strcmpi(enclosingCircle, 'in')
		radius = radius + radiusCorrection;
	end
	[px,py] = pol2cart(theta*(0:nSides-1)' + theta0, radius);
	
	% make sure the first element of [px, py] is the point with smallest
	% positive angle:
	buffer = atan2(py, px);
	n_shift = sum(buffer >= 0 & buffer < theta0);
	px = circshift(px, n_shift);
	py = circshift(py, n_shift);
	
	% close the polygon?
	if ~exist('closeEnd', 'var') || closeEnd
		px = [px; px(1)];
		py = [py; py(1)];
	end
	
	if nargout < 2
		px = [px, py];
		return;
	end
end