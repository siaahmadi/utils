function v = lowertrd(inMat)

v = inMat(tril(ones(size(inMat)))==1);
