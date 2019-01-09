function outstr = textreadtable(pathToTxtFile, firstLineIsHeader, delimiter)
%TEXTREADTABLE Import text file as a table
%
% outstr = textreadtable(pathToTxtFile, firstLineIsHeader, delimiter)
%
% First argument mandatory
% Second and Third arguments optional

lines = textreadlines(pathToTxtFile);

if ~exist('readheader', 'var') || isempty(firstLineIsHeader)
	firstLineIsHeader = true;
end

if ~exist('delimiter', 'var') || isempty(delimiter)
	delimiter = '\t';
end

linecounter = 1;

variables = strsplit(lines{linecounter}, delimiter);

if ~firstLineIsHeader
	linecounter = 0;
	variables = strcat('var', 1:length(variables)); % call them var1, var2, ...
end

for i = 1:length(lines)-linecounter
	linebuffer = strsplit(lines{i+linecounter}, delimiter);
	for j = 1:length(variables)
		outstr(i).(variables{j}) = numeric(linebuffer{j});
	end
end

outstr = outstr(:);

function i = couldnumeric(str)
converted = str2double(str);
if ~isnan(converted) || strcmpi(str, 'nan')
	i = true;
else
	i = false;
end

function n = numeric(str)
if couldnumeric(str)
	n = str2double(str);
else
	n = str;
end