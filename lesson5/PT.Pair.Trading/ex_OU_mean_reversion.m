% mean-reversion (Ornstein-Uhlenbeck process‚Ìdrift term) - •½‹Ï‰ñ‹A
close all;
clear all:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (–{‘è)
% AR(1); Spd(t)=alp+bt*Spd(t-1)+e(t)?@% AR(1) : auto-regression
% Ž©‰ñ??’ö?C?—¢alp = alpha, bt = beta, e(t) = epsilon(t) = residual error
% Y = Spread(t), X = Spread(t-1)
% 
% dSpd(t)=Spd(t)-Spd(t-1)
%        =alp+bt*Spd(t-1)+e(t)-Spd(t-1) % AR(1),Spd(t)=alp+bt*Spd(t-1)+e(t)
%        =alp-(1-bt)*Spd(t-1)+e(t) -> Why? -> okay ??‘ã“ü‘¦“¾
% ------
% OU process; 
% dr_t=\kappa(rbar-r_t)dt+\sigma \sqrt{dt} \epsilon_t
% dS_t = S(t) - S(t-1) = Kappa * (Sbar - S(t-1)) * dt + sigma * sqrt(dt) * randn(1)
% that is,
% S(t) = S(t-1)+Kappa * (Sbar - S(t-1)) * dt + sigma * sqrt(dt)*randn(1)
% ------
%
% ŒW?””äŠr; why?
% \kappa dt = 1- bt;
% rbar=alp/(\kappa dt)
% \sigma= std(e(t))/\sqrt{dt}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w=csvread('monex_kabucom.csv',1,0);
%names = w(1,:);
% read from 1-th row and 0-th column.
ymd=w(:, 1); % ymd=year-month-day; shape=(574,1)
St=w(:, 2:3); % monex vs. kabucom, two stocks; shape=(574,2)
% column 2 stores monex's stock price; 
% column 3 stores kabucom's stock price

figure(1);
plot(St);
legend('monex', 'kabucom', 'Location', 'best');
title('monex vs. kabucom stock prices');
disp('type any key to continue');
pause;

%%%%%%%%%%%%%%%%%
% ‰ñ‹A
%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spread process‚ð?ì‚é
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nt0,nS]=size(St); 
% [nt0=574, nS=2], so (574, 2)

fprintf('data number=%d\n',nt0); % 574
tm=1:300;%%nt0;

% regress is very important! why
[b,bint,r,rint,stats] = regress(St(tm,1),[ones(length(tm),1) St(tm,2)]);
% St(tm,1): take the 1:300 rows and the 1st column of St, (300,1)
% ones(length(tm)) : build a 300-row column vector to append alpha_i ?Ø•Ð
% x=St(tm, 2), i.e., kabucom stock price
% y=St(tm, 1), i.e., monex stock price
fprintf('beta=%10.5f; alpha=%10.5f\n',b(2), b(1));
% alike, y = beta*x + alpha
% b(2)=beta; b(1)=alpha.

% beta=   0.96071; alpha= -64.29370
spd=St(tm,1)-b(2)*St(tm,2); % spd=(300,1) vector
% spread

figure(2);plot(spd); % spd's shape is (300,1)
grid on;
title(sprintf('Spread=S(monex)-beta*S(kabu.com),beta=%10.2f, alpha=%10.2f',b(2), b(1)));
hold on;
nt=length(spd); % nt=300
mspd=mean(spd); % -64.2937 important! alpha = mean! TODO, mspd = mean of spread value
plot(mspd*ones(nt,1),'m-'); % draw the horizon "mean" line
sig=std(spd); % 15.6913, standard derivation = var^0.5

plot((mspd+sig)*ones(nt,1),'c-.'); % mean + standard derivation
plot((mspd-sig)*ones(nt,1),'c-.'); % mean - standard derivation

plot((mspd+2*sig)*ones(nt,1),'r--'); % mean + 2*standard derivation
plot((mspd-2*sig)*ones(nt,1),'r--'); % mean - 2*standard derivation
legend('spread', 'mean', 'mean+sigma', 'mean-sigma', ...
    'mean+2*sigma', 'mean-2*sigma', ...
    'Location', 'best');
hold off; % lines from 51 to 57, continue plot at figure (2)

disp('type any key to continue');
pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spread process‚ÌOU?„’è
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% important, use spd(1:nt-1) to explain spd(2:nt), auto-regression? or
% self-regression? -> AR=auto-regression
[b,bint,r,rint,stats] = regress(spd(2:nt),[ones(nt-1,1) spd(1:nt-1)]);
% use spread(t-1) to explain spread(t).
% nt=300

%[b,bint,r,rint,stats] = regress(y,X) 
% also returns a vector stats that contains the R2 statistic, 
% the F-statistic and its p-value, and an estimate of the error variance.
% r is for residual, mean(r)=  -3.9686e-15 -> 0, std(r)=4.8190

% R2 = sum_i{(y_hat_i - y_bar)^2} / {sum_i(yi-y^bar)^2}
% in which, y_hat_i = alpha_hat + beta_hat * x_i : model's predicted value
% y_bar = sum(y_i)/n, averaged value of the reference yi
% y_i, reference value

fprintf('self-autoregression beta=%10.4f; alpha=%10.4f\n',b(2), b(1)); 
% self-autoregression beta=   0.95188; alpha=  -3.20694

dt=1/252; % one year's working days 252 = 12(months)*21(days/month)
kappa=(1-b(2))/dt; 
% 252 * (1-beta), in which beta = 0.95188; kappa=12.1262
rbar=b(1)/(kappa*dt); 
% rbar = b(1)/(1-b(2))
sigma= std(r)/dt^0.5; 
% r=residual, it is the output of regress, what is sigma?

fprintf('kappa = %12.10f\n', kappa);
fprintf('rbar  = %12.10f\n', rbar);
fprintf('sigma = %12.10f\n', sigma);
fprintf('R^2   = %12.8f\n', stats(1));
%fprintf('half life [days] = %10.2f\n', half_life(kappa,252));
fprintf('half life [days] = %10.2f\n', log(2)/kappa * 252); 
% from N0 to N0/2, tau = log2/kappa

% check the residual r should follow normal distribution
figure(3); qqplot(normrnd(0,1,size(r)),r);
title('QQplot of the Residual');grid on;

figure(4); histfit(r,50);title('Residual, 50 parts'); grid on;
disp('type any key to continue');
pause;

figure(5); histfit(r,100);title('Residual, 100 parts'); grid on;
disp('type any key to continue');
pause;

figure(6); histfit(r,200);title('Residual, 200 parts'); grid on;

%%%%%%%%%%%
