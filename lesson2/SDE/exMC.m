nsimulation = 1000;
seed = 12345678;
rand('state', seed);

premium = zeros(nsimulation, 1)

s = 0;
T = 10; % N(0, T)?
sigma = 0.2; % reuse the old function defined in exBS.m
K = 100; % x reuse the old function defined in exBS.m
for is=1:nsimulation,
    z = normrnd(0,1)
    payoff = max(s * exp(r*T + sigma*T^0.5*z - 0.5*sigma^2*T) - K,0);
    s = s+payoff;
    premium(is) = s/is*exp(-r*T);
    if mod(is, 100) == 0,
        fprintf('discounted average = %15.10f\n', premium(is)); 
    end;
end;