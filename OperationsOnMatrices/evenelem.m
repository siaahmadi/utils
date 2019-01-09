function e = evenelem(x, dim)


if ~exist('dim', 'var') || isempty(dim)
	dim = 1;
end

if dim ~= 1 && dim ~= 2
	error('dim == 1 OR dim == 2 accepted!');
end
if dim == 1
	e = x(2:2:end, :);
else
	e = x(:, 2:2:end);
end