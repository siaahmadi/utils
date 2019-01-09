function idx = stridx(strCell, subStrCell)
% return the index set 'idx' for which strCell(idx) == subStrCell

if isempty(subStrCell)
	idx = [];
	return;
end
idx = sum(cell2mat(cellfun(@matchstr, repmat({strCell}, 1, length(subStrCell)), subStrCell, 'UniformOutput', false)), 2);