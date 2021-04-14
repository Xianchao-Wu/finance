% ???????33????
% JPX400
% TOPIX500
% ?PCA
% (?????????????=????)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
datadir='';%%'..\..\..\Data\';

datafile='TSE33_00-18.xlsx';   Dataset='TSE33';
%datafile='JPX400_11-18.xlsx'; Dataset='JPX400';
%datafile='TPX500_11-18.xlsx'; Dataset='TPX500'; 
% ?????????????? 


%%%%%%%%%%%%%%%%%%%%%
% data ??
% ?????????
% [w,txt]=xlsread('c:\your_directory\JPX400_11-18.xlsx');
%%%%%%%%%%%%%%%%%%%%%
[w,txt]=xlsread(strcat([datadir,datafile]));% w????txt????
% for TSE33, size(w)=(4494, 34), size(txt)=(4495, 35)
% for 'txt' the first row is the title, and other rows are empty, except
% the first column is "date"

codename=txt(1,2:end); 
% codename='title', 2:end : since the first column is "date"
% 34

ymds=txt(2:end,1); 
% ymds = year-month-day, 
% txt(1,1)="date", txt(2,1)='2000/01/04', txt(end,1)='2018/04/20'
ymd=str2num(datestr(datenum(ymds,'mm/dd/yyyy'),'yyyymmdd')); 
[ymd1, ymd2] = size(ymd)
fprintf('%d %d', ymd1, ymd2); % ymd1=4494; ymd2=1

disp('type any key to continue.');
pause;
%%startDate=20000101
%%endDate=20041231

%%startDate=20050101
%%endDate=20091231

%startDate=20100101
%endDate=20141231

%startDate=20150101
%endDate=20201231

%startDate=20160101
%endDate=20161231

startDate=20000101 % data is from 2000/01/04 to 2018/04/20
endDate=20180420

%sbegidx=1 % 1 wii be skipped later
%sendidx=12

%sbegidx=12 % 1 wii be skipped later
%sendidx=23

sbegidx=23; % 1 wii be skipped later
sendidx=34;


begidx=1;
endidx=1;
for i=1:ymd1
    if ymd(i,1) < startDate
        begidx=i;
    end
    if ymd(i, 1) > endDate
        endidx=i-1;
        break
    else
        endidx=i;
    end
end

disp(begidx)
disp(endidx)
w=w(begidx:endidx,sbegidx:sendidx);

% begidx=1, endidx=4494, sbegidx=23, sendidx=34
fprintf('begidx=%d, endidx=%d, sbegidx=%d, sendidx=%d', begidx,endidx,sbegidx,sendidx);
size(w) % 4494, 12
txt=txt(begidx:endidx, sbegidx:sendidx);
size(txt) % 4494, 12
disp('type any key to continue');
pause;

% size(ymd) = (4494, 1)
clear ymds;
for i=1:length(codename) % length(codename)=34 todo
    [codes(i) Sname(i)] = strtok(codename(i),' '); % why
    % codes(i) = 1*472 cell, alike: 'TOPIX:?I’l'    '1605'    '1721'    '1801'    '1802'    '1803'  
    % Sname(i) = 1*472 cell, alike: ''    ' ?‘?Û?ÎŠJ’é?Î'    ' ƒRƒ€ƒVƒX‚g‚c'    ' ‘å?¬Œš'    ' ‘å—Ñ‘g'    ' ?´?…Œš'    
    % problem, where are these data come from?
    % codes(2) = 1*472 cell, alike: 'TOPIX:?I’l'    '?…ŽY¥”_—Ñ‹Æ:?I’l'    '1721'    '1801'    '1802'    '1803'    '1808'
    % Sname(2) = 1*472 cell, alike: ''    ''    ' ƒRƒ€ƒVƒX‚g‚c'    ' ‘å?¬Œš'    ' ‘å—Ñ‘g'    ' ?´?…Œš'    ' ’·’J?H'    ' Ž­“‡' 
    codes(i);
    Sname(i);
end;


switch Dataset
	case 'TSE33'
		Tpx=w(:,1); % size(Tpx) = (4494, 1), topix values
		St=w(:,2:end); % size(St) = (t=4494, N=33), 33 types of values
	case {'JPX400','TPX500'}
	  ic=find(~isnan(w(1,:)));
		St=w(:,ic);
		Sname=Sname(ic);
		codes=codes(ic);
		for i=1:length(Sname)
			code(i)=str2num(codes{i});
		end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Check missing values
%%%%%%%%%%%%%%%%%%%%%%%%%
[nt,nS]=size(St); % [nt=4494, nS=33]

for i=1:nS % nS=33 number of securities
  fprintf('%2d:%s\n',i,Sname{i});
  [St(:,i)]=SplineInterpMissVal(St(:,i)); 
  % use spline interp to fill the missing values
end;

%%%%%%%%%%%%%%%%%%
% (0) daily[%] returns
%%%%%%%%%%%%%%%%%%
% rate of return 1:(St(i)-St(i-1))/St(i-1),1 daily????? (from t-1 to t)
% rate of return 2: log(St(i)) - log(St(i-1)), 1ŠúŠÔ(daily)‚Ì‘Î?”Žû‰v—¦
rt=diff(St)./St(1:end-1,:)*100;
%%diff(log(St))*100; (St(i) - St(i-1)) / St(i-1), * 100 for percent
[nt,nS]=size(rt); 
% [nt=4493, nS=33], thus rt \in R^{T * N}, 
% T time periods, N for number of securities

%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) mean & cov's computing
%%%%%%%%%%%%%%%%%%%%%%%%%
mu=mean(rt); 
% size(mu) = (1, 33), 2000”N - 2018”N one column with one average value

Sig=cov(rt); 
% size(Sig) = (33, 33), details can be found in "risk management-nakagawa-sensei"

% cov matrix, of size (N*N), one element in this matrix = cov(i, j),
% non-bias cov! Thus use 1/(T-1) instead of 1/T!
% cov(i, j)
%    = E[(ri-E(ri))*(rj-E(rj))] 
%    = (1/(T-1)) * Sum_{t=1..T}{(ri(t)-ri_bar)*(rj(t)-rj_bar)}
% ri_bar = (1/T) * Sum_{t=1..T}(ri(t)) is the sample mean
% for i-th security

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ???????????
% (2) covariance matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[V,D]=eig(Sig); % 


[Dsort,I]=sort(diag(D),'descend');
disp('Dsort=');
disp(Dsort);
disp('I=');
disp(I);
% eigenvalue sorting
% e.g., Dsort = 62.1349/101.1046 = 61.46%
%    4.5636 = 4.51%
%    3.6408 = 3.60%
%    3.0398
%    2.7510
%    2.2588
%    1.7590
%    1.6875 ...
% I = 33  32  31  30  29  and so on, why in this order, not quite
% understand -> by default, D was sorted in small->big order, D[1,1] is the
% smallest and D[N,N] is the biggest.
V=V(:,I); % TODO why? -> 
%since lambda were reordered, then V is also reordered, 
% (by columns) so that still 1-st column V -> 1-st lambda

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (3) computer proportion
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sumup=sum(Dsort)
% s=101.1046, = trace(Sig) = trace(cov(rt)) = sum_i{lambda_i} where i=1..N(e.g, N=33)
switch Dataset
	case 'TSE33'
		figure(1);
		subplot(2,1,1);
        plot(cumsum(Dsort)/sumup,'m+-','Linewidth',1.5);
        grid on;
        title1=sprintf('Contribution to Total Var. (Cov Matrix) %d-%d, %d-%d', ...
            startDate, endDate, sbegidx+1, sendidx)
        title(title1);
		subplot(2,1,2);
        bar(Dsort/sumup);
        grid on;
        % cumsum(Dsort) is alike: ans =   62.1349   66.6985   70.3394
        % 73.3792   76.1302   78.3889   80.1480 ...
	case {'JPX400','TPX500'}
		figure(1);
		nmax=100;
		subplot(2,1,1);plot(cumsum(Dsort(1:nmax))/sumup,'m+-','Linewidth',1.5);
        grid on;
        title('Contribution to Total Var. (Cov Matrix)');
		subplot(2,1,2);bar(Dsort(1:nmax)/sumup);grid on;
end;
disp('type any key to continue');
pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (4) focus on the top-3 biggest eigen values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zt=diag(1./(Dsort.^0.5))*V'*(rt - repmat(mu,nt,1))'; 
% right first item: (11,11)
% right second item: (11,11)
% right third item: ((4493,11)-(4493,11))' -> (11, 4493)
% all right = (11, 4493)
% then transpose -> (4493,11)

% rt = return, size(rt)=(4493,33)?G mu = mean(rt), Šú‘ÒƒŠƒ^?[ƒ“, size(mu)=(1,33)
% implement zt = 1/sqrt(D) * V' * (rt-m) in the PDF file
% size(mu) = (1,33), repmat(mu, nt, 1) ->[duplicate mu vector to build a matrix] (nt=4493, 33)
% diag(1./(Dsort.^0.5)) : (33, 33)
% size(V') : (33, 33)
% (rt-repmat(mu,nt,1))' -> (11, 4493)
zt=zt'; % zt now (T=4493, N=11), from (11, 4493)
figure(2);
subplot(3,1,1);plot(zt(:,1));grid on; %d-%d', startDate, endDate
title1=sprintf('1st factor ~ N(0,1), mean=%d, var=%d, %d-%d, %d-%d', ...
    mean(zt(:,1)), var(zt(:,1)), startDate, endDate, sbegidx+1, sendidx);
title(title1);
subplot(3,1,2);plot(zt(:,2));grid on;
title1=sprintf('2nd factor ~ N(0,1), mean=%d, var=%d, %d-%d, %d-%d', ...
    mean(zt(:,2)), var(zt(:,2)), startDate, endDate, sbegidx+1, sendidx);
title(title1);
subplot(3,1,3);plot(zt(:,3));grid on;
title1=sprintf('3rd factor ~ N(0,1), mean=%d, var=%d, %d-%d, %d-%d', ...
    mean(zt(:,3)), var(zt(:,3)), startDate, endDate, sbegidx+1, sendidx);
title(title1);

disp('type any key to continue');
pause;

%figure(20);
%qqplot(zt(:,1));title(sprintf('qqplot for 1st factor %d-%d', startDate, endDate));
%figure(21);
%qqplot(zt(:,2));title(sprintf('qqplot for 2nd factor %d-%d', startDate, endDate));
%figure(22);
%qqplot(zt(:,3));title(sprintf('qqplot for 3rd factor %d-%d', startDate, endDate));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (5)  factor loading (V(:,1)*sqrt(Dsort(1)),V(:,2)*sqrt(Dsort(2)),V(:,3)*sqrt(Dsort(3)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
% factor loading of z1 = V(:,1) * lambda1^0.5
% factor loading of z2 = V(:,2) * lambda2^0.5
% factor loading of z3 = V(:,3) * lambda3^0.5
bt=[V(:,1)*Dsort(1)^0.5 V(:,2)*Dsort(2)^0.5 V(:,3)*Dsort(3)^0.5];
subplot(3,1,1);bar(bt(:,1));grid on;
title1=sprintf('1st factor loading, mean(V1 * sqrt(D1))=%d, Var=%d, %d-%d, %d-%d', ...
    mean(bt(:,1)), var(bt(:,1)), startDate, endDate, sbegidx+1, sendidx)
title(title1);

subplot(3,1,2);bar(bt(:,2));grid on;%title('2nd factor loading');
title2=sprintf('2nd factor loading, mean(V2 * sqrt(D2))=%d, Var=%d, %d-%d, %d-%d', ...
    mean(bt(:,2)), var(bt(:,2)), startDate, endDate, sbegidx+1, sendidx)
title(title2);

subplot(3,1,3);bar(bt(:,3));grid on;%title('3rd factor loading');
title3=sprintf('3rt factor loading, mean(V3 * sqrt(D3))=%d, Var=%d, %d-%d, %d-%d', ...
    mean(bt(:,3)), var(bt(:,3)), startDate, endDate, sbegidx+1, sendidx)
title(title3);

disp('type any key to continue');
pause;

%return;

figure(4);
plot3(bt(:,1),bt(:,2),bt(:,3),'.');
title('Factor Loadings');
xlabel('FactorLoading1');ylabel('FL2');zlabel('FL3');

disp('type any key to continue');
pause;
%return;










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cholesky and Monte-Carlo simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[G]=chol(Sig);
%L=G';

switch Dataset
	case 'TSE33'
		%I=[29 33];% sub-matrix
        I=[6 10];
	case 'TPX500'
		I=[29 30];% sub-matrix
	case 'JPX400'
		i1=find(strcmp(Sname,' ‚è‚»‚È‚g‚c'));
		i2=find(strcmp(Sname,' ŽOˆä?Z—Fƒgƒ‰'));
		I=[i1 i2];% sub-matrix
end;

disp('Sig(I,I)');
disp(Sig(I,I));
%    3.7609    2.9386
%    2.9386    4.5048
[G]=chol(Sig(I,I)); % size(Sig)=(11, 11)
L=G';

mu=mean(rt(:,I));
mu=mu';

N=1000;% # of scenarios

Z=randn(N,length(I)); % (1000, 2)
Rt=repmat(mu,1,N) + L*Z';
% use, mu(2,1) -> repmat -> (2, 1000)
% L=(2,2)
% Z'=(2,1000)
% LZ' = (2,1000)
% Rt = (2,1000)

Rt=Rt'; % (1000,2)
figure(5);
scatter(Rt(:,1),Rt(:,2));
grid on;
xlabel(Sname{I(1)});
ylabel(Sname{I(2)});
%%%%%%%%%%%%%%
