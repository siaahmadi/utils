function [h, spikes] = rastert(spikeTimes, varargin)

if isa(spikeTimes, 'double')
	if isvector(spikeTimes)
		spikeTimes = {spikeTimes};
	else
		error('spikeTimes must be either a vector of doubles or a cell of double vectors')
	end
elseif islogical(spikeTimes)
	spikeTimes = find(spikeTimes);
	spikeTimes = {spikeTimes};
elseif ~isa(spikeTimes, 'cell')
	error('spikeTimes must be either a vector of doubles or a cell of double vectors')
end

spikeTimes = spikeTimes(:);

[spikeTimes, trialt, p] = parseVarargin(spikeTimes, varargin{:});


validate_TrialSplit(trialt);

lbl = p.Results.TrialLabel;

spikes = cellfun(@splitAtTS, spikeTimes, trialt, 'un', 0);
spikes = align2zero(spikes, trialt);
spikes = accFunc_unpack(spikes);

[catspikes, offset, spikes] = preprocessForPlotting(spikes);

group = p.Results.Group;

catspikes = reorderByGroup(catspikes, group);
spikes = reorderByGroup(spikes, group);


unmatched = struct2list(p.Unmatched);
h = raster_core(catspikes, unmatched{:});

ax = gca;
ax.XTick = offset;
plot([offset;offset;nan(size(offset))], [zeros(size(offset)); ones(size(offset))*max(ax.YLim);nan(size(offset))], 'k--');
ax.XTickLabel = lbl;
ax.FontName = 'Arial';
ax.FontSize = 18;
ax.XTickLabelRotation = 45;

shade_grouping(ax, p.Results);



function validate_TrialSplit(trialt)
sz = cellfun(@size, trialt, 'un', 0);
if length(sz) > 1 && ~isequal(sz{:})
	error('Sizes must be the same in TrialSplit');
end
validateattributes(trialt{1}, {'double'}, {'nrows', 2});

function U = accFunc_unpack(C)
U = cat(1, C{:});

function spikes = splitAtTS(spikes, trialt)
spikes = spikes(:)';
trialt = column2cell(trialt);

spikes = cellfun(@(t) restr(spikes, t(1), t(2)), trialt, 'un', 0);

function spikes = align2zero(spikes, trialt)
spikes = cellfun(@accFunc_subtractStart, spikes, trialt, 'un', 0);

function sp = accFunc_subtractStart(splitSpikes, t)
sp = cellfun(@(sp,t) sp - t, splitSpikes, num2cell(t(1, :)), 'un', 0);

function h = raster_core(spikes, varargin)

hold on;
hg = hggroup;
h = cell(length(spikes), 1);
for i = 1:length(spikes)
	A = nan(3*length(spikes{i}), 1);
	A(1:3:end) = spikes{i};
	A(2:3:end) = spikes{i};
	if ~isempty(varargin)
		h{i} = plot(A, repmat([.55;1.45;NaN] + i - 1, length(spikes{i}), 1), varargin{:}, 'Parent', hg);
	else
		h{i} = plot(A, repmat([.55;1.45;NaN] + i - 1, length(spikes{i}), 1), 'Parent', hg);
	end
	set(gca,'ytick',[])
	dcm_obj = datacursormode(gcf);dcm_obj.UpdateFcn = @testfunc; % experimental
end
h = hg;

function [catspikes, offset, spikes] = preprocessForPlotting(catspikes)

offset = floor(cellfun(@(col) max(cellfun(@mymax, col)), column2cell(catspikes))) + 1;
offset = cumsum([0 offset(1:end-1)]);

spikes = cellfun(@(sp,offset) sp + offset, catspikes, num2cell(repmat(offset, size(catspikes, 1), 1)), 'un', 0);

catspikes = cellfun(@(row) cat(2, row{:}), row2cell(spikes), 'un', 0);

function m = mymax(x)
if isempty(x)
	m = 0;
else
	m = max(x);
end
function m = mymin(x)
if isempty(x)
	m = Inf;
else
	m = min(x);
end

function [spikeTimes, trialt, p] = parseVarargin(spikeTimes, varargin)

DEFAULT_LBL_PREFIX = 'Block';
DEFAULT_GRPLBL_PREFIX = 'Neuron';

p = inputParser();
p.KeepUnmatched = true;
p.addParameter('BinaryBinSize', 1);
p.addParameter('TrialSplit', {[min(cellfun(@mymin, spikeTimes));max(cellfun(@mymax, spikeTimes))]}, @iscell);
p.addParameter('AlignTo', 'start', @(x) validatestring(x, {'start', 'end'}, 'rastert'));
p.addParameter('Group', 1:numel(spikeTimes), @(x) isnumeric(x) & numel(x) == numel(spikeTimes));
p.parse(varargin{:});

displayDefault = ~ismember('Group', p.UsingDefaults);

binsize = p.Results.BinaryBinSize;
if islogical(spikeTimes{1})
	spikeTimes = cellfun(@(x) x*binsize, spikeTimes, 'un', 0);
end

trialt = p.Results.TrialSplit;
trialt = trialt(:);
if ~isequal(size(trialt), size(spikeTimes))
	trialt = repmat(trialt, size(spikeTimes));
end
group = p.Results.Group;

p = inputParser();
p.KeepUnmatched = true;
p.addParameter('BinaryBinSize', 1);
p.addParameter('TrialSplit', max(cellfun(@mymax, spikeTimes)), @iscell);
p.addParameter('AlignTo', 'start', @(x) validatestring(x, {'start', 'end'}, 'rastert'));
p.addParameter('TrialLabel', cateach([DEFAULT_LBL_PREFIX ' '], arrayfun(@num2str, 1:size(trialt{1}, 2), 'un', 0)), @iscellstr);
p.addParameter('GroupLabel', cateach([DEFAULT_GRPLBL_PREFIX ' '], arrayfun(@num2str, group, 'un', 0)), @(x) iscellstr(x) && numel(x) == numel(unique(group)));
p.addParameter('Group', 1:numel(spikeTimes), @(x) isnumeric(x) & numel(x) == numel(spikeTimes));
p.addParameter('DisplayGroupLabel', displayDefault);

p.parse(varargin{:});

function onoff = validateOnOff(str)

if isnumeric(str)
	onoff = str == true;
elseif ischar(str)
	validatestring(str, {'on', 'off'}, 'rastert');
	onoff = strcmpi(str, 'on');
else
	error('Invalid parameter type.');
end

function spikes = reorderByGroup(spikes, group)

spikes = arrayfun(@(grp) spikes(group==grp, :), unique(group(:)), 'un', 0);
spikes = cat(1, spikes{:});

function c = ctrOfSeq(seq)
% Make sure |seq| is sorted before it is passed it on
c = arrayfun(@(grp) mean(find(seq==grp)), unique(seq));

function shade_grouping(ax, opt)

group = opt.Group;
glbl = opt.GroupLabel;

c = ctrOfSeq(sort(group));
if opt.DisplayGroupLabel
	ax.YTick = c;
	ax.YTickLabel = glbl;
end
xl = ax.XLim;
ax.TickDir = 'out';

grpFirstInd = arrayfun(@(grp) find(sort(group)==grp, 1), unique(group));
grpLastInd = arrayfun(@(grp) find(sort(group)==grp, 1, 'last'), unique(group));

mypatch = @(from,to,even) patch([xl(1), xl(1), xl(2), xl(2)], [from-1, to, to, from-1]+.5, 'k', 'facealpha', .05*(logical(even)+1), 'edgecolor', 'none', 'Tag', 'GroupShading');

arrayfun(@(from,to,indx) mypatch(from,to,mod(indx,2)==0), grpFirstInd(:)', grpLastInd(:)', 1:length(unique(group)));