function phi = thetaphase(spikes, eeg, ts, theta_ivls, theta_def)
%THETAPHASE Use the Hilbert transform to find theta phase of spike times
%
% phi = THETAPHASE(spikes, eeg, theta_ivls, theta_def)

if ~exist('theta_def', 'var')
	theta_low = 6;
	theta_high = 10;
else
	theta_low = theta_def.low;
	theta_high = theta_def.high;
end

if isa(eeg, 'tsd')
	eeg_filt = XX_Filter(Data(eeg), EEG.Fs(eeg), theta_low, theta_high);
elseif isnumeric(eeg)
	if isreal(eeg)
		eeg_filt = eeg;
	else
		eeg_hilb = eeg;
	end
else
	error('Unknown');
end
if ~exist('eeg_hilb', 'var')
	eeg_hilb = hilbert(eeg_filt);
end

if ~exist('ts', 'var')
	ts = EEG.toSecond(eeg, 'Range');
end

phi = interp1(ts, atan2(imag(eeg_hilb), real(eeg_hilb)), spikes, 'nearest');
phi = mod(phi+2*pi, 2*pi);