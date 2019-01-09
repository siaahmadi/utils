function mm = tron(logicalVec)
%RTOFF(LOGICALARRAY) Return (off)-to-on transitions
%
% in a vectors of 0's and 1's the index of element before the first 1 of
% each series of adjacent 1's will be 1, everything else will be 0's
%
% Member of (L)ogical (A)rray (U)titlies (LAU) pack

mm = lau.rt(logicalVec);
mm(end+1) = 0;
mm = ~logicalVec & diff(mm);