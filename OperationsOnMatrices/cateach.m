function c = cateach(str1, str2)

if iscell(str1)
	c = cellfun(@(x) [x, str2], str1, 'un', 0);
elseif iscell(str2)
	c = cellfun(@(x) [str1, x], str2, 'un', 0);
else
	c = cellfun(@(x) cateach(str1, x), str2, 'un', 0);
	c = cat(1, c{:});
	return;
end