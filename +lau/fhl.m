function L = fhl(logicalArray, tolerance)
%FHL(logicalArray, tolerance) Fill Holes Logical
%
% Utilizes image processing toolbox

% Siavash Ahmadi
% University of California, San Diego
% January 29, 2015

if ~islogical(logicalArray) || ~isvector(logicalArray)
	error('Hut Donguz')
end

isEven = mod(tolerance, 1)==0;

tolerance = floor(tolerance/2);

L = bwmorph(logicalArray, 'dilate', tolerance);
L = L & ~bwmorph(~L, 'dilate', tolerance);

if isEven
	L = ~bwmorph(~L,'clean', 1); % equivalent to fill for 1D
end