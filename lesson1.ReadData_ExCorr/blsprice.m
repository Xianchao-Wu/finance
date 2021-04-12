function [call,put] = blsprice(so,x,r,t,sig,q)
    %???Black-Scholes put and call pricing.
    % [CALL,PUT] = BLSPRICE(SO,X,R,T,SIG,Q) returns the value of
    % call and put options using the Black-Scholes pricing formula. 
    % SO is the current asset price, X is the exercise price, 
    % R is the risk-free interest rate, 
    % T is the time to maturity of the option in years, 
    % SIG is the standard deviation of the annualized continuously compounded
    % rate of return of the asset (also known as volatility), and 
    % Q is the dividend rate of the asset. The default Q is 0.
    d1 = (log(so./x)+(r-q+sig.^2/2).*t)./(sig.*sqrt(t));
    d2 = d1 - (sig.*sqrt(t));
    call = so.*exp(-q.*t).*normcdf(d1)-x.*(exp(-r.*t).*normcdf(d2));
    put = x.*exp(-r.*t).*normcdf(-d2)-so.*exp(-q.*t).*normcdf(-d1);

end

