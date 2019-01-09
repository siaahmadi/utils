function B = reord(A, perm)

B = A;

for i = 1:length(perm)
	B(:, i) = A(:, perm(i));
end