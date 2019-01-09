function obj = sort(obj, byBeginOrEnd)
%obj = sort(obj, byBeginOrEnd) Sort the intervals in increasing order
%
% byBeginOrEnd (OPTIONAL, case-insensitive, default: 'begin')
%	can be one of these values:
%		- 'begin'
%		- 'end'
%		- 'largest'
%		- 'smallest'
%
% Will attempt to sort the uncollapsed version if object is already
% collapsed. If unsuccessful, a warning will be displayed.

% Siavash Ahmadi
% 11/3/2015 2:50 PM

validBeginOrEnd = {'begin', 'end', 'largest', 'smallest'};

if ~exist('byBeginOrEnd', 'var') || isempty(byBeginOrEnd)
	byBeginOrEnd = 'begin';
end
if ~any(strmpi(validBeginOrEnd, byBeginOrEnd))
	error('IvlSet:Sort:InvalidArgument', 'byBeginOrEnd can be either ''begin'', or ''end''');
end

if strcmpi(byBeginOrEnd, 'begin')
	[s, I] = sort(obj.Begin);
	obj.Begin = s;
	obj.End = obj.End(I);
elseif strcmpi(byBeginOrEnd, 'end')
	[s, I] = sort(obj.End);
	obj.End = s;
	obj.Begin = obj.Begin(I);
else
	error('IvlSet:NotImplementedYet', 'Todo...');
end

if obj.iscollapsed()
	try
		obj.CollapseBuffer_Begin = obj.CollapseBuffer_Begin(I);
		obj.CollapseBuffer_End = obj.CollapseBuffer_End(I);
	catch
		warning('Attempted to sort the uncollapsed ivlset. Unsuccessful.')
	end
end