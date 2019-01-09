function s = structmerge(struct1, struct2, varargin)

fn1 = fieldnames(struct1);
fn2 = fieldnames(struct2);
% data1 = struct2cell(struct1);
% data2 = struct2cell(struct2);
data1 = row2cell(struct2cell(struct1));
data2 = row2cell(struct2cell(struct2));

s = ezstruct([fn1(:); fn2(:)], [data1(:); data2(:)]);

s = s(:);

if nargin > 2
	s = structmerge(s, varargin{1}, varargin{2:end});
end