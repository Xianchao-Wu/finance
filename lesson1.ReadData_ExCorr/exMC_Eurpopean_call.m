%<<exMC.m>>
nrange=10000;
seed=12345678; % your choice of a seed of the random number
rand('state',seed); % seed is set.

s0=100;
K=100;
r=0.01;
sigma=0.2;
T=1;
q=0.005;
ntimes = 10;
all = 0;
for time=1:ntimes,
    s=0;
    premium=zeros(nrange,1);
    for is=1:nrange,
        z=normrnd(0,1); % standard normal random variate
        payoff=max(s0*exp(r*T-q*T+sigma*T^0.5*z-0.5*sigma^2*T)-K,0);
        s=s+payoff;
        premium(is)=s/is*exp(-r*T);
        if mod(is,10000)==0, 
            fprintf('time=%d, discounted average = %15.10f\n', time, premium(is));
        end;
    end;
    all = all + premium(nrange);
end;
fprintf('after %d times of simulation, call price= %15.10f\n', ntimes, all/ntimes);