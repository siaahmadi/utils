function L = dilate(logicalArray, by)
%L = dilate(logicalArray, by)
% functionally the same as running imdilate(logicalArray, strel('line', 2*by, 0)))
% but faster and without invoking the Image Processing toolbox

% by = by * 2 + ~mod(by,2); <-- wrong
by = by * 2 + 1;
if ~verLessThan('matlab', '8.5')
	toSmooth = double([false; logicalArray(:); false]);
	L = conv(toSmooth, ones(1,by),'same')' > 0 & by > 0;
else
    L = smooth([false; logicalArray(:); false], by)' * by > 0;
end
L = L(2:end-1);