function [spTimesAll, tFileNames, tFileNamesInv, trialBeginEndTimeStamps] ...
	= readSpikes_session(pathToSession, trialNames, zeroAnchored, timeUnit, allowStaggering)

% Siavash Ahmadi
% 11/7/2014 4:36 PM

if size(trialNames, 1) > 1
	trialNames = trialNames';
end

spTimes = cell(size(trialNames));
tFileNames = cell(size(trialNames));
tFileNamesInv = cell(size(trialNames));
trialBeginEndTimeStamps = cell(size(trialNames));
% all_t_files = containers.Map;

tFileInd = 1;
for trialInd = 1:length(trialNames)
	thisTrialName = trialNames{trialInd};
	[spTimes{trialInd}, tFileNames{trialInd}, tFileNamesInv{trialInd}, trialBeginEndTimeStamps{trialInd}] ...
		= readSpikes([pathToSession '\' thisTrialName], zeroAnchored, timeUnit);
	for j = 1:tFileNamesInv{trialInd}.Count
		all_t_files{tFileInd, 1} = tFileNamesInv{trialInd}(num2str(j));
		tFileInd = tFileInd + 1;
	end
end

if allowStaggering
	return;
end

all_t_files = unique(all_t_files);
spTimesAll = cell(size(trialNames));

for i = 1:length(trialNames)
	spTimesAll{i} = cell(length(all_t_files), 1);
	for j = 1:length(all_t_files)
		if tFileNames{i}.isKey(all_t_files{j})
			spTimesAll{i}{j} = spTimes{i}{tFileNames{i}(all_t_files{j})};
		end
	end
end

tFileNames = cell(size(trialNames));
tFileNamesInv = cell(size(trialNames));

for i = 1:length(trialNames)
	tFileNames{i} = containers.Map;
	tFileNamesInv{i} = containers.Map;
	for j = 1:length(all_t_files)
		tFileNames{i}(all_t_files{j}) = j;
		tFileNamesInv{i}(num2str(j)) = all_t_files{j};
	end
end

for i = 2:size(spTimesAll, 2)
	spTimesAll{1}(:, i) = spTimesAll{i};
end
spTimesAll = spTimesAll{1};