function L = open(logicalArray, by)

l = [true(1, by), logicalArray(:)', true(1, by)];

L = lau.erode(l, by);
L = lau.dilate(L, by);

L = L(by+1:end-by);