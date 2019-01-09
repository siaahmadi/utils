function out = ezgetfield(s, fields)

out = [];
for i = 1:length(fields)
	out(end+1, 1) = s.(fields{i});
end