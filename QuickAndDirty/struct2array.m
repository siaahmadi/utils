function a = struct2array(s, dim)
%STRUCT2ARRAY Convert structure with doubles to an array.

%   Author(s): R. Losada
%   Copyright 1988-2013 The MathWorks, Inc.

% Convert structure to cell
c = struct2cell(s);

if nargin<2
	dim = 2;
end
% Construct an array
a = cat(dim, c{:});