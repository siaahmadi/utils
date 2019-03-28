function x = nancumsum(x)
%NANCUMSUM Cumulative sum ignoring NaNs
%
%x = NANCUMSUM(x)

x(~isnan(x)) = cumsum(x(~isnan(x)));