*libname sl '/lustre/scr/v/i/victorw/ag/snplst';
libname ag '/lustre/scr/v/i/victorw/ag/ag';
libname agrul '/lustre/scr/v/i/victorw/ag/agrul';
libname agyl '/lustre/scr/v/i/victorw/ag';
*libname agf '/lustre/scr/v/i/victorw/ag/pfreq';
*libname ag 'D:\AM\FHS550k\ag\mx';
/*
data ag500kr1;
  merge sl.agr1-sl.agr17;
  by iid;
run;
proc sort data=ag500kr1 out=sl.ag500kr1; by iid; run;
data ag500kr2;
  merge sl.agr18-sl.agr34;
  by iid;
run;
proc sort data=ag500kr2 out=sl.ag500kr2; by iid; run;

data sl.ag500kr;
  merge sl.ag500kr1-sl.ag500kr2;
  by iid;
run;
proc sort data=sl.ag500kr; by iid; run;


data ag500km1;
  merge sl.agm1-sl.agm17;
  by iid;
run;
proc sort data=ag500km1 out=sl.ag500km1; by iid; run;
data ag500km2;
  merge sl.agm18-sl.agm34;
  by iid;
run;
proc sort data=ag500km2 out=sl.ag500km2; by iid; run;

data sl.ag500km;
  merge sl.ag500km1 sl.ag500km2;
  by iid;
run;
proc sort data=sl.ag500km; by iid; run;
*/

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

/*
data agf.agfreq1;
  set agf.freq1-agf.freq500;
run;
data agf.agfreq2;
  set agf.freq501-agf.freq1000;
run;
data agf.agfreq3;
  set agf.freq1001-agf.freq1600;
run;
data agf.agfreq4;
  set agf.freq1601-agf.freq2304;
run;
data agyl.agfall;
  set agf.agfreq:;
run;
*/