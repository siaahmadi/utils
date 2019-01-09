function [h, d_smooth, xim, yim, d] = density(x, y, varargin)

[h_a, d_smooth, xim, yim, d] = heatd(x, y, varargin{:});
if nargout > 0
	h = h_a;
end

%% Simulation
% x = 0:0.01:1;
% phi0 = 1/3; m = -0.5;
% y = phi0 + m * x;
% den = 100 + 100 * x;
% phases_x = arrayfun(@(x,den) ones(den, 1) * x, x(:), den(:), 'un', 0);
% phases = arrayfun(@(theta,den) circ_vmrnd(theta*pi, 3, den), y(:), den(:), 'un', 0);
% figure; scatter(cat(1, phases_x{:}), cat(1, phases{:}), 2, 'filled');
% n = hist3([cat(1, phases{:}), cat(1, phases_x{:})], [30, 30]);
% [X, Y] = meshgrid(linspace(0, 1, 30), linspace(-pi, pi, 30));
% figure; scatter(cat(1, phases_x{:}), cat(1, phases{:}), 2, 'filled');
% hold on;; contour(X, Y, n);
% figure; contour(X, Y, n);