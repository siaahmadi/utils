function plotidx(varargin)

if length(varargin)>1 && ismatrix(varargin{2})
	xdata = varargin{1};
	ydata = varargin{2};
	varargin(1:2) = [];
else
	ydata = varargin{1};
	xdata = 1:size(ydata,1);
	varargin(1) = [];
end
ax = gca;
if length(varargin)>1 && ismatrix(varargin{2})
	plot(xdata,ydata, varargin{:}); hold on;
	h = plot(nan(size(xdata)), nan(size(xdata)), 'MarkerFaceColor', [.5 .5 .5], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 15);
else
	h0 = plot(ydata, varargin{:}); hold on;
% 	h = plot(nan(size(ydata)), 'Color', [.6 .6 .6], 'linewidth', 3);
	addlistener(ax, 'Hit', @(~,evnt) linkedselect.genericLinkedSelectCallback(ax,evnt,h0));
end

end

