libname ag "D:\AM\FHS550k\agcon";
%let sect= 1;

proc sort data=ag.agconpairs out=temp; by iid; run;
data temp;
  merge temp(in=t) ag.agconmad1;
  by iid;
  if t;
run;
proc sort data=temp; by pair ipid; run;
proc transpose data=temp out=tempt; 
  by pair ;
  var ss:;
run;
data tempt;
  set tempt;
  col=.;
  if col1=0 & col2=0 then col=0;
  else if col1=1 & col2=1 then col=1;
  else if col1=2 & col2=2 then col=2;
  else if col1=0 & col2=1 then col=3;
  else if col1=1 & col2=0 then col=3;
  else if col1=0 & col2=2 then col=4;
  else if col1=2 & col2=0 then col=4;
  else if col1=2 & col2=1 then col=5;
  else if col1=1 & col2=2 then col=5;
run;
proc freq data=tempt noprint; 
  by pair; 
  tables col / out=freq; 
run;
proc sort data=freq; by col; run;
proc means data=freq ; 
  class col;
  vars PERCENT; 
run;


proc sort data=tempt; by _NAME_; run;
data tempt;
  merge tempt ag.mx_gwmp;
  by _NAME_;
run;
proc sort data=tempt; by pair; run;
proc mixed data=tempt method=ml noitprint noclprint ratio covtest; 
      by pair;
	  where estimate>=0;
      class _NAME_; 
      model COL1=/s notest;
      repeated /type=ar(1) subject=_NAME_; 
      ods output CovParms=ag.pmxagmadp&sect.; 
run;
proc mixed data=tempt method=ml noitprint noclprint ratio covtest; 
      by pair;
	  where estimate<0;
      class _NAME_; 
      model COL1=/s notest;
      repeated /type=ar(1) subject=_NAME_; 
      ods output CovParms=ag.nmxagmadp&sect.; 
run;
