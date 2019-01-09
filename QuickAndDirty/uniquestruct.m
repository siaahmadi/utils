function strs = uniquestruct(strs)
%strs = UNIQUESTRUCT(strs)
%
% Return structs with non-identical fields and values

if length(strs) > 1
	if isequal(strs(1), strs(2))
		strs = uniquestruct(strs(2:end));
	else
		strs = [strs(1); uniquestruct(strs(2:end))];
	end
end