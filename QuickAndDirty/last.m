function L = last(array)

L = [];

if numel(array) > 0
	L = array(end);
end