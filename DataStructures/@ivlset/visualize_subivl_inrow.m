function visualize(obj, labels)
% Make a plot of the current interval set

% Siavash Ahmadi
% 11/3/2015

persistent ax

if ~exist('labels', 'var') || isempty(labels)
	labels = {};
end

[B, E] = obj.toIvl;

if obj.isempty()
	warning('Interval set empty.');
	return
end

if any(~isfinite(B))
	error('Not able to handle Inf at the moment');
end

N = obj.length();

toPlotX = repmat(B, 3, 1);
toPlotX(1:3:end) = B;
toPlotX(2:3:end) = E;
toPlotX(3:3:end) = NaN;

toPlotY = repmat(1:N, 3, 1);

if ~isvalidhandle(ax)
	figure;
	p = plot(toPlotX(:), toPlotY(:),'-o');
else
	p = plot(ax, toPlotX(:), toPlotY(:),'-o');
end
text(mean([B, E], 2), 1:length(B), labels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', 12, 'FontName', 'Arial', 'Interpreter', 'None');
ax = ancestor(p, 'Axes');

R = max(E) - min(B);
xlim(ax, [min(B) - .1*R, max(E) + .1*R]);
ylim(ax, [0 N+1]);

ax.YTick = 1:N;
axis(ax, 'ij');
title(ax, inputname(1), 'FontName', 'Courier New');
ax.FontName = 'Arial';
ax.Box = 'off';
ax.TickDir = 'out';