function [dirOutput, metaOutput, visitedDirs] = recdir2(recStr, fullPath, metaProperty)
%RECDIR2 recursively run 'dir recStr' on fullPath and its subdirectories
%
% INPUT:
%	recStr
%		The wildcard string that will be passed to MATLAB's @dir function.
%		Default is '*' (i.e. any file name).
%
%	fullPath
%		The directory on which to run @recdir2. If skipped or an empty
%		array is passed it will default to the current directory.
%
%	metaProperty
%		What other property, other than the name of the files, must be
%		returned? Default is 'date'. Possible inputs include 'date',
%		'bytes', 'datenum'.
%
% OUTPUT:
%	dirOutput
%		Cell array of file names.
%
%	metaOutput
%		Cell array of meta property.
%
%	visitedDirs
%		Cell array of all subdirectories. (NOT IMPLEMENTED YET).
%
% ALGORITHM:
%	First "dir recStr" is run on |fullPath|. This returns an array of
%	structs with information about the files and directories that reside in
%	|fullPath|, stored in variable |fullCurrDir|. Any non-directory (i.e.
%	files) entries will be stored in variable |currDirFiles|. For each
%	struct in |fullCurrDir| that is a directory (whos names and path are
%	stored in the variable |subdirs|),  the same command, namely
%	"recdir2(recStr, fullPath, metaProperty)", is run again and the results
%	of each is stored as elements to the cell structs |rsdirs| and
%	|rsmetas|. The names of files residing in |fullPath| (i.e. |currDirFiles|
%	and those from the subdirectories (i.e. |rsdirs|)) are then merged into
%	|dirOutput|. The corresponding meta property of interest (default: 'date')
%	is stored and returned in |metaOutput|.
%
% See Also: dir, fastdir

% Siavash Ahmadi
% 02/08/2016 1:03 PM
% Version 0.9

visitedDirs = {''};

if ~exist('fullPath', 'var') || isempty(fullPath)
	fullPath = pwd;
end

if ~exist('metaProperty', 'var') || isempty(metaProperty)
	metaProperty = 'date';
end

if ~exist('recStr', 'var') || isempty(recStr)
	recStr = '*';
end

validatestring(metaProperty, {'date', 'bytes', 'datenum'}, 'recdir2', inputname(3), 3);

currDirFiles = dir(fullfile(fullPath, recStr));
fullCurrDir = dir(fullPath);

subdirs = fullCurrDir([fullCurrDir.isdir] & ~strcmp({fullCurrDir.name}, '.') & ~strcmp({fullCurrDir.name}, '..'));

[rsdirs, rsmetas] = arrayfun(@(sdir) recdir2(recStr, fullfile(fullPath, sdir.name), metaProperty), subdirs, 'un', 0);

dirOutput = [fullfile(fullPath, {currDirFiles(~[currDirFiles.isdir]).name})';...
	cat(1, rsdirs{:})];

metaOutput = [{currDirFiles(~[currDirFiles.isdir]).(metaProperty)}';...
	cat(1, rsmetas{:})];