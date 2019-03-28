function s = gindex(vals)
%GINDEX Index elements within groups defined by identical adjacent values
%
% s = GINDEX(vals)

if any(~isfinite(vals(1)))
	error('Non-finite values found.');
end
if vals(1)==0
	vals = [-1; vals];
else
	vals = [0; vals];
end

d = [diff(vals(:)); 0]~=0;

c = circshift(d,1) .* (1:length(vals))';
jumps = find(c);
cc = c(jumps) - [0; c(jumps(1:end-1))];
c(jumps) = cc;

s = (1:length(vals))' - cumsum(c) + 1;

s = s(2:end);