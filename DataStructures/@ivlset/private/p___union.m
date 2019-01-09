function u = p___union(intervals)

list = convertToSortStruct(intervals);

% do sort intervals:
u = NaN(length(list), 2); % allocate memory for worst case
l_idx = 1;
u_idx = 1;
while (l_idx < length(list)) % not reached end
	lower = list(l_idx).value;
	next = list(l_idx).pointer;
	while (next < list(list(next).pointer).pointer)
		l_idx = list(next).pointer;
		next = list(l_idx).pointer;
	end
	upper = list(next).value;
	u(u_idx, :) = [lower, upper];
	u_idx = u_idx + 1;
	l_idx = next + 1; % will be an 'l' bound type
end

u = u(~isnan(u(:, 1)), :); % free unused portion of allocated memory

function intstr = convertToSortStruct(intervals)
nIntervals = size(intervals, 1);

intervalID = num2cell(repmat(1:nIntervals, 1, 2));
values = num2cell(intervals);
bound = num2cell([repmat('l', nIntervals, 1); repmat('u', nIntervals, 1)]);

intstr = repmat(struct('intervalID', [], 'value', [], 'bound', '', 'pointer', []), 2*nIntervals, 1);
% for i = 1:nIntervals
% 	intstr(i).intervalID = i;
% 	intstr(2*i).intervalID = i;
% 	
% 	intstr(i).value = intervals(i);
% 	
% 	intstr(i).bound = 'l';
% 	intstr(2*i).bound = 'u';
% end
[intstr.intervalID] = intervalID{:};
[intstr.value] = values{:};
[intstr.bound] = bound{:};
intstr = sortIntstr(intstr); % sets 'pointer' field

function s = sortIntstr(intstr)
values = cat(1, intstr.value);
[~, I] = sort(values);
s = intstr(I);
l = strcmp({s.bound}, 'l');
u = strcmp({s.bound}, 'u');

% set the pointers:
% l_inv = containers.Map(cat(1, s(l).intervalID), find(l)); %#ok<FNDSB>
% l_pointers_idx = arrayfun(@(i) l_inv(i), [s(u).intervalID]); % is this the same thing as l(I)?
l_pointers = num2cell(find(u));
[s(l).pointer] = l_pointers{:};

last_l = find(diff(l)<0);
u_pointers = zeros(size(l));
u_pointers(last_l) = last_l;
u_pointers = setzeros(u_pointers);
u_pointers = num2cell(u_pointers(u));
[s(u).pointer] = u_pointers{:};

function u_pointers = setzeros(u_pointers)
lastval = u_pointers(1);
for i = 2:length(u_pointers) % never is 1
	if u_pointers(i) == 0
		u_pointers(i) = lastval;
	else
		lastval = u_pointers(i);
	end
end