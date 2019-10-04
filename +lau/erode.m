function L = erode(logicalArray, by, treatEnds)

if ~exist('treatEnds', 'var')
	treatEnds = false;
end

if isempty(logicalArray)
	L = logicalArray;
	return;
end

if ~treatEnds
	logicalArray = [~logicalArray(1) logicalArray ~logicalArray(end)];
	L = ~lau.dilate(~logicalArray, by);
	L = L(2:end-1);
else
	dummyBegin = repmat(logicalArray(1), 1, by);
	dummyEnd = repmat(logicalArray(end), 1, by);
	logicalArray = [dummyBegin logicalArray dummyEnd];
	L = ~lau.dilate(~logicalArray, by);
	L = L(1+length(dummyBegin):end-length(dummyEnd));
end