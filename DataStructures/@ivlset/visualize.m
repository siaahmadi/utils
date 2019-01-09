function visualize(obj, axs, labels)
% Make a plot of the current interval set

% Siavash Ahmadi
% 11/3/2015

persistent ax


if nargin > 1
	if isa(axs, 'matlab.graphics.axis.Axes')
		ax = axs;
	else
		figure;
		ax = gca;
		if iscellstr(axs) || ischar(axs)
			labels = axs;
		end
	end
else
	figure;
	ax = gca;
end


N_obj = numel(obj);

[B, E] = arrayfun(@toIvl, obj, 'un', 0);

if ~exist('labels', 'var') || isempty(labels)
	labels = cell(size(B));
	labels(:) = {''};
else
	labels = reshape(labels, size(B));
end

y = reshape(num2cell(1:N_obj), size(B));

ax = cellfun(@(b,e,y,l) draw(ax, b, e, y, l), B, E, y, labels, 'un', 0);
ax = ax{1};
ax.YTickLabel = labels;

M = max(cellfun(@max, E));
m = min(cellfun(@min, B));
R = M - m;
xlim(ax, [m - .1*R, M + .1*R]);
ylim(ax, [0 N_obj+1]);

ax.YTick = 1:N_obj;
axis(ax, 'ij');
title(ax, inputname(1), 'FontName', 'Courier New');
ax.FontName = 'Arial';
ax.Box = 'off';
ax.TickDir = 'out';

function ax = draw(ax, B, E, y, labels)

inlineLabels = true;

if ~exist('labels', 'var') || isempty(labels)
	labels = cell(size(B));
	labels(:) = {''};
end

if ~iscell(labels)
	labels = {labels};
	inlineLabels = false;
end

I_linf = isinf(B) & ~isinf(E); % only Inf on left
I_rinf = isinf(E) & ~isinf(B); % only Inf on right
I_binf = I_linf & I_rinf; % Inf on both ends

I_fin = ~I_linf & ~I_rinf & ~I_binf;

if inlineLabels
	labels = labels(I_fin);
end

ax.NextPlot = 'add';
ax = drawBFin(ax, B(I_fin), E(I_fin), y, labels, inlineLabels);
% ax = drawLInf(ax, B(I_linf), E(I_linf), y, labels(I_linf));
% ax = drawRInf(ax, B(I_rinf), E(I_rinf), y, labels(I_rinf));
% ax = drawBInf(ax, B(I_binf), E(I_binf), y, labels(I_binf));
ax.NextPlot = 'replace';

function ax = drawLInf(ax, B, E, y, labels)
% Draw if left end infinite

function ax = drawRInf(ax, B, E, y, labels)
% Draw if right end infinite

function ax = drawBInf(ax, B, E, y, labels)
% Draw if both ends infinite

function ax = drawBFin(ax, B, E, y, labels, inlineLabels)
% Draw if both ends are finite

N_ivls = length(B);

I_empty = isnan(B) & isnan(E); % the only way the interval is empty is if its B and E are singleton NaNs

if I_empty
	return;
end

toPlotX = repmat(B, 3, 1);
toPlotX(1:3:end) = B;
toPlotX(2:3:end) = E;
toPlotX(3:3:end) = NaN;

if N_ivls > 1 % this is because linspace outputs the right end of the interval if N == 1
	toPlotY = repmat(linspace(y-.45,y+.45,N_ivls), 3, 1);
else
	toPlotY = repmat(y, 3, 1);
end

if ~isvalidhandle(ax)
	p = plot(toPlotX(:), toPlotY(:),'k-o');
else
	p = plot(ax, toPlotX(:), toPlotY(:),'k-o');
end
if inlineLabels && length(y) == length(B)
	text(mean([B, E], 2), y, labels, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Top', 'FontSize', 12, 'FontName', 'Arial', 'Interpreter', 'None');
end
ax = ancestor(p, 'Axes');