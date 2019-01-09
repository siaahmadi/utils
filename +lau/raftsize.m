function [sz, start] = raftsize(logicalVec)
%[sz, start] = raftsize(logicalVec) Find the length of continguous 1's in a
%logical array
%
% The output will be a vector of integers of the lengths of the continguous
% 1's in the input array. If the input array does not contain 1's, the
% output will be the empty vector.

logicalVec = logicalVec(:)';

if iscolumn(logicalVec)
	logicalVec = [logicalVec;false];
elseif isrow(logicalVec)
	logicalVec = [logicalVec false];
else
	error('Enter a vector')
end
cs = cumsum(logicalVec);
troff = lau.troff(logicalVec);
sz = diff([0 cs(troff)]);
if isempty(sz)
	start = [];
	return;
end
start = find(troff) - sz;