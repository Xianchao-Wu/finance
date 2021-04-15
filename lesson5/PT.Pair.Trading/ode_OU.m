% <<ode_OU.m>> % kap,ybar are input parameters
function[dy]=ode_OU(t,y,kap,ybar)

dy=kap*(ybar-y); % ybar = average of y (1.4) of page2 of the pdf. dy/dt? not dy?
