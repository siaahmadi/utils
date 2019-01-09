function h_scalebar = scalebar(ax, xscale, x_unit, yscale, y_unit)
%SCALEBAR Place scale bars on axes
%
% SYNTAX:
%    h_scalebar = SCALEBAR(ax, xscale, x_unit, yscale, y_unit)

% Siavash Ahmadi
% 12/27/2015 7:00 PM

xbar_startPercentage = 0.05;
ybar_startPercentage = 0.05;

xbar_lengthPercentage = .1;
ybar_lengthPercentage = .1;

barthickness = 5;

if ~exist('y_unit', 'var') || isempty(y_unit)
	y_unit = '';
end
if ~exist('yscale', 'var') || isempty(yscale)
	yscale = true;
end
if ~exist('x_unit', 'var') || isempty(x_unit)
	x_unit = '';
end
if ~exist('xscale', 'var') || isempty(xscale)
	xscale = true;
end
if ~exist('ax', 'var') || isempty(ax)
	ax = gca;
end

if ~ischar(x_unit) && ~iscellstr(x_unit)
	error('"x_unit" must be character.');
end
if ~ischar(y_unit) && ~iscellstr(y_unit)
	error('"y_unit" must be character.');
end

xl = ax.XLim;
yl = ax.YLim;

xbar_start = xl(1) + xbar_startPercentage * range(xl);
ybar_start = yl(1) + ybar_startPercentage * range(yl);

holdstatus = ax.NextPlot;
ax.NextPlot = 'add';

h = [];

if xscale
	xbar_x = [xbar_start, xbar_start+xbar_lengthPercentage*range(xl)];
	h(end+1) = plot(ax, xbar_x, ones(1,2)*ybar_start, 'k', 'LineWidth', barthickness);
	
	xtext_x = mean(xbar_x);
	xtext_y = ybar_start;
	xtext = [num2str(range(xbar_x), '%.0f'), ' ' x_unit];
	text(xtext_x, xtext_y, xtext, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontName', 'Arial', 'FontSize', 16);
end
if yscale
	ybar_y = [ybar_start, ybar_start+ybar_lengthPercentage*range(yl)];
	h(end+1) = plot(ax, ones(1,2)*xbar_start, ybar_y, 'k', 'LineWidth', barthickness);
	
	ytext_x = xbar_start;
	ytext_y = mean(ybar_y);
	ytext = [num2str(range(ybar_y), '%.0f'), ' ' y_unit];
	text(ytext_x, ytext_y, ytext, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'Rotation', 90, 'FontName', 'Arial', 'FontSize', 16);
end

ax.NextPlot = holdstatus;

if nargout > 0
	h_scalebar = h;
end

fprintf('Horizontal Scale = %f\nVerticalScale = %f\n', range(xbar_x), range(ybar_y));