libname ag '/lustre/scr/v/i/victorw/ag/snplst';
libname agrul '/lustre/scr/v/i/victorw/ag/agrul';
libname agyl '/lustre/scr/v/i/victorw/ag';
*libname ag 'D:\AM\FHS550k\ag\mx';
/*
data ag500kr1;
  merge ag.agr1-ag.agr24;
  by iid;
run;
proc sort data=ag500kr1 out=ag.ag500kr1; by iid; run;
data ag500kr2;
  merge ag.agr25-ag.agr48;
  by iid;
run;
proc sort data=ag500kr2 out=ag.ag500kr2; by iid; run;
data ag500kr3;
  merge ag.agr49-ag.agr72;
  by iid;
run;
proc sort data=ag500kr3 out=ag.ag500kr3; by iid; run;
data ag500kr4;
  merge ag.agr73-ag.agr96;
  by iid;
run;
proc sort data=ag500kr4 out=ag.ag500kr4; by iid; run;
data ag500kr5;
  merge ag.agr97-ag.agr120;
  by iid;
run;
proc sort data=ag500kr5 out=ag.ag500kr5; by iid; run;
data ag500kr6;
  merge ag.agr121-ag.agr144;
  by iid;
run;
proc sort data=ag500kr6 out=ag.ag500kr6; by iid; run;

data ag.ag500kr;
  merge ag.ag500kr1-ag.ag500kr6;
  by iid;
run;
proc sort data=ag.ag500kr; by iid; run;
*/
/*
data ag500km1;
  merge ag.agm1-ag.agm24;
  by iid;
run;
proc sort data=ag500km1 out=ag.ag500km1; by iid; run;
data ag500km2;
  merge ag.agm25-ag.agm48;
  by iid;
run;
proc sort data=ag500km2 out=ag.ag500km2; by iid; run;
data ag500km3;
  merge ag.agm49-ag.agm72;
  by iid;
run;
proc sort data=ag500km3 out=ag.ag500km3; by iid; run;
data ag500km4;
  merge ag.agm73-ag.agm96;
  by iid;
run;
proc sort data=ag500km4 out=ag.ag500km4; by iid; run;
data ag500km5;
  merge ag.agm97-ag.agm120;
  by iid;
run;
proc sort data=ag500km5 out=ag.ag500km5; by iid; run;
data ag500km6;
  merge ag.agm121-ag.agm144;
  by iid;
run;
proc sort data=ag500km6 out=ag.ag500km6; by iid; run;

data ag.ag500kma;
  merge ag.ag500km1-ag.ag500km3;
  by iid;
run;
data ag.ag500kmb;
  merge ag.ag500km4-ag.ag500km6;
  by iid;
run;
data ag.ag500km;
  merge ag.ag500kma ag.ag500kmb;
  by iid;
run;
proc sort data=ag.ag500km; by iid; run;
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
