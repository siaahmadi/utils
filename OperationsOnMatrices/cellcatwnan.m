function C = cellcatwnan(C)
%CELLCATWNAN Concatenate cell entries with a NaN separating them in the
%output
%
% Works only for column cell arrays and column arrays as entries

C = cellfun(@(c) [c; NaN], C, 'un', 0);
C = cat(1, C{:});
C(end) = []; % removes the extra NaN at the end