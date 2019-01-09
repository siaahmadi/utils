function [fr, duration] = firingrate_summary(listOfSessions)
%FIRINGRATE_SUMMARY Calculate mean firing rate of neurons during trials
%from pathdata.mat and spikedata.mat in a list of sessions given by
%|listOfSessions|
%
% [fr, duration] = FIRINGRATE_SUMMARY(listOfSessions)

if ischar(listOfSessions)
	listOfSessions = {listOfSessions};
end

for i = 1:length(listOfSessions)
	pd{i, 1} = load(fullfile(listOfSessions{i}, 'pathdata.mat'));
	sp{i, 1} = load(fullfile(listOfSessions{i}, 'spikedata.mat'));
end

[fr, duration] = cellfun(@firingrate1session, pd, sp, 'un', 0);