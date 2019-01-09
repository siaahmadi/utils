function CT = celltranspose(C)

CT = cellfun(@(c) c', C, 'un', 0);