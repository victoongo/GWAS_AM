libname sl '/lustre/scr/v/i/victorw/ag/snplst';
libname agp '/lustre/scr/v/i/victorw/ag/plst';
libname ag '/lustre/scr/v/i/victorw/ag/ag';

%MACRO seg(num);
%do i=0 %to &num.;
%let sect= %eval(&sysparm.+&i.*100);
proc sort data=agp.agp&sect. out=temp; by iid; run;
data temp;
  merge temp(in=t) sl.ag500kr;
  by iid;
  if t;
run;
proc sort data=temp; by pair iid; run;
proc transpose data=temp out=tempt; 
  by pair iid;
  var ss:;
run;
proc sort data=tempt; by pair; run;
proc mixed data=tempt method=ml noitprint noclprint ratio covtest; 
      by pair;
      class _NAME_; 
      model COL1=/s notest;
      repeated /type=ar(1) subject=_NAME_; 
      ods output CovParms=ag.mxagp&sect.; 
run;
%end;
%MEND;
%seg(23);
