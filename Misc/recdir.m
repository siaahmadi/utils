function [dirOutput, visitedDirs, meta] = recdir(fullPath, recStr, uniqueFiles)
% recursively run 'dir recStr' on fullPath and its subdirectories

metaProperty = 'date';
allSubDirMeta = '';

if ~exist('fullPath', 'var') || isempty(fullPath)
	fullPath = pwd;
end

fullPathDir = dir(fullPath);

currDir = dir(fullfile(fullPath, recStr));
currDirMeta = dir(fullfile(fullPath, recStr));
thisDir = cell(size(fullPathDir));
thisDirMeta = cell(size(fullPathDir));
visitedDirs = cell(size(fullPathDir));
for i = 3:length(fullPathDir)
	if fullPathDir(i).isdir
		thisDir{i} = dir(fullfile(fullPath, fullPathDir(i).name, recStr));
		visitedDirs{i} = fullfile(fullPath, fullPathDir(i).name);
	end
end
idx = ~cellfun(@isempty, thisDir);
dirsWithFiles = fullfile(fullPath, {fullPathDir(idx).name}');
thisDir(~idx) = [];
visitedDirs(~idx) = [];

if nargin > 2 && uniqueFiles
	for i = 1:length(thisDir)
		thisDir{i} = {thisDir{i}.name}';
	end
	allSubDirFiles = cell(sum(cellfun(@length, thisDir)), 1);
	j = 0;
	for i = 1:length(thisDir)
		allSubDirFiles(j+1:j+length(thisDir{i})) = thisDir{i}(:);
		j = j + length(thisDir{i});
	end

	dirOutput = unique([allSubDirFiles; {currDir.name}']);
	return
end

for i = 1:length(thisDir)
	thisDir{i} = fullfile(dirsWithFiles{i}, {thisDir{i}.name}');
end

allSubDirFiles = cell(sum(cellfun(@length, thisDir)), 1);
j = 0;
for i = 1:length(thisDir)
	allSubDirFiles(j+1:j+length(thisDir{i})) = thisDir{i}(:);
	j = j + length(thisDir{i});
end

dirOutput = [fullfile(fullPath, {currDir.name}');...
			allSubDirFiles];
		
meta = [{currDirMeta.(metaProperty)}';...
	allSubDirMeta];