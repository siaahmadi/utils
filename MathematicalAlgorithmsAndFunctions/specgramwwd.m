function [SPG, t, f, bandSpecgramFun] = specgramwwd(eeg, sampFreq, fpassLow, fpassHigh, params)
% SPECGRAMWWD(eeg, sampFreq, fpassLow, fpassHigh, params) spectrogram by
% wavelets with downsampling (a user friendy interface to contwt())
%
% SYNTAX:
%	[SPG, t, f, bandSpecgramFun] = SPECGRAMWWD(eeg, sampFreq, fpassLow, fpassHigh, params)
%
% INPUT:
%	eeg
%		Double array of raw EEG signal
%
%	sampFreq
%		Sample rate of the EEG signal (in Hz)
%
%	fpassLow
%		Lowest frequency requested for band-pass filter
%
%	fpassHigh
%		Highest frequency requested for band-pass filter
% 
%	params (OPTIONAL)
%		Parameters for downsampling and smoothing
%
%		Can have the following fields:
%
%			dsrate: down sample by this number of points
%					this is applied after the wavelet transform, so use
%					this to save memory for storing the resulting
%					spectrogram. Default is 25.
%
%			minNyquist:
%					retain at least this number of samples per fastest
%					frequency in order to perform wavelet transform. This,
%					in a way, is a "pre-downsampling". Default is 5, if the
%					requested fpassHigh is at least 1/5 of sampling rate.
%
%			smoothingWin:
%					Will be used as the smoothing filter kernel width for
%					the downsampled spectrogram (in seconds).
% 
%			freqRes:
%					The resolution in the frequency axis. The higher the
%					number, the closer lying the frequency definition.
%					Higher values correspond to finer resolutions, which in
%					turn requires higher amount of memory.
%					Default is 50.
%
%			nFreqRows:
%					The number of rows in the frequency axis. See above
%					(freqRes).
%
%
% OUTPUT:
%	SPG:
%		The spectrogram. A matrix whose columns are the spectral power
%		density across time samples and whose rows are the power profile
%		within a narrow frequency band, corresponding to the entry in 'f'.
%		The frequency axis will be logarithmic.
% 
%	t
%		The time points. Can be used as a label for plotting SPG, or
%		restricting SPG to certain epochs.
% 
%	f
%		The frequencies. Can be used as a label for plotting SPG, or
%		pulling out a certain band from within SPG. The scale is
%		logarithmic.
%
%	bandSpecgramFun(low, hi)
%		Function handle. Accepts as input two arguments, low and hi, and
%		returns the chunk of SPG that most closely lies within [low, hi]
%		frequency band.
%		USAGE: [SPG_band, f_band] = bandSpecgramFun(lowFreq, hiFreq);
%
% External (non-MATLAB) calls: closestPoint(), contwt()

% Siavash Ahmadi
% University of California, San Diego
% January 28, 2015

afterdsrate = 25;
minNyquist = 5; % at least this many samples for the highest frequency requested
smoothingWin = 20;
freqRes = 50;
downsampleRawEEG = true;
if exist('params', 'var')
	if isfield(params, 'dsrate')
		afterdsrate = params.dsrate;
	end
	if isfield(params, 'minNyquist')
		minNyquist = params.minNyquist;
	end
	if isfield(params, 'smoothingWin')
		smoothingWin = params.smoothingWin;
	end
	if isfield(params, 'freqRes')
		freqRes = params.freqRes;
	end
	if isfield(params, 'nFreqRows')
		freqRes = floor((params.nFreqRows-1)/2);
	end
	if isfield(params, 'downsampleRawEEG')
		downsampleRawEEG = params.downsampleRawEEG;
	end
end
if fpassHigh > sampFreq/2
	warning(['Nyquist frequency is ' num2str(sampFreq/2) '. Using this as high frequency cutoff.'])
	fpassHigh = sampFreq/2;
end
if minNyquist < 2
	minNyquist = 2; % at least two samples needed per highest frequency according to Nyquist-Shannon sampling theorem
end
if minNyquist > sampFreq/fpassHigh
	minNyquist = floor(sampFreq/fpassHigh);
	if exist('params', 'var') && isfield(params, 'minNyquist')
		warning(['minNyquist requested is too high. Given requested low-pass cutoff, maximum possible is ' num2str(minNyquist) ', which will be used.'])
	end
end

if downsampleRawEEG
	dsrate = floor(sampFreq/(minNyquist*fpassHigh));
else
	dsrate = 1;
end
sr_ds = sampFreq/dsrate;
eeg_ds = downsample(eeg, dsrate);
dt = 1/sr_ds;
finestScale = 1/fpassHigh;	% upper cutoff frequency
df = log2(fpassHigh/fpassLow)/round(log2(fpassHigh/fpassLow))/freqRes;% frequency resolution
numScales = round(log2(fpassHigh/fpassLow)/df);

[wave, ~, scale] = EEG.contwt(eeg_ds,dt,1,df,finestScale,numScales, 'morlet');

f = 1./scale;

dt = dsrate*afterdsrate/sampFreq;
sp_raw = downsample(abs(wave)', afterdsrate);
sp_smooth = smooth(sp_raw, size(sp_raw, 1)/(smoothingWin/dt));
SPG = reshape(sp_smooth, size(sp_raw, 1), size(sp_raw, 2))';
t = dt:dt:size(SPG, 2)*dt;

bandSpecgramFun = @(low, hi) getFreqBandSpecgram(SPG, f, low, hi);

function [S, f] = getFreqBandSpecgram(SPG, f, low, hi)

hi_ind = closestPoint(fliplr(f), 1:length(f), hi);
low_ind = closestPoint(fliplr(f), 1:length(f), low);

S = SPG(end-hi_ind+1:end-low_ind+1, :);
f = f(end-hi_ind+1:end-low_ind+1);