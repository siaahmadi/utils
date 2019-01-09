function showspikes(spikeTrain, videoX, videoY, videoTS)

figure;
plot(videoX, videoY)

hold on;
if videoY == 0
	plot(videoX(spike2ind(spikeTrain, videoTS)), 0, 'r.')
else
	plot(videoX(spike2ind(spikeTrain, videoTS)), videoY(spike2ind(spikeTrain, videoTS)), 'r.')
end