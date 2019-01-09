function s = eztable2struct(t)
%EZTABLE2STRUCT Convert table to struct, adding
% an additional field 'id' containing the RowNames
% of the table
% 
% s = EZTABLE2STRUCT(t)

rownames = t.Properties.RowNames;

s = table2struct(t);
[s(:).id] = rownames{:};