* create 10 subset datasets a time and launch 10 Rsession to do parallel computing on one workstation. 

libname p500k2rp 'd:/am/fhs550k/rp_old';

/*1. extract the list of snps: raw file*/
/*2. generate a list of all pairwise combinations excluding pairs within family*/
/*3. sample from the list with n replicates*/
/*4. estiamte intracorrelation rho and its p value*/
/*5. sum the results*/

%macro read(data=);
data _temp;
  length head $32767.;
  infile "D:\AM\FHS550k\rp\&data..raw" obs=1 TRUNCOVER lrecl=10000000 dlm="*" ;
  input head $;
  vars=strip(SUBSTRN(head,index(head,'PHENOTYPE')+10));
  ids=SUBSTRN(head,1,index(head,'PHENOTYPE')+8);
run;

data _null_;
  set _temp;
  if _n_=1 then call symput("var", strip(vars));
  if _n_=1 then call symput("ids", strip(ids));
run;

data &data;
  length &ids $ 25;
  infile "D:\AM\FHS550k\rp\&data..raw" firstobs=2 TRUNCOVER lrecl=10000000;
  input &ids $ &var;
run;
%mend;

/* raw data (plink output) should be placed in the folder 'c:\temp' */
 
%read(data=ga);


%macro sample(ind=, npair=, rep=);

data id; 
   set &ind. (keep=fid iid);
   proc sort data=id; by iid; run;

/*1. generate a list with all unique combinations, and delete the pairs within each family*/

proc sql;
   create table p500k2rp.pair as
   select f1.fid as fid1, f1.iid as id1,
          f2.fid as fid2, f2.iid as id2
   from  id as f1, id as f2
   where f1.iid < f2.iid & f1.fid ne f2.fid 
   order by f1.iid, f2.iid; 
quit;

proc surveyselect data=p500k2rp.pair out=sample seed=12478
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
  var id1 id2;
  by replicate pair;
proc sort data=temp;
  by iid;
/*
proc sort data=&ind.;
  by iid;
data temp;
  merge temp(in=first) &ind.;
  by iid;
  if first;
proc sort data=temp out=temp;
  by replicate pair;
run;
*/
%mend;


%sample(ind=ga,npair=5000,rep=1000);
endsas;
%macro sum(nrep=, step=);

proc contents data=temp out=var noprint;
run;

data _null_;
  set var end=eof;
  if eof then call symput("nsnp",_n_-9);
run;
proc sql noprint;
  select distinct NAME into: snps SEPARATED by ' '
  from var where (varnum>9)
  order by varnum;
quit;

%do i=0 %to &nsnp. %by &step.;
  %let ind1=%scan(&snps,&i.+1);
  %let p1=%SYSFUNC(indexw(%quote(&snps.),%quote(&ind1.)));
  %let ind2=%scan(&snps.,&i.+1+&step.);
  %let p2=%SYSFUNC(indexw(%quote(&snps.),%quote(&ind2.)));
  %let snpi=%SUBSTR(&snps.,&p1.,&p2.-&p1.);
  %if &ind2= %then %let snpi=%SUBSTR(&snps.,&p1.);

  %let t=1;
  %let snp=%scan(&snpi., &t.);

  %do %while("&snp" NE "");
*dm log 'clear';
data _null_;
  file "D:\AM\FHS550k\rp\data&t..dat" LRECL=1000;
  set temp(keep=replicate pair &snp. where=(&snp.^=.));
  put (_all_)(:);
run;

data _null_;
  file "D:\AM\FHS550k\rp\data&t..r"  ;
  put@1   "library(lme4)    ";
  put@1   "setwd('D:/AM/FHS550k/rp')	";
  put@1   "data<-read.table(file=%str(%")data&t..dat%str(%"),head=F,col.names=c('replicate','pair',%str(%")&snp.%str(%")))     ";
  put@1   "data$&snp.<-as.numeric(data$&snp.)     " ;
  put@1   "nrep=&nrep.              ";
  put@1   "res<-matrix(0,nrep,6) ";
  put@1   "colnames(res)<-c('replicate','s2u','se.s2u','s2e','se.s2e','ngrp') ";
  put@1   "for (i in 1:nrep){    ";
  put@1   "   fit<-summary(lmer(&snp~ 1|pair, data=data,subset=replicate==i))    ";
  put@1   "   s2u<-as.numeric(fit@REmat[1,3])	        ";
  put@1   "   s2e<-as.numeric(fit@REmat[2,3])	        ";
  put@1   "   se.s2u<-as.numeric(fit@REmat[1,4])       ";
  put@1   "   se.s2e<-as.numeric(fit@REmat[2,4])      ";
  put@1   "   parm<-cbind(i,s2u,se.s2u, s2e,se.s2e,fit@ngrps[1])  ";
  put@1   "   res[i,]<-parm                            ";
  put@1   "	 }             ";
  put@1   "res<-as.data.frame(res)	   ";
  put@1   "res$snp<-%str(%")&snp.%str(%")            ";
  put@1   "write.table(res, file=%str(%")out&t..txt%str(%"))	";
  put@1   "quit()   ";
run;
    %let t = %eval(&t + 1);
    %let snp = %scan(&snpi., &t.);
  %end;

%do j=1 %to &t-1;
SYSTASK command " 'C:\Program Files\R\R-2.13.2\bin\x64\Rcmd.exe' BATCH --no-save --no-restore -- D:/AM/FHS550k/rp/data&j..r  D:/AM/FHS550k/rp/log&j..txt" taskname=job&j;
%end;

waitfor _all_ %do s=1 %to &t-1; job&s %end;;
SYSTASK KILL  %do s=1 %to &t-1; job&s %end;;

%do s=1 %to &t-1;
data res&s;
  length id $10. replicate s2u ses2u s2e ses2e ngrp 8. snp $20.;
  infile "D:\AM\FHS550k\rp\out&s..txt" firstobs=2 ;
  input id replicate s2u ses2u s2e ses2e ngrp snp;
run;
%end;

data result&i;
  set %do s=1 %to &t-1; res&s %end;;
run;

systask command "del D:\AM\FHS550k\rp\out*.txt" taskname=cl;
waitfor _all_ cl;
systask kill cl;

proc datasets library=work;
  delete %do s=1 %to &t-1; res&s %end;;
run; 
quit;

%end;

data result_&nrep;
  set %do k=0 %to &nsnp %by &step; result&k %end;;
  rho=s2u/(s2u+s2e);
  stderr=sqrt((1-rho)**2*(1+rho)**2/ngrp);
  t=rho/stderr;
  p=(1-probt(abs(t),ngrp-1))*2;
run;

proc means data=result_&nrep;
  class snp;
  var rho;
  ods output summary=sum;
run;

proc sort data=sum out=p500k2rp.sum;
  by descending rho_mean;
  proc print data=p500k2rp.sum;

%mend;

/* the macro uses 'c:\temp' folder to save the temporary data files and results*/

/* r should be installed under 'C:\Program Files' */
/* the folder, version information for the rcmd.exe file may need to be updated*/
/* if so, the Rcmd options also need to be updated*/
/* the version here is R 2.13.1 x64*/
/* lme4 library is required*/
 
%sum(nrep=100, step=8);



