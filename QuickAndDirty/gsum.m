function s = gsum(vals, group)
%GSUM Sum by group
%
% s = GSUM(vals, group)

if isnumeric(group)
	s = arrayfun(@(g) sum(vals(group==g)), unique(group, 'stable'));
elseif iscellstr(group)
	s = cellfun(@(g) sum(vals(strcmp(group, g))), unique(group, 'stable'));
end

