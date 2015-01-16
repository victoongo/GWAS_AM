*libname ag '/lustre/scr/v/i/victorw/ag/snplst';
*libname ag '/lustre/scr/v/i/victorw/ag/snplst3';
*libname agrul '/lustre/scr/v/i/victorw/ag/agrul3';
libname agrul '/lustre/scr/h/e/hexuanl/ag/agconrul5';
*libname agmrp '/lustre/scr/h/e/hexuanl/ag/agmrp';
*libname agconmrp '/lustre/scr/h/e/hexuanl/ag/agconmrp';
libname agt '/lustre/scr/h/e/hexuanl/ag';
*libname agmrp '/lustre/scr/v/i/victorw/ag/agmrp';
*libname agt '/lustre/scr/v/i/victorw/ag';
*libname ag 'D:\AM\FHS550k\ag\mx';
*libname agat '/lustre/scr/v/i/victorw/ag/agat2';
/*
data mx_agconmrp_all1(drop=Subject);
  set agconmrp.mx_agconmrp1-agconmrp.mx_agconmrp800(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agconmrp_all2(drop=Subject);
  set agconmrp.mx_agconmrp801-agconmrp.mx_agconmrp1600(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agconmrp_all3(drop=Subject);
  set agconmrp.mx_agconmrp1601-agconmrp.mx_agconmrp2469(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data agt.mx_agconmrp_all;
  set mx_agconmrp_all1-mx_agconmrp_all3;
run;
proc sort data=agt.mx_agconmrp_all; by pair col; run;

data agt.mx_agconmp_all(drop=Subject);
  set agconmrp.mx_agconmrp3000-agconmrp.mx_agconmrp3009(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=agt.mx_agconmp_all; by pair col; run;
*/

data mx_agconrul_all1(drop=Subject);
  set agrul.mx_agconrul1-agrul.mx_agconrul800(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agconrul_all2(drop=Subject);
  set agrul.mx_agconrul801-agrul.mx_agconrul1600(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agconrul_all3(drop=Subject);
  set agrul.mx_agconrul1601-agrul.mx_agconrul2137(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;

data agt.mx_agconrul5_all;
  set mx_agconrul_all1-mx_agconrul_all3;
run;
proc sort data=agt.mx_agconrul5_all; by pair; run;

/*
data mx_agmrp_all1(drop=Subject);
  set agmrp.mx_agmrp1-agmrp.mx_agmrp800(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agmrp_all2(drop=Subject);
  set agmrp.mx_agmrp801-agmrp.mx_agmrp1600(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agmrp_all3(drop=Subject);
  set agmrp.mx_agmrp1601-agmrp.mx_agmrp2469(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data agt.mx_agmrp_all;
  set mx_agmrp_all1-mx_agmrp_all3;
run;
proc sort data=agt.mx_agmrp_all; by pair; run;

data agt.mx_agmp_all(drop=Subject);
  set agmrp.mx_agmrp3000-agmrp.mx_agmrp3009(keep=PAIR Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=agt.mx_agmp_all; by pair; run;
*/
/*
data mx_agconrul_all1(drop=Subject);
  set agrul.mx_agconrul1-agrul.mx_agconrul800(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agconrul_all2(drop=Subject);
  set agrul.mx_agconrul801-agrul.mx_agconrul1600(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
data mx_agconrul_all3(drop=Subject);
  set agrul.mx_agconrul1601-agrul.mx_agconrul2137(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;

data agt.mx_agconrul_all;
  set mx_agconrul_all1-mx_agconrul_all3;
run;
proc sort data=agt.mx_agconrul4_all; by pair col; run;
*/
/*
%MACRO seg(num);
%do i=1 %to &num.;
data agt.mx_agconmedats1_all&i.(drop=Subject rename=(colc&i.=col));
  set agat.mx_agconmed&i.at1-agat.mx_agconmed&i.at800(keep=PAIR colc&i. Subject Estimate ProbZ);
  where Subject="_NAME_";
  colc=&i.;
run;
data agt.mx_agconmedats2_all&i.(drop=Subject rename=(colc&i.=col));
  set agat.mx_agconmed&i.at801-agat.mx_agconmed&i.at1600(keep=PAIR colc&i. Subject Estimate ProbZ);
  where Subject="_NAME_";
  colc=&i.;
run;
data agt.mx_agconmedats3_all&i.(drop=Subject rename=(colc&i.=col));
  set agat.mx_agconmed&i.at1601-agat.mx_agconmed&i.at2137(keep=PAIR colc&i. Subject Estimate ProbZ);
  where Subject="_NAME_";
  colc=&i.;
run;
%end;
%MEND;
%seg(2);
data agt.mx_agconmedat2_all;
  set agt.mx_agconmedats1_all1-agt.mx_agconmedats1_all2 
      agt.mx_agconmedats2_all1-agt.mx_agconmedats2_all2
      agt.mx_agconmedats3_all1-agt.mx_agconmedats3_all2;
run;
proc sort data=agt.mx_agconmedat2_all; by pair col; run;
*/

/*
data mx_agconmed_all(drop=Subject);
  set ag.mx_agconmed:(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=mx_agconmed_all; by pair col; run;
data mx_agconrul_all(drop=Subject);
  set ag.mx_agconrul:(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=mx_agconrul_all; by pair col; run;
data ag.mx_agcon200_all(drop=Subject);
  merge mx_agconrul_all(rename=(Estimate=rhorul Probz=prul)) mx_agconmed_all(rename=(Estimate=rhomed Probz=pmed));
  by pair col;
run;
*/
/*
data ag.mx_conmad_rp_all(drop=Subject);
  set ag.mxagconmadrp:(keep=PAIR Subject Estimate StdErr ProbZ);
  where Subject="_NAME_";
run;
*/
/*
data ag.mx_rp_all(drop=Subject);
  set ag.mxagrp:(keep=PAIR Subject Estimate StdErr ProbZ);
  where Subject="_NAME_";
run;
*/
/*
data ag200krp.mx_agconmed200krp_all(drop=Subject);
  set ag200krp.mx_agconmed1-ag200krp.mx_agconmed1000(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=ag200krp.mx_agconmed200krp_all; by pair col; run;
*/
/*
data ag200.mx_agconmed_all(drop=Subject);
  set ag200.mx_agconmed1-ag200.mx_agconmed456(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=ag200.mx_agconmed_all; by pair col; run;
*/
/*
data ag1t.mx_agconmed1t_all(drop=Subject);
  set ag1t.mx_agconmed1-ag1t.mx_agconmed99(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=ag1t.mx_agconmed1t_all; by pair col; run;
*/
/*
data ag1trp.mx_agconmed1t200krp_all(drop=Subject);
  set ag1trp.mx_agconmed1-ag1trp.mx_agconmed1000(keep=PAIR col Subject Estimate ProbZ);
  where Subject="_NAME_";
run;
proc sort data=ag1trp.mx_agconmed1t200krp_all; by pair col; run;
*/
