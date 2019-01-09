function mstr = matchstr(strCell, word, exactness)
if isempty(strCell)
	mstr = false;
	return;
elseif isempty(word)
	mstr = false;
	return;
end

if nargin < 3 || strcmpi(exactness, 'contains')
	mstr = ~cellfun(@isempty, regexp(strCell, word));
elseif strcmpi(exactness, 'exact')
	mstr = ~cellfun(@isempty, regexp(strCell, ['^' word '$']));
end