function s = strcap(s)
%STRCAP Capitalize the first letter of a string or a cell array of strings,
%while lower-casing the rest of the string.

% Siavash Ahmadi
% 11/29/2015 1:42 PM

if ischar(s)
	s = lower(s);
	s = [upper(s(1)), s(2:end)];
elseif iscellstr(s)
	s = cellfun(@strcap, s, 'UniformOutput', false);
else
	error('Input must be a string or a cell array of strings.');
end