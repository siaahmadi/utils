% Returns a vector of length length(v1)+length(v2) with the elements
% interleaved (v11, v21, v12, v22,...).  If they are of unequal lengths,
% the interleaving will stop after one runs out of elements.  A warning
% will appear.  If only one vector is passed, v2 will be assumed to be a
% vector of zeros of the same length as v1.
% 
% function vec = interleave(v1,v2)

function vec = interleave(v1,v2)


if nargin == 1
    v2 = zeros(1,length(v1))
end

l1 = length(v1);
l2 = length(v2);
if l1 ~= l2
    warning('Vectors are of unequal length')
end

vec = zeros(1, l1+l2);

if l1<l2
    vec(1:2:(2*l1-1)) = v1;
    vec(2:2:2*l1) = v2(1:l1);
    vec((2*l1+1):(l1+l2)) = v2((l1+1:l2));
else
    vec(1:2:(2*l2-1)) = v1(1:l2);
    vec(2:2:2*l2) = v2;
    vec((2*l2+1):(l1+l2)) = v1((l2+1:l1));
end