function h = raster(spikeTimes, Fs, varargin)
if nargin == 1
	Fs = 1;
end

rowIndexGiveAt = strcmpi(varargin, 'rowIndex');
if any(rowIndexGiveAt)
	rowIndex = varargin{find(rowIndexGiveAt)+1};
	varargin = varargin(~(rowIndexGiveAt | circshift(rowIndexGiveAt, 1, 2)));
else
	rowIndex = 1:length(spikeTimes);
end


if isa(spikeTimes, 'double')
	if isvector(spikeTimes)
		spikeTimes = {spikeTimes};
	else
		error('spikeTimes must be either a vector of doubles or a cell of double vectors')
	end
elseif islogical(spikeTimes)
	spikeTimes = find(spikeTimes)/Fs;
	spikeTimes = {spikeTimes};
elseif ~isa(spikeTimes, 'cell')
	error('spikeTimes must be either a vector of doubles or a cell of double vectors')
end

hold on;
hg = hggroup;
h0 = cell(length(spikeTimes), 1);
for i = 1:length(spikeTimes)
	A = nan(3*length(spikeTimes{i}), 1);
	A(1:3:end) = spikeTimes{i};
	A(2:3:end) = spikeTimes{i};
	if ~isempty(varargin)
		h0{i} = plot(A, repmat([.55;1.45;NaN] + rowIndex(i) - 1, length(spikeTimes{i}), 1), varargin{:});
	else
		h0{i} = plot(A, repmat([.55;1.45;NaN] + rowIndex(i) - 1, length(spikeTimes{i}), 1));
	end
	if ~isempty(h0{i})
		h0{i}.Parent = hg;
	end
	set(gca,'ytick',[])
	dcm_obj = datacursormode(gcf);dcm_obj.UpdateFcn = @testfunc; % experimental
end
h0 = hg;

if nargout > 0
	h = h0;
end
axis ij