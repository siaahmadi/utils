function varargout = structnfun(func_handle, varargin)
%STRUCTNFUN Map-reduce routine handling more than 1 struct (unlike
%MATLAB's own @structfun)

% Siavash Ahmadi
% 12/27/2015 7:44 PM


structs = cellfun(@isstruct, varargin);
fnon = find(~structs, 1);
if isempty(fnon)
	fnon = length(structs) + 1;
end
structs(fnon:end) = false;

fn = cellfun(@fieldnames, varargin(structs), 'un', 0);
fnsame = cellfun(@(fn1,fn2) all(strcmp(fn1, fn2)), fn(1:end-1), fn(2:end));

if ~all(fnsame)
	error('All structs must have the exact same fields.');
end

instructs = cellfun(@struct2cell, varargin(structs), 'un', 0);

results = cell(1, nargout);
str = 'results{1}';
for i = 2:nargout
	s = [', results{' int2str(i) '}'];
	str = strcat(str,s);    
end
str = strcat('[', str, ']');

Terminal_Output = evalc([str, ' = cellfun(func_handle, instructs{:}, varargin{~structs});']);

varargout = cellfun(@(results) num2cell(cell2struct(results, fieldnames(varargin{structs(1)}))), results, 'un', 0);
varargout = cat(2, varargout{:});