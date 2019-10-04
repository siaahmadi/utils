function out = uniform(inarray, default)
%out = uniform(inarray, default) Insert a default scalar value into empty
%entries
%
% If |inarray| is an empty array, |default| will be returned.
%
% If |inarray| is a cell array, its entries must be either empty or scalar.
% In this case only the empty entries will be replaced by |default|.
%
% The output is always a double.

if ~isscalar(default) && numel(default) ~= 1
	warning('The default value should be a scalar');
end

if iscell(inarray)
	out = cellfun(@(in,def) uniform(in,def), inarray);
	return;
elseif numel(inarray) <= 1
	if isempty(inarray)
		inarray = default;
	end
else
	error('Accepts only scalar or empty arrays');
end

if iscell(inarray)
	out = cell2mat(inarray);
else
	out = inarray;
end