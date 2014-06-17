*libname agp '/lustre/scr/v/i/victorw/ag/plst';
libname agp 'D:\AMH\ag\plst';

%MACRO seg(num);
%do i=1 %to &num.;
data agp.agp&i.;
  set agp.ag_pairs;
  where pair>&i.*200-200 & pair<=&i.*200;
run;
%end;
%MEND;
%seg(2018);
