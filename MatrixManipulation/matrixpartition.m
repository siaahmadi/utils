function [B, categories] = matrixpartition(A, categories)
%MATRIXPARTITION Partition a matrix or a cell array into disjoint sets of
%its elements
%
% B = MATRIXPARTITION(A, categories)
%
%     A           Input
%     categories  Categories (i.e. labels)
%
%     B           Output

categories = categorical(categories);

ucategories = unique(categories);
indx = arrayfun(@(c) ismember(categories, c), ucategories, 'un', 0);

B = cellfun(@(i) A(i), indx, 'un', 0);

categories = ucategories;