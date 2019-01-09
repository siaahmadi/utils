function joyplot(xi,f)
%JOYPLOT Joy plot (a.k.a. ridge plot)
%
% Use MATLAB'S KSDENSITY to obtain xi and f inputs

if ~iscell(xi)
	xi = {xi};
	f = {f};
end

hold on;
left = cellfun(@min, f, 'un', 0);
right= cellfun(@max, f, 'un', 0);
N = length(f);

cellfun(@(x,f,i,l,r)plotone(N,x,f,i,l,r), ...
	xi, ...
	f, ...
	num2cell(1:N)', ...
	left, ...
	right);

function plotone(N,x,f,i,l,r)
MULT = 60;
DIV = 1;

patch('xdata', [l, x, r], 'ydata', [(N-i)/DIV, MULT*f+((N-i)/DIV), (N-i)/DIV], 'facecolor', 'w', 'edgecolor', 'none');
plot(x, MULT*f+((N-i)/DIV), 'k');