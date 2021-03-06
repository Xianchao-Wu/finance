%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

dirname='';%%<------'C:\YourDataDir\';


	filename=strcat(dirname,'GPIF4d00-18.csv');
	S=csvread(filename,2,0);
% csvreadを使うと欠損値はnan(not a number)でなく?A0となることに??意せよ?B





ymd=S(:,1);

%%%%%%%%%%%%%
% TOPIX
%%%%%%%%%%%%%
tpx=S(:,3);



I=find(tpx==0);%欠損値であるdataの添え字
J=find(tpx ~= 0);%欠損値でないdataの添え字
figure(1);plot(tpx(J));title('TOPIX');grid on;
disp('Type any key!')
pause;





%%%%%%%%%%%%%%%%%%%%
% Bond index(BPI)
%%%%%%%%%%%%%%%%%%%%
bpi=S(:,2);
J1=(bpi~=0);
figure(2);plot(bpi(J1));title('BPI');grid on;
disp('Type any key!')
pause;

%%%%%%%%%%%%%%%%
% 分?ﾍ期間を選ぶ
%%%%%%%%%%%%%%%%

%ymds=txt(3:end,1);
%ymd=datestr(datenum(ymds,'yyyy/mm/dd'),'yyyymmdd');
%ymd=str2num(ymd);

%I=find(20070104<= ymd & ymd<=20091231);
I=find(20000104<= ymd & ymd<=20180331);

bpi=S(I,2);
tpx=S(I,3);

I=find(bpi~=0);%欠損値でないdataの添え字
J=find(tpx~=0);%欠損値でないdataの添え字

[K]=intersect(I,J);
St=[bpi(K) tpx(K)];
ymd=ymd(K);

rt=diff(St,1)./St(1:end-1,:);
Rt=cumprod(1+rt)-1;


%plottype='PlainPlot';
plottype='YMPlot';

switch plottype
 case 'PlainPlot'
	figure(3);plot(Rt);title('Cumulative Returns');grid on;
	legend('BPI','TOPIX','Location','Best')

 case 'YMPlot'
	str='Cumulative Returns';lty='b-';lty='-';
	[h]=plot_ts_ym(Rt,ymd(2:end),str,lty,3);
	legend('BPI','TOPIX','Location','Best')

 otherwise
   error('irregular plot label');
end

disp('Type any key!')
pause;

%%%%%%%%%%%%%%%
% 共分散
%%%%%%%%%%%%%%%
ydays=250;
cov(rt)*ydays

%%%%%%%%%%%%%%%
% 相関
%%%%%%%%%%%%%%%

corr(rt)

%%%%%%%%%%%%%%%
% scatterplot
%%%%%%%%%%%%%%%


figure(4);scatter(rt(:,1),rt(:,2));grid on;
xlabel('BPI');ylabel('TPX');

%%%%%%%%%%%
% 標??化
%%%%%%%%%%
 	X=(rt(:,1)-mean(rt(:,1)))/std(rt(:,1));Xname='BPI';
  Y=(rt(:,2)-mean(rt(:,2)))/std(rt(:,2));Yname='TPX';

%%%%%%%%%%%%%%%
% 閾値の範囲を[0,1.0\sigma]までとし?A200分割する?B
%%%%%%%%%%%%%%%
    nstd=1.0;
		qmin=-nstd;qmax=nstd;
		nq=200;
		dq=(qmax-qmin)/nq; 
		q=qmin:dq:qmax;

		for l=1:length(q);
  		rhov(l)=exceedance_corr(-X,Y,q(l));
		end;


		for l=1:length(q);
  		rhov1(l)=exceedance_corr(X,Y,q(l));
		end;

		figure(5);
		plot(q,rhov);grid on;legend('-X vs. Y','Location','Best');
		xlabel(strcat('-',Xname));ylabel(Yname);

		disp('Type any key!')
		pause;

		figure(6);
		subplot(2,1,1)
		plot(q,rhov);grid on;legend('-X vs. Y','Location','Best');
		xlabel(strcat('-',Xname,' vs. ', Yname));ylabel('Ex.Corr');
		subplot(2,1,2)
		plot(q,rhov1);grid on;legend('X vs. Y','Location','Best');
		xlabel(strcat(Xname,' vs. ', Yname));ylabel('Ex.Corr');



    figure(7);scatterhist(X,Y); grid on;
    title('Scatter plot');xlabel(Xname);ylabel(Yname);
    legend('X vs. Y','Location','NorthWest');
