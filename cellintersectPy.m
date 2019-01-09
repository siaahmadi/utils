function result = cellintersectPy(a, b, n)
%RESULT = CELLINTERSECTPY(A, B, N) Find the intersection of two cell arrays
%
% First, tuples of length |n| from cell arrays |a| and |b| are grouped
% together. The tuples such grouped are treated as independent items. This
% allows the user to compute the intersection of two sets of sets. For
% example if the user desires to treat the rows of the cell arrays as a
% single element of the set.
%
% Next, the items are passed to Python to make a list of zipped items and
% the intersection of the sets is computed by taking advantage of Python's
% core functionality.
%
% Last, the results are returned.
%
% Similar to MATLAB's builtin @intersect, but allows grouping of cell array
% elements. MATLAB's @intersect's behavior would be achieved by setting
% N = 1, though this function is more robust in accepting cell arrays that
% contain heterogenous data types.
%
% Utilizes Python at its core.
%
%
% INPUT:
% 
% A
%	Cell array of items
% 
% B
%	Cell array of items
%
% N
%	Length of tuples of items taken from cell arrays A, and B
%	(default n = 2)
%
%
% OUTPUT:
%
% results
%	The intersection of the sets.

% Python Code:
% def cellintersect(a, b, n=2):
% 	from itertools import izip, chain
% 	def chunkwise(t, n):
% 		return [i for i in izip(*[iter(t)]*n)]
% 	
% 	a_pairs = chunkwise(a, n);
% 	b_pairs = chunkwise(b, n);
% 	l = list(set(a_pairs) & set(b_pairs))
% 	
% 	return list(chain.from_iterable(l));


% Siavash Ahmadi
% April 27, 2015
%
% Modified slightly + added documentation @date 9/24/2015 6:10 PM by
% @author: Sia

a = a(:)';
b = b(:)';
if ~exist('n', 'var') || isempty(n)
	n = int32(2);
end
if numel(n) ~= 1 || mod(n,1) ~= 0
	error('|n| must be a single integer value');
end
% [~, ~, ~] = pyversion; % force load Python
% sys = py.importlib.import_module('sys');
% sys.path.append('Y:\Sia\scripts\py');
% py.importlib.import_module('myutils');

initPythonEngine(); % if this doesn't work, uncomment the above lines @date 9/24/15

pyIN_a = cellfun(@int32,num2cell(a),'uniformOutput', false);
pyIN_b = cellfun(@int32,num2cell(b),'uniformOutput', false);
pyOUT = py.myutils.cellintersect(pyIN_a, pyIN_b, int32(n));

result = cell2mat(cell(pyOUT));