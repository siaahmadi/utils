function [Lia, Locb] = cellmember(A, B)
%CELLMEMBER Assess membership in generic cell arrays
%
% See Also: ismember

Lia = false(size(A));
ii = 0;
for ia = 1:numel(A)
	for ib = 1:numel(B)
		Lia(ia) = isequal(size(A{ia}), size(B{ib})) && isequal(A{ia}, B{ib});
		if Lia(ia) % found
			ii = ii + 1;
			Locb(ii) = ib; %#ok<AGROW>
			break;
		end
	end
end
Locb = Locb(:);