function[St]=SplineInterpMissVal(St)
	ic=find(isnan(St) | St==0);
	if ~isempty(ic)
		fprintf('Spline interpolation of missing values\n');

		nt=length(St);
		tm=1:nt;
		tm1=setdiff(tm,ic);% regular price dates
		St1=St(tm1);
		St=spline(tm1,St1,tm);St=St';
	end;

