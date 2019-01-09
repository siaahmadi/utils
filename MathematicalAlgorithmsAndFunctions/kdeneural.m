function s = kdeneural(X, sigma)

smfact = 5;

K = normpdf(linspace(-4*sigma, 4*sigma, smfact*round(1/sigma))', 0, sigma);

s = conv(sum(X, 2)./size(X, 2), K, 'same') ./ smfact;