function [x, y] = p___swap(obj1, obj2)
%[x, y] = swap(obj1, obj2) Swap handles or values
%
% If both input arguments are handles, they will be swapped in-place and no
% output arguments are returned.
%
% If both input arguments are values, they will be swapped in the following
% sense: the first output will carry the second output and vice versa.

% Siavash Ahmadi
% 10/29/15 3:19 PM

if ishandle(obj1) && ishandle(obj2)
	if nargout > 0
		error('Inputs are handle objects. Can''t output anything.');
	end
	buffer = obj1;
	obj1 = obj2; %#ok<*NASGU>
	obj2 = buffer;
elseif strcmp(class(obj1), class(obj2)) % at least one is not a handle; let's see if they're the same type
	x = obj2;
	y = obj1;
else
	error('Cannot handle a mixture of handle and value objects.');
end