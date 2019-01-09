function addsliders(obj)
parentFigure = ancestor(obj.h_path, 'Figure');
hls1 = linkedslider(parentFigure,[],obj,[],[]);
hls2 = linkedslider(parentFigure,hls1,obj,[20 60 525 20], 1);
obj.linksliders(hls1.slider,hls2.slider); % link these sliders to obj, not to each other!

numMLH = length(obj.mlh);
obj.mlh{numMLH+1} = addlistener(hls1, 'Updated', @(src,evnt) obj.update()); % linked slider
obj.mlh{numMLH+2} = addlistener(hls2, 'Updated', @(src,evnt) obj.update()); % linked slider