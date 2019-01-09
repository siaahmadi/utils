function [nRowSubplot, nColSubplot] = subplotoptimal(Nf, aspectratio)
%SUBPLOTOPTIMAL Opimally factorize desired number of subplots into
% nRows and nColumns
%
% [nRowSubplot, nColSubplot] = SUBPLOTOPTIMAL(Nf, aspectratio)

optimN = Nf - 1;
i = 0;
bestratio = NaN(Nf+1, 1);
while optimN <= Nf * 2
	optimN = optimN + 1;
	i = i + 1;
	
	dualFactors = partition2(optimN);
	bestratio(i) = dualFactors(end, 1) ./ dualFactors(end, 2);
end

if ~exist('aspectratio', 'var')
	[~, I] = max(bestratio);
else
	if aspectratio > 1
		aspectratio = 1/aspectratio;
	end
	I = find(bestratio >= aspectratio, 1);
end

N_optim = Nf + I - 1;
dualFactors = partition2(N_optim);
nRowSubplot = dualFactors(end, 1);
nColSubplot = dualFactors(end, 2);

function p = partition2(N)
p = unique(cell2mat(cellfun(@(sets) sort(cellfun(@prod, sets)), partitions([1, factor(N)], 2), 'un', 0)), 'rows');