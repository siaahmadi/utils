function rad8outline(mazecolor, linestyle)

maze = dataanalyzer.env.rad8.radial8maze(8, 'line');
if ~exist('mazecolor', 'var')
	mazecolor = 'k';
end

ax = gca;
state = ax.NextPlot;
ax.NextPlot = 'add';
if exist('linestyle', 'var') && (strcmpi(linestyle, 'scatter') || strcmpi(linestyle, '.'))
	scatter(maze(:, 1), maze(:, 2), 2, mazecolor, 'filled');
else
	if exist('linestyle', 'var')
		plot(maze(:, 1), maze(:, 2), 'color', mazecolor, 'linestyle', linestyle);
	else
		plot(maze(:, 1), maze(:, 2), mazecolor);
	end
end

ax.NextPlot = state;