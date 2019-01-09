function s = ezstruct(varargin)
%EZSTRUCT Make the syntax of building a struct with many fields easier
%
% SYNTAX:
% s = EZSTRUCT({'fieldnames'}, {corresponding values})
%
% s = EZSTRUCT(['fieldnames'], [corresponding values])
% 
% See also: struct()

s = cell(nargin, 1);

if nargin == 2
	s = cell(numel(varargin{1})*2, 1);
	if iscell(varargin{1})
		s(1:2:end) = varargin{1};
	else
		s(1:2:end) = num2cell(varargin{1});
	end
	if iscell(varargin{2})
		s(2:2:end) = varargin{2};
	else
		s(2:2:end) = num2cell(varargin{2});
	end
else
	s(1:2:end) = varargin{1:floor(nargin/2)};
	s(2:2:end) = varargin{floor(nargin/2)+1:end};
end

s = struct(s{:});