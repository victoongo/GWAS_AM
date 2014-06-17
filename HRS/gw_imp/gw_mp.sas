libname gw '/lustre/scr/h/e/hexuanl/snp';

proc sort data=gw.snps out=gw; by iid; run;
proc sort data=gw.eig out=eig; by iid; run;

data temp;
  merge gw.mp(in=t rename=(fm=fid)) gw(drop=fid) eig;
  by iid;
  if t;
run;
proc sort data=temp; by fid; run;
data new;
  set gw(obs=0 keep=ss:);
run;
data gmr_vars(keep= name);
 set sashelp.vcolumn;
 where libname= "WORK" and memname= "NEW";
 file "/lustre/scr/h/e/hexuanl/snp/gwmpt.sas" ls= 2000 ;

 put "ods listing close;"; 
 put "proc mixed data=temp method=ml noitprint noclprint ratio covtest; 
      class fid; 
      model " name "=eig1 eig2 eig3 eig4 eig5 eig6 eig7/s notest;
      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; ";
 put "ods listing;";

 put "data mx; set mx; snp=' " name " '; run;";
 if _n_ = 1 then put "data mx_all; set mx; run;";
 else put "data mx_all; set mx_all mx; run;";
run;
%include "/lustre/scr/h/e/hexuanl/snp/gwmpt.sas";
%sysexec rm /lustre/scr/h/e/hexuanl/snp/gwmpt.sas ;

data gw.mx_mp(keep=snp rho_mp p_mp);
 set mx_all(rename=(estimate=rho_mp probz=p_mp));
 snp=strip(snp);
 where Subject="fid";
 proc sort; by snp;
run;
