function n = numelspike(spikes)

if isemptyspike(spikes)
	n = 0;
else
	n = numel(spikes);
end