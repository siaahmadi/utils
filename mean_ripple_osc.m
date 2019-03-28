function ripples = mean_ripple_osc(pathToSession, newsys, thresholds)
% Using method described in Davidson, Kloosterman, and Wilson (2009)
% to detect ripple oscillations
%
% Default values used:
% peakThresholdSD = 4     % must be 4 SD above mean rectified ripple band
% dropThresholdLow = 0.04 % drop shorter than 40 ms
% dropThresholdHigh = 1   % drop longer than 1000 ms
% mergeThreshold = 0.01   % Merge if closer than 100 ms
% ripple average smoothing kernel SD = 12.5 ms


ripple_avg = [];
nValid = 0;
for i = 1:12
	if newsys
		try
			load(fullfile(pathToSession, sprintf('CSC%i.mat', i)));
		catch
			eeg = EEG.read(fullfile(pathToSession, sprintf('CSC%i.ncs', i)));
		end
	else
		eeg = EEG.read(fullfile(pathToSession, sprintf('CSC%i.ncs', i)));
	end
	if isempty(Data(eeg)) || (~isempty(ripple_avg) && length(ripple_avg) ~= length(eeg))
		continue;
	end
	Fs = Frequency(eeg);
	nValid = nValid + 1;
	t = Range(eeg);
	eeg = XX_Filter(Data(eeg), Fs, 150, 250);
	eeg = abs(hilbert(eeg));
	
	if isempty(ripple_avg)
		ripple_avg = eeg;
	else
		ripple_avg = ripple_avg + eeg;
	end
end
ripple_avg = ripple_avg / nValid;
kernel = normpdf(linspace(-.5, .5, 1*Fs+1), 0, 12.5e-3); % kernel = 12.5 ms @ sample rate of 2000
ripple_amp_avg_dkw = conv(ripple_avg, kernel, 'same');

ripple_amp_avg_dkw = tsd(t, ripple_amp_avg_dkw, Fs);

sd = thresholds.numSD;
i = 0;
for s = sd(:)'
	i = i + 1;
	thresholds.numSD = s;
	ripples(i, 1) = EEG.findRipple(ripple_amp_avg_dkw,thresholds);
end