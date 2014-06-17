libname rp '/lustre/scr/h/e/hexuanl/snp';

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
%sample(ind=,npair=3474,rep=5000);

data rp.r5000p989all;
  set rp.r5000p3474o(drop=_NAME_);
run;
proc sort data=rp.r5000p989all; by iid; run;


proc sort data=rp.snps out=rp; by iid; run;
proc sort data=rp.eig out=eig; by iid; run;

data temp;
	merge rp.r5000p989all(in=t) rp eig;
	by iid;
	if t;
run;
proc sort data=temp; by replicate pair; run;
data new;
	set rp(obs=0 keep=ss:);
run;
data gmr_vars(keep= name);
 set sashelp.vcolumn;
 where libname= "WORK" and memname= "NEW";
 file "/lustre/scr/h/e/hexuanl/snp/rpt.sas" ls= 2000 ;

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
%include "/lustre/scr/h/e/hexuanl/snp/rpt.sas";
%sysexec rm /lustre/scr/h/e/hexuanl/snp/rpt.sas ;

data rp.mxt_rp_all(keep=snp Estimate);
	set mx_all;
	where Subject="pair";
	snp=strip(snp);
	proc sort; by snp;
run;

proc means data=rp.mxt_rp_all noprint; by snp; var Estimate; output out=rp.mxf_rp_all(drop=_type_ _freq_) mean=rho_rp std=std_rp; run;