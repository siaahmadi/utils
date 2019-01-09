function linksliders(obj,hs1, hs2)
% link hs1, hs2 to obj
numCLH = length(obj.clh);
obj.clh{numCLH+1} = addlistener(hs1, 'ContinuousValueChange', @(src, evnt) obj.update());
obj.clh{numCLH+2} = addlistener(hs2, 'ContinuousValueChange', @(src, evnt) obj.update());
hs1.SliderStep = [1/length(obj.x) hs1.SliderStep(2)];
hs2.SliderStep = [1/length(obj.x) hs2.SliderStep(2)];