%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (I) ODE
%
% dy/dt=p*y^2+q*y+r; Riccati-type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (I-1)
%% <<ex_ODE1d.m>>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

T=10;
p=0.1; q=-1;r=1;

%%options = odeset('RelTol',1e-4,'AbsTol',1e-4); 	

options =[];										
% default
y0=0.01;% initial value

[t,y] =ode45('ode1d_Riccati',[0 T],y0,options,p,q,r);	
% [0, T]=definition region; 
% y0=initial value and when t=0, we have y=0.01

% p,q,r are input parameters for function 'ode1d_Riccati'.


figure(1);plot(t,y);grid();
title('dy/dx=0.1*y^2-1*y+1');
xlabel('x');
ylabel('y');
