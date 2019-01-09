function s = splitatnan(A)
%SPLITATNAN Split array of values into entries of a cell array
% 
% s = SPLITATNAN(A)  Delimiter used is a run of NaNs of any length (>0)

nans = isnan(A);
idx = find(lau.troff(nans) | lau.tron(nans)); % not tested; not sure if it will handle nans(1) and nans(end) correctly
s = arrayfun(@(i0,i1) A(i0:i1), idx(1:2:end), idx(2:2:end), 'un', 0);
s = s(:);