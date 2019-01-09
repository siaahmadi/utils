function idx = ininterval(A, B, inclusive)

if ~exist('inclusive', 'var') || isempty(inclusive)
	inclusive = true;
end

idx = cell(size(diff(A)));

for i = 1:numel(idx)
	if inclusive
		idx{i} = B(A(i) <= B & B <= A(i+1));
	else
		idx{i} = B(A(i) < B & B < A(i+1));
	end
end
