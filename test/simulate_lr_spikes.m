function [X, L] = simulate_lr_spikes(N, len)

maxrate.l = 16;
maxrate.r = 15.5;

Fs = 100; % maximum instantaneous rate
smwin = .5;

Y = zeros(len * Fs, sum(N));
L = true(1, sum(N));
L(1:N(1)) = false;


P.l = maxrate.l / Fs / smwin;
P.r = maxrate.r / Fs / smwin;

y = normpdf(linspace(-5, 5, size(Y, 1))', 0, 1);
rates.l = y / max(y) * P.l;
rates.r = y / max(y) * P.r;

X_l = cell2mat(arrayfun(@(x) binornd(ones(size(rates.l)), rates.l), 1:N(1), 'un', 0));
X_r = cell2mat(arrayfun(@(x) binornd(ones(size(rates.r)), rates.r), 1:N(2), 'un', 0));

X = [X_l, X_r];