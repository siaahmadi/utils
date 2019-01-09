function [sr, startIdx, endIdx, idx] = seqreduce(seq,tol)
%SEQREDUCE Replace repetetive subsequences with a single number
%
% sr = SEQREDUCE(seq,tol)
%
%   seq    Sequence to be processed
%   tol    Minimum length of subsequence to be retained
%          (default == 1).
%
% See also: consolidate()

sr = [];
startIdx = [];
endIdx = [];
idx = [];

if ~exist('tol', 'var')
	tol = 1;
end

if isempty(seq)
	return;
end

seqlen = 1;
sr = [];
last = seq(1);
lastStart = 1;
idx = false(size(seq));
for i = 2:length(seq)
	if seq(i) ~= last && seqlen >= tol
		seqlen = 1;
		sr = [sr; seq(i-1)]; %#ok<*AGROW>
		last = seq(i);
		startIdx = [startIdx; lastStart];
		endIdx = [endIdx; i-1];
		idx(startIdx(end):endIdx(end)) = true;
		lastStart = i;
	elseif seq(i) ~= last
		seqlen = 1;
		lastStart = i;
		last = seq(i);
	elseif seq(i) == last
		seqlen = seqlen + 1;
	end
end

if seqlen >= tol
	startIdx = [startIdx; lastStart];
	endIdx = [endIdx; i];
	idx(startIdx(end):endIdx(end)) = true;
	sr = [sr; seq(i)];
end