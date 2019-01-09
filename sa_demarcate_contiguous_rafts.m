function indArray = sa_demarcate_contiguous_rafts(raftArray)

if numel(raftArray) == 1
	if raftArray == 1
		indArray = [1 1];
	else
		indArray = [];
	end
elseif (numel(raftArray)) == 2
	if sum(raftArray) == 2 % raftArray is [1 1]
		indArray = [1 2];
	elseif sum(raftArray) == 0 % raftArray is [0 0]
		indArray = [];
	elseif raftArray(1) == 1
		indArray = [1 1];
	else
		indArray = [2 2];
	end
else
	raft_left = sa_demarcate_contiguous_rafts(raftArray(1:round(numel(raftArray)/2)));
	raft_right = sa_demarcate_contiguous_rafts(raftArray(1+round(numel(raftArray)/2):end)) + round(numel(raftArray)/2);

	if isempty(raft_right)
		indArray = raft_left;
		indArray = reshape(indArray, 2, numel(indArray)/2);
		return
	elseif isempty(raft_left)
		indArray = raft_right;
		indArray = reshape(indArray, 2, numel(indArray)/2);
		return
	end

	if raft_right(1) - raft_left(end) == 1
		indArray = [raft_left(1:end-1), raft_right(2:end)];
	else
		indArray = [raft_left, raft_right];
	end
end
indArray = reshape(indArray, 2, numel(indArray)/2);