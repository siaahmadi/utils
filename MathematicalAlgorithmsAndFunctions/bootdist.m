function bootstat = bootdist(nboot, bootfun, d1, varargin)
%BOOTDIST Bootstrap distribution for input samples
%
% Very similar to MATLAB's @bootstrp function only it allows for any size
% inputs (resampling each input sample independently)

% Siavash Ahmadi
% 10/30/2017

bootstat = NaN(nboot, 1);

for i = 1:nboot
	bootin1 = datasample(d1,length(d1));
	bootinv = cellfun(@(x) datasample(x, length(x)), varargin, 'un', 0);
	bootstat(i) = bootfun(bootin1, bootinv{:});
end