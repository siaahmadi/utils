function [ANAN, idxData] = insertnanatjump(array, jump)
%INSERTNANATJUMP Insert NaN's in between array elements different by more
%than |jump|
%
% Good for plotting jumpy position data
%
% WORK IN PROGRESS!!!

jumps = diff(array);

if jump<0
	jumpIdx = jumps<jump;
	jumpIdx(end+1) = false;
	nJumps = sum(jumpIdx);
else
	jumpIdx = jumps>jump;
	jumpIdx(end+1) = false;
	nJumps = sum(jumpIdx);
end

jumpIdx = find(jumpIdx);
jumpIdx = jumpIdx(:) + (1:length(jumpIdx))';

ANAN = zeros(numel(array)+nJumps, 1);
ANAN(jumpIdx) = NaN;
idxData = ~isnan(ANAN); % input data might have NaN's already
ANAN(idxData) = array(:);