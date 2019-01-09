function d = polydist(pt, polygon)

from_vertices = arrayfun(@(x, y) eucldist(pt(1), pt(2), x, y), polygon(:, 1), polygon(:, 2));

h = arrayfun(@(x1,y1,x2,y2) hoveratop(pt, [x1,y1], [x2,y2]), polygon(1:end-1, 1), polygon(1:end-1, 2), polygon(2:end, 1), polygon(2:end, 2));

from_consec_segments = sum(cell2mat(arrayfun(@(x1,y1,x2,y2) [eucldist(x1, y1, pt(1), pt(2)), eucldist(x2, y2, pt(1), pt(2))], polygon(1:end-1, 1), polygon(1:end-1, 2), polygon(2:end, 1), polygon(2:end, 2), 'UniformOutput', false)), 2);

from_consec_segments(~h) = Inf;

d = min([from_vertices(:); from_consec_segments(:)]);