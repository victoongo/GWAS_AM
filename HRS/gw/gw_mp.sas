libname gw '/lustre/scr/v/i/victorw/gw';
%let sect= &sysparm.;
/*
proc standard data=gw.gw&sect. mean=0 std=1 out=gw;
  var ss:;
run;
*/
proc sort data=gw.gw&sect. out=gw; by iid; run;
data temp;
  merge gw.mp(in=t rename=(fm=fid)) gw(drop=fid) gw.eig;
  by iid;
  if t;
run;
proc sort data=temp; by fid; run;
data new;
  set gw(obs=0 keep=rs:);
run;
data gmr_vars(keep= name);
 set sashelp.vcolumn;
 where libname= "WORK" and memname= "NEW";
 file "/lustre/scr/v/i/victorw/gw/gwmpt&sect..sas" ls= 2000 ;

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
%include "/lustre/scr/v/i/victorw/gw/gwmpt&sect..sas";
data gw.mx_gw_mp&sect.;
 set mx_all;
 snp=strip(snp);
run;

%sysexec rm /lustre/scr/v/i/victorw/gw/gwmpt&sect..sas ;
