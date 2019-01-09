function [pathTo, TheRest, separator] = sa_subStringTillLastSeparator(pathToFile)

indLastSeparatorRev = regexp(pathToFile(end:-1:1), '\', 'once');

pathTo = pathToFile(1:end-indLastSeparatorRev);
TheRest = pathToFile(end-indLastSeparatorRev+2:end);
separator = pathToFile(end-indLastSeparatorRev+1);