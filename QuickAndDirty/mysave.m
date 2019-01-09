function mysave(varargin)

[ST, ~] = dbstack('-completenames');

if length(ST) == 1
	generatedBy = 'ROOT';
else
	ST(2) = rmfield(ST(2), 'name');
	generatedBy = ST(2);
end

varargin{end+1} = generatedBy;

save(varargin{:});