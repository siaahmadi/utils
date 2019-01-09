function mstr = matchstri(strCell, word, exactness)

if iscell(word) % handle several words at the same time
	mstr = sum(cell2mat(cellfun(@(x) matchstri(strCell, x, 'exact'), word(:)', 'UniformOutput', false)), 2)>0;
	return
end

if nargin < 3 || strcmpi(exactness, 'contains')
	mstr = ~cellfun(@isempty, regexpi(strCell, word));
elseif strcmpi(exactness, 'exact')
	mstr = ~cellfun(@isempty, regexpi(strCell, ['^' word '$']));
end