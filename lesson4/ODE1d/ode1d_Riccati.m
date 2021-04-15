% <<ode1d_Riccati.m>>
% p, q, and r are input parameters
% flag is not used.
function[fv]=ode1d_Riccati(t,y,flag,p,q,r)

fv=p*y^2+q*y+r;
