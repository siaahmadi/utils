function o = oddelem(x, dim)


if ~exist('dim', 'var') || isempty(dim)
	dim = 1;
end

if dim ~= 1 && dim ~= 2
	error('dim == 1 OR dim == 2 accepted!');
end
if dim == 1
	o = x(1:2:end, :);
else
	o = x(:, 1:2:end);
end