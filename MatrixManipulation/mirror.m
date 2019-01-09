function m = mirror(A, dim)

if nargin == 1
	dim = 1;
end

if dim == 1
	m = [A; flipud(A)];
elseif dim == 2
	m = [A fliplr(A)];
else
	error('dim must be 1 or 2')
end