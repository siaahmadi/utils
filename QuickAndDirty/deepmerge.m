function structs = deepmerge(structs)
%DEEPMERGE Deep merge structs
%
% structs = DEEPMERGE(structs)
%    where |structs| is an array of structs
%
% Common fields will be recursively merged. Unique fields will be retained
% as is.

this = structs(1);
for i = 2:length(structs)
	this = mergefields(this, structs(i));
end
structs = this;

function allfields = mergefields(fields1, fields2)
if ~isstruct(fields1)
	allfields = fields1;
	return;
end
fn1 = fieldnames(fields1);
fn2 = fieldnames(fields2);
fn_common = intersect(fn1, fn2, 'stable');

% unique fields get added directly:
for fn = setdiff(fn1(:)', fn_common(:)')
	allfields.(fn{1}) = fields1.(fn{1});
end
for fn = setdiff(fn2(:)', fn_common(:)')
	allfields.(fn{1}) = fields2.(fn{1});
end
% common fields get merged:
for fn = fn_common(:)'
	allfields.(fn{1}) = mergefields(fields1.(fn{1}), fields2.(fn{1}));
end