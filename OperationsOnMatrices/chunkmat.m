function c = chunkmat(M, chunkIdx)
%CHUNKMAT Convert array to cell array with potentially different sized cells
%(a.k.a. user-friendlier version of mat2cell, for a single vector)
%
% c = CHUNKMAT(M, chunkIdx)
%
%     M         is a vector.
%
%     chunkIdx  is the [a, b) formatted slicing indices.
%
%     -  If chunkIdx is a vector then for each i = [1,...,len(chunkIdx)],
%        c(i) = num2cell{chunkIdx(i:i+1));
%
%     -  if chunkIdx is a m x 2 matrix, for each i = [1,...,len(chunkIdx)],
%        c(i) = num2cell(M(chunkIdx(i, 1):chunkIdx(i, 2)));
%
%     -  if chunkIdx is a 2 x m matrix, c = chunkmat(M, chunkIdx');

% Siavash Ahmadi

if ~isvector(M)
	error('Input a vector')
end

if isvector(chunkIdx)
	c = arrayfun(@(y, z) M(y:z-1), chunkIdx(1:end-1), chunkIdx(2:end), 'UniformOutput', false);
elseif ismatrix(chunkIdx)
	if size(chunkIdx, 1) == 2
		chunkIdx = chunkIdx';
	end
	if size(chunkIdx, 2) == 2
		c = arrayfun(@(y, z) M(y:z), chunkIdx(:, 1), chunkIdx(:, 2), 'UniformOutput', false);
	else
		error('Unrecognized matrix size.');
	end
end