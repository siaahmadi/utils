function [isthereVal, LocStruct_all, LocStruct_first] = findstruct(struct, field, value)
%[isthereVal, LocStruct_all, LocStruct_first] = FINDSTRUCT(struct, field, value)

if ischar(value)
	value = {value};
end
if iscellstr(value)
	[isthereVal, LocStruct_first] = ismember(value, {struct.(field)});
	LocStruct_all = cellfun(@(x) strcmp(x, {struct.(field)}), value, 'UniformOutput', false);
elseif iscell(value)
	if ~isequal(numel(field), numel(value))
		error('field and value must have the same number of corresponding elements');
	end
	[isthereVal, LocStruct_all, LocStruct_first] = cellfun(@(f,v) findstruct(struct, f, v), field, value, 'un', 0);
	isthereVal = cat(1, isthereVal{:});
	LocStruct_all = cat(1, LocStruct_all{:});
	LocStruct_first = cat(1, LocStruct_first{:});
else
	[isthereVal, LocStruct_first] = ismember(value, [struct.(field)]);
	LocStruct_all = arrayfun(@(x) x == [struct.(field)], value, 'UniformOutput', false);
end