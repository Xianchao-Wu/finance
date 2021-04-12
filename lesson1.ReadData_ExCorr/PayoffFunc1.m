function fv=PayoffFunc1(z,s0,K,r,q,sigma,T)
    fv=exp(-r*T)*max(s0*exp((r-q)*T+sigma*(T^0.5)*z-0.5*sigma^2*T)-K,0).*normpdf(z);
end

