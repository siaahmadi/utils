function handle = plotspike(x,y,t,s,h,modification)

if exist('h', 'var') && strcmpi(h.Type, 'Patch') && exist('modification', 'var') && isa(modification, 'struct')
	modifypatch(h, modification);
	return
end

x = x(spike2ind(s, t));
y = y(spike2ind(s, t));

handle = p___spikepatch(x,y, 2, [], 'circle');

function handle = p___spikepatch(x, y, scale, color, shape, transparency, varargin)

c = [1, 0, 0];
t = 0.1;
s = 1;
if exist('scale', 'var') && ~isempty(scale)
	s = scale;
end
if exist('color', 'var') && ~isempty(color)
	c = color;
end
if ~exist('shape', 'var') || isempty(shape)
	shape = 'rectangle';
end
if exist('transparency', 'var') && ~isempty(transparency)
	t = transparency;
end

[x,y] = p___xy2vertex(x,y,shape,scale);

handle = patch(x,y,c, 'FaceAlpha', t, 'EdgeColor', 'none', varargin{:});


function modifypatch(h, modification)

[x, y, scale, color, shape, transparency] = p___getAttrOfInterest(h); %#ok<ASGLU>

if isfield(modification, 'x')
	x = modification.x; %#ok<*NASGU>
end
if isfield(modification, 'y')
	y = modification.y;
end
if isfield(modification, 'scale')
	scale = modification.scale;
end
if isfield(modification, 'color')
	color = modification.color;
end
if isfield(modification, 'shape')
	shape = modification.shape;
end
if isfield(modification, 'transparency')
	transparency = modification.transparency;
end

[x,y] = p___xy2vertex(x,y,shape,scale);
h.Vertices = [x, y];
h.Faces = reshape(1:length(x), length(x)/size(h.XData, 2), size(h.XData, 2))';
h.FaceAlpha = transparency;

function [x, y, scale, color, shape, transparency] = p___getAttrOfInterest(h)
x = mean(h.XData);
y = mean(h.YData);
x_onePatch = h.XData(:, 1);
y_onePathc = h.YData(:, 1);
scale = p___getMaxDist(x_onePatch,y_onePathc);
color = h.FaceColor;
shape = p___shapeEngine([],x_onePatch,y_onePathc);
transparency = h.FaceAlpha;

function [scale, I] = p___getMaxDist(x,y)
D = zeros(size(x));

for i = 1:length(x)
	for j = 1:length(y) % or x
		D(i,j) = eucldist(x(i), y(i), x(j), y(j));
	end
end

[scale, I] = max(D(:));
d = zeros(1,2);
[d(1), d(2)] = ind2sub(size(D), I);
I = d;

function [x_dflt, y_dflt] = p___shapeEngine(shape, x, y)

% Make a rectangle
rect.x = [1/2, 1/2, -1/2, -1/2, 1/2];
rect.y = [-1/2, 1/2, 1/2, -1/2, -1/2];

% Make a star
star.x = [0.1753, 0.8736, 0.9994, 0.2875, 0.7478, 0.4126, 0.0031, -0.4120, -0.7416, -0.2869, -0.9994, -0.8730, -0.1753, -0.2076, 0.2076, 0.1753];
star.y = [0.2113, 0.4622, 0.0731, -0.1252, -0.7119, -0.9486, -0.3364, -0.9486, -0.7119, -0.1245, 0.0737, 0.4616, 0.2113, 0.9498, 0.9498, 0.2113];

% Make a circle
res = 10;
if exist('circ_res', 'var') && circ_res >= 1 % let's not implement this actually---will be a pain in the butt
	res = circ_res;
end
circ.x = linspace(-.5,.5, 2+res); % unit diameter (the 2 is for the ends)
circ.y = [-sqrt(0.25 - circ.x.^2) sqrt(0.25 - circ.x.^2)];
circ.x = [circ.x fliplr(circ.x)];
circ.x(length(circ.y)/2) = [];
circ.y(length(circ.y)/2) = [];

if nargin == 3
	if nargout == 2
		warning('Shape identification mode: second output is meaningless');
		y_dflt = y;
	end
	switch length(x)
		case length(rect.x)
			x_dflt = 'rectangle';
		case length(circ.x)
			x_dflt = 'circle';
		case length(star.x)
			x_dflt = 'star';
	end
	return
end

switch shape
	case 'rectangle'
		x_dflt = rect.x;
		y_dflt = rect.y;
	case 'star'
		x_dflt = star.x;
		y_dflt = star.y;
	case 'circle'
		x_dflt = circ.x;
		y_dflt = circ.y;
	case 'hexagon'
		
	otherwise
		x_dflt = [];
		y_dflt = [];
		warning('Shape not found')
end

function [x,y] = p___xy2vertex(x,y,shape,scale)

[x_dflt, y_dflt] = p___shapeEngine(shape);
if isempty(x_dflt)
	x = [];
	y = [];
	return
end

x = arrayfun(@(x) x_dflt(:) * scale + x(:), x, 'UniformOutput', false);
y = arrayfun(@(x) y_dflt(:) * scale + x(:), y, 'UniformOutput', false);
x = cell2mat(x');
y = cell2mat(y');