function [TList, ttLoc] = ttdb_vero(filename, path)
% extract .t file names and their histology info from Vero's many text files
% with obscure names
%
% See Also: readtxttable, sort_nat

if ~exist('path', 'var')
	path = pwd;
end

if ~exist('filename', 'var') || isempty(filename)
	filename.sgzhilus = 'SGZhilusanalysisTT.txt';
	filename.hilus = 'DGhilusanalysisTT.txt';
	filename.gcl = 'DGanalysisTT.txt';
	filename.ca3 = 'CA3analysisTT.txt';
end

if exist(fullfile(path, filename.sgzhilus), 'file')
	SGZ_hilus = readtxttable(fullfile(path, filename.sgzhilus));
else
	SGZ_hilus = {};
end

if exist(fullfile(path, filename.hilus), 'file')
	Hilus = readtxttable(fullfile(path, filename.hilus));
else
	Hilus = {};
end

if exist(fullfile(path, filename.gcl), 'file')
	GCL = readtxttable(fullfile(path, filename.gcl));
else
	GCL = {};
end

if exist(fullfile(path, filename.ca3), 'file')
	CA3 = readtxttable(fullfile(path, filename.ca3));
else
	CA3 = {};
end

SGZ = setdiff(SGZ_hilus, Hilus);

GCL = setdiff(GCL, SGZ);

TList = sort_nat([GCL(:); SGZ(:); CA3(:); Hilus(:)]);

ttLoc.gcl = ismember(TList, GCL);
ttLoc.sgz = ismember(TList, SGZ);
ttLoc.hilus = ismember(TList, Hilus);
ttLoc.ca3 = ismember(TList, CA3);
