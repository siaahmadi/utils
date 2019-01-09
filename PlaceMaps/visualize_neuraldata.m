function visualize_neuraldata(t,x,y,s)

figure; hold on;

if isnumeric(x)
	t = {t};
	x = {x};
	y = {y};
end

if isnumeric(s)
	s = {s};
end

if exist('s', 'var') && ~isempty(s)
	color = ones(1,3)*.75;
else
	color = 'k';
end

cellfun(@(x,y) plot(x,y, 'Color', color), x, y);

if exist('s', 'var')
	[x_sp, y_sp] = spike2xy(cat(1, s{:}), cat(1, t{:}), cat(1, x{:}), cat(1, y{:}));
	
	scatter(x_sp, y_sp, 'r', 'filled');
end