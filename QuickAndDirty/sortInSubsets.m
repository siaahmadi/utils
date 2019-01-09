function [med_slope_partition, I] = sortInSubsets(x, Partition)

[med_slope_partition, categories] = matrixpartition(x, Partition);
[med_slope_partition, I] = cellfun(@sort, med_slope_partition, 'un', 0);
I = cellfun(@(c, i) indexInSuperset(ismember(categorical(Partition), c), i), num2cell(categories), I, 'un', 0);

med_slope_partition = cat(1, med_slope_partition{:});
I = cat(1, I{:});
