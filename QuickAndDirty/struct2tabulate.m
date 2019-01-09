function tab = struct2tabulate(str, recursive)
%STRUCT2TABLULATE Concatenate the fields of struct adding a second column
%with field names tabulated with each row
%
% Every field i must be an N_i x 1 column vector or cell vector
%
% tab = STRUCT2TABLULATE(str, recursive)

if isempty(str)
	tab = str;
	return;
end

fn = fieldnames(str);
for i = 1:length(fn)
	if recursive
		if isstruct(str(1).(fn{i}))
			str.(fn{i}) = struct2tabulate(str.(fn{i}), recursive);
		else
			if size(str(1).(fn{i}), 2) > 1
				tab = cell2table(struct2cell(str)', 'variablenames', fieldnames(str)); % unlike struct2table will handle fields with more than 1 column
			else
				tab = struct2table(str);
			end
			return;
		end
	end
end

n = structfun(@(x) size(x, 1), str);
data = struct2cell(str);
data(cellfun(@isempty, data)) = [];
data = cat(1, data{:});
lbl = arrayfun(@(i,n) repmat(fn(i), n, 1), 1:length(n), n(:)', 'un', 0);
lbl = cat(1, lbl{:});

if istable(data)
	[st,~] = dbstack();
	st = strcmp({st.name}, 'struct2tabulate');
	lbl = table(lbl, 'variablenames', {['level', num2str(sum(st))]});
end
tab = [lbl, data];