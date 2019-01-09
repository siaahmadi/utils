function [pval,chi2stat, stats, tbl] = propchi2test(y1, y2, n1, n2)

if y1<=1 && y2<=1
	y1 = round(y1*n1);
	y2 = round(y2*n2);
end

x1 = [repmat('a',n1,1); repmat('b',n2,1)];
x2 = [ones(y1,1); repmat(2,n1-y1,1);ones(y2,1); repmat(2,n2-y2,1)];

[tbl,chi2stat,pval] = crosstab(x1,x2);

stats.p = pval;
stats.chi2stat = chi2stat;
stats.tbl = tbl;