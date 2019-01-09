function [idxBegin, idxEnds] = findNlxEventBeginsAndCorrespondingEnds(eventStrings)
%[idxBegin, idxEnds] = findNlxEventBeginsAndCorrespondingEnds(eventStrings)

begins = regexp(eventStrings, '^begin.*', 'match', 'once');
idxBegin = cellfun(@(x) ~isempty(x), begins);
idxBegin = lau.rtoff(idxBegin);
possibleEnds = {cateach('^end', begins(idxBegin)), ...
	cateach('^end', regexp(begins(idxBegin), '\d{1,2}', 'match', 'once')), ...
	cateach('^end', regexp(begins(idxBegin), '(?<=begin).*', 'match', 'once'))};
giveup = false;
success = false;
next = 0;
lookfor = [];
while ~giveup && ~success
	try
		eachBeginsCorrespondingEnds = cellfun(@(x) regexp(eventStrings, [x, '$'], 'match', 'once'), lookfor, 'un', 0);
		idxEnds = cellfun(@(x) find(cellfun(@(x) ~isempty(x), x), 1, 'last'), eachBeginsCorrespondingEnds);
		success = true;
	catch
		next = next + 1;
		if next > length(possibleEnds)
			giveup = true;
		else
			lookfor = possibleEnds{next};
		end
	end
end

if giveup || ~success
	error('Couldn''t find the corresponding ends to Begin Nlx Strings.');
end

idxBegin = find(idxBegin); % for consistency