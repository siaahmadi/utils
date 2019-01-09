function [p, extent, stats] = resample_fujisawa08(X, L, FWER)

diff_tolerance = 0.01; % shuffled difference must exceed pointwise alpha by at least this much (due to the discrete and finite nature of data, how prctile works, and perhaps roundoff errors)

N = 10;
[X, L] = simulate_lr_spikes([5, 5], N);

sigma = 0.05;
FWER = 0.05;

N_shuffle.point = 1000;
N_shuffle.family = 500;

D0 = kdeneural(X(:, ~L), sigma) - kdeneural(X(:, L), sigma);

D1toN.point = nan(size(X, 1), N_shuffle.point);

ALPHA = 1./exp((linspace(4, 7, 60)));
this_fwer = NaN(size(ALPHA));

Kset = false;
p = 1;

for k = 1:length(ALPHA)
	alpha = ALPHA(k);
	for i = 1:N_shuffle.point
		l = L(reshuffle(length(L)));

		D1toN.point(:, i) = kdeneural(X(:, l), sigma) - kdeneural(X(:, ~l), sigma);
	end
	threshpointw.l(:, k) = prctile(D1toN.point', (1-alpha/2)*100)';
	threshpointw.r(:, k) = prctile(D1toN.point', (alpha/2)*100)';
	
	for j = 1:N_shuffle.family
		l = L(reshuffle(length(L)));
		D1toN.point(:, j) = kdeneural(X(:, l), sigma) - kdeneural(X(:, ~l), sigma);
	end
	this_fwer(k) = sum(cellfun(@(shuff) any(shuff > threshpointw.l(:, k) + diff_tolerance), column2cell(D1toN.point))) / N_shuffle.point;
	
	if this_fwer(k) <= FWER && ~Kset
		K = k;
		Kset = true;
	end
	if any(D0 > threshpointw.l(:, k) + diff_tolerance)
		p = this_fwer(k);
	end
end


stats.fwer = this_fwer(1:K);
stats.pointwise = ALPHA(1:K);
extent = NaN;
