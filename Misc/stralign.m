function s = stralign(str, extraPadding, alignment)

if nargin < 2
	extraPadding = 0;
end
if nargin < 3
	alignment = 'right';
end

if iscell(str)
	if ~all(cellfun(@ischar, str))
		error('Invalid input type.');
	end
	len = max(cellfun(@length, str(:))) + extraPadding;
	s = cellfun(@(x) auxFunc_align(x, alignment, len), str, 'UniformOutput', false);
elseif ~iscell(str) && ischar(str)
	s = auxFunc_align(str, alignment, length(str)+extraPadding);
	return;
else
	error('Invalid input type.');
end

function s = auxFunc_align(str, alignment, len)

switch alignment
	case 'right'
		s = sprintf(['%' num2str(len) 's'], str);
	case 'left'
		str = fliplr(str);
		s = sprintf(['%' num2str(len) 's'], str);
		s = fliplr(s);
	case 'center'
	otherwise
		error('Invalid alignment requested.');
end