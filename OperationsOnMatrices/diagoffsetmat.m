function o = diagoffsetmat(matSize)

o = zeros(matSize);
for i = 1:matSize
	o(:,i) = circshift((0:matSize-1)', i-1);
end
o = tril(o) + tril(o)'; % trace(o) == 0, so this works