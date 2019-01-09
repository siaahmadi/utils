function l = pathlen(x, y)
%PATHLEN Length of path taken by animal
%
% l = PATHLEN(x, y)
%    Accepts video data X and Y coordinates and return as output the length
%    of the path in the same unit as X and Y.
%
% See Also: crectify()

l = crectify(x, y);