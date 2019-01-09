function v = uppertrd(inMat)

v = inMat(triu(ones(size(inMat)))==1);
