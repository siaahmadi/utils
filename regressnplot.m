function [h, b_regr, stats_regr] = regressnplot(x,y, method, varargin)

if ~exist('method', 'var') || isempty(method)
	method = 'linear';
end

x = x(:); y = y(:);
idx_finite = isfinite(x) & isfinite(y);
x = x(idx_finite);
y = y(idx_finite);
if isempty(x)
	error('not enough finite data points to carry out the regression')
end


if strcmpi(method, 'linear')
	[b_regr, ~,~,~, stats_regr] = regress(y, [ones(size(y, 1), 1), x]);
	
	xli = [min(x), max(x)];
	Y = @(x) b_regr(1) + b_regr(2) .* x;
elseif strcmpi(method, 'log');
	x = log10(x);
	y = log10(y);
	idx_finite = isfinite(x) & isfinite(y);
	x = x(idx_finite);
	y = y(idx_finite);
	
	if isempty(x)
		error('not enough finite data points to carry out the regression')
	end
	
	[b_regr, ~,~,~, stats_regr] = regress(y, [ones(size(y, 1), 1), x]);
	
	xli = [min(x), max(x)];
	Y = @(x) 10.^(b_regr(1) + b_regr(2) .* log10(x));
else
	error('log or linear?')
end

ih = ishold;
hold on;
h = plot(xli, Y(xli), varargin{:});
if ~ih
	hold off;
end