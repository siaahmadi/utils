function obj = collapse(obj, operator)
%obj = collapse(obj, operator) Apply |operator| to overlapping intervals
%
% operator = {'&', '|'}

% Siavash Ahmadi
% 11/3/2015

if obj.isempty()
	warning('IvlSet:EmptySetCollapsed', '%s\n', 'Object is an empty ivlset. Skipping.');
	return;
elseif numel(obj) > 1
	obj = collapse(merge(obj), operator);
	return;
end

obj.CollapseBuffer_Begin = obj.Begin;
obj.CollapseBuffer_End = obj.End;

Ivls = obj.toIvl();

overlaps = p___findOverlaps(Ivls);
overlaps = cat(2, overlaps{:});

Begins = [];
Ends = [];

for currIvl = 1:size(overlaps, 2)
	switch operator
		case '&'
			candidateB = max(Ivls(overlaps(:, currIvl), 1));
			candidateE = min(Ivls(overlaps(:, currIvl), 2));
			
			if isempty(candidateB) && isempty(candidateE) % ivl not overlapping with anyone
				Begins = [Begins; Ivls(currIvl, 1)]; %#ok<*AGROW>
				Ends = [Ends; Ivls(currIvl, 2)];
				continue;
			elseif xor(isempty(candidateB), isempty(candidateE)) % bizzarre problem if only one is empty--can't foretell why right now
				error('Unknown problem');
			end
			
			if candidateE >= candidateB && ~(ismember(candidateB, Begins) & ismember(candidateE, Ends)) %#ok<AND2> % if valid interval and not already in stack
				Begins = [Begins; candidateB];
				Ends = [Ends; candidateE];
			end
		case '|'
			u = obj.U;
			
			Begins = u(:, 1);
			Ends = u(:, 2);
			
			% Old (wrong) way:
% 			candidateB = min(Ivls(overlaps(:, currIvl), 1)); % candidateB will be empty if |overlaps| contains all 0's in column |currIvl|
% 			candidateE = max(Ivls(overlaps(:, currIvl), 2)); % candidateE will be empty if |overlaps| contains all 0's in column |currIvl|
% 			
% 			if isempty(candidateB) && isempty(candidateE) % ivl not overlapping with anyone
% 				Begins = [Begins; Ivls(currIvl, 1)]; %#ok<*AGROW>
% 				Ends = [Ends; Ivls(currIvl, 2)];
% 				continue;
% 			elseif xor(isempty(candidateB), isempty(candidateE)) % bizzarre problem if only one is empty--can't foretell why right now
% 				error('Unknown problem');
% 			end
% 			
% 			if candidateE >= candidateB && ~(ismember(candidateB, Begins) & ismember(candidateE, Ends)) %#ok<AND2> % if valid interval and not already in stack
% 				Begins = [Begins; candidateB];
% 				Ends = [Ends; candidateE];
% 			end
		otherwise
			error('IvlSet:Collapse:InvalidOperator', 'The collapse method is only defined for the & and | operators.');
	end
end

obj.Begin = Begins;
obj.End = Ends;

obj.inCollapsedState = true;