function a_c = consolidate(a)
%CONSOLIDATE Replace sub-sequences of repeated numbers by a single instance
%
% a_c = CONSOLIDATE(a)
%
% See also: seqreduce()

d = [find(diff(a(:))); numel(a)];

a_c = a(d);