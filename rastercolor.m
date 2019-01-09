function rastercolor(spikeTimes, colors)
% raster and paint each spike a certain color

if ~isa(spikeTimes, 'cell')
	spikeTimes = {spikeTimes};
end

hold on;

for cellInd = 1:length(spikeTimes)
	for spInd = 1:length(spikeTimes{cellInd})
		mycolormap = colormap(hsv(256));
		thisSpikeColor = mycolormap(ceil((eps+colors{cellInd}(spInd))*(255+eps)), :);
		
		spToRaster = cell(cellInd, 1);
		spToRaster{cellInd} = spikeTimes{cellInd}(spInd);
		raster(spToRaster, 1, 'color', thisSpikeColor, 'linewidth', 2)
	end
end
