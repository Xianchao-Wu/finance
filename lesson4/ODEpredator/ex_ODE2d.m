%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  dy(1)/dt = pm.mu(1)*y(2)-0.5*pm.sig(1)*y(2)^2;
%  dy(2)/dt = pm.mu(2)*y(2)-0.5*pm.sig(2)*y(2)^2 + 1;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (II-1)
% <<ex_ODE2d.m>>
% Lotka-Volterra predator-prey ODE
close all; 
clear all;

%%%%%% Set parameters %%%%%%%%%%%%%
T=20;%%20;
y0=[10;100]; 
% y0(1), number of initial predator; y0(2), number of initial prey

% -- predator ----
% dy(1)/dt = a*y(1)*y(2)-b*y(1);
%
% -- prey ----
% dy(2)/dt = c*y(2)-d*y(1)*y(2);

% a, b, c, d are constants, can be tuned
a=0.01;
b=0.5;

c=2;
d=0.03;


%%%%%%%%%%% ODE solver %%%%%%%%%%%%%%%%%%%%%%%%%%%
options = [];%%odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
[t,y] = ode45(@(t,y) ODE2d(t,y,a,b,c,d),[0 T],y0,options); 

figure(1);plot(t,y(:,1),'-',t,y(:,2),'-.'); grid on;
legend('predator y(1)','prey y(2)','Location','Best');
title('predator-prey ODE');
