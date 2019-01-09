%BINSEARCH_APPROX Binary Search (Assumes ascendingly sorted array)
%
% idx = BINSEARCH_APPROX(ascendingly_sorted_array, keys, include_outOfRange)
% 
%
% INPUT:
%       ascendingly_sorted_array     array sorted in ascending order.
%
%       keys                         keys to search for in sorted_array.
%
%       include_outOfRange           Set out of range keys to first or last
%                                    index of ascendingly_sorted_array if == 1.
%                                    Otherwise (if omitted or set to 0),
%                                    set those indices to 0.
%
% If an exact key is provided its index in the sorted array is
% returned.
% 
% If a key outside the range of the sorted array is provided, 0 is
% returned, unless include_outOfRange == 1 in which case the index of
% values less than the first item on the list is set to 1 and the index of
% the values greater than the last item on the list is set to the last
% index of the list.
%
% If a key falls between two consecutive values v(i) and v(i+1) in the
% sorted array, -i is returned.
%
%
% OUTPUT:
%          idx will have the same shape as keys.
% 
%          Specifying idx in output arguemnt list is mandatory.
%
% See also: bfind()