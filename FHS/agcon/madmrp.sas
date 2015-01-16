libname ag '/lustre/scr/v/i/victorw/ag/snplst2';
libname agp '/lustre/scr/h/e/hexuanl/ag/mrplst';
libname agf '/lustre/scr/h/e/hexuanl/ag/mrpfreq';
libname agt '/lustre/scr/h/e/hexuanl/ag';
%let f= (&sysparm.-1)*50+1;
%let l= (&sysparm.-1)*50+50;
%MACRO seg;
%do sect=&f. %to &l.;
proc sort data=agp.mrp&sect. out=temp; by iid; run;
data temp;
  merge temp(in=t) ag.ag500kconmad;
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
  if col1=0 & col2=0 then col=4;
  else if (col1=0 & col2=1) or (col1=1 & col2=0) then col=2;
  else if col1=1 & col2=1 then col=3;
  else if (col1=2 & col2=1) or (col1=1 & col2=2) then col=5;
  else if (col1=0 & col2=2) or (col1=2 & col2=0) then col=1;
  else if col1=2 & col2=2 then col=6;
  if col=. then delete;
run;
proc freq data=tempt noprint; 
  by pair; 
  tables col / out=agf.freq&sect.; 
run;
proc sort data=agf.freq&sect.; by col; run;
%end;
%MEND;

%seg

/*
proc means data=agt.freq ; 
  class col;
  vars PERCENT; 
run;
*/
