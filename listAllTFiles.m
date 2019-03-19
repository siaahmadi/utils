function [listOfTFiles, listOfTFilesBySubDir, visitedDirs, subDirectories] = listAllTFiles(pathToSession, subDirectories, sortDefault)
% List all .t Files in a given session and subDirectories to that session
%
% INPUT:
%
% pathToSession:
%		path to a session where the trial folders are located
%
% subDirectories:
%		look into these subdirectories only in search of .t files
%
% sortDefault:
%		if true or not provided, will rely on Windows's default way
%		of sorting files, otherwise will use the more intuitive way of sorting
%
% OUTPUT:
%
% listOfTFiles:
%		unique .t file names in all subdirectories
%
% listOfTFilesBySubDir:
%		a cell array containing a list of .t files of each
%		subdirectory as an element

if ~exist('pathToSession', 'var') || isempty(pathToSession)
	pathToSession = pwd;
end

if ~exist('subDirectories', 'var') || isempty(subDirectories)
	buffer = dir(pathToSession);
	buffer = {buffer([buffer.isdir]).name}';
	subDirectories = buffer(3:end);
end



% [~, a] = dos(['dir /s /b "' pathToSession '\*.t"']);
% Windows's 'dir' is slower than my 'recdir' (recursive dir)
[a, visitedDirs] = recdir(pathToSession, '*.t');a = cat(2, a{:});
visitedDirs = visitedDirs(matchstr(visitedDirs, cateachrow(subDirectories, '|'), 'contains'));

if nargin < 3 || sortDefault == 1
	if isempty(a)
		a = {''};
		b = {''};
	else
		b = regexp(a, 'TT\d*_\d\d.t', 'match');
	end
	listOfTFiles = unique(b)';
elseif sortDefault == 0
	b1 = regexp(a, 'TT\d_\d\d.t', 'match');
	b2 = regexp(a, 'TT\d\d_\d\d.t', 'match');
	c1 = unique(b1)';
	c2 = unique(b2)';
	listOfTFiles = [c1; c2];
end

listOfTFilesPerSubDirectory = cell(size(subDirectories));
for i = 1:length(subDirectories)
	b = regexp(a, [subDirectories{i}, '\\TT\d*_\d\d.t'], 'match');
	listOfTFilesPerSubDirectory{i} = unique(cellfun(@(x, y) x(length(y)+2:end), b, repmat(subDirectories(i), size(b)), 'UniformOutput', false));
	% I added 'unique' to make sure the order becomes independent of Windows's sorting algorithm
end

listOfTFilesBySubDir = 1==cell2mat(cellfun(@stridx, repmat({listOfTFiles}, size(subDirectories)), listOfTFilesPerSubDirectory, 'UniformOutput', false));
% 
% if nargout == 3
% 	cellToWriteFile = 
% end