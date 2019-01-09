function h = horzplot(y,x0,x1, varargin)
%HORZPLOT Plot horizontal lines at y from x = x0 to x = x1
%
% h = HORZPLOT(y,x0,x1, varargin)

[ax, args] = axescheck(varargin{:});

Y = repmat(y(:)', 3, 1);
Y(3, :) = NaN;
Y = Y(:);

x = [x0; x1; NaN];
X = repmat(x, numel(y), 1);

if isempty(ax)
	h0 = plot(X, Y, args{:});
else
	h0 = plot(ax, X, Y, args{:});
end

if nargout > 0
	h = h0;
end