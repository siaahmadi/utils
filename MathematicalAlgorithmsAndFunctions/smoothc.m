function x = smoothc(x, kernel)
%SMOOTHC Smooth by column
%
% x = SMOOTHC(x)

tr = false;
if isvector(x) && size(x, 2) >= size(x, 1)
	tr = true;
	x = x';
end

xi = linspace(-.5,.5,100)';
y = normpdf(xi,0,kernel);

x = cellfun(@(row) convc(replaceNans(row), y), column2cell(x), 'un', 0);
x = cat(2, x{:});

if tr
	x = x';
end

x = replaceInfs(x);

function x = convc(x, y)
x = conv(x, y, 'same');