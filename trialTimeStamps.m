function [thisTrialBeganAt, thisTrialEndedAt] = trialTimeStamps(pathToTrial)
if strcmp(pathToTrial(end),'\')
	pathToTrial = pathToTrial(1:end-1);
end

[beginOrSleep, I1, I2] = regexp(pathToTrial, '(begin\d+|sleep\d+|b\d+|e\d+)', 'match', 'once');

pathToParentOfTrial = fileparts(pathToTrial); % always try parent folder 11/24/2015

% Old version (would try current foldr first and if Events.nev not found
% would try parent folder):
% pathToParentOfTrial = pathToTrial;
% while ~exist([pathToParentOfTrial '\Events.nev'], 'file') && ~isempty(pathToParentOfTrial)
% 	pathToParentOfTrial = fileparts(pathToParentOfTrial);
% end

try
	[TimeStamps, EventStrings] = Nlx2MatEV([pathToParentOfTrial '\Events.nev'], [1 0 0 0 1 0], 0, 1, 1);
catch
	error('Could not find Event.nev')
end

[~, folderName] = fileparts(pathToTrial);
I = strcmp(EventStrings, folderName);
if ~any(I)
	thisTrialBeganAt = TimeStamps(1);
	a = dir(fullfile(pathToParentOfTrial, EventStrings{end}));
	
	eeg = readCRTsd(fullfile(pathToParentOfTrial, EventStrings{end},a(find([a.bytes] > 16384 & matchstr({a.name}, 'CSC'), 1)).name));
	thisTrialEndedAt = EndTime(eeg);
	return;
end
thisTrialBeganAt = TimeStamps(I);
thisTrialBeganAt = thisTrialBeganAt(end);
if isempty(strfind(beginOrSleep, 'begin')) % it's a sleep trial
	I = cellfun(@strcmp, EventStrings, repmat({['endsleep' num2str(pathToTrial(I1+5:I2))]}, size(EventStrings)));
else
	I = cellfun(@strcmp, EventStrings, repmat({['end' num2str(pathToTrial(I1+5:I2))]}, size(EventStrings)));
	if ~any(I)
		I = cellfun(@strcmp, EventStrings, repmat({['endbegin' num2str(pathToTrial(I1+5:I2))]}, size(EventStrings)));
	end
end
thisTrialEndedAt = TimeStamps(I);
thisTrialEndedAt = thisTrialEndedAt(end);