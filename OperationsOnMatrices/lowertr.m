function v = lowertr(inMat)

v = inMat(tril(ones(size(inMat)), -1)==1);
