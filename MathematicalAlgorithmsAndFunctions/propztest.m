function pval = propztest(p1, p2, n1, n2)

if p1>1 && p2>1
	p1 = p1 / (p1 + n1);
	p2 = p2 / (p2 + n2);
end
	

p_star = (p1*n1 + p2*n2) / (n1+n2);
Z_star = (p1 - p2) / sqrt(p_star * (1-p_star) * (1/n1 + 1/n2)); % I don't know which test statistic to use
Z_star = (p1 - p2) / sqrt((p1 * (1-p1) / n1) + (p2 * (1-p2) / n2));

pval = 2*(1-normcdf(abs(Z_star), 0, 1));