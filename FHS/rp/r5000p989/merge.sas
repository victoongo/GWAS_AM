libname rp '/lustre/scr/v/i/victorw/r5000p989/snplst';
libname rpf '/lustre/scr/v/i/victorw/r5000p989';
*libname rp 'D:\AM\FHS550k\rp\r5000p989';
/*
%MACRO seg(num);
%do i=1 %to &num.;
data rp.mxt_rp&i.(keep=snp Estimate); 
  set rp.mx_r&i.p:;
  where Subject="pair";
run;
%end;
%MEND;

%seg(5)
*/
data rp.mxt_rp_all; 
  set rp.mxt_rp:;
  proc sort data=rp.mxt_rp_all; by snp;
run;
proc means data=rp.mxt_rp_all noprint; by snp; var Estimate; output out=rpf.mxf_rp_all(drop=_type_ _freq_) mean=rho_rp std=std_rp; run;
