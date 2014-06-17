*libname allp '/lustre/scr/v/i/victorw/allp';
libname allp "D:\AM\FHS550k\pheno";
/*
proc standard data=allp.height_var mean=0 std=1 out=pheno;
  by sex;
  var height;
run;
*/
proc sort data=allp.height_var out=pheno; by iid; run;

%MACRO seg(num);
%do i=1 %to &num.;
data temp;
  merge allp.r&i.000p1023(in=t) pheno allp.eig;
  by iid;
  if t;
run;
proc sort data=temp; by replicate pair; run;
data new;
  set pheno(obs=0 keep=z:);
run;
data gmr_vars(keep= name);
 set sashelp.vcolumn;
 where libname= "WORK" and memname= "NEW";
 file "D:\AM\FHS550k\pheno\tmp/allpt&i..sas" ls= 2000 ;

 put "ods listing close;"; 
 put "proc mixed data=temp method=ml noitprint noclprint ratio covtest; 
      class replicate pair; by replicate;
      model " name "=eig1 eig2 eig3 eig4 eig5 eig6 eig7/s notest;
      repeated /type=ar(1) subject=pair; ods output CovParms=mx; run; ";
 put "ods listing;";

 put "data mx; set mx; pheno=' " name " '; run;";
 if _n_ = 1 then put "data mx_all; set mx; run;";
 else put "data mx_all; set mx_all mx; run;";
run;
%include "D:\AM\FHS550k\pheno\tmp/allpt&i..sas";
data allp.mx_r&i.;
 set mx_all;
 pheno=strip(pheno);
run;

%end;
%MEND;

%seg(6);
*number 6 are for all other pairs;

data allp.mx_rall(keep=pheno Estimate);
 set allp.mx_r1-allp.mx_r5;
 where Subject="PAIR";
 proc sort data=allp.mx_rall; by pheno;
run;

proc means data=allp.mx_rall noprint; by pheno; var Estimate; output out=allp.mxf_rall(drop=_type_ _freq_) mean=rho_rp std=std_rp; run;
