classdef ivlset < handle
	properties (SetAccess=private,GetAccess=protected)
		Begin	= int32([]);
		End		= int32([]);
		
		U  % Contains the union of current intervals | used by collapse among others
		
		currIvlInd = 0;
		
		CollapseBuffer_Begin = int32([]);
		CollapseBuffer_End	 = int32([]);
		inCollapsedState = false;
	end
	methods
		function obj = ivlset(bdr, bdr2) % Constructor
			if nargin == 1
				if ~isnumeric(bdr) && ~isa(bdr, class(obj))
					error('IvlSet:Constructor:InvalidArgument:Type', 'Input must be a numeric array or a ''ivlset'' object');
				end
				if isnumeric(bdr)
					if any(isnan(bdr))
						error('IvlSet:Constructor:InvalidArgument:NaN', 'Input cannot contain any NaN entries.');
					end
					if isvector(bdr)
						if ~issorted(bdr)
							error('IvlSet:Constructor:InvalidArgument:NotSorted', 'A Vector input must be sorted');
						end
						InBegin = bdr(1:end-1);
						InEnd = bdr(2:end);
						
						obj.Begin = InBegin(:);
						obj.End = InEnd(:);
					elseif ismatrix(bdr)
						if size(bdr, 2) == 2 % vertical matrix
							bdr = bdr'; % so that we can conveniently use the MATLAB idiom 1:2:end to take the first COLUMN of original bdr
							if ~all(bdr(1, :) <= bdr(2, :))
								error('IvlSet:Constructor:InvalidArgument:NotSorted', 'All second column values must be larger than their first column counterparts');
							end
							InBegin = bdr(1:2:end); % take the first column of original/user input bdr
							InEnd = bdr(2:2:end);  % take the second column of original/user input bdr

							[obj.Begin, I] = sort(InBegin(:));
							obj.End = InEnd(I);
							obj.End = obj.End(:);
						elseif size(bdr, 1) == 2 % horizontal matrix
							if ~all(bdr(1, :) <= bdr(2, :))
								error('IvlSet:Constructor:InvalidArgument:NotSorted', 'All second row values must be larger than their first row counterparts');
							end
							InBegin = bdr(1:2:end); % take the first row
							InEnd = bdr(2:2:end);  % take the second row

							obj.Begin = InBegin(:);
							obj.End = InEnd(:);
						elseif isempty(bdr)
							obj.Begin = [];
							obj.End = [];
						else % ill-sized matrix
							error('IvlSet:Constructor:InvalidArgument:Size', 'For a numeric non-vector matrix, the argument must be either 2xM or Mx2');
						end
					end
				else % isa ivlset
					obj.Begin = bdr.toIvl('begin');
					obj.End = bdr.toIvl('end');
				end
			elseif nargin == 2
				if numel(bdr) ~= numel(bdr2)
					error('IvlSet:Constructor:InvalidArgument:IncompatibleSize', 'bdr and bdr2 must have the same number of elements');
				end
				if ~isnumeric(bdr) && ~isa(bdr, class(obj)) % type check
					error('IvlSet:Constructor:InvalidArgument:Type', 'Input arguments must both be numeric arrays or a ''ivlset'' objects');
				end
				if (isnumeric(bdr) && ~isnumeric(bdr)) || (isa(bdr, class(obj)) && ~isa(bdr2, class(obj))) % type compatibility
					error('IvlSet:Constructor:InvalidArgument:IncompatibleType', 'bdr and bdr2 must have the same type--either both numeric or both ivlset');
				end
				
				if isnumeric(bdr) % both numeric
					if any(isnan(bdr)) || any(isnan(bdr2))
						error('IvlSet:Constructor:InvalidArgument:NaN', 'Input cannot contain any NaN entries.');
					end
					if ~all(bdr <= bdr2)
						error('IvlSet:Constructor:InvalidArgument:NotSorted', 'All bdr2 values must be larger than their bdr counterparts');
					end
					obj.Begin = bdr(:);
					obj.End = bdr2(:);
				else % both ivlset
					temp = bdr + bdr2;
					obj.Begin = temp.toIvl('begin');
					obj.End = temp.toIvl('end');
				end
			end
			
			obj.U = p___union(obj.toIvl);
		end
		
		function disp(obj)
			if numel(obj) > 1
				arrayfun(@disp, obj);
				return;
			end
			
			[m, i_min] = min(obj.End-obj.Begin);
			[M, i_max] = max(obj.End-obj.Begin);
			
			fprintf('\n\t%d intervals.\n', numel(obj.Begin));
			if numel(obj.Begin) > 0
				fprintf([...
				'\tStart:          %#7.2f\n', ...
				'\tEnd:            %#7.2f\n', ...
				'\tCoverage:       %#7.2f\n', ...
				'\tSmallest:       %#7.2f  [%g, %g]\n', ...
				'\tLargest:        %#7.2f  [%g, %g]\n', ...
				'\tAverage Length: %#7.2f', ...
				'\n'], ...
				min(obj.Begin), ...
				max(obj.End), ...
				max(obj.End)-min(obj.Begin), ...
				m, obj.Begin(i_min), obj.End(i_min), ...
				M, obj.Begin(i_max), obj.End(i_max), ...
				mean(obj.End-obj.Begin));
			end
		end
		
		function I = isempty(obj)
			I = arrayfun(@(obj) isempty(obj.Begin), obj);
		end
		
		function ivl = getNext(obj)
			obj.currIvlInd = obj.currIvlInd + 1;
			ivl = obj.getInterval(obj.currInd());
			if obj.currInd() == length(obj.Begin)
				display('Reached end. Rewinding...');
				obj.currIvlInd = 0;
			end
		end
		
		function N = currInd(obj)
			N = obj.currIvlInd;
		end
		
		function reset(obj)
			obj.currIvlInd = 0;
		end
		
		function N = length(obj)
			N = length(obj.Begin);
		end
		
		function d = duration(obj)
			obj.collapse('|');
			
			d = sum(diff(obj.toIvl(), [], 2));
			
			obj.uncollapse();
		end
		
		ivl = getInterval(obj, N, N2)							% Return indexed intervals as an ivlset object
		ivl = toSeq(obj, Uniform, beginOrEnd, memoryUsageLimit)	% main retrieval function: returns a sequence of values in the interval
		[ivl, ivl2] = toIvl(obj, Uniform, beginOrEnd)			% main retrieval function: returns the delimters of the interval
		idx = index(obj, numericArray, idxType)
		
		[idx, varargout] = restrict(obj, sorted, values, varargin)
		[idx, varargout] = restrict_approx(obj, values, varargin)
		obj = collapse(obj, operator)
		obj = uncollapse(obj)
		I = iscollapsed(obj)
		obj = sort(obj, byBeginOrEnd)
		obj = merge(obj, varargin)
		obj = drop(obj, operator, value)
		
		visualize(obj, axs, labels)
		
		%% Set Operators:
		function newObj = plus(obj, obj2) % Union of obj and obj2; if isa(obj2, 'numeric'), move interval to right
			if isnumeric(obj2)
				Ivls = obj.toIvl();
				Ivls(isnan(Ivls(:, 1)), :) = [];
				Ivls = Ivls + obj2;
				
				newObj = ivlset(Ivls);
				return
			end
			Ivls = obj.toIvl();
			Ivls(isnan(Ivls(:, 1)), :) = [];
			Ivls2 = obj2.toIvl();
			Ivls2(isnan(Ivls2(:, 1)), :) = [];
			
			% Make-shift for now, until later improved for efficiency:
			Ivls = union(Ivls, Ivls2, 'rows', 'stable'); % should use the MERGE step of MergeSort for efficiency
			
			newObj = ivlset(Ivls);
		end
		
		function newObj = minus(obj, obj2) % setdiff(obj, obj2); if isa(obj2, 'numeric'), move interval to left
			error('There''s a TODO');
			% TODO setdiff(obj, obj2)
		end
		
		function newObj = mtimes(obj, obj2) % intersect(obj, obj2)
			error('There''s a TODO');
			% TODO intersect(obj, obj2)
			myIvls = obj.toIvl();
			testIvls = obj2.toIvl();
		end
		function [newObj, ivl_iscontained] = mpower(obj, obj2)
			%MPOWER Proper superset of obj2 intervals found in obj
			%   Use this operator to choose obj intervals that contain
			%   obj2 intervals.
			%
			% newObj = MPOWER(obj, obj2)
			% obj2 can be numeric
			myIvls = obj.collapse('|').toIvl();  % no overlapping intervals
			if isa(obj2, 'ivlset')
				ivltest = obj2.collapse('|').toIvl();% no overlapping intervals
			elseif isnumeric(obj2)
				if isvector(obj2)
					ivltest = [obj2(:), obj2(:)];
				else
					error('if numeric, obj2 must be a vector.');
				end
			else
				error('second operand of unhandled type.');
			end
			
			% Since there are no overlapping intervals, sorting the
			% intervals by their left-end will result in right-ends being
			% sorted too. Furthermore, for each right-end |r|, |r| always
			% lies to the left of all left-ends greater than |r|.
			[~, I] = sort(myIvls(:, 1));
			myIvls = myIvls(I, :);
			[~, I] = sort(ivltest(:, 1));
			ivltest = ivltest(I, :);
			
			containsL = arrayfun(@(lEnd) find(myIvls(:, 1) <= lEnd, 1, 'last'), ivltest(:, 1), 'un', 0);
			containsR = arrayfun(@(rEnd) find(myIvls(:, 2) >= rEnd, 1, 'first'), ivltest(:, 2), 'un', 0);
			valid = ~cellfun(@isempty, containsL) & ~cellfun(@isempty, containsR) & cellfun(@isequal, containsL, containsR);
			newObj = ivlset(myIvls(unique(cell2mat(containsL(valid)), 'stable'), :));
			
			obj.uncollapse();
			ivl_iscontained = valid;
		end
		
		function newObj = power(obj, obj2)
			%POWER Returns set of all obj intervals each of which is a proper subset some obj2 interval
			%  Use this operator when you want to choose obj intervals
			%  that happened during obj2.
			%
			% newObj = POWER(obj, obj2)
			%
			% The return value is the union of the intervals extracted from
			% obj (i.e. returned intervals will not overlap).
			
			myIvls = obj.collapse('|').toIvl();  % no overlapping intervals
			if isa(obj2, 'ivlset')
				ivltest = obj2.collapse('|').toIvl();% no overlapping intervals
			else
				error('second operand must be an ivlset type.');
			end
			
			% Since there are no overlapping intervals, sorting the
			% intervals by their left-end will result in right-ends being
			% sorted too. Furthermore, for each right-end |r|, |r| always
			% lies to the left of all left-ends greater than |r|.
			[~, I] = sort(myIvls(:, 1));
			myIvls = myIvls(I, :);
			[~, I] = sort(ivltest(:, 1));
			ivltest = ivltest(I, :);
			
			firstIntervalContained = arrayfun(@(lEnd) find(myIvls(:, 1) >= lEnd, 1, 'first'), ivltest(:, 1), 'un', 0);
			lastIntervalContained = arrayfun(@(rEnd) find(myIvls(:, 2) <= rEnd, 1, 'last'), ivltest(:, 2), 'un', 0);
% 			valid = ~cellfun(@isempty, firstIntervalContained) & ~cellfun(@isempty, lastIntervalContained) & cellfun(@isequal, firstIntervalContained, lastIntervalContained);
			valid = ~cellfun(@isempty, firstIntervalContained) & ~cellfun(@isempty, lastIntervalContained);
			containedIvls = cellfun(@(i,j) myIvls(i:j, :), firstIntervalContained(valid), lastIntervalContained(valid), 'un', 0);
			newObj = ivlset(cat(1, containedIvls{:}));
			
			obj.uncollapse();
		end
		
		%% Interval Operators:
		function newObj = and(obj, obj2)
			newObj = p___logical('&', obj, obj2);
		end
		
		function newObj = or(obj, obj2)
			newObj = p___logical('|', obj, obj2);
		end
		
		function newObj = xor(obj, obj2)
			newObj = p___logical('^', obj, obj2);
		end
		
		function newObj = not(obj)
			newObj = p___logical('~', obj);
		end
		
		function newObj = mldivide(obj, obj2) % This is different from |obj - obj2| in that it operates on the intervals as sets, not sets of intervals as objects
			newObj = obj & ~obj2;
		end
		
		function I = lt(obj, obj2) % obj entirely lies within obj2
			I = p___logical('<', obj, obj2);
		end
		
		function I = le(obj, obj2) % first interval of obj starts before first interval of obj2, and ends after its start
			I = p___logical('<=', obj, obj2);
		end
		
		function I = gt(obj, obj2) % obj encompasses the entirety of obj2
			I = p___logical('>', obj, obj2);
		end
		
		function I = ge(obj, obj2) % first interval of obj starts before end of first interval of obj2, and ends after its end
			I = p___logical('>=', obj, obj2);
		end
		
		function I = ne(obj, obj2) % disjoint intervals
			I = p___logical('<>', obj, obj2);
		end
		
		function I = eq(obj, obj2) % same intervals
			I = p___logical('==', obj, obj2);
		end
		
		%% Access operators:
% 		subsref(obj, objORnum)
% 		subsasgn(obj, objORnum)
% 		subsindex(obj, objORnum)
	end
end