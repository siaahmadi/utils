ax = gca;
ax_fig = ancestor(ax, 'figure');

ax.FontName = 'Arial';
ax.FontSize = 16;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YTick = [min(ax.YLim), min(ax.YLim) + range(ax.YLim) / 2, max(ax.YLim)];