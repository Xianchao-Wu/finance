so = 100;
x = 100;
r = 0.01;
t=1;
sig=0.2;
q=0.005;
[call, put] = blsprice2(so, x, r, t, sig, q)
fprintf('call=%10.3f, put=%10.3f\n', call, put)
so = 90:1:100
[call, put] = blsprice2(so, x, r, t, sig, q)

plot(so, call)
plot(so, call, so, put)
legend('call', 'put')

xlabel('Stock price'); ylabel('Option prices'); title('BS formula');