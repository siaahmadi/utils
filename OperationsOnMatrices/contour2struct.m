function st = contour2struct(contourMatrix)

[n, s, e] = validateCM(contourMatrix);

st = repmat(struct('value', NaN, 'boundary', [], 'level', NaN), n, 1);

peak = max(contourMatrix(1, s-1));

for i = 1:length(st)
	st(i).boundary = contourMatrix(:, s(i):e(i));
	st(i).value = contourMatrix(1, s(i)-1);
	st(i).level = st(i).value / peak;
end


function [numCont, s, e] = validateCM(contourMatrix)

if size(contourMatrix, 1) ~= 2
	error('');
end

if size(contourMatrix, 2) < 2
	error('');
end

n = 1;
w = iswholenum(contourMatrix(2, n));
numCont = 0;
while w && n < size(contourMatrix, 2)
	numCont = numCont + 1;
	w = iswholenum(contourMatrix(2, n));
	
	s(numCont) = n+1;
	
	n = n + contourMatrix(2, n)+1;
	e(numCont) = n - 1;
end

if ~w % contour number "numCont" not defined by a whole number
	error('');
end

function I = iswholenum(n)
I = mod(n, 1) == 0;