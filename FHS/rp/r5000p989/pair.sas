libname rp 'D:\AM\FHS550k\rp\r5000p989';

data rp.r5000p989all;
  set rp.r5000p989o(drop=_NAME_);
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

