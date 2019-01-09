function [units, unitIDs] = readSNAP(path, ttno, readflag)
%READSNAP Read spike files written by Neuralynx's SNAP cluster sorting
%
% USAGE:
%
%    units = READSNAP(path, ttno, readflag)
%
%          path 
%                   path to the directory where the .mat files were
%                   saved by SNAP
%          ttno
%                   tetrode number
%          readflag 
%                   0: read good and best clusters (default)
%                   1: read only the best clusters
%                   2: read every cluster

% Siavash Ahmadi
% 12/7/2016 4:00 PM

if ~exist('path', 'var') || isempty(path)
	path = pwd;
end

if ~exist('readflag', 'var') || isempty(readflag)
	readflag = 0;
end

if ~exist('ttno', 'var') || isempty(ttno)
	ttno = 1:60;
end

if isnumeric(ttno) && ~isscalar(ttno)
	units = arrayfun(@(t) readSNAP(path, t, readflag), ttno(:), 'un', 0);
	units = cat(1, units{:});
	return;
elseif ~isscalar(ttno)
	error('Wrong ttno formatting.');
end

inCurrDir = exist(fullfile(pwd, ['TT', num2str(ttno), '.mat']), 'file');
inPath = exist(fullfile(path, ['TT', num2str(ttno), '.mat']), 'file');
if ~inCurrDir && ~inPath
	units = {};
	return;
elseif inCurrDir
	tt = load(fullfile(pwd, ['TT', num2str(ttno), '.mat']));
	ttinfo = load(fullfile(pwd, ['TT', num2str(ttno), '_info.mat']));
else
	tt = load(fullfile(path, ['TT', num2str(ttno), '.mat']));
	ttinfo = load(fullfile(path, ['TT', num2str(ttno), '_info.mat']));
end

unitColumn = tt.output(:, 2);
unitIDs = unique(unitColumn);
nUnits = length(unitIDs);

units = arrayfun(@(u) tt.output(u == unitColumn), unitIDs, 'un', 0);
if readflag == 1
	units = units(ttinfo.final_grades >= 3); % best clusters
elseif readflag == 2
	% pass: all clusters, including artifacts, cut by threshold, etc
else
	units = units(ttinfo.final_grades >= 1); % good or better clusters
end
