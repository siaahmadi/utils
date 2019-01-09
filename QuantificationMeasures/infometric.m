function [D, d] = infometric(X)
% d is the information metric H(X, Y) - I(X, Y)
% D is d normalized by H(X, Y)

[I, I_unb] = mutinfo(X); %#ok<NASGU>
H = diag(I);

d = nan(size(X, 2));
H_XY = nan(size(d));

for i = 1:length(d)
	for j = 1:length(d)
		H_XY(i,j) = H(i) + H(j) - I(i,j); % this is essentially H(i) ? H(j)
		
		d(i,j) = H_XY(i,j) - I(i,j);
	end
end
D = d ./ H_XY;