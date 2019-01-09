function N = next(array)

if nargout == 0
	N = first(array(2:end));
else % for chaining
	N = array(2:end);
end