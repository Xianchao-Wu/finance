%%<<exIntegral.m>>
s0=100;
K=100;
r=0.01;
q=0.005;
sigma=0.2;
T=1;

zl=-100;
zu=100;

fun=@(z)PayoffFunc(z, s0, K, r, q, sigma, T);

call_approx=integral(fun, zl, zu);
fprintf('eurpoean call price, result=%10.4f\n', call_approx);

function fv=PayoffFunc(z,s0,K,r,q,sigma,T)
    fv=exp(-r*T)*max(s0*exp((r-q)*T+sigma*(T^0.5)*z-0.5*sigma^2*T)-K,0).*normpdf(z);
end

%{

min=0;
max=2;
y=5;
fun=@(x)fun1(x,y); % x?????????x????dx
y=integral(fun, min, max)

function func = fun1(x,y)
    func=x.^2 + x + y;
end
%}