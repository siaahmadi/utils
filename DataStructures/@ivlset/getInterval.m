function ivl = getInterval(obj, N, N2)

if nargin == 3 % both N and N2 provided
	if ~(isnumeric(N) && isvector(N)) || ~(isnumeric(N2) && isvector(N2))
		if numel(N) ~= numel(N2)
			error('IvlSet:GetInterval:InvalidArgument:IncompatibleSize', 'N and N2 must have the same number of elements.');
		end
		ivl = ivlset(obj.Begin(N(:)), obj.End(N2(:)));
	else
		error('IvlSet:GetInterval:InvalidArgument:IncompatibleType', 'N and N2 must both be numeric vectors');
	end
elseif nargin == 2 % only N provided
	if isnumeric(N)
		ivl = ivlset(obj.Begin(N(:)), obj.End(N(:)));
	else
		error('IvlSet:GetInterval:InvalidArgument:Type', 'N must be a numeric array');
	end
elseif nargin == 1
	ivl = ivlset(obj.Begin(:), obj.End(:)); % return everything
else
	error('');
end