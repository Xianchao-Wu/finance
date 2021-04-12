%% module saved in file <<exBS.m>>
so=100;
x=100;
r=0.01;
t=1;
sig=0.2;
q=0.005;
[call put]=blsprice(so,x,r,t,sig,q);
fprintf('call=%10.4f, put=%10.4f\n', call, put);
%
% using some underlying ?prices  to compute option ?price and plot
%
so=90:1:110;
[call put]=blsprice(so,x,r,t,sig,q);
figure(1);
%plot(so,call);
plot(so,call,so,put);
legend('call','put');
xlabel('Stochastic price');
ylabel('Option prices');
title('Black-Scholes formula');

so=1.15;
x=1.17;
r=0.02;
t=14/365.0;
sig=0.15;
q=0.000;
[call put]=blsprice(so,x,r,t,sig,q);
fprintf('call=%10.4f, put=%10.4f\n', call, put);

sig=0.00:0.001:0.99;
%r=0.00:0.001:0.99
[call put]=blsprice(so,x,r,t,sig,q);
figure(2);
plot(sig,call);
plot(sig,call,sig,put);
legend('call','put');
xlabel('Stochastic price');ylabel('Option prices');title('BS formula');
find(call>=0.0064 & call <= 0.0066)
sig(find(call>=0.0064 & call <= 0.0066))
%r(find(call>=0.0064 & call <= 0.0066))
call(155:157)
