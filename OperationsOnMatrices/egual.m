function I = egual(A, B, tolerance)
%I = EGUAL(A, B, tolerance)
%
% Assert whether two numbers are almost equal
%
% Useful when the numbers being compared are the results of certain
% calculations that may introduce some roundoff errors but are expected to
% be mathematically equal. This function will allow the tolerance of a user
% specified error (default |tolerance = eps|).

% Siavash Ahmadi
% 9/30/15

if nargin < 2
	error('Enter two numbers');
end
if ~exist('tolerance', 'var') || isempty(tolerance)
	tolerance = eps;
end

I = abs(A-B) < tolerance;