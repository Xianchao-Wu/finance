function[h]=plot_ts_ym(yt,ymd,str,lty,fignum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot time-series 'yt' (absolute time of from 1 to 4000) with year-month
% label 'ym'( real year-month labels, horizen axis)
% str; title string
% lty='b-';line type
% fignum; figure number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning off;
if nargin<5 % number of argument input < 5
 fignum=1;
end;

it0=1;nbk=8;
try
	ntm=datenum(num2str(ymd(it0:end)),'yyyymmdd');
catch 
	ntm=datenum(num2str(ymd(it0:end)),'yyyymmdd');
end;

dtm=floor(length(ymd(it0:end))/nbk);

h=figure(fignum); % current function returns h
plot(ntm,yt,lty);
grid on;

title(str,'Interpreter','latex');
%  title(str, 'Interpreter','none');
%  FontSize: 40
%  FontWeight: 'normal'
%  FontName: 'Times New Roman'

xlim([ntm(1),ntm(end)]); % X-axis's range
set(gca,'Xtick',ntm(1:dtm:end)) % X-axis's tick position
% use ntm's values as the value of X-axis
% gca is for current figure's axis's property
datetick('x','mmmyy','keeplimits','keepticks')
% x-axis's data tick property setting.
% mmm is alike 'Sep', 'Nov', and so on which is to use 3-character
% to express a 'month'.
