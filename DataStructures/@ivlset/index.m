function idx = index(obj, numericArray, idxType)

if ~exist('idxType', 'var') || isempty(idxType)
	idxType = 'upointer';
end

if iscell(numericArray)
	idx = cellfun(@(numArr) obj.index(numArr, idxType), numericArray, 'un', 0);
	return;
end

notSorted = ~issorted(numericArray);
if notSorted
	[numericArray, I] = sort(numericArray);
end
idx = obj.restrict(numericArray, true);
if notSorted
	idx = cat(1, idx{:});
	idx = idx(:, I);
	idx = row2cell(idx);
end

if strcmpi(idxType, 'upointer')
	idx = cellfun(@(idx, chunkInd) double(idx(:))*chunkInd, idx, num2cell(1:length(idx))', 'un', 0);
	idx = sum(cat(2, idx{:}), 2);
elseif strcmpi(idxType, 'pointer')
	idx = cellfun(@(idx, chunkInd) double(idx(:))*chunkInd, idx, num2cell(1:length(idx))', 'un', 0);
elseif strcmpi(idxType, 'binidx')
	% PASS (already in this mode)
elseif strcmpi(idxType, 'ubinidx')
	idx = sum(cat(2, idx{:}), 2) > 0;
else
	warning('Unknown idxType.');
end