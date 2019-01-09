function c = cateachrow(str1, str2)
% cateach, to produce a row vector (name shouldn't suggest operation on rows)

x = strcat(str1, str2);
c = cat(2, x{:});