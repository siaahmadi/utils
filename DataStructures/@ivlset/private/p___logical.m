function newObj = p___logical(operator, obj1, obj2)

if ~isa(obj1, 'ivlset') || (exist('obj2', 'var') && ~isa(obj2, 'ivlset'))
	error('IvlSet:LogicalOperation:InvalidArgument:Type', 'Operand(s) must be ivlset objects');
end

Begin1	= obj1.toIvl('begin');
End1	= obj1.toIvl('end');
if exist('obj2', 'var')
	Begin2	= obj2.toIvl('begin');
	End2	= obj2.toIvl('end');
elseif ~strcmp(operator, '~') % operator not unary, but only one input provided
	error('IvlSet:LogicalOperation:InvalidArgument:MoreArgsNeeded', 'For a binary operator both operands are mandatory');
end

switch operator
	case '&' % AND
		% Description of function:
		% For some interval i in obj1 and j in obj2:
		% X in newObj <==> X in i AND X in j
		%
		% Observation: newObj can at most have min(length(obj1), length(obj2)).
		%
		% Algorithm: iterate over the intervals of the obj with fewer
		% intervals (for simplicity assume =obj1). For each i in obj1 see
		% if there is some interval j in obj2 for which intersect(i, j) is
		% non-empty. If so, add intersct(i, j) to newObj.
		
		[l, I] = min([length(obj1), length(obj2)]);
		if I == 2 % swap
			p___swap(obj1, obj2);
		end
		
		Begin = NaN(l, 1);	% at most |l| intervals
		End = NaN(l, 1);	% at most |l| intervals
		
		[obj2Begin, obj2End] = obj2.toIvl();
		indMatchIvls = 0;
		for i = 1:length(obj1)
			currIvl = obj1.getInterval(i).toIvl();
			
			intersectingInterval = find(obj2End >= currIvl(1) & obj2Begin <= currIvl(2)); % Here the & operation can be made maximal or minimal (default: maximal)
			
			if ~isempty(intersectingInterval)
				indMatchIvls = indMatchIvls + 1;
				Begin(indMatchIvls) = max([currIvl(1); min(obj2Begin(intersectingInterval))]);
				End(indMatchIvls) = min([currIvl(2); max(obj2End(intersectingInterval))]);
			end
		end
		
		Begin = Begin(isfinite(Begin));
		End = End(isfinite(End));
	case '|' % OR
		% Description of function:
		% For some i in obj1 or some j in obj2
		% X in newObj <==>  X in i OR X in j
		%
		% Algorithm:
		% Apply the bracket matching algorithm. Call Begin boundaries open
		% brackets (ID-ed +1) and End boundaries closed brackets (ID-ed -1)
		% and find indices at which the cumulative sum amounts to 0. First
		% and last indices are always +1 and -1, respectively. By ivlset
		% definition, brackets are guaranteed to be balanced.
		
		Begins = sort([Begin1(:); Begin2(:)]);
		Ends = sort([End1(:); End2(:)]);
		
		[s, I] = sort([Begins; Ends]);
		IDs = 2*(double(I <= length(I) / 2) - .5); % this works because of last line and that length(Begins) == length(Ends)
		% IDs == 1 are Begins and IDs == -1 are Ends
		ivlEnds = cumsum(IDs) == 0;
		ivlBgns = [1; find(ivlEnds(1:end-1))+1];
		
		Begin = s(ivlBgns);
		End = s(ivlEnds);
	case '^' % XOR
		% Description of function:
		%
		%
		% Algorithm:
		error('Todo');
	case '~' % NOT
		% Description of function:
		% newObj = Z \ obj1;
		%
		% Algorithm:
% 		error('Carefully analyze this code. It is dealing with Inf. Also, make sure @toSeq handles input well when Inf is involved.');
		[b, e] = obj1.collapse('|').toIvl;
		if isnan(b)
			b = -Inf;
			e = Inf;
		elseif ~isfinite(b(1)) && ~isfinite(e(end)) % extends to infinity on both sides
			if length(b) == 1 % interval is (-infinity, +infinity)
				b = [];
				e = [];
			else % some finite number is a bound to an interval
				sIdx = find(e(1) >= b, 1, 'last'); % this will always be == 1, because ivlset is collapsed with '|'
				eIdx = sum(b(end) <= e); % this will always be == l, because ivlset is collapsed with '|'
				intmIvl = ivlset(b(sIdx+1:end-eIdx), e(sIdx+1:end-eIdx)); % sIdx, eIdx > 0
				intmIvl.collapse('|');
				[B_intm, E_intm] = intmIvl.toIvl;
				if isnan(B_intm(1)) || e(1) < B_intm(1)
					B_new = e(1);
					E_new = finite(B_intm(1));
				else
					B_new = [];
					E_new = [];
				end
				B_new = [B_new; finite(E_intm(1:end-1))];
				E_new = [E_new; finite(B_intm(2:end))];
				if isnan(E_intm(end)) || b(end) > E_intm(end)
					B_new = [B_new; finite(E_intm(end))];
					E_new = [E_new; b(end)];
				end
				
				b = B_new;
				e = E_new;
			end
		elseif ~isfinite(b(1)) % (-infinity, [FINITE]] is an interval
			E = max(e);
			intmIvl = ~ivlset([b; E+1], [e; Inf]);
			[B_new, E_new] = intmIvl.toIvl();
			% replace [E, E+1] with [E, Inf]:
			b = [B_new(1:end-1); E];
			e = [E_new(1:end-1); Inf];
		elseif ~isfinite(e(end)) % ([FINITE], +inifinity) is an interval
			intmIvl = ~ivlset([-Inf; b], [b(1)-1; e]);
			[B_new, E_new] = intmIvl.toIvl();
			% replace [b(1)-1, b(1)] with [-Inf, b(1)]:
			e = [b(1); E_new(2:end)];
			b = [-Inf; B_new(2:end)];
		else % doesn't extent to infinity on either side
			E = max(e);
			B = b(1)-1;
			intmIvl = ~ivlset([-Inf; b; E+1], [B; e; Inf]);
			[B_new, E_new] = intmIvl.toIvl();
			% replace intervals:
			e = [b(1); E_new(2:end-1); Inf];
			b = [-Inf; B_new(2:end-1); E];
		end
		newObj = ivlset(b, e);
		obj1.uncollapse();
		return
	case '<' % obj1 PROPER SUBSET OF obj2
		newObj = obj1 & obj2 == obj1;
		return
	case '<='
		error('Todo');
	case '>' % obj1 PROPER SUPERSET OF obj2
		newObj = obj2 < obj1;
		return
	case '>='
		error('Todo');
	case '<>' % disjoint
		newObj = isempty(obj1 & obj2);
		return
	case '==' % obj1 and obj2 contain exact same intervals
		obj1All = obj1.toIvl();
		obj2All = obj2.toIvl();
		
		newObj = (length(obj1) == length(obj2)) & all(obj1All(:) == obj2All(:));
		return
	otherwise
		error('Undefined')
end

try
	newObj = ivlset(Begin, End);
catch
	error('Not Implemented Yet');
end