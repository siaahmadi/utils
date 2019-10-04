function L = close(logicalArray, by)

l = [false(1, by), logicalArray(:)', false(1, by)];

L = lau.dilate(l, by);
L = lau.erode(L, by);

L = L(by+1:end-by);