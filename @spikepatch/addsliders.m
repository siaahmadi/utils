function addsliders(obj)
parentFigure = ancestor(obj.h_path, 'Figure');
hls1 = linkedslider(parentFigure,0,obj,[],[]);
hls2 = linkedslider(parentFigure,hls1,obj,[20 45 525 20], 1);
obj.linksliders(hls1,hls2); % link these sliders to obj, not to each other!

hsld = sum(hls2.slider.Position([2 4]));
h_fig = ancestor(obj.h_spikes,'Figure');
hsld_rel = (hsld+30)/h_fig.Position(4);
buffer = obj.ax.Position(2);
obj.ax.Position(2) = hsld_rel;
obj.ax.Position(4) = obj.ax.Position(4) - (hsld_rel - buffer);

numMLH = length(obj.mlh);
obj.mlh{numMLH+1} = addlistener(hls1, 'Updated', @(src,evnt) obj.update()); % linked slider
obj.mlh{numMLH+2} = addlistener(hls2, 'Updated', @(src,evnt) obj.update()); % linked slider