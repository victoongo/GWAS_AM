*libname ag '/lustre/scr/v/i/victorw/ag/snplst';
*libname ag '/lustre/scr/v/i/victorw/ag/snplst4';
libname ag '/lustre/scr/h/e/hexuanl/ag/snplst4';
*libname agt '/lustre/scr/v/i/victorw/ag';
*libname ag 'D:\AM\FHS550k\ag\mx';
*libname agat '/lustre/scr/v/i/victorw/ag/agat2';

data ag500kconmad1;
  merge ag.agconmad1-ag.agconmad24;
  by iid;
run;
proc sort data=ag500kconmad1 out=ag500kconmad1; by iid; run;
data ag500kconmad2;
  merge ag.agconmad25-ag.agconmad48;
  by iid;
run;
proc sort data=ag500kconmad2 out=ag500kconmad2; by iid; run;
data ag500kconmad3;
  merge ag.agconmad49-ag.agconmad72;
  by iid;
run;
proc sort data=ag500kconmad3 out=ag500kconmad3; by iid; run;
data ag500kconmad4;
  merge ag.agconmad73-ag.agconmad96;
  by iid;
run;
proc sort data=ag500kconmad4 out=ag500kconmad4; by iid; run;
data ag500kconmad5;
  merge ag.agconmad97-ag.agconmad120;
  by iid;
run;
proc sort data=ag500kconmad5 out=ag500kconmad5; by iid; run;
data ag500kconmad6;
  merge ag.agconmad121-ag.agconmad144;
  by iid;
run;
proc sort data=ag500kconmad6 out=ag500kconmad6; by iid; run;

data ag.ag500kconmad;
  merge ag500kconmad1-ag500kconmad6;
  by iid;
run;
proc sort data=ag.ag500kconmad; by iid; run;

