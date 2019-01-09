function [ratNo, recdate, recday] = pathrat(fullSessionPath)

ratNo = regexp(fullSessionPath, '(?:.*)(?:Rat\s*)(\d{3,4})(?:.*)', 'tokens', 'once', 'ignorecase');
ratNo = str2double(ratNo);

recdate = regexp(fullSessionPath, '(?:.*)(\d{1,2}-\d{1,2}-\d{2})(?:.*)', 'tokens', 'once');
recdate = recdate{1};

recday = regexp(fullSessionPath, '(?:.*)(?:[dD]ay)(\d{1,2})(?:.*)', 'tokens', 'once');
if ~isempty(recday)
	recday = str2double(recday);
else
	recday = 0;
end