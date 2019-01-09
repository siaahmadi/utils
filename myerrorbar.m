function h = myerrorbar(Y, E, varargin)

if nargin > 2
	if isnumeric(varargin{1}) && isequal(size(varargin{1}), size(Y))
		X = Y;
		Y = E;
		E = varargin{1};
		varargin(1) = [];
	else
		X = 1:length(Y);
	end
end

endpoints = NaN(3, length(Y));
endpoints(1, :) = Y+E;
endpoints(2, :) = Y-E;

h = plot(repmat(X, 3, 1), endpoints, varargin{:});