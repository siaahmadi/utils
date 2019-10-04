function [ripples_at1sd, ripples_atxsd, ripple_osc_1sd, ripple_osc_xsd, ripple_osc_1sd_z, ripple_osc_xsd_z] = mean_ripple_osc(pathToSession, newsys, thresholds)
% Using method described in Davidson, Kloosterman, and Wilson (2009)
% to detect ripple oscillations
%
% Default values used:
% peakThresholdSD = 4     % must be 4 SD above mean rectified ripple band
% dropThresholdLow = 0.04 % drop shorter than 40 ms
% dropThresholdHigh = 1   % drop longer than 1000 ms
% mergeThreshold = 0.01   % Merge if closer than 100 ms
% ripple average smoothing kernel SD = 12.5 ms
%
% Output:
% ripples_at1sd    : `ivlset` object of ripple periods, detected at threshold x and expanded to a threshold of 1 SD
% ripples_atxsd    : `ivlset` object of ripple periods, detected at threshold x (not expanded)
% ripple_osc_1sd   : `tsd` object of the amplitude of ripples corresponding to `ripples_at1sd`
% ripple_osc_xsd   : `tsd` object of the amplitude of ripples corresponding to `ripples_atxsd`
% ripple_osc_1sd_z : `tsd` object of the z-scored amplitude of ripples corresponding to `ripples_at1sd`
% ripple_osc_xsd_z : `tsd` object of the z-scored amplitude of ripples corresponding to `ripples_atxsd`


ripple_avg = [];
nValid = 0;
ripple_channels_txtfilename = 'ripplech.txt';
ripple_channels = fullfile(pathToSession, ripple_channels_txtfilename);
try
	ripple_channels = cellfun(@str2double, textreadlines(ripple_channels));
catch err
	warning('Defaulting to read all channels because couldn''t read `ripplech.txt` due to some error:\n ---> %s', err.message);
	ripple_channels = 1:12; % default, if ripplech.txt doesn't exist or is poorly formatted
end
for i = ripple_channels(:)'
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
buffer.numSD = 1;
ripples1 = EEG.findRipple(ripple_amp_avg_dkw,buffer);
for s = sd(:)'
	i = i + 1;
	thresholds.numSD = s;
	ripples_atxsd(i, 1) = EEG.findRipple(ripple_amp_avg_dkw,thresholds);
	ripples_at1sd(i, 1) = ripples1 ^ ripples_atxsd(i, 1);
	[~, tdkw_xsd, ddkw_xsd, ddkw_xsd_z] = ripples_atxsd(i, 1).restrict(Range(ripple_amp_avg_dkw), Range(ripple_amp_avg_dkw), Data(ripple_amp_avg_dkw), zscore(Data(ripple_amp_avg_dkw)));
	ripple_osc_xsd{i, 1} = tsd(tdkw_xsd, ddkw_xsd);
	ripple_osc_xsd_z{i, 1} = tsd(tdkw_xsd, ddkw_xsd_z);
	[~, tdkw_1sd, ddkw_1sd, ddkw_1sd_z] = ripples_at1sd(i, 1).restrict(Range(ripple_amp_avg_dkw), Range(ripple_amp_avg_dkw), Data(ripple_amp_avg_dkw), zscore(Data(ripple_amp_avg_dkw)));
	ripple_osc_1sd{i, 1} = tsd(tdkw_1sd, ddkw_1sd);
	ripple_osc_1sd_z{i, 1} = tsd(tdkw_1sd, ddkw_1sd_z);
end