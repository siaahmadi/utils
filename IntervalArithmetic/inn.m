function idx = inn(timestamps, timearrow)
%INN Find indices in |timearrow| lying within |timestamps|
%
% SYNTAX:
%	idx = INN(timestamps, timearrow)
%
% See Also: ismember, find, restr

if numel(timestamps) ~= 2
	error('Not supported. timestamps must have 2 values.');
end

idx = timestamps(1) <= timearrow & timestamps(2) >= timearrow;