function strout = catstructfield(structarray)
%CATSTRUCTFIELD Takes in an array of structs and concatenates their fields'
%contents along the first dimension. If the fields are structs themselves,
%they must have the same fields and the too will be concatenated
%recursively.
%
% 5/31/2018

if isstruct(structarray) % recursive
	fn = fieldnames(structarray);
	for i = 1:length(fn)
		if isstruct(cat(1, structarray.(fn{i})))
			strout.(fn{i}) = catstructfield(cat(1, structarray.(fn{i})));
		else
			strout.(fn{i}) = cat(1, structarray.(fn{i}));
		end
	end
else
	strout = structarray;
end