function mm = troff(logicalVec)
%RTOFF(LOGICALARRAY) Return (on)-to-off transitions
%
% in a vectors of 0's and 1's the index of element after the last 1 of
% each series of adjacent 1's will be 1, everything else will be 0's
%
% Member of (L)ogical (A)rray (U)titlies (LAU) pack

mm = lau.rt(logicalVec(:)');
mm = ~logicalVec(:)' & diff([0 mm]);