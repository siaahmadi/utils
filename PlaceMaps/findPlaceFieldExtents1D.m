function [extents, fieldSize, x_peaks] = findPlaceFieldExtents1D(maps1d, x, opt)
%FINDPLACEFIELDEXTENTS1D Find beginning and end of 1-dimensional place fields
%
% [extents, fieldSize, x_peaks] = FINDPLACEFIELDEXTENTS1D(maps1d, x, opt)

binSize = range(x(1:2));

% for each peak's extent
mergedPeaks = lau.close(maps1d>=opt.minPeakHeight, floor(opt.mergePeaksSeparatedByLessThan/binSize)/2);
fieldSize = lau.raftsize(mergedPeaks) * binSize;
fieldSize = fieldSize(:);
extents = lau.raftidx(mergedPeaks);
extents = reshape(extents(:), 2, numel(extents)/2)';
extents = x(extents);

if isfield(opt, 'positiveFiringThreshold')
	isfiring = lau.close(maps1d>=opt.positiveFiringThreshold, floor(opt.mergePeaksSeparatedByLessThan/binSize)/2);
	isfiringExtents = lau.raftidx(isfiring);
	isfiringExtents = reshape(isfiringExtents(:), 2, numel(isfiringExtents)/2)';
	isfiringExtents = x(isfiringExtents);

	warning off IvlSet:EmptySetCollapsed
	containFields = ivlset(isfiringExtents) ^ ivlset(extents); % ^ is overloaded in @ivlset
	warning on IvlSet:EmptySetCollapsed

	extents = containFields.toIvl;
end