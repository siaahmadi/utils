function l = crectify(x, y)
%CRECTIFY Rectify Curve
%
% l = CRECTIFY(X, Y)
%    Accepts a 2-d curve specified by X and Y and returns the length of the
%    curve, computed as the cumulative sum of the distances between
%    successive points on the curve.
%
% See Also: pathlen()

r = eucldist(x(1:end-1), y(1:end-1), x(2:end), y(2:end));
l = cumsum(r);
l = [0; l(:)];