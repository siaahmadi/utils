function overlaps = p___findOverlaps(Ivls)

[b, I_b] = sort(Ivls(:, 1)); % sort by 'begin' without altering the original object
[e, I_e] = sort(Ivls(:, 2)); % sort by 'end'   without altering the original object
[~, I_b_inv] = sort(I_b); % b(I_b_inv) == original Begins
[~, I_e_inv] = sort(I_e); % e(I_e_inv) == original Ends

overlaps = arrayfun(@(x) auxFunc_findOverlap(b, e, I_b, I_e, I_b_inv, I_e_inv, x), 1:size(Ivls, 1), 'UniformOutput', false);

function qIvl_overlaps_with = auxFunc_findOverlap(b, e, I_b, I_e, I_b_inv, I_e_inv, whichInterval)

qIvl_b = b(I_b_inv(whichInterval));
qIvl_e = e(I_e_inv(whichInterval));

[bb, ee] = auxFunc_getBandE(b, e, qIvl_b, qIvl_e);

% initialize idx_b and idx_e
qIvl_b_leq = false(size(b));
qIvl_e_geq = false(size(e));

% convert subscript indices to logical
qIvl_b_leq(bb:end) = true; % Query interval's begin is less than or equal to these intervals ends
qIvl_e_geq(1:ee) = true; % Query interval's end is greater than or equal to these intervals begins

beginsBeforeEndOfThese = full(sparse(I_e(qIvl_b_leq), ones(1, sum(qIvl_b_leq)), true, length(I_e), 1)); % if an error arises, check if I_e should be I_e_inv
endsAfterBeginOfThese = full(sparse(I_b(qIvl_e_geq), ones(1, sum(qIvl_e_geq)), true, length(I_b), 1));  % if an error arises, check if I_b should be I_b_inv

qIvl_overlaps_with = beginsBeforeEndOfThese & endsAfterBeginOfThese;


function [bb, ee] = auxFunc_getBandE(b, e, qIvl_b, qIvl_e)
%[bb, ee] = auxFunc_getBandE(b, e, qIvl_b, qIvl_e)
%
% bb is the first index for which e(bb) >= qIvl_b
% ee is the last index for which b(ee) <= qIvl_e
%
% b and e are sorted
% qIvl_b and qIvl_e are single query values

[~, idx_b_itp, idx_b_pseu] = bfind(qIvl_b, e);
[~, idx_e_itp, idx_e_pseu] = bfind(qIvl_e, b);

bb = ceil(idx_b_pseu);
ee = floor(idx_e_pseu);