function in_struct = insertvalue(in_struct, valuename, values)


if ~iscell(values)
	values = num2cell(values);
end
if ~isequal(size(in_struct), size(values))
	error('Size mismatch.');
end

[in_struct.(valuename)] = values{:};