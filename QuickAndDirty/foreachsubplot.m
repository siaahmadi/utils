function foreachsubplot(fig, command)

initFig = gcf;
initAx = gca;

if nargin == 1
	command = fig;
	fig = initFig;
end

ax = get(fig, 'Children');
ax = findobj(ax, 'Type', 'Axes');

% do for each ax in fig
set(0, 'CurrentFigure', fig);
arrayfun(@(ax) auxFunc_exec(command, ax, fig), ax, 'un', 0);

% return to where things were
set(0, 'CurrentFigure', initFig);
set(initFig, 'CurrentAxes', initAx);

function auxFunc_exec(command, ax, fig)
set(fig, 'CurrentAxes', ax);
eval(command);