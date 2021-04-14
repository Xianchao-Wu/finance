% SDE=stochastic differential equation??????
% Simulation of diffusion process; BM = Brown Motion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

nt=21*12; % 21 days per month, 12 months per year
Xt=zeros(nt,1); % vector
Xt2=zeros(nt,1)
Xt3=zeros(nt,1)
Xt4=zeros(nt,1)
Xt5=zeros(nt,1)
dt=1/nt;

%%%%%%%%%%%%%%
% (1) dX(t)=alp*dt+sig*dB(t) 
% alpha (alike mu), 
% dt (time-difference), 
% sig (sigma), dB(t): Brown motion, 
% dX(t) = difference of the value function, X(t). 
%%%%%%%%%%%%%%%

Xt(1)=0;
Xt2(1)=0;
Xt3(1)=0;
alp=0.2;
sig=0.3;

rng(123456789,'twister');
for t=2:nt
	dB=dt^0.5*randn(1);
	Xt(t)=Xt(t-1)+alp*dt+sig*dB; % alp=0.2, sig=0.3
    Xt2(t)=Xt2(t-1) + alp*2*dt+sig*dB; % alp=0.4, sig=0.3
    Xt3(t)=Xt3(t-1) + alp*4*dt+sig*dB; % alp=0.8, sig=0.3
    Xt4(t)=Xt4(t-1) + alp*dt+sig*2*dB; % alp=0.2, sig=0.6
    Xt5(t)=Xt5(t-1) + alp*4*dt+sig*2*dB; % alp=0.8, sig=0.6
end

figure(1);
plot(Xt);grid on;
title('Diffusion process, alpha=0.2/0.4/0.8, sigma=0.3/0.6');
hold on;
plot(Xt2);
plot(Xt3); 
plot(Xt4);
plot(Xt5);

legend('alpha=0.2, sigma=0.3', 'alpha=0.4, sigma=0.3',  ...
    'alpha=0.8, sigma=0.3', 'alpha=0.2, sigma=0.6', ...
    'alpha=0.8, sigma=0.6')

disp('Type any key to continue!');
pause; 
%return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (2) Mean-reversion process;
%  dX(t)=alp*(Xbar-X(t))dt+sig*dB(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In finance, mean reversion is the assumption that:
% a stock's price will tend to move to the average price over time.
Xt(1)= 0.15;
Xt2(1) = 0.15;
Xt3(1) = 0.15;
Xt4(1) = 0.15;
alp  = [20.0 2.0]; % strength of mean-reversion, 2.0
Xbar = [0.1 0.5];% long-run mean, pre-given
sig  = 0.3;

%rng(123456789,'twister');
for t=2:nt
	dB=dt^0.5*randn(1);
%	Xt(t)=Xt(t-1)+...;%<========== 1?s programming
    Xt(t)=Xt(t-1)+alp(1)*(Xbar(1)-Xt(t-1))*dt + sig*dB; % 20.0, 0.1
    Xt2(t)=Xt2(t-1)+alp(2)*(Xbar(1)-Xt2(t-1))*dt + sig*dB; % 2.0, 0.1
    Xt3(t)=Xt3(t-1)+alp(1)*(Xbar(2)-Xt3(t-1))*dt + sig*dB; % 20.0, 0.5
    Xt4(t)=Xt4(t-1)+alp(2)*(Xbar(2)-Xt4(t-1))*dt + sig*dB; % 2.0, 0.5
	%Xt(t)=Xt(t-1);
end

figure(2);
plot(Xt);hold on;
plot(Xt2);plot(Xt3);plot(Xt4);
grid on;title('Mean Reversion process');
legend('alp=20.0, Xbar=0.1', 'alp=2.0, Xbar=0.1', ...
    'alp=20.0, Xbar=0.5', 'alp=2.0, Xbar=0.5')



