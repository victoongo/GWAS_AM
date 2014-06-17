libname ag '/lustre/scr/y/i/yilanfu/aghrs/ag';
libname agrul '/lustre/scr/y/i/yilanfu/aghrs/agrul';
libname agyl '/lustre/scr/y/i/yilanfu/aghrs';
*libname ag '/lustre/scr/v/i/victorw/aghrs/snplst';
*libname ag '/lustre/scr/v/i/victorw/aghrs/ag';
*libname agrul '/lustre/scr/v/i/victorw/aghrs/agrul';
*libname agf '/lustre/scr/v/i/victorw/aghrs/pfreq';
*libname ag 'D:\AM\FHS550k\ag\mx';
/*
data ag500kr1;
  merge ag.agr1-ag.agr17;
  by iid;
run;
proc sort data=ag500kr1 out=ag.ag500kr1; by iid; run;
data ag500kr2;
  merge ag.agr18-ag.agr34;
  by iid;
run;
proc sort data=ag500kr2 out=ag.ag500kr2; by iid; run;

data ag.ag500kr;
  merge ag.ag500kr1-ag.ag500kr2;
  by iid;
run;
proc sort data=ag.ag500kr; by iid; run;


data ag500km1;
  merge ag.agm1-ag.agm17;
  by iid;
run;
proc sort data=ag500km1 out=ag.ag500km1; by iid; run;
data ag500km2;
  merge ag.agm18-ag.agm34;
  by iid;
run;
proc sort data=ag500km2 out=ag.ag500km2; by iid; run;

data ag.ag500km;
  merge ag.ag500km1-ag.ag500km2;
  by iid;
run;
proc sort data=ag.ag500km; by iid; run;
*/

/*
data agyl.mx_ag_alln1(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mxagp1-ag.mxagp500;
  where Subject="_NAME_";
run;

data agyl.mx_ag_alln2(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mxagp501-ag.mxagp1000;
  where Subject="_NAME_";
run;
data agyl.mx_ag_alln3(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mxagp1001-ag.mxagp1500;
  where Subject="_NAME_";
run;
data agyl.mx_ag_alln4(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mxagp1501-ag.mxagp2000;
  where Subject="_NAME_";
run;
data agyl.mx_ag_alln5(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mxagp2001-ag.mxagp2304;
  where Subject="_NAME_";
run;
data agyl.mx_ag_all;
  set agyl.mx_ag_alln:;
run;

data agyl.mx_agrul_alln1(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul1-agrul.mx_agrul500;
  where Subject="_NAME_";
run;
data agyl.mx_agrul_alln2(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul501-agrul.mx_agrul1000;
  where Subject="_NAME_";
run;
data agyl.mx_agrul_alln3(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul1001-agrul.mx_agrul1500;
  where Subject="_NAME_";
run;
data agyl.mx_agrul_alln4(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul1501-agrul.mx_agrul2000;
  where Subject="_NAME_";
run;
data agyl.mx_agrul_alln5(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul2001-agrul.mx_agrul2304;
  where Subject="_NAME_";
run;
data agyl.mx_agrul_all;
  set agyl.mx_agrul_alln:;
run;
*/
/*
data agf.agfreq1;
  set agf.freq1-agf.freq500;
run;
data agf.agfreq2;
  set agf.freq501-agf.freq1000;
run;
data agf.agfreq3;
  set agf.freq1001-agf.freq1500;
run;
data agf.agfreq4;
  set agf.freq1501-agf.freq2018;
run;
data agf.agfall;
  set agf.agfreq:;
run;
*/

data ag.mx_ag_alln1(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mx_ag_p1-ag.mx_ag_p500;
  where Subject="_NAME_";
run;
data ag.mx_ag_alln2(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mx_ag_p501-ag.mx_ag_p1000;
  where Subject="_NAME_";
run;
data ag.mx_ag_alln3(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mx_ag_p1001-ag.mx_ag_p1500;
  where Subject="_NAME_";
run;
data ag.mx_ag_alln4(keep=PAIR Subject Estimate StdErr ProbZ);
  set ag.mx_ag_p1501-ag.mx_ag_p2018;
  where Subject="_NAME_";
run;
data agyl.mx_ag_all;
  set ag.mx_ag_alln:;
run;

data ag.mx_agrul_alln1(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul_p1-agrul.mx_agrul_p500;
  where Subject="_NAME_";
run;
data ag.mx_agrul_alln2(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul_p501-agrul.mx_agrul_p1000;
  where Subject="_NAME_";
run;
data ag.mx_agrul_alln3(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul_p1001-agrul.mx_agrul_p1500;
  where Subject="_NAME_";
run;
data ag.mx_agrul_alln4(keep=PAIR Subject Estimate StdErr ProbZ);
  set agrul.mx_agrul_p1501-agrul.mx_agrul_p2018;
  where Subject="_NAME_";
run;
data agyl.mx_agrul_all;
  set ag.mx_agrul_alln:;
run;
