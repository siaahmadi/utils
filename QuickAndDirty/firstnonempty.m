function [b, i] = firstnonempty(a)

if iscell(a)
	i = find(~cellfun(@isempty, a), 1);
	b = a(i);
else
	i = find(~isempty(a), 1);
	b = a(i);
end