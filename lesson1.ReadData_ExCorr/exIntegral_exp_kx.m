%%<<exIntegral_exp_kx.m>>
k=2;
sigma=2;
mu=1;
ntimes = 50;
all = 0;

fun=@(z)expkx(z, k, sigma, mu);

E_expkx=integral(fun, zl, zu);
fprintf('use integral, result=%10.4f\n', E_expkx);

ref = exp(k*mu + 0.5*k^2*sigma^2);
fprintf('ref value call price= %15.10f\n', ref);

function fv=expkx(z,k,sigma,mu)
    fv=exp(k*(z*sigma+mu)).*normpdf(z);
end