libname gw '/lustre/scr/v/i/victorw/gw';
*libname gw 'D:\AM\FHS550k\gw';

data gw.mx_gwmp_all(keep=snp Estimate Probz); 
  set gw.mx_gw_mp:;
  where Subject="fid";
  proc sort data=gw.mx_gwmp_all; by snp;
run;
data gw.mx_gwsp_all(keep=snp Estimate Probz); 
  set gw.mx_gw_sp:;
  where Subject="fid";
  proc sort data=gw.mx_gwsp_all; by snp;
run;
data gw.mx_gwpc_all(keep=snp Estimate Probz); 
  set gw.mx_gw_pc:;
  where Subject="fid";
  proc sort data=gw.mx_gwpc_all; by snp;
run;

proc sort data=gw.mx_gwmp_all; by snp; run;
proc sort data=gw.mx_gwsp_all; by snp; run;
proc sort data=gw.mx_gwpc_all; by snp; run;

data gw.mx_gw_all;
  merge gw.mx_gwmp_all(rename=(estimate=rho_mp probz=p_mp)) gw.mx_gwsp_all(rename=(estimate=rho_sp probz=p_sp)) 
        gw.mx_gwpc_all(rename=(estimate=rho_pc probz=p_pc));
  by snp;
run;
