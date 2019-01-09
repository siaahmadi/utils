function posmat = xy2matpos(x, y)

if nargin == 1
	if size(x, 2) == 2
		y = x(:, 2);
		x = x(:, 1);
	elseif size(x, 1) == 2
		y = x(2, :);
		x = x(1, :);
	else
		error('Invalid x- and y- coordinates.');
	end
else
	if numel(x) == 4
		x = [x(:)', x(end)];
		y = [y(:)', y(end)];
	end
end

if ~isequal(size(x), size(y))
	error('Inconsistent x- and y-coordinate matrix sizes.');
end

posmat = [x(1), y(1), x(3)-x(1), y(2)-y(1)];