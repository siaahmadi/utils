function fo = firstone(inArray, dim)

if nargin == 1
	dim = 2;
end
inArray = inArray ~= 0;

if dim == 1
	inArray = inArray';
	fo = zeros(1, size(inArray, 2));
else
	fo = zeros(size(inArray, 1), 1);
end

if size(inArray, 2) == 1
	fo(:) = inArray(:)~=0;
	return
end

for i = 1:length(fo)
	if inArray(i, 1) == 1
		fo(i) = 1;
		continue;
	end
	thisRow = inArray(i, :);
	
	if sum(thisRow) == 0, fo(i) = 0; continue; end;
	
	fo(i) = find(thisRow, 1, 'first');
end