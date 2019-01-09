function v = uppertr(inMat)

v = inMat(triu(ones(size(inMat)), 1)==1);
