% BS formula
function [call,put] = blsprice2(so, x, r, t, sig, q)

d1 = (log(so./x) + (r-q+sig.^2/2).*t)./(sig.*sqrt(t));
d2 = d1 - (sig.*sqrt(t));
call = so.*exp(-q.*t).*normcdf(d1)-x.*(exp(-r.*t).*normcdf(d2));
put = x.*exp(-r.*t).*normcdf(-d2)-so.*exp(-q.*t).*normcdf(-d1);
%return;