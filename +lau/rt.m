function mm = rt(logicalVec)
%RT(LOGICALARRAY) (R)etain (T)ransitions
%
% in a vectors of 0's and 1's replaces the inner 1's of a series of adjacent
% 1 values with 0's
%
% Member of (L)ogical (A)rray (U)titlies (LAU) pack

if ~isvector(logicalVec) || ~islogical(logicalVec)
	error('This function accepts only logical arrays')
end

initIsRow = isrow(logicalVec);

logicalVec = reshape(logicalVec, 1, numel(logicalVec));
mm = bwmorph([ones(1,length(logicalVec));logicalVec;ones(1,length(logicalVec))]==1, 'remove'); mm = mm(2,:);

if initIsRow
	mm = mm(:)';
else
	mm = mm(:);
end