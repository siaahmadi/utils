function Y = scmatcol(X, n_bins_time)
%SCMATCOL Scale matrix along the second dimensions

x_ind = linspace(1, size(X, 2), n_bins_time);
[x_ind, weight] = weight_indices(x_ind);

Y1 = X(:, x_ind(:, 1));
Y2 = X(:, x_ind(:, 2));

Y = repmat(weight(:, 1)', size(Y1, 1), 1) .* Y1 ...
	+ repmat(weight(:, 2)', size(Y2, 1), 1) .* Y2;

% Alternatively, with matrix multiplication
% Y = Y1 * sqrt((weight(:, 1) * weight(:, 1)') .* eye(size(weight, 1))) ...
% 	+ Y2 * sqrt((weight(:, 2) * weight(:, 2)') .* eye(size(weight, 1)));

function [idx, weight] = weight_indices(idx)
idx = idx(:);

weight = [1-(idx-floor(idx)), idx-floor(idx)];
idx = [floor(idx), ceil(idx)];
