function h_bar = barmean(ax, x, varargin)

if ~isa(ax, 'matlab.graphics.axis.Axes')
	if exist('x', 'var')
		varargin = {x, varargin{:}};
	end
	x = ax;
	ax = gca;
end

ax.NextPlot = 'add';

means = nanmean(x);

h_b = bar(ax, means, varargin{:});

E = nanstd(x) ./ sqrt(sum(~isnan(x)));
h_e = errorbar(means, E, varargin{:});

h_e.LineStyle = 'none';

if nargout > 0
	h_bar = h_b;
end