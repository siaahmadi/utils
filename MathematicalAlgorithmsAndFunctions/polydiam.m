function d = polydiam(polygon)

if size(polygon, 2) > 2
	polygon = polygon';
end

all_d = nan(size(polygon, 1));

for i = 1:length(all_d)
	for j = i+1:length(all_d)
		all_d(i, j) = eucldist(polygon(i, 1), polygon(i, 2), polygon(j, 1), polygon(j, 2));
	end
end

d = max(all_d(:));