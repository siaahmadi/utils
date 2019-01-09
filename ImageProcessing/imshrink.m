function sh = imshrink(bw, h, w)

sh = zeros(size(bw));

rz = imresize(bw, [h, w]);

cntrRZ = [floor(size(rz, 1)/2)+1, floor(size(rz, 2)/2)+1];
cntrBW = [floor(size(bw, 1)/2)+1, floor(size(bw, 2)/2)+1];

if mod(h, 2) == 0 % even
	iX = cntrBW(1)-cntrRZ(1)+1:cntrBW(1)+cntrRZ(1)-2;
else
	iX = cntrBW(1)-cntrRZ(1)+1:cntrBW(1)+cntrRZ(1)-1;
end
if mod(w, 2) == 0 % even
	iY = cntrBW(2)-cntrRZ(2)+1:cntrBW(2)+cntrRZ(2)-2;
else
	iY = cntrBW(2)-cntrRZ(2)+1:cntrBW(2)+cntrRZ(2)-1;
end

sh(iX, iY) = rz;