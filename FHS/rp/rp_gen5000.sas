libname rp 'd:/am/fhs550k/rp';

%macro sample(ind=, npair=, rep=);

data id; 
   set &ind.;
   proc sort data=id; by iid; run;
/*1. generate a list with all unique combinations, and delete the pairs within each family*/

proc sql;
   create table rp.pair as
   select f1.fid as fid1, f1.iid as id1,
          f2.fid as fid2, f2.iid as id2
   from  id as f1, id as f2
   where f1.iid < f2.iid & f1.fid ne f2.fid 
   order by f1.iid, f2.iid; 
quit;

proc surveyselect data=rp.pair out=sample seed=12478
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
proc sort data=temp out=rp.r5000p989; by iid;run;
%mend;
%sample(ind=rp.fidiid500k,npair=989,rep=5000);

