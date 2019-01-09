function m = midpt(A)

m = A(1:end-1) + diff(A)/2;