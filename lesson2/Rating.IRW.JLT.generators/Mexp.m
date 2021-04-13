function [expQ]=Mexp(Q)
% t=1
% exp(Q); matrix exponential is calculated, using the eigenvalue module
%
[v,d]=eig(Q);
expQ=v*diag(exp(diag(d)))*inv(v);

% for example, when Q=[1 0; 0 1], then 
% exp(Q) = [e 1; 1 e]
% but expQ here = [e 0; 0 e] - yes by definition

% when Q=[1 0; 0 2], then
% exp(Q) = [e 1; 1 e^2]
% but expQ by Mexp is [e 0; 0 e^2] - yes by definition
% 1. diag(d) -> vector
% 2. exp(diag(d)) -> e^vector
% 3. recover a diagnosis matrix

% which definition is correct? use the defination of expQ, not exp(Q)

