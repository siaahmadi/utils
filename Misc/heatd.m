function [h, d_smooth, xim, yim, d] = heatd(x, y, varargin)
%HEATD Heat map of (x, y) point density
%
%
% SYNTAX:
%	[h, d_smooth, xim, yim, d] = heatd(x, y, varargin)
%
%
% INPUT:
% X
%	x-coordinates of data.
%
% Y
%	y-coordinates of data.
%
%
% OPTIONAL (Param-Value pairs)
%	nBins (default=[30, 30])
%		Number of bins the data should be binned into.
%
%	smoothingKernel (default=3)
%		The standard deviation of the gaussian smoothing kernel.
%
%	boxcarWin (default=[3,3])
%		Window over which smoothing takes place. Units are in number of
%		bins of heat map.
%
%	Normalization (default='probability')
%		Specify whether the heat map should be a probability density
%		function. Possible values are 'probability' (default) and 'none'.
%
%
% OUTPUT
% h
%	Handle to heat map object.
%
% d_smooth
%	The heat map matrix.
%
% xim
%	x-labels of heat map.
%
% yim
%	y-labels of heat map.
%
% d
%	Unsmoothed version of heat map.

% Siavash Ahmadi
% 12/06/2015 8:45 PM

p = inputParser;
p.addParameter('nBins', [30, 30], @(x) validateattributes(x, {'numeric'}, {'size', [1, 2]}, 'heatd'));
p.addParameter('smoothingKernel', 3, @(x) validateattributes(x, {'numeric'}, {'scalar'}, 'heatd'));
p.addParameter('boxcarWin', [3, 3], @(x) validateattributes(x, {'numeric'}, {'size', [1, 2]}, 'heatd'));
p.addParameter('Normalization', 'probability', @(x) assert(ismember(x, {'probability', 'none'})));
p.parse(varargin{:});

nBins = p.Results.nBins;
smoothingKernel = p.Results.smoothingKernel;
boxcarWin = p.Results.boxcarWin;
normalization = p.Results.Normalization;

iFin = isfinite(x) & isfinite(y);
x = x(iFin);
y = y(iFin);

if isempty(x)
	h = [];
	d_smooth = [];
	xim = [];
	yim = [];
	d = [];
	return;
end

[~, ~, xb] = histcounts(x, nBins(1));
[~, ~, yb] = histcounts(y, nBins(2));

d = full(sparse(yb, xb, 1, nBins(2), nBins(1)));

if any(~boxcarWin)
	d_smooth = d;
else
	d_smooth = gsmooth(d, boxcarWin, smoothingKernel);
end
xim = [min(x), max(x)];
yim = [min(y), max(y)];
if strcmp(normalization, 'probability')
	xim_lin = linspace(xim(1), xim(2), size(d_smooth, 2));
	yim_lin = linspace(yim(1), yim(2), size(d_smooth, 1));
	area_under_curve = trapz(xim_lin, trapz(yim_lin,d));
	d_smooth = d_smooth./area_under_curve;
end
h_im = imagesc(xim, yim, d_smooth);
axis xy;
colormap jet;

if nargout > 0
	h = h_im;
end


%--------------------------
% From here on Chris's code:
%--------------------------

function y = gsmooth(x,boxSize,sigma)
% GSMOOTH   Smooth 1D or 2D data with Gaussian boxcar
%
% Y = GSMOOTH(X,BOXSIZE,SIGMA). 
%
%       BOXSIZE can be 1x2 vector giving the number of rows and columns of 
%       the boxcar or a scalar giving both dimensions. If X in NxM, 
%       BOXSIZE(1) cannot be greater than N and BOXSIZE(2) cannot be 
%       greater than M. For adaptability, if either dimension exceeds its 
%       maximum, it will be set to its maximum without warning.
%
%       SIGMA is the standard deviation of the gaussian in samples or
%       pixels.
%
% Y = GSMOOTH(X,BOXSIZE) uses the default SIGMA of 1 (sample or pixel).
%
% Y = GSMOOTH(X) uses the default BOXSIZE of (at most) [5 5].
%
% See also CONV2, FSPECIAL

if nargin<3 || isempty(sigma)
    sigma = 1;
end
if nargin<2 || isempty(boxSize)
    boxSize = [5 5];
end
if isscalar(boxSize)
    boxSize = [boxSize boxSize];
end

boxSize = [min(size(x,1),boxSize(1)) min(size(x,2),boxSize(2))];
box = fspecial('gaussian',boxSize,sigma);

% x = inpaint_nans(x);
% x(isnan(x)) = 0;
x = patchnans(x,boxSize,sigma);
y = conv2(x,box,'same');


function [i, j] = neighsubs(siz,i0,j0,varargin)
k = 1;
method = 'all';
nArgIn = length(varargin);
for i = 1:nArgIn
   input = varargin{i};
   if ischar(input) && ismember(lower(input),{'all','adj','diag'})
       method = lower(input);
   elseif ismember(size(input),[1 1;1 2],'rows') && isequal(input,int64(input))
       
       k = input;
       if isscalar(k)
           k = [k k];
       end
   else
       error('Invalid input argument');
   end
end

M = siz(1);
N = siz(2);

i = i0+[-sort(1:k(1),'descend') 0 1:k(1)];
j = j0+[-sort(1:k(2),'descend') 0 1:k(2)];
[iMesh, jMesh] = meshgrid(i,j);

keep = (iMesh>0 & jMesh>0 & iMesh<=M & jMesh<=N) & ~(iMesh==i0 & jMesh==j0);
switch method
    case 'adj'
        keep = keep & (jMesh==j0 | iMesh ==i0);
    case 'diag'
        d = diag(diag(keep));
        keep = keep & (d | fliplr(d));
end

i = iMesh(keep);
j = jMesh(keep);

if nargout==1
    i = sub2ind(siz,i,j);
end


function Z = patchnans(Z0,boxSize,sigma)
if isscalar(boxSize)
    boxSize = [boxSize boxSize];
end
Z = Z0;
box0 = fspecial('gaussian',boxSize,sigma);
rBox = (boxSize-1)/2;
[iNan, jNan] = find(isnan(Z0));

nNan = length(iNan);
trys = 0;
while nNan > 0 && trys<=100
    trys = trys+1;
    for n = 1:nNan
        [i, j] = neighsubs(size(Z0),iNan(n),jNan(n),rBox);
        indZ = sub2ind(size(Z0),i,j);
        iBox = i - iNan(n)+rBox(1)+1;
        jBox = j - jNan(n)+rBox(2)+1;
        indBox = sub2ind(boxSize,iBox,jBox);
        Z(iNan(n),jNan(n)) = nansum(box0(indBox)/nansum(box0(indBox)).*Z0(indZ));
    end
    [iNan, jNan] = find(isnan(Z));    
    nNan = length(iNan);
    Z0 = Z;
end