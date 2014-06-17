libname rp "D:\AMH\rp\r5000p989\snplst\";

data rp.r1000p989;
 set rp.r1000p989;
 where replicate<3;
run;
data rp.r2000p989;
 set rp.r2000p989;
 where replicate<1003;
run;

%MACRO seg(num);
%do i=1 %to &num.;
data temp;
  merge rp.r&i.000p989(in=t) rp rp.eig;
  by iid;
  if t;
run;
proc sort data=temp; by replicate pair; run;
data new;
  set rp(obs=0 keep=rs:);
run;
data gmr_vars(keep= name);
 set sashelp.vcolumn;
 where libname= "WORK" and memname= "NEW";
 file "D:\AMH\rp\r5000p989/sas/rpt&sect..sas" ls= 2000 ;

 put "ods listing close;"; 
 put "proc mixed data=temp method=ml noitprint noclprint ratio covtest; 
      class replicate pair; by replicate;
      model " name "=eig1 eig2 eig3 eig4 eig5 eig6 eig7/s notest;
      repeated /type=ar(1) subject=pair; ods output CovParms=mx; run; ";
 put "ods listing;";

 put "data mx; set mx; snp=' " name " '; run;";
 if _n_ = 1 then put "data mx_all; set mx; run;";
 else put "data mx_all; set mx_all mx; run;";
run;
%include "D:\AMH\rp\r5000p989\sas/rpt&sect..sas";
data rp.mx_r&i.p&sect.;
 set mx_all;
 snp=strip(snp);
run;
%end;
%MEND;

%MACRO seg2(num2);
%do i2=1 %to &num2.;
%let sect= %eval(1+(&i2.-1)*111);

data _temp;
  length head $32767.;
  infile "D:\AMH\rp\r5000p989\snplst\rp&sect..raw" obs=1 TRUNCOVER lrecl=10000000 dlm="*" ;
  input head $;
  vars=strip(SUBSTRN(head,index(head,'PHENOTYPE')+10));
  ids=SUBSTRN(head,1,index(head,'PHENOTYPE')+8);
run;
data _null_;
  set _temp;
  if _n_=1 then call symput("var", strip(vars));
  if _n_=1 then call symput("ids", strip(ids));
run;
data rp(drop= iid rename=(niid=iid));
  length &ids $ 25;
  infile "D:\AMH\rp\r5000p989\snplst\rp&sect..raw" firstobs=2 TRUNCOVER lrecl=10000000;
  input &ids $ &var;
  niid= input(iid, best9.);
run;
proc standard data=rp mean=0 std=1 out=rp;
  var &var;
run;
proc sort data=rp out=rp; by iid; run;
%seg(2)
%end;
%MEND;
%seg2(2);
