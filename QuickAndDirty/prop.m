function p = prop(x, method)
%PROP proportion in N x 2 matrix x
%
% method can be
%       'total'   first column divided by second (default)
%       'sum'     first column divided by sum of rows
%
% See Also: diff()

if ~exist('method', 'var')
	method = 'total';
end
if strcmpi(method, 'total')
	p = x(:, 1) ./ x(:, 2);
elseif strcmpi(method, 'sum')
	p = x(:, 1) ./ sum(x, 2);
end