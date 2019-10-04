function ri = revidx(primary_selection, secondary_selection)
%REVIDX Reverse indexing
%
% ri = REVIDX(primary_selection, secondary_selection)
%
% Map indices of a secondary selection to a primary selection.
%
% Example:
% primary_selection = A>0;
% secondary_selection = primary_selection < 5;
% ri = revidx(primary_selection, secondary_selection);
% ri_equivalent = 0<A & A<5;
% all(ri == ri_equivalent)
%  --> true

I = find(primary_selection);
I2 = I(secondary_selection);
ri = false(size(primary_selection));
ri(I2) = true;