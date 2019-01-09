function C = restr2cell(S, intervals)

if ~isvector(S)
	error('S must be a vector');
end

if ~iscell(S)
	error('S must be a cell array');
end

if any(cellfun(@(x) ~isvector(x), S))
	error('Entries of S must each be vectors');
end

C = cellfun(@(x) auxFunc_restrToEachIvl(x, intervals, 1+isvector(S)), S, 'UniformOutput', false);

if isrow(C)
	C = cat(2, C{:});
elseif iscolumn(C)
	C = cat(1, C{:});
end

function C = auxFunc_restrToEachIvl(x, i, dim)

if dim ~= 1 && dim ~= 2
	error('Only accepts dim == 1 OR dim == 2');
end

C = cellfun(@(i1, i2) restr(x, i1, i2), num2cell(i(1:end-1)), num2cell(i(2:end)), 'UniformOutput', false);

if dim == 1
	C = C(:);
elseif dim == 2
	C = C(:)';
end