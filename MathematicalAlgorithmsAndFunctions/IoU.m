function [iou, N_i, N_u] = IoU(set1, set2)
%IOU Intersection over Union of two sets of numbers
%
% [iou, N_i, N_u] = IoU(set1, set2)
% 
% iou: a fraction, division of the size of the intersection of the two sets
%      by the size of the union of the them
%
% N_i: size of the intersection of the two sets
%
% N_u: size of the union of the two sets

in = intersect(set1, set2);
un = unique([set1(:); set2(:)]);
N_i = length(in);
N_u = length(un);
iou = N_i / N_u;