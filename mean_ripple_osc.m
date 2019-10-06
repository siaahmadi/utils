function ripples = mean_ripple_osc(pathToSession, newsys, thresholds, correction)
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


if ~exist('correction', 'var')
	correction = 0;
end


opt.SPIKE_PEAK_THRESHOLD = 100; % in micro-volts
opt.MAX_L_INFINITY_NORM_OF_PEAKS = 20;
opt.MUA_STD_THRESHOLD = 3;
opt.MUA_BIN_SIZE = 0.02; % seconds
opt.KERNEL_STD = 0.02; % seconds
opt.MIN_MUA_BASE_WINDOW = .04; % seconds
opt.step_size = 0.005; % seconds


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

valid_spikes = cell(12, 1);
for i = ripple_channels(:)'
	try
		valid_spikes{i} = extract_valid_spikes_from_ntt(pathToSession, ['TT', num2str(i), '.ntt'], opt);
	catch
		warning('Some error occurred.');
	end
end
MUA = cat(2, valid_spikes{:})' + correction;

MUA_rate = estimate_MUA_rate(MUA, opt);
ts_MUA_on = extract_MUA_on(MUA_rate, min(MUA), opt);


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

kernel_std = 12.5e-3; % kernel = 12.5 ms
ripple_amp_avg_dkw = smooth1(ripple_avg, kernel_std, Fs);
ripple_amp_avg_dkw = tsd(t+correction, ripple_amp_avg_dkw, Fs);

sd = thresholds.numSD;
i = 0;
buffer.numSD = 1;
ripples1 = EEG.findRipple(ripple_amp_avg_dkw,buffer);
for s = sd(:)'
	i = i + 1;
	
	thresholds.numSD = s;
	
	ripples.ivls_lfp.atxsd(i, 1) = EEG.findRipple(ripple_amp_avg_dkw,thresholds);
	[~, tdkw_xsd, ddkw_xsd, ddkw_xsd_z] = ripples.ivls_lfp.atxsd(i, 1).restrict(Range(ripple_amp_avg_dkw), Range(ripple_amp_avg_dkw), Data(ripple_amp_avg_dkw), zscore(Data(ripple_amp_avg_dkw)));
	ripples.osc.atxsd{i, 1} = tsd(tdkw_xsd, ddkw_xsd);
	ripples.osc.atxsd_z{i, 1} = tsd(tdkw_xsd, ddkw_xsd_z);
	
	ripples.ivls_lfp.at1sd(i, 1) = ripples1 ^ ripples.ivls_lfp.atxsd(i, 1);
	[~, tdkw_1sd, ddkw_1sd, ddkw_1sd_z] = ripples.ivls_lfp.at1sd(i, 1).restrict(Range(ripple_amp_avg_dkw), Range(ripple_amp_avg_dkw), Data(ripple_amp_avg_dkw), zscore(Data(ripple_amp_avg_dkw)));
	ripples.osc.at1sd{i, 1} = tsd(tdkw_1sd, ddkw_1sd);
	ripples.osc.at1sd_z{i, 1} = tsd(tdkw_1sd, ddkw_1sd_z);
	
	ripples.ivls_mua.by_std.mean_minus_0std(i, 1) = ts_MUA_on.by_std.mean_minus_0std ^ (ts_MUA_on.by_std.mean_minus_0std & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.by_std.mean_minus_1_10th_std(i, 1) = ts_MUA_on.by_std.mean_minus_1_10th_std ^ (ts_MUA_on.by_std.mean_minus_1_10th_std & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.by_std.mean_minus_2_10th_std(i, 1) = ts_MUA_on.by_std.mean_minus_2_10th_std ^ (ts_MUA_on.by_std.mean_minus_2_10th_std & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.fixed.f1_10th(i, 1) = ts_MUA_on.fixed.f1_10th ^ (ts_MUA_on.fixed.f1_10th & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.fixed.f10_10th(i, 1) = ts_MUA_on.fixed.f10_10th ^ (ts_MUA_on.fixed.f10_10th & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.fixed.f100_10th(i, 1) = ts_MUA_on.fixed.f100_10th ^ (ts_MUA_on.fixed.f100_10th & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.fixed.prctile16(i, 1) = ts_MUA_on.fixed.prctile16 ^ (ts_MUA_on.fixed.prctile16 & ripples.ivls_lfp.atxsd(i, 1));
	ripples.ivls_mua.fixed.prctile30(i, 1) = ts_MUA_on.fixed.prctile30 ^ (ts_MUA_on.fixed.prctile30 & ripples.ivls_lfp.atxsd(i, 1));
end

function valid_spikes = extract_valid_spikes_from_ntt(pathToSession, ntt_file_name, opt)
% Reads .ntt file and returns timestamp of spikes with a peak above some
% threshold specified in `opt`.
%
% To remove the 45-degree recording noise artifacts, applies a maximum
% L-infinity norm to the distance among peaks with the threshold specified
% in `opt`. Tries to detect dead channels by checking if all values are 0s.
% This method of detecting dead channels has a positive predictive value
% (PPV) of 1, but it's sensitivity is unknown (depends on whether
% experimenter turned dead channels off while recording).

[TS, Samples, Header] = Nlx2MatSpike( fullfile(pathToSession, ntt_file_name), [1 0 0 0 1], 1, 1, 0);
TS = TS * 1e-6;
adbitvolts = nlx.extract_adbitvolt(Header);
for i = 1:length(adbitvolts)
	Samples(:, i, :) = Samples(:, i, :) * adbitvolts(i) * 1e6; % will be micro-volts
end
suprathreshold = any(squeeze(max(Samples, [], 1) > opt.SPIKE_PEAK_THRESHOLD), 1);
peaks = squeeze(Samples(8, :, :));
idx_valid_ch = cellfun(@(x) any(x(:)~=0), mat2cell(Samples, 32, [1,1,1,1], size(Samples,3))); % if the channel is all 0's it was probably broken or turned off
diagonal_idx = max(abs(peaks(idx_valid_ch, :) - repmat(mean(peaks(idx_valid_ch, :), 1), sum(idx_valid_ch), 1))) < opt.MAX_L_INFINITY_NORM_OF_PEAKS;
valid_spikes = TS(suprathreshold & ~diagonal_idx);

function MUA_rate = estimate_MUA_rate(MUA, opt)
% Estimates multi-unit firing rate with parameters specified in `opt`.
% Smoothes the results with a gaussian kernel.

edges = min(MUA):opt.MUA_BIN_SIZE:max(MUA);
MUA_rate = NaN(opt.MUA_BIN_SIZE / opt.step_size, length(edges)-1);
for i = 1:size(MUA_rate, 1)
	edges = edges + opt.step_size;
	MUA_rate(i, :) = histcounts(MUA, edges)/opt.MUA_BIN_SIZE;
end
kernel = normpdf(linspace(-.5,.5,1/opt.step_size), 0, opt.KERNEL_STD);
MUA_rate = conv(MUA_rate(:), kernel, 'same') * opt.step_size;

function ts_MUA_on_admissible = extract_MUA_on(MUA_rate, MUA_start, opt)
% Extracts periods of high MUA activity
%
% First, a threshold must be reached: `opt.MUA_STD_THRESHOLD`
% Then, the period is broadened until the mean is reached.
% Periods shorter than `opt.MIN_MUA_BASE_WINDOW` are dropped.
%
% As a result, multiple high threshold crossings might be absorbed into a
% baseline MUA-on period.
%
% Three baselines are used: mean, 10% STD below mean, and 20% STD below
% mean.
% These can later be compared for various experimental groups.

MUA_on = MUA_rate > (mean(MUA_rate(MUA_rate>0)) + opt.MUA_STD_THRESHOLD * std(MUA_rate(MUA_rate>0)));
ts_MUA_on = ivlset(lau.raftidx(MUA_on) * opt.step_size + MUA_start);

MUA_base0 = MUA_rate > mean(MUA_rate(MUA_rate>0));
MUA_base1 = MUA_rate > (mean(MUA_rate(MUA_rate>0)) - .1 * std(MUA_rate(MUA_rate>0)));
MUA_base2 = MUA_rate > (mean(MUA_rate(MUA_rate>0)) - .2 * std(MUA_rate(MUA_rate>0)));
ts_MUA_base0 = ivlset(lau.raftidx(lau.open(MUA_base0, round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base1 = ivlset(lau.raftidx(lau.open(MUA_base1, round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base2 = ivlset(lau.raftidx(lau.open(MUA_base2, round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base_fixed_1_10th = ivlset(lau.raftidx(lau.open(MUA_rate > 0.1, round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base_fixed_10_10th = ivlset(lau.raftidx(lau.open(MUA_rate > 1, round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base_fixed_100_10th = ivlset(lau.raftidx(lau.open(MUA_rate > 10, round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base_fixed_16th_prctile = ivlset(lau.raftidx(lau.open(MUA_rate > prctile(MUA_rate(MUA_rate>0), 100/6), round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);
ts_MUA_base_fixed_30th_prctile = ivlset(lau.raftidx(lau.open(MUA_rate > prctile(MUA_rate(MUA_rate>0), 30), round(opt.MIN_MUA_BASE_WINDOW / opt.step_size / 2))) * opt.step_size + MUA_start);

ts_MUA_on_admissible.by_std.mean_minus_0std = ts_MUA_base0 ^ ts_MUA_on;
ts_MUA_on_admissible.by_std.mean_minus_1_10th_std = ts_MUA_base1 ^ ts_MUA_on;
ts_MUA_on_admissible.by_std.mean_minus_2_10th_std = ts_MUA_base2 ^ ts_MUA_on;
ts_MUA_on_admissible.fixed.f1_10th = ts_MUA_base_fixed_1_10th ^ ts_MUA_on;
ts_MUA_on_admissible.fixed.f10_10th = ts_MUA_base_fixed_10_10th ^ ts_MUA_on;
ts_MUA_on_admissible.fixed.f100_10th = ts_MUA_base_fixed_100_10th ^ ts_MUA_on;
ts_MUA_on_admissible.fixed.prctile16 = ts_MUA_base_fixed_16th_prctile ^ ts_MUA_on;
ts_MUA_on_admissible.fixed.prctile30 = ts_MUA_base_fixed_30th_prctile ^ ts_MUA_on;