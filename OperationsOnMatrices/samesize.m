function [l, why] = samesize(array1, array2)

size1 = size(array1);
size2 = size(array2);

if numel(size1) ~= numel(size2)
	why = 'inconsistent dimensions';
	l = false;
	return;
end

if any(size1-size2)
	why = 'inconsistent lengths';
	l = false;
	return;
end

why = '';
l = true;