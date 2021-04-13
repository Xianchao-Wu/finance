%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <<ex.m>>
%
% JLT : for Jarrow, Lando and Turnbull 's 1997 paper of "A markov model for the term structure of credit risk spread"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%P=[0.8929 0.0963 0.0078 0.0019 0.0030 0.0000 0.0000 0.0000;...
%   0.0086 0.9010 0.0747 0.0099 0.0029 0.0029 0.0000 0.0000;...
%   0.0009 0.0291 0.8894 0.0649 0.0101 0.0045 0.0000 0.0009;...
%   0.0006 0.0043 0.0656 0.8427 0.0644 0.0160 0.0018 0.0045;...
%   0.0004 0.0022 0.0079 0.0719 0.7764 0.1043 0.0127 0.0241;...
%   0.0000 0.0019 0.0031 0.0066 0.0517 0.8246 0.0435 0.0685;...
%   0.0000 0.0000 0.0116 0.0116 0.0203 0.0754 0.6493 0.2319;...
%   0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 1.0000]; 
P=[86.99 9.12 0.53 0.05 0.08 0.03 0.05 0.00;...
0.51 86.95 7.91 0.50 0.05 0.07 0.02 0.02;...
0.03 1.72 88.00 5.22 0.30 0.12 0.02 0.06;...
0.01 0.10 3.45 85.79 3.73 0.49 0.11 0.17;...
0.01 0.03 0.12 4.88 77.19 6.79 0.58 0.68;...
0.00 0.02 0.08 0.18 5.05 74.34 4.44 3.59;...
0.00 0.00 0.12 0.21 0.59 13.18 43.46 26.82;...
0.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00];

P = P / 100;

% size(P) = 8 8, 8 rows and 8 columns, rating transferring matrix
%%  sum(P,2) ?s‚Ì˜a?@‚P‚ÌŠm”F
%%% diagonalization %%%%%%%%%%%%%%%
[v,d] = eig(P); % P = V*D*V^{-1}

disp(d)
%disp(min(d))
%disp(max(d))
if all(abs(diag(d)-1)<1),
  fprintf('series converges around 1\n'); % yes
else
  fprintf('series does not converge around 1\n'); % no
end;

% P=[0.9 0.1; 0 0]; 
%%% construction of the generator matrix %%%%%%%%%%%%%%%
nc=size(P,1); % nc = number of rows of P, nc=8
I=diag(diag(ones(nc))); % is I = eye(nc) also okay here?


R=P-I; % P = exp(logP) = exp (log(I+P-I)), 
%use Taylor extension for log(1+x) = x - x^2/2 + x^3/3 - x^4/4 + ..., thus we have
% exp(Q) = P, so, Q=log(I+P-I)=(P-I) - (P-I)^2/2 + (P-I)^3/3 - (P-I)^4/4 +
% ... which is exactly IRW method for computing the "generator" of P. (1.3)
% page 3
np=16; % max degree of polynomial
Q=zeros(size(P));
for i=1:np,
  Q=Q+(-1)^(i-1)*R^i/i; % based on (1.3) page 3 of Theorem 1.1 [Israel-Rosenthal-Wei, IRW method]
end;


%%%%%% test the generator %%%%%%%%%%%
%%  sum(Q,2)?@?s‚Ì˜a?@‚O‚ÌŠm”F
%%  bar3(Q)?@‘ÎŠp—v‘f‚Ì•‰?A”ñ‘ÎŠp—v‘f‚Ì”ñ•‰‚ÌŠm”F?GŽÀ?Û‚Í•‰‚Ì—v‘f‚ ‚è?@

% matrix‚ÌŽw?”?æ‚ÌŒvŽZ?Amatlab‚Ì“Á’¥
Mexp(Q)-P % Mexp(Q) should be as close to P as possible, thus Mexp(Q) - P ~= [0]_8*8
disp('Mexp(Q) - P = (should be as close to P as possible)')
disp(Mexp(Q) - P)
disp('Q row-sums')
% ??ˆê—ñ‹?˜a?F
%disp(sum(Q, 1)) % sum = [-0.1024    0.0410    0.0645    0.0134   -0.0787    0.0516   -0.3616    0.3737] result is one row vector
% ??ˆê?s‹?˜a?F
disp(sum(Q, 2)) % sum = [0.0020    -0.0000   -0.0002   -0.0001   -0.0001   -0.0001    0.0001 0]'
% before norm(P-exp(Q_{IRW})) =    0.0000000062
fprintf('before norm(P-exp(Q_{IRW})) = %15.10f\n', sum(sum(abs(P-Mexp(Q))))); 
disp('press any key to continue')
pause


%% modify the negative off-diagonal elements, ?C‰ü?Šp?”VŠO“I??
disp('before modifying the negative off-diagonal elements in Q')
disp(Q)
disp(det(Q)) % 0
QT=Q;
for i=1:nc,
 j=1:nc;
 k=j(j~=i);
 Q(i,k)=max(QT(i,k),0);
 Q(i,i)=QT(i,i)+sum(min(QT(i,k),0)); % TODO why need to update Q(i,i)? to keep row-sums = 0? by (1.3)
 % e.g., if one off-diagnonal element changed from -0.1 to 0, then -0.1 is
 % appended to the diagnonal element of that row to keep 0 + X - 0.1 = 0
  % added to the diagnonal elemnt of that row.
 
 % old, -0.1 + X = 0, now 0 + X + (-0.1)
  
 % Q has two conditions:
 %(1) Q's off-diagnonal elements should be >= 0; 
 %(2) sum up each row of Q is 0 (row-sums=0)
end;
disp('after modifying the negative off-diagonal elements in Q')
disp(Q)
disp(det(Q)) % 0

X=P-Mexp(Q);
% norm(P-exp(Q_{IRW})) =    0.0027361735
fprintf('norm(P-exp(Q_{IRW})) = %15.10f\n', sum(sum(abs(X)))); % what is IRW? = Israel-Rosenthal-Wei, abbreviation name

figure(1); bar3(Mexp(Q));title('Transition Probability of Ratings in one-year, which is computed by ');
figure(2); bar3(Q);      title('Generator Q (Q is obtained by IRW-method in (1.3)) of Transition Probability');
disp('type any key to continue')
pause;

%%% JLT (Benchmark-Test) %%%%%%%
% TODO what is the formula of this computing? using JLT method to compute Q
% (QJLT)
QJLT=zeros(size(P));
% TODO why i is from 1 to (nc-1); why not i from 1 to nc? since the last
% row is always [0, .., 0, 1] with nc-1 number of 0 and only one 1.
for i=1:(nc-1), 
 QJLT(i,i)=log(P(i,i));
 j=1:nc;
 k=j(j~=i);
 QJLT(i,k)=P(i,k)*log(P(i,i))/(P(i,i)-1); % TODO to find the equation from the paper -> 
 % from the book of:Rating Based Modeling of Credit Risk: Theory and Application of Migration ...
% By Stefan Trueck, Svetlozar T. Rachev; Page 89
% equation:
% (1) when i=j, diagnonal elements, Q(i,i) = log(P(i,i))
% (2) when i!=j, Q(i,k) = P(i,k) * log(P(i,i)) / (P(i,i) - 1)
end;


Y=P-Mexp(QJLT);
% another approximiate computing of Q (P's generator matrix)
fprintf('norm(P-exp(Q_{JLT})) = %15.10f\n', sum(sum(abs(Y))));
fprintf('Compare this Q_{JLT} with the above Q_{IRW}\n');

%norm(P-exp(Q_{IRW})) =    0.0027361735 -> better
%norm(P-exp(Q_{JLT})) =    0.1164668592
%Compare this Q_{JLT} with the above Q_{IRW}

%%%%%%%%%%%%%%%%  Transition Matrix of each prespecified term %%%%%%

fprintf('\n\n*************** 1 day P *******************\n');
P1D=Mexpt(Q,1/(12 * 30)) % why not 12 * 30, used 12 originally, TODO

fprintf('\n\n*************** 1 month P *******************\n');
P1M=Mexpt(Q,1/12)

fprintf('\n\n*************** 1 year P *******************\n');
P1Y=Mexpt(Q,1)


fprintf('\n\n*************** 10 year P *******************\n');
P10Y=Mexpt(Q,10)


fprintf('\n\n*************** 35 year P *******************\n');
P35Y=Mexpt(Q,35)

% DEF_PR = (def)ault (pr)obabilities:
DEF_PR=[P1D(1:(end-1),end) P1M(1:(end-1),end) P1Y(1:(end-1),end) P10Y(1:(end-1),end) P35Y(1:(end-1),end)];
% the 8-th column, of rows from 1 to 7
% totally 5 columns, which correspond to 5 types of time periods (rating
% vectors)
figure(4);
plot(DEF_PR);grid on;title('Default probability');xlabel('rating');ylabel('default probability');
legend('1D', '1M', '1Y', '10Y', '35Y','Location','Best'); %,0); % TODO

%figure(45);
%plot(DEF_PR);grid on;title('Default probability');xlabel('rating');ylabel('default probability');
%legend('1D', '1M', '1Y', '10Y', '35Y'); %,0); % TODO


disp('type any key to continue');
pause;

figure(5);
surf(1:nc,1:nc,P35Y'); % ‰æŽO?‹È–Ê?i?F?j?
title('Transition Probability after 35 years');xlabel('rating(initial)');ylabel('rating(final)');
shading interp; % ?‰e?‡??Ž¦colors

disp('type any key to continue');
pause;

figure(6);
surf(1:nc,1:nc,P'); % ‰æŽO?‹È–Ê?i?F?j?
title('Transition Probability for 1 year');xlabel('rating(initial)');ylabel('rating(final)');
shading interp; % ?‰e?‡??Ž¦colors

%dingchangfenbu(P)


