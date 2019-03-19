function split_data = array_split(inarray, n, c)
%ARRAY_SPLIT Return sliced fraction of run data
%
% split_data = ARRAY_SPLIT(inarray, n, c)
% n: slice data into 1/n
% c: array of integers, will return [(i-1)/n, i/n] of data for i \in c

n_data = length(inarray);
idx = (1:n) * floor(n_data / n);
idx(end) = n_data;
idx = [0, idx];
split_data = [];
for i = c(:)'
	split_data = [split_data; inarray(idx(i)+1:idx(i+1))];
end