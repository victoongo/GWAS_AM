libname ag '/lustre/scr/v/i/victorw/ag/snplst3';
libname agp '/lustre/scr/v/i/victorw/ag/palst';
libname agrul '/lustre/scr/v/i/victorw/ag/agrul3';
*libname ag "D:/AM/FHS550k/agcon";
*libname agp "D:/AM/FHS550k/agcon/plst";
%let sect= &sysparm.;

proc sort data=agp.agconpa&sect. out=temp; by iid; run;
data tempm;
  merge temp(in=t drop=ipid) ag.ag500kconmad;
  by iid;
  if t;
run;
proc sort data=tempm; by pair; run;
proc transpose data=tempm out=tempm; 
  by pair;
  var ss:;
run;
data tempm(keep=pair _NAME_ col);
  set tempm;
  col=.;
  if col1=0 & col2=0 then col=1;
  else if (col1=0 & col2=1) or (col1=1 & col2=0) then col=0;
  else if col1=1 & col2=1 then col=0;
  else if (col1=2 & col2=1) or (col1=1 & col2=2) then col=1;
  else if (col1=0 & col2=2) or (col1=2 & col2=0) then col=0;
  else if col1=2 & col2=2 then col=1;
  if col=. then delete;
run;
proc sort data=tempm; by pair _NAME_; run;
data tempr;
  merge temp(in=t) ag.ag500kr;
  by iid;
  if t;
run;
proc sort data=tempr; by pair ipid; run;
proc transpose data=tempr out=tempr; 
  by pair ipid;
  var ss:;
run;
proc sort data=tempr; by pair _NAME_; run;
data tempr;
  merge tempr(drop=ipid) tempm(in=t);
  by pair _NAME_;
  if t;
run;
proc sort data=tempr; by pair col; run;
ods listing close;
proc mixed data=tempr method=ml noitprint noclprint ratio covtest; 
  class pair _NAME_; 
  by pair col;
  model col1=/s notest;
  repeated /type=ar(1) subject=_NAME_; 
  ods output CovParms=agrul.mx_agconrul&sect.; 
run;
ods listing;
