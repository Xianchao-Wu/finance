 % 
% Simulation of jump process

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

%%%%%%%%%%%%%%
% (1) N(t): Plain jump(Poisson) process
% lam: constant intensity
%%%%%%%%%%%%%%%

lam=10; 
% one year, 10 times, jump times?Cor jump frequency?Galike write 10 reports per year
nt=21*12; 
% 21 days per month; 12 months
Nt=zeros(nt,1); 
% jump's times vector
dt=1/nt; 
% one day 

rng(123456789,'twister');
for t=2:nt % nt - 2 + 1 = nt - 1 times
	if rand(1)<lam*dt 
        % Passion Process?Crandomly generate a double in [0, 1]?C 10*1/(21*12)
		dN=1; 
        % do jump, with a probability of lam*dt
	else
		dN=0; 
        % do not jump, with a probability of (1-lam*dt), specially important
	end
	Nt(t)=Nt(t-1)+dN; % Nt add (1, or 0)
end

figure(1);
disp(Nt);
% draw Nt into figure 1:
stairs(Nt);grid on;title('N(t)');

disp('Type any key!');pause;

%for t=2:nt
%    if rand(1) <= 0.1
%        dN = %use r2
%    else
%        dN = %use r1
%    end
%end

%%%%%%%%%%%%%%
% (2) Simulation of Hawkes(HW) process
% d lam(t) = alpha*(lambar-lam(t))*dt + beta*dN(t)
%%%%%%%%%%%%%%%

lam=zeros(nt,1);

lam(1)=20;
lambar=20; % 10
alp=1.5; % 1.5
bt=0.5; % 0.5

rng(123456789,'twister');
for t=2:nt
	if rand(1)<lam(t-1)*dt
		dN=1;
	else
		dN=0;
	end
	Nt(t)=Nt(t-1)+dN; 
    % first update the jumping of Nt(t) based on a jumping probability of lam(t-1)*dt
%	lam(t)=lam(t-1)+...;% <===== 1?s programming
    lam(t) = lam(t-1) + alp * (lambar - lam(t-1))*dt + bt*dN; 
    % then update lam(t) based on updated dN
    % this is a joint jumping process, interesting
end

figure(2);
subplot(2,1,1);plot(lam);grid on;
title('Hawkes intensity: $\lambda(t)$','interpreter','latex');
subplot(2,1,2);stairs(Nt);grid on;title('N(t)');
disp('Type any key!');pause;

%%%%%%%%%%%%%%
% (3) Simulation of stochastic HW process
% d lam(t) = alpha*(lambar-lam(t))*dt + sigma*dB(t) + beta*dN(t)
% d lam(t) = lam(t) - lam(t-1)
% vix chat? ??Q“Š?“IŠ÷‰ï?C˜¸’†
%%%%%%%%%%%%%%%

lam=zeros(nt,1);

lam(1)=20;
lambar=10;
alp=1.5;
bt=0.5;
sig=0.8;

rng(123456789,'twister');
for t=2:nt
	if rand(1)<lam(t-1)*dt
		dN=1;
	else
		dN=0;
	end
	dB=dt^0.5*randn(1); % add a Brown motion
	Nt(t)=Nt(t-1)+dN;

%	lam(t)=lam(t-1)+...;% <===== 1?s programming

	%lam(t)=lam(t-1);
    lam(t) = lam(t-1) + alp * (lambar - lam(t-1))*dt + sig * dB + bt * dN;
    % consider to add Brown motion in the chatting process? for topic
    % selection?
end

figure(3);
subplot(2,1,1);plot(lam);grid on;
title('Stochastic Hawkes intensity: $\lambda(t)$','interpreter','latex');
subplot(2,1,2);stairs(Nt);grid on;title('N(t)');

% for lagelangri optimization method:
%clc; clear;
%syms x y z t; % define variables x, y, z, lang t
%f(x,y,z)=x + 2*y+3*z;
%g = x^2 + y^2 + z^2 - 4; % set x^2 + y^2 + z^2 - 4 = 0 as the constraint
%L = f - t * g;
%sln = solve(diff(L, x) == 0, diff(L, y) == 0, diff(L, z) == 0, g==0);
%eval(f(sln.x, sln.y, sln.z));