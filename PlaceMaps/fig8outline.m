function fig8outline(ax)

if ~exist('ax', 'var')
	ax = gca;
end

mz = dataanalyzer.env.fig8.figure8maze;

ax.NextPlot = 'add';
plot(ax, mz(:, 1), mz(:, 2), '--', 'color', ones(1,3)*.7);