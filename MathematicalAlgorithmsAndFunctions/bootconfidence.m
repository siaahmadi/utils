function ci = bootconfidence(nboot,bootfun,varargin)

alpha = 95;

dist = bootdist(nboot, bootfun, varargin{:});

ci = [prctile(dist, (100-alpha)/2); prctile(dist, 100-(100-alpha)/2)];