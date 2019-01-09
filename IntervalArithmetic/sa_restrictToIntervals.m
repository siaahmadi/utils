function restrictedArray = sa_restrictToIntervals(inArray, intervalSet)

if ~isvector(intervalSet) || mod(length(intervalSet), 2) == 1 || ~issorted(intervalSet)
	error('Invalid intervalSet. Must be a sorted vector of even length.')
end
if ~issorted(inArray)
	error('Input array must be sorted.')
end
if size(inArray, 2) > 1 % make sure inArray is a column vector
	inArray = inArray';
end
if size(intervalSet, 2) > 1 % make sure intervalSet is a column vector
	intervalSet = intervalSet';
end

if length(inArray) == 1 % handle singleton inArray
	if inArray > intervalSet(end) || inArray < intervalSet(1) || ...
			(mod(closestPoint(intervalSet, 1:length(intervalSet), inArray), 2) == 1 && inArray < intervalSet(closestPoint(intervalSet, 1:length(intervalSet), inArray))) || ...
			(mod(closestPoint(intervalSet, 1:length(intervalSet), inArray), 2) == 0 && inArray > intervalSet(closestPoint(intervalSet, 1:length(intervalSet), inArray)))
		restrictedArray = [];
	else
		restrictedArray = inArray;
	end
	return
end
	

% Find the length of restrictedArray
intervalSetInd = ismembc2(closestPoint(inArray, inArray, intervalSet), inArray);
restrictedArray = diff(intervalSetInd);
restrictedArray = sum(restrictedArray(1:2:end)) + length(intervalSet)/2; % maximally, restrictedArray will be of this length
restrictedArray = NaN(restrictedArray, 1);

lastInd = 1;
for i = 1:2:length(intervalSet)-1
	if intervalSet(i) <= inArray(intervalSetInd(i))
		leftInd = intervalSetInd(i);
	else
		leftInd = intervalSetInd(i) + 1;
	end
	if intervalSet(i+1) >= inArray(intervalSetInd(i+1))
		rightInd = intervalSetInd(i+1);
	else
		rightInd = intervalSetInd(i+1) - 1;
	end
	
	restrictedArray(lastInd:lastInd + rightInd-leftInd) = inArray(leftInd:rightInd);
	lastInd = lastInd + (rightInd-leftInd+1);
end

restrictedArray = restrictedArray(~isnan(restrictedArray));