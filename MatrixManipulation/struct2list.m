function l = struct2list(st)

fields = fieldnames(st);
vals = cellfun(@(field) st.(field), fields, 'un', 0);

l = cell(1, length(fields) + length(vals));

l(1:2:end) = fields;
l(2:2:end) = vals;