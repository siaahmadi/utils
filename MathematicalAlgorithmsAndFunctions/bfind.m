function [idx, itpIdx, pseudoIdx] = bfind(x, array)
%[idx, itpIdx] = bfind(x, array) Binary Search for |x| in |array|
%
% Assumes |array| is sorted. DOES NOT CHECK FOR SORTED TO AVOID SPEED
% COMPROMISE.
%
% Runs in O(M*log(N)) where
%	M = length(x), and
%	N = length(array)
%
%
% USAGE:
%	[idx, itpIdx] = bfind(x, array)
%		Finds elements of x in array and returns their respective array
%		indices as idx.
%
%		If the exact value is not found the interpolated position will be
%		returned in itpIdx.
%
%		If x is a single value and cannot be found in array, idx will be
%		empty, but itpIdx will contain the interpolated index.
%
%		If x is an array and x(i) cannot be found in array, the
%		corresponding element in idx will be a NaN value.

% Siavash Ahmadi
% University of California, San Diego
% 11/3/2015 2:24 PM


if ~isvector(x)
	error('"%s" is not a vector. Only accepts vectors as |x|.\n', inputname(1));
end
if ~isvector(array)
	error('"%s" is not a vector. Only accepts vectors as |array|.\n', inputname(2));
end

if numel(array) < 2
	idx = find(array == x);
	itpIdx = ones(size(x));
	pseudoIdx = double(x < array)*0.5 + double(x == array) + double(x > array)*1.5;
	return
end
	

itpIdx = x;
idx = x;
pseudoIdx = x;

for i = 1:length(x)
	i_low = 1;
	i_up = length(array);
	i_mid = floor((i_up+i_low)/2);
	cQuery = x(i);
	while true
		if i_mid == i_low
			if cQuery > array(i_up)
				idx(i) = NaN;
				itpIdx(i) = i_up;
				pseudoIdx(i) = i_up + .5;
				return;
			elseif cQuery < array(i_low)
				idx(i) = NaN;
				itpIdx(i) = i_low;
				pseudoIdx(i) = i_low - .5;
				return;
			end
			if abs(cQuery - array(i_mid)) < abs(cQuery - array(i_mid+1))	% |cQuery| closer in value to |i_middle| than to |i_middle + 1|
				itpIdx(i) = i_mid;
				if cQuery == array(i_mid)  % item found
					idx(i) = i_mid;
					pseudoIdx(i) = i_mid;
				else
					idx(i) = NaN;
					if cQuery < array(i_mid)
						pseudoIdx(i) = i_mid - .5;
					else
						pseudoIdx(i) = i_mid + .5;
					end
				end
			elseif cQuery == array(i_mid+1) % item found
				itpIdx(i) = i_mid+1;
				idx(i) = i_mid+1;
				pseudoIdx(i) = i_mid + 1;
			else % |cQuery| closer in value to |i_middle + 1| than to |i_middle|
				itpIdx(i) = i_mid+1;
				idx(i) = NaN;
				if cQuery < array(i_mid)
					pseudoIdx(i) = i_mid - .5;
				else
					pseudoIdx(i) = i_mid + .5;
				end
			end
			break;
		end
		if cQuery==array(i_mid) % item found
			itpIdx(i) = i_mid;
			idx(i) = i_mid;
			pseudoIdx(i) = i_mid;
			break;
		elseif cQuery<array(i_mid) % item in the first half of current sub-array
			i_up = i_mid;
			i_mid = floor((i_up+i_low)/2);
			continue;
		else % item in the second half of current sub-array
			i_low = i_mid;
			i_mid = floor((i_up+i_low)/2);
			continue;
		end
	end
end

if numel(idx) == 1 && isnan(idx)
	idx = [];
end