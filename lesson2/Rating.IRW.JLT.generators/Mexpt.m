function [expQ]=Mexpt(Q,t)
%
% exp(tQ); matrix exponential times t is calculated, using the eigenvalue module
%

[v,d]=eig(Q);
expQ=v*diag(exp(t*diag(d)))*inv(v);

% for example,
% if Q = [1 0; 0 2], then
% t=1, expQ = [e 1; 1 e^2]
% t=2, expQ = [e^2 0; 0 e^4]

