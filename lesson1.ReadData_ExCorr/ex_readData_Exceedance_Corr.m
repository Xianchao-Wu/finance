% (1) read xlsx excel data
% (2) plot graph
% (3) simple examples of return rates, accumulated return and so on
% (4) exceedance correlation computing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

dirname='';%%<------'C:\YourDataDir\';

filename=strcat(dirname,'GPIF4d00-18.xlsx');

[S,txt]=xlsread(filename);

%Tbl=readtable(filename);

iMAC=0;
if iMAC
	filename=strcat(dirname,'GPIF4d00-18.csv');
	S=csvread(filename,2,0);
end;

%%%%%%%%%%%%%
% TOPIX
%%%%%%%%%%%%%
tpx=S(:,2); % topix is in the second column, column index starts >= 0
% 0-th column = date?[this is true]
% 1-th column = nomura bpi index
% 2-th column = topix index (with data from 9/26/2000, 
% i.e., no data at the first 193 lines)...
S(1,:)
S(1,2)
S(2,:)
S(2,2)

I=find(isnan(tpx));% index list of default values (missing values)
J=find(~isnan(tpx));% index list without default values (no missing values)
%figure(10); plot(tpx(I)); title('TOPIX-with nan'); grid on;
%disp('type any key!')
%pause;

figure(1);plot(tpx(J));title('TOPIX');grid on;
disp('Type any key!')
pause;





%%%%%%%%%%%%%%%%%%%%
% Bond index(BPI) Nomura's BPI
%%%%%%%%%%%%%%%%%%%%
bpi=S(:,1); % 1-th column is NOMURA bpi index
J1=~isnan(bpi);
figure(2);plot(bpi(J1));title('BPI');grid on;
disp('Type any key!')
pause;

%%%%%%%%%%%%%%%%
% select the period for computing
%%%%%%%%%%%%%%%%

ymds=txt(3:end,1);
txt(1,:)
txt(2:5,:)
%ymd=datestr(datenum(ymds,'yyyy/mm/dd'),'yyyymmdd');
ymd=datestr(datenum(ymds,'mm/dd/yyyy'), 'yyyymmdd');
ymd=str2num(ymd);

%I=find(20070104<= ymd & ymd<=20091231);
I=find(20000104<= ymd & ymd<=20180331);

bpi=S(I,1); % column-1's bpi values
tpx=S(I,2); % column-2's topix values

I=find(~isnan(bpi));% bpi's indices without missing values
J=find(~isnan(tpx));% topix's indices without missing values

[K]=intersect(I,J); % take the intersection of two datasets
St=[bpi(K) tpx(K)]; % St=matrix, size=(4297, 2)
ymd=ymd(K);

% compute daily-return rate
rt=diff(St,1)./St(1:end-1,:); 
% for ALL the columns of St, do rt=(S(t)-S(t-1))/S(t-1)
% diff(St, 1), the second parameter "1" means one-order difference
% if diff(St, 2), "2" means two-order difference, that is alike
% diff(diff(St,1),1) = diff(St,2)

% cumulated product
Rt=cumprod(1+rt)-1; 
% Rt what is Rt used for?-> alike 
% M0 * (1+return.rate.1) * (1+return.rate.2) * ...


%plottype='PlainPlot';
plottype='YMPlot';

switch plottype
 case 'PlainPlot'
	figure(3);plot(Rt);title('Cumulative Returns');grid on;
	legend('BPI','TOPIX','Location','Best')

 case 'YMPlot'
	str='Cumulative Returns';
    lty='b-';
    lty='-';
    % Rt=BPI and Topix's returns
    % ymd(2:end)=year-month
    % title=str='Cumulative Returns'
    % lty = line's type
    % 3 = ?
	[h]=plot_ts_ym(Rt,ymd(2:end),str,lty,3); % ym=year-month
    % label (horizon) from 0..4000 to real year-month labels
	legend('BPI','TOPIX','Location','Best')

 otherwise
   error('irregular plot label');
end

%figure(30); 
%subplot(2,1,1);
%plot(Rt); grid on; title('Cumulative Returns-1'); grid on;
%legend('BPI', 'TOPIX', 'Location', 'Best')
%subplot(2,1,2);
%str='Cumulative Returns-2'; lty='b-'; lty='-';
%[h] = plot_ts_ym(Rt,ymd(2:end), str, lty, 3);
%legend('BPI', 'TOPIX', 'Location', 'Best')
%disp('type any key to continue');
%pause;

disp('Type any key!')
pause;

%%%%%%%%%%%%%%%
% co-variance
%%%%%%%%%%%%%%%
ydays=250;
sprintf('cov(rt)*ydays:');
cov(rt)*ydays

%%%%%%%%%%%%%%%
% correlation coefficient
%%%%%%%%%%%%%%%
sprintf('corr(rt):');
corr(rt)

%%%%%%%%%%%%%%%
% scatter plot
%%%%%%%%%%%%%%%


figure(4);
scatter(rt(:,1),rt(:,2));
grid on;
xlabel('BPI');
ylabel('TPX');
disp('type any key to continue');
pause;

%%%%%%%%%%%
% normalization
%%%%%%%%%%
X=(rt(:,1)-mean(rt(:,1)))/std(rt(:,1)); % alike (x-mean)/std
Xname='BPI';

Y=(rt(:,2)-mean(rt(:,2)))/std(rt(:,2));
Yname='TPX';

%%%%%%%%%%%%%%%
% threshold ranges = [-1.0, 1.0] with 200 points
%%%%%%%%%%%%%%%
nstd=1.0;
qmin=-nstd;qmax=nstd; % [-1.0, 1.0]
nq=200;
dq=(qmax-qmin)/nq; % 2/200 = 0.01 as step.length
q=qmin:dq:qmax; % [-1 -0.99 ... -0.01 0 0.01 ... 0.99 1]

for l=1:length(q);
    % -X = -BPI, why?
    rhov(l)=exceedance_corr(-X,Y,q(l)); 
    % iteratively setting the filtering threshold
end;


for l=1:length(q);
    rhov1(l)=exceedance_corr(X,Y,q(l));
end;

figure(5);
plot(q,rhov);grid on;legend('-BPI vs. TPX','Location','Best');
xlabel(strcat('-',Xname));
ylabel(Yname); %strcat - join two strings together

disp('Type any key!')
pause;

figure(6);
subplot(2,1,1)
% rhov, -X vs. Y
plot(q,rhov);grid on;legend('-X vs. Y','Location','Best');
xlabel(strcat('-',Xname,' vs. ', Yname));ylabel('Ex.Corr');
subplot(2,1,2)
% rhov1, X vs. Y
plot(q,rhov1);grid on;legend('X vs. Y','Location','Best');
xlabel(strcat(Xname,' vs. ', Yname));ylabel('Ex.Corr');

disp('Type any key to continue');
pause;

figure(7);
scatterhist(X,Y); 
grid on;
title('Scatter plot');
xlabel(Xname);
ylabel(Yname);
legend('X vs. Y','Location','NorthWest');% up-left corner to show legend
disp('type any key to continue!');
pause;

figure(8); 
scatterhist(-X, Y); 
grid on; % scatter + histgram a combination of two types of figures
title('Scatter plot'); 
xlabel(strcat('-', Xname)); 
ylabel(Yname);
legend('-X vs. Y', 'Location', 'NorthWest'); 

