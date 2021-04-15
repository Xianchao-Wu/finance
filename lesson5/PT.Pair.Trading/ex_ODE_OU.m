%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1?ODE
%
% dy/dt=kap*(ybar-y)  
% mean-reversion (Ornstein-Uhlenbeck process‚ drift term)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% <<ex_ODE_OU.m>>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

T=60/252; % 60 working days
ybar=-66;
kap=12.1;
%%options = odeset('RelTol',1e-4,'AbsTol',1e-4); 	% ODE solver‚ ????

options =[];										% default
%y0=30;% initial value
%y0 = 50;
y0=-100;

[t,y] =ode45(@(t,y) ode_OU(t,y,kap,ybar),[0 T],y0,options);	
% [0,T]‚ ???
% y0‚????(when t=0‚ y=0.01);

% ode45 ?= help ode45: 1, function; 2, time span, 3. initial condition y0
% to solve function is: ode_OU(t,y,kap,ybar)


% p,q,r‚ÍODE program 'ode1d_Riccati'‚É“n‚·parameters


disp(y0);
figure(1);plot(t,y);grid on;title(sprintf('ode45 method, y0=%d',y0));

figure(2);
% ???
t2=0:0.001:0.25;
yref=ybar + (y0-ybar)*exp(-kap*t2);
%plot(t2, yref, t, y);
plot(t2, yref);
%plot(t, y);
grid on;
title(sprintf('reference (directly computed by equation) curve, and y0=%d', y0));