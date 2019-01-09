function popcorr = popveccorr(popmap1, popmap2, occ1, occ2, opt)

% Check popmap1, popmap2 same size
if ~isequal(size(popmap1), size(popmap2))
	error('The population vectors must be the same size.');
end

flags = {'Field Max Firing Rate';
	'Information per second';
	'Firing Rate Normalization';
	'Discard Low-Info PVs'};

FIELD_THRESH_MIN = 2;
FIELD_THRESH_MAX = 40;
INFO_THRESH_MIN = 0.25;
INFO_THRESH_MAX = 10;
normalization = false;
normalize_to = 'max';
discard_lowinfo_pv = true;
PV_DROP_THRESH_MIN = FIELD_THRESH_MIN;


if exist('opt', 'var') && ~isempty(opt)
	if isfield(opt, 'FIELD_THRESH_MIN')
		FIELD_THRESH_MIN = opt.FIELD_THRESH_MIN;
	end
	if isfield(opt, 'FIELD_THRESH_MAX')
		FIELD_THRESH_MAX = opt.FIELD_THRESH_MAX;
	end
	if isfield(opt, 'INFO_THRESH_MIN')
		INFO_THRESH_MIN = opt.INFO_THRESH_MIN;
	end
	if isfield(opt, 'INFO_THRESH_MAX')
		INFO_THRESH_MAX = opt.INFO_THRESH_MAX;
	end
	if isfield(opt, 'normalization')
		normalization = opt.normalization;
	end
	if isfield(opt, 'discard_lowinfo_pv')
		discard_lowinfo_pv = opt.discard_lowinfo_pv;
	end
	if isfield(opt, 'normalize_to')
		normalize_to = opt.normalize_to;
	end
	% todo: opt:include rules
	% todo: opt:normalization rules
else
	
end

selected_flags = [true, true, normalization, discard_lowinfo_pv];

info1 = arrayfun(@(i) dataanalyzer.routines.spatial.information_skaggs96(popmap1(:, :, i), occ1), 1:size(popmap1, 3));
info2 = arrayfun(@(i) dataanalyzer.routines.spatial.information_skaggs96(popmap2(:, :, i), occ2), 1:size(popmap2, 3));


popcorr = NaN(size(popmap1, 1), size(popmap1, 2));
include1_fieldrate = findInclude(popmap1, FIELD_THRESH_MIN, FIELD_THRESH_MAX);
include2_fieldrate = findInclude(popmap2, FIELD_THRESH_MIN, FIELD_THRESH_MAX);
include1_inforate = INFO_THRESH_MIN <= info1 & info1 <= INFO_THRESH_MAX;
include2_inforate = INFO_THRESH_MIN <= info2 & info2 <= INFO_THRESH_MAX;
include = include1_fieldrate(:) & include2_fieldrate(:) & include1_inforate(:) & include2_inforate(:);

% Calculate which PVs would be discarded based on actual rates (before
% normalization) -- call the indicator matrix dlipv (:=discard low-info
% population vectors)
dlipv = false(size(popmap1, 1), size(popmap1, 2));
for i = 1:size(popmap1, 1)
	for j = 1:size(popmap1, 2)
		if occ1(i,j) > 0 && occ2(i,j) > 0
			if discard_lowinfo_pv && ~(any(popmap1(i,j,include) > PV_DROP_THRESH_MIN) & any(popmap2(i,j,include) > PV_DROP_THRESH_MIN))
				dlipv(i,j) = true;
			end
		end
	end
end

if normalization
	if strcmpi(normalize_to, 'max')
		popmap1 = stack(cellfun(@normalize, unstack(popmap1), 'un', 0));
		popmap2 = stack(cellfun(@normalize, unstack(popmap2), 'un', 0));
	elseif strcmpi(normalize_to, 'zscore')
		popmap1 = stack(cellfun(@zscore2d, unstack(popmap1), 'un', 0));
		popmap2 = stack(cellfun(@zscore2d, unstack(popmap2), 'un', 0));
	end
end

fprintf(2, ['Calculating pop-vec correlations with the following flags:\n', repmat('--> %s\n', 1, sum(selected_flags)), '\n'], flags{selected_flags});
for i = 1:size(popmap1, 1)
	for j = 1:size(popmap1, 2)
		if occ1(i,j) > 0 && occ2(i,j) > 0
			if dlipv(i,j)
				continue;
			end
			buffer = corrcoef(popmap1(i,j,include), popmap2(i,j,include));
			if isnan(buffer)
				error('Fix this! Todo: Make corrcoef ignore the NaNs in the PVs');
			end
			popcorr(i, j) = buffer(2);
		end
	end
end

function include = findInclude(popmap, FIELD_THRESH, FIELD_THRESH_max)
include = cellfun(@(map) any(map(:)>FIELD_THRESH) & ~any(map(:)>FIELD_THRESH_max), mat2cell(popmap, size(popmap, 1), size(popmap, 2), ones(1, size(popmap, 3))));

function us = unstack(popmap)
us = mat2cell(popmap, size(popmap, 1), size(popmap, 2), ones(1, size(popmap, 3)));

function s = stack(popmap)
s = cat(3, popmap{:});

function nrm = normalize(ratemap)
nrm = ratemap ./ max(ratemap(:));

function ratemap = zscore2d(ratemap)
ratemap(:) = zscore(ratemap(:));