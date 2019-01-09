% cd V:\Sia\PhD\LabProjects\phasePrecessionTakuya\Recordings\control\rat650\2013-12-24_10-44-41
%%
hg_cutoff_high = 100;
hg_cutoff_low = 65;
lg_cutoff_high = 50;
lg_cutoff_low = 20;

[eeg, Fs] = EEG.read('CSC6.ncs');
eeg_t = Range(eeg);
eeg_theta = XX_Filter(Data(eeg), Fs, 6, 10);
eeg_lowGamma = XX_Filter(Data(eeg), Fs, lg_cutoff_low, lg_cutoff_high);
eeg_highGamma = XX_Filter(Data(eeg), Fs, hg_cutoff_low, hg_cutoff_high);
figure; hold on;
% plot(zscore(eeg_lowGamma));
plot(eeg_t, zscore(eeg_highGamma));
plot(eeg_t, abs(hilbert(zscore(eeg_highGamma))), 'b--');
plot(eeg_t, zscore(eeg_theta));
%%
eeg_phasetheta = atan2(imag(hilbert(eeg_theta)), real(hilbert(eeg_theta)));
theta_peaks = find(diff(eeg_phasetheta) < -3/4*pi);

params.dsrate = 1;
params.downsampleRawEEG = false;
params.freqRes = 25;
[S, t, f] = specgramwwd(Data(eeg), Fs, lg_cutoff_low, hg_cutoff_high, params);
%%
figure;imagesc(t,f,S);
hold on; vertplot(eeg_t(theta_peaks)-eeg_t(1), 30, 80, 'w', 'linewidth', 3);
colormap jet
axis xy
set(gca, 'yscale', 'log')
%%
figure; hold on;
plot(eeg_t-eeg_t(1), Data(eeg));
plot(eeg_t-eeg_t(1), eeg_theta);
plot(eeg_t-eeg_t(1), eeg_phasetheta/pi*2e-4);
scatter(t(theta_peaks), 2e-4*ones(size(theta_peaks)), [], 'r', 'filled');
%%
avg_theta_freq = 1/mean(diff(theta_peaks)/Fs);
figure; hold on;
histogram(diff(theta_peaks(10:end-10))/Fs);
vertplot(1/avg_theta_freq, 0, 160, 'r');
xlabel('Theta Period (s)');
ylabel('Count Cycles');
legend({'', 'Average Period'}, 'Location', 'nw');

%%
N_cycles_to_display = 3;
avg_n_theta_bins = 2*round(mean(diff(theta_peaks)));
S = zscore(S')';
thetacycle_specgram = arrayfun(@(i,j) scmatcol(S(:, i:j), avg_n_theta_bins), theta_peaks(1:end-N_cycles_to_display), theta_peaks(1+N_cycles_to_display:end), 'un', 0);
% theta_specgram = cellfun(@(x) zscore(x')', theta_specgram, 'un', 0);
thetacycle_specgram = mean(cat(3, thetacycle_specgram{:}), 3);

figure;imagesc(0:pi/2:N_cycles_to_display*2*pi, f, thetacycle_specgram); axis xy; colormap jet
set(gca, 'yscale', 'log', 'xtick', 0:pi:N_cycles_to_display*2*pi, ...
	'xticklabel', {'-2\pi', '-\pi', '0', '\pi', '2\pi', '3\pi', '4\pi'}, ...
	'fontname', 'arial', 'fontsize', 14);
hold on;
vertplot(2*pi, lg_cutoff_low, hg_cutoff_high, 'w--', 'linewidth', 3);
vertplot(4*pi, lg_cutoff_low, hg_cutoff_high, 'w--', 'linewidth', 3);