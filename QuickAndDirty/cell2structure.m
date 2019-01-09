function S = cell2structure(C, fields)

C = cellfun(@(c) c, C, 'un', 0);

args = cell(length(C)*2, 1);
args(1:2:end) = fields;
args(2:2:end) = C;

S = struct(args{:});