function c = nonempty(c)

if iscell(c)
	c = c(~cellfun(@isempty, c));
else % objects
	c = c(~arrayfun(@isempty, c));
end