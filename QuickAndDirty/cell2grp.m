function [c, g] = cell2grp(c)

n = cellfun(@length, c);
g = zeros(sum(n), 1);
boundaries = [0; cumsum(n)];
for i = 1:length(boundaries)
	j = boundaries(i) + 1;
	g(j:end) = g(j:end) + 1;
end
c = cat(1, c{:});