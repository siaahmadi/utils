function writespikes_snap(pathToSess)

trials = getTrialNames(pathToSess);

S = cell(length(trials), 1);
clusters = cell(length(trials), 1);
for i = 1:length(trials)
	[S{i}, clusters{i}] = getSpikes(fullfile(pathToSess, trials{i}), i);
end

% todo: write S to file

function trials = getTrialNames(pathToSess)
trials = readtxttable(fullfile(pathToSess, 'trials.txt'));
trials = cell2table(trials(2:end, :), 'variablenames', trials(1, :));
trials = trials.name;

function [S, clusters] = getSpikes(pathToSess, offset)

% read 1 block of some EEG file in the session
for i = 1:16
	try
		eeg = readCRTsd(fullfile(pathToSess, ['CSC' i, '.ncs']), 0, 1);
		break;
	catch
		if i == 16
			error('No EEG file could be used to subtract session start time.');
		end
		continue;
	end
end

startOfSession = EEG.toSecond(eeg, 'StartTime');

[S, clusters] = readSNAP(pathToSess);

S = cellfun(@(s) s - startOfSession + offset, S, 'un', 0);