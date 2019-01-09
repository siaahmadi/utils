function l = captelem(array, idx)
%CAPTELEM capture elements of array (useful for inline capturing of
%elements of an array outputted by execution of another function).
%
% SYNTAX:
%	l = captelem(array, idx)
%	
% EXAMPLE:
%	l = captelem(find(logicalArray, 7), 7); % returns the position of 7th
%	                                        % true value in "logicalArray"
%
%  This example is equivalent to running both of the following lines:
%	l = find(logicalArray, 7);
%	l = l(7);

l = array(idx);