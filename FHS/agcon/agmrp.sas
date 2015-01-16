libname ag '/lustre/scr/v/i/victorw/ag/snplst2';
libname agp '/lustre/scr/h/e/hexuanl/ag/mrplst';
libname agmrp '/lustre/scr/v/i/victorw/ag/agmrp';
*libname ag "D:/AM/FHS550k/agcon";
*libname agp "D:/AM/FHS550k/agcon/plst";
%let sect= &sysparm.;

proc sort data=agp.mrp&sect. out=temp; by iid; run;
data temp;
  merge temp(in=t) ag.ag500kr;
  by iid;
  if t;
run;
proc sort data=temp; by pair iid; run;
proc transpose data=temp out=tempt; 
  by pair iid;
  var ss:;
run;
/*proc sort data=tempt; by pair; run;*/
proc mixed data=tempt method=ml noitprint noclprint ratio covtest; 
      by pair;
      class _NAME_; 
      model COL1=/s notest;
      repeated /type=ar(1) subject=_NAME_; 
      ods output CovParms=agmrp.mx_agmrp&sect.; 
run;

