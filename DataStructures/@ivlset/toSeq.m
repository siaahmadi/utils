function ivl = toSeq(obj, Uniform, beginOrEnd, memoryUsageLimit) % main retrieval function: returns a sequence of values in the interval
% Uniform determines whether a cell array or a numeric array
% should be returned.
%
% If Uniform==false (default) then a cell array of sequences of intervals
% will be returned.
%
% If Uniform==true it will be attampted to return a MxN matrix of sequences
% where M is the number of intervals and N is the uniform length of every
% interval. Where this is not possible, Uniform==true will be ignored.

validBeginOrEnd = {'begin', 'end', 'both'};

if nargin < 2
	if ~exist('Uniform', 'var')
		Uniform = false;
	end
	if ~exist('beginOrEnd', 'var')
		beginOrEnd = 'both';
	end
elseif nargin < 3 % First argument provded
	if exist('Uniform', 'var') && (islogical(Uniform) || isempty(Uniform))
		beginOrEnd = 'both';
	elseif ischar(Uniform)
		beginOrEnd = Uniform;
		Uniform = false;
	else
		error('IvlSet:toIvl:InvalidArgument:Type', 'Provide either a logical value or a string from set {''begin'', ''end'', ''both''}.')
	end
elseif nargin < 4 % Both arguments provided
	if (~isempty(Uniform) && ~islogical(Uniform)) || ~ischar(beginOrEnd) || ~any(strcmp(validBeginOrEnd, beginOrEnd))
		error('IvlSet:toIvl:InvalidArgument:Type', 'Provide a logical value as first argument (or pass on an empty matrix) and a string from set {''begin'', ''end'', ''both''} as the second argument.')
	end
end

if isempty(Uniform)
	Uniform = false;
end
if isempty(beginOrEnd)
	beginOrEnd = 'both';
end
if ~exist('memoryUsageLimit', 'var') || isempty(memoryUsageLimit)
	memoryUsageLimit = .5; % allow using up to 50% of available memory for MATLAB usage to return the expanded-view (sequence type) intervals
elseif memoryUsageLimit <= 0
	error('memoryUsageLimit must be a positive value.')
elseif memoryUsageLimit > 1
	memoryUsageLimit = Inf;
end

myIvl = obj.toIvl(Uniform, beginOrEnd);
if isempty(myIvl)
	ivl = [];
	return;
end

memReq = auxFunc_calculateMemReq(myIvl, obj.Begin(1));
try
	if ~auxFunc_handleMemory(memReq, memoryUsageLimit)
		return
	end
catch err
	if strcmp(err.identifier, 'IvlSet:ToSeq:NonWindowsSystem')
		% pass
	else
		rethrow(err)
	end
end

ivl = cellfun(@auxFunc_bdr2seq, myIvl, 'UniformOutput', false);

if Uniform || length(ivl) == 1
	try
		ivl = cell2mat(ivl);
	catch err
		if strcmp(err.identifier, 'MATLAB:catenate:dimensionMismatch')
			warning('Cannot produce a uniform output. Ingnoring uniformity parameter.');
			% pass (ivl has been created already--just need to return)
		else
			rethrow(err)
		end
	end
end

function seq = auxFunc_bdr2seq(bdr)

if all(isfinite(bdr))
	seq = bdr(1):bdr(2);
else
	error('IvlSet:ToSeq:InfSeqAttempted', 'Sequencing an interval one of whose bounds includes an Inf is not allowed.');
end

function I = auxFunc_handleMemory(memNeeded, memoryUsageLimit)

if memNeeded == Inf
	error('IvlSet:ToSeq:InfSeqAttempted', 'Sequencing an interval one of whose bounds includes an Inf is not allowed.');
end

if isempty(regexp(computer, 'PCWIN', 'once'))
	error('IvlSet:ToSeq:NonWindowsSystem', 'Not implemented for non MS Windows machines');
end
	
[u, s] = memory;

if floor(u.MemAvailableAllArrays * memoryUsageLimit) < memNeeded
	error('IvlSet:ToSeq:OutOfAllowedMemory', 'Memory required exceeds the allowed usage amount');
end
if memoryUsageLimit == Inf && memNeeded > s.PhysicalMemory.Available
	if memNeeded <= s.SystemMemory.Available
		warning('Memory required exceeds available physical memory. This means that the operation will heavily slow down your computer.')
		uin = input('Proceed? (y/n) >> ', 's');
		if ~strcmpi(uin, 'y')
			I = false;
			return;
		end
	else
		error('IvlSet:ToSeq:OutOfMemory', 'Memory required exceeds system memory available.');
	end
end
I = true;

function memReq = auxFunc_calculateMemReq(myIvl, instance)

szOfEach = auxFunc_sizeof(instance);
totalNumSeqItems = sum(cellfun(@diff, myIvl))+length(myIvl);

memReq = totalNumSeqItems * szOfEach;

function bytes = auxFunc_sizeof(instance) %#ok<INUSD>
zw = whos('instance');
bytes = zw.bytes;