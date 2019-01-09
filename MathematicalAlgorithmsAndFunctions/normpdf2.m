function z = normpdf2(x, y, mu, Sigma)

if nargin < 3
	mu = [0 0];
	Sigma = eye(2);
end

[X1,X2] = meshgrid(x,y);
z = mvnpdf([X1(:) X2(:)],mu,Sigma);
z = reshape(z,length(y),length(x));