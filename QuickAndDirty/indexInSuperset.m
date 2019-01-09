function I = indexInSuperset(subset, idxInSubset)
% subset:  must be a binary arrray the size of the superset, with 1's
% indicating the subset elements, and 0's indicating non-subset elements
%
% idxInSubset: indices in the subset

A = find(subset);
I = A(idxInSubset);