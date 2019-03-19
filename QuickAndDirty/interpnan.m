function x_i = interpnan(x)
%INTERPNAN Linearly interpolate NaNs with adjacent non-NaN values
%
% x_i = INTERPNAN(x)

nanboundaries = lau.raftidx(isnan(x));
x_i = x;
for b = nanboundaries
	if b(1) == 1
		x_i(b(1):b(2)) = x(b(2)+1);
	elseif b(2) == length(x_i)
		x_i(b(1):b(2)) = x(b(1)-1);
	else
		x_i(b(1):b(2)) = linspace(x(b(1)-1), x(b(2)+1), diff(b)+1);
	end
end