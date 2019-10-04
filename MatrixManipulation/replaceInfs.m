function A = replaceInfs(A,newValue)
if ~exist('newValue','var')||isempty(newValue)
    newValue = 0;
end
iif = @(varargin) varargin{2 * find([varargin{1:2:end}], 1, 'first')}();
A = arrayfun(@(x)iif(~isfinite(x),@()newValue,true,x),A);