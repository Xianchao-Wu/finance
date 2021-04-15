%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (II) —á‘è:?@‚QŽŸŒ³ODE
%?@
%  dy(1)/dx = gama1 * (y(2) - beta * y(1));
%  dy(2)/dx = gama2 * (y(2) - beta * y(1));
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (II-1)
% <<ex_ODE2d_stock2.m>>
close all; 
clear all;

%%%%%% Set parameters %%%%%%%%%%%%%
T=20;%%20;
y0=[10;100]; 

gama1 = 2
gama2 = 3
beta = 2

%%%%%%%%%%% ODE solver %%%%%%%%%%%%%%%%%%%%%%%%%%%
options = [];
%%odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
[t,y] = ode45(@(t,y) ODE2d_stock2(t,y,gama1, gama2, beta),[0 T],y0,options); 

figure(2);plot(t,y(:,1),'-',t,y(:,2),'-.'); grid on;
legend('stock1 y(1)','stock2 y(2)','Location','Best');
title('two stock error correction ODE');
