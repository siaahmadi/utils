function m = interactivemode(mode)
h = cell(5, 1);

h{1} = zoom;
h{2} = pan;
h{3} = rotate3d;
h{4} = datacursormode(gcf);
h{5} = brush;
if nargin ==0
	if all(cellfun(@(x) strcmpi(x.Enable, 'off'), h))
		m = false;
	else
		m = true;
	end
	if nargout==0
		if m
			display('Interactive mode on')
		else
			display('Interactive mode off')
		end
	end
else
	if ~strcmpi(mode, 'on') && ~strcmpi(mode, 'off')
		error('input must be eitner ''on'' or ''off''');
	end
	
	if strcmpi(mode, 'off')
		cellfun(@(x) auxFunc(x, 'off'), h);
	else
		pan on
	end
end

function auxFunc(a,b)
a.Enable = b;