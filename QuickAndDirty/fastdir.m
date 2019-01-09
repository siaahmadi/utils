function d = fastdir(path)
%FASTDIR List folder contents
% 
% MATLAB's @dir function does the same but is very slow on a network, and
% sometimes on the local hard disk. This function uses Java to accomplish
% the same goal faster.
%
% Inputs and outputs same as MATLAB's builtin @dir function
%
% See also: dir

% Siavash Ahmadi
% 12/01/2015 5:59 PM
% Version 0.5
% TODO: implement wildcards
% TODO: populate the empty fields in output

if nargin < 1
	path = pwd;
end

j = java.io.File(path);
d = cell(j.list);

% to do: dot, doubledot
% dot --> j.getName, j.getPath
% doubledot --> j.getParent


subj = cellfun(@(x) java.io.File(x), fullfile(path, d), 'UniformOutput', false);
subj = cat(1, subj{:});
id = arrayfun(@(x) x.isDirectory, subj, 'UniformOutput', false);


d = cellfun(@(n, id) struct('name', n, 'date', '', 'bytes', [], 'isdir', id, 'datenum', []), d, id, 'UniformOutput', false);
d = cat(1, d{:});

% to do: other fields