function modifypatch(h, modification)
if ~(exist('h', 'var') && strcmpi(h.Type, 'Patch') && exist('modification', 'var') && isa(modification, 'struct'))
	return
end

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