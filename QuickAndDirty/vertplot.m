function h = vertplot(x,h0,h1, varargin)
%VERTPLOT Plot vertical lines at x from y = h0 to y = h1
%
% h = vertplot(x,h0,h1, varargin)

[ax, args] = axescheck(varargin{:});

X = repmat(x(:)', 3, 1);
X(3, :) = NaN;
X = X(:);

y = [h0; h1; NaN];
Y = repmat(y, numel(x), 1);

if isempty(ax)
	h0 = plot(X, Y, args{:});
else
	h0 = plot(ax, X, Y, args{:});
end

if nargout > 0
	h = h0;
end