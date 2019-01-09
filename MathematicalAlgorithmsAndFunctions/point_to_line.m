function d = point_to_line(pt, v1, v2)
% from http://www.mathworks.com/matlabcentral/answers/95608-is-there-a-function-in-matlab-that-calculates-the-shortest-distance-from-a-point-to-a-line#answer_104961

if length(pt) == 2
	pt(end+1) = 0;
	v1(end+1) = 0;
	v2(end+1) = 0;
end

a = v1 - v2;

b = pt - v2;

d = norm(cross(a,b)) / norm(a);