function overlap = pfoverlap(pfmap1, pfmap2)
% modified Jaccard metric for place maps

error('pfoverlap hasn''t been correctly implemented yet!!')
meanfr1 = mean(pfmap1); % these measures are temporary and totally incorrect!
meanfr2 = mean(pfmap2);
pfintersect = intersect(pfmap1, pfmap2);
pfunion = union(pfmap1, pfmap2);

overlap = sqrt(pfintersect/pfunion * min(meanfr1, meanfr2)/max(meanfr1,meanfr2));