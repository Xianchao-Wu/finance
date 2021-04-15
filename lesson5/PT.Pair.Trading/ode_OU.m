% <<ode_OU.m>> % kap,ybar are input parameters
function[dy]=ode_OU(t,y,kap,ybar)

dy=kap*(ybar-y); 

