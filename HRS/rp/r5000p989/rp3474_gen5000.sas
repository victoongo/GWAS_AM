libname rp '/lustre/scr/v/i/victorw/r5000p989';
*libname rp "D:\AMH\rp";

%macro sample(ind=, npair=, rep=);

proc surveyselect data=rp.rp_all out=sample seed=12478
              method=srs n=&npair. REPS=&rep.;
run;
/*3. generate unique pair ids */
data sample;
  set sample;
  by replicate;
  retain pair;
  if first.replicate then pair=0;
  pair=pair+1;
run;
/*4. merge to the original data file*/
proc sort data=sample;
  by replicate pair;
proc transpose data=sample out=temp(rename=(col1=iid));
  var iid1 iid2;
  by replicate pair;
proc sort data=temp out=rp.r5000p3474o; by iid;run;
%mend;
*%sample(ind=,npair=3474,rep=5000);

data rp.r5000p989all;
  set rp.r5000p3474o(drop=_NAME_);
run;
proc sort data=rp.r5000p989all; by iid; run;

data rp.r1000p989;
set rp.r5000p989all(where=(replicate<1001));
run;
data rp.r2000p989;
set rp.r5000p989all(where=(1000<replicate<2001));
run;
data rp.r3000p989;
set rp.r5000p989all(where=(2000<replicate<3001));
run;
data rp.r4000p989;
set rp.r5000p989all(where=(3000<replicate<4001));
run;
data rp.r5000p989;
set rp.r5000p989all(where=(4000<replicate<5001));
run;

