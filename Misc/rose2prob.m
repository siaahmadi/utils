function [probPeak, idx_ylimlbl_textobj] = rose2prob(h_rose, rout, probtype)

if nargin < 2
	probtype = 'continuous';
end


numBins = length(rout);
totalArea = sum(pi*rout.^2./numBins);
myArea = pi*max(rout).^2/numBins;

if strcmpi(probtype, 'continuous')
	maxRadius = max(rout) / sqrt(totalArea);
elseif strcmpi(probtype, 'discrete')
	maxRadius = myArea / totalArea;
end

rosetextobj = findall(h_rose.Parent, 'type', 'text');
rosetexts = {rosetextobj.String}';
IDX_heights = strncmp(rosetexts, '  ', 2);
[~, largest_height] = max(str2double(rosetexts(IDX_heights)));
idx_ylimlbl_textobj = elem(find(IDX_heights), largest_height);
% probPeak = str2double(rosetextobj(idx).String) / maxRadius;
probPeak = maxRadius;