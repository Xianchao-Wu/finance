function[rho]=exceedance_corr(X,Y,q)

% X for BPI, nomura's bound index
% Y for TPX, topix
% q for threshold

% for growing up return.rates >=0 (positive)
if q>=0, 
	k=find(X>=q & Y>=q);
	try
		rho=corr(X(k),Y(k));
	catch
		rho=nan;
	end;
% for dropping down return.rates < 0 (negative)
else
	k=find(X<q & Y<q);
	try
		rho=corr(X(k),Y(k));
	catch
		rho=nan;
	end;
end;


