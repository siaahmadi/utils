function [outInterval, intervalSetsPositive, intervalSetsNegative, numEpochs1, numEpochs0] = mergeIntervals(interval, threshold)
% converts stretches of 0's of length threshold or less to 1's in an array
% of 0's and 1's, interval.

if sum(interval) == 0 % all 0's
	if threshold >= numel(interval)
		outInterval = ~interval;
		intervalSetsPositive = {1:length(interval)};
		intervalSetsNegative = [];
		numEpochs1 = 1;
		numEpochs0 = 0;
		return;
	else
		outInterval = interval;
		intervalSetsPositive = [];
		intervalSetsNegative = {1:length(interval)};
		numEpochs1 = 0;
		numEpochs0 = 1;
		return;
	end
elseif sum(interval) == numel(interval) % all 1's
	outInterval = interval;
	intervalSetsPositive = {1:length(interval)};
	intervalSetsNegative = [];
	numEpochs1 = 1;
	numEpochs0 = 0;
	return;
end

A = intset2int(find(~interval), 0);
A = reshape(A, 2, length(A)/2);
B = A(2,:) - A(1,:) + 1;
B = B <= threshold;

A = A(:, B); A = A(:);
A = int2intset([-1;0;A]); A = A(3:end);

interval(A) = true;

outInterval = interval;


numEpochs1 = size(intset2int(find(interval), 0), 2)/2;
if outInterval(1) == true && outInterval(end) == true
	numEpochs0 = numEpochs1-1;
elseif outInterval(1) == false && outInterval(end) == false
	numEpochs0 = numEpochs1+1;
else
	numEpochs0 = numEpochs1;
end

buffer = intset2int(find(interval));
intervalSetsPositive = cell(numEpochs1, 1);
for i = 1:length(intervalSetsPositive)
	intervalSetsPositive{i} = int2intset([-2 -1 buffer(2*i-1:2*i)]);
	intervalSetsPositive{i} = intervalSetsPositive{i}(3:end);
end

if sum(interval) == numel(interval) % all 1's
	outInterval = interval;
	intervalSetsPositive = 1:length(interval);
	intervalSetsNegative = [];
	numEpochs1 = 1;
	numEpochs0 = 0;
	return;	
end
buffer = intset2int(find(~interval));
intervalSetsNegative = cell(numEpochs0, 1);
for i = 1:length(intervalSetsNegative)
	intervalSetsNegative{i} = int2intset([-2 -1 buffer(2*i-1:2*i)]);
	intervalSetsNegative{i} = intervalSetsNegative{i}(3:end);
end