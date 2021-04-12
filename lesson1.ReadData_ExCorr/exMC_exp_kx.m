% ????<<exMC_exp_kx.m>>
nrange=10000;
seed=12345678; % your choice of a seed of the random number
rand('state', seed); % seed is set.

k=2;
sigma=2;
mu=1;
ntimes = 20;
all = 0;

for time=1:ntimes,
    s=0;
    premium=zeros(nrange,1);
    for is=1:nrange,
        z=normrnd(0,1); % standard normal random variate
        payoff = exp(k*(z*sigma+mu));
        s=s+payoff;
        premium(is)=s/is;
        if mod(is,100)==0, 
            fprintf('time=%d, is=%d, discounted average = %15.10f\n', time, is, premium(is));
        end;
    end;
    all = all + premium(nrange);
end;
fprintf('after %d times of simulation, simulated= %15.10f\n', ntimes, all/ntimes);

ref = exp(k*mu + 0.5*k^2*sigma^2);
fprintf('after %d times of simulation, ref value= %15.10f\n', ntimes, ref);