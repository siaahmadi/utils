function [idx, I_spike] = spike2ind(spikeTrain, videoTS)

if length(videoTS)>1
	dt = nanmean(diff(videoTS));
else
	dt = 1/60;
end

[spikeTrain, I_spike] = restr(spikeTrain, nanmin(videoTS)-dt/2, nanmax(videoTS)+dt/2);
v = videoTS(isfinite(videoTS));

idx = interp1(v, 1:length(v), spikeTrain, 'nearest');
idx = finite(idx);

% nanidx = cumsum(~isfinite(videoTS));
finidx = find(isfinite(videoTS));
idx = finidx(idx);