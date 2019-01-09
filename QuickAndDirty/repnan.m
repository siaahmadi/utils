function A = repnan(B,repval)
%REPNAN Replace NaN's with a value
A = B;
A(isnan(A)) = repval;