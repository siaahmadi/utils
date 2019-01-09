function L = close(logicalArray, by)

L = lau.dilate(logicalArray(:)', by);
L = lau.erode(L, by);