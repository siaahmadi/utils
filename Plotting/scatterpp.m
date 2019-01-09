function scatterpp(ax, distance, phase, varargin)
%SCATTERPP Scatter plot for Phase Precession data
%
% 


scatter([distance(:); distance(:)], [phase(:); phase(:)+2*pi], varargin{:});

ax.XTick = [0, 1];
ax.XLim = [0, 1];
ax.YTick = [0, 2*pi, 4*pi];
ax.YLim = [0, 4*pi];
ax.YTickLabel = 0:2;
ax.FontName = 'Arial';
ax.FontSize = 14;
xlabel(ax, 'Frac. Field');
ylabel(ax, 'Theta Phase (cycles)');