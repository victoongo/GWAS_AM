ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66053595_a =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66053595_a  '; run;
data mx_all; set mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66123306_g =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66123306_g  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66207873_a =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66207873_a  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66317863_t =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66317863_t  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66507485_a =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66507485_a  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66052917_c =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66052917_c  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66157537_c =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66157537_c  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66312524_g =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66312524_g  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66448641_c =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66448641_c  '; run;
data mx_all; set mx_all mx; run;
ods listing close;
proc mixed data=temp method=ml noitprint noclprint ratio covtest;      class fid;      model ss66376899_g =eig1 /s notest;      repeated /type=ar(1) subject=fid; ods output CovParms=mx; run; 
ods listing;
data mx; set mx; snp=' ss66376899_g  '; run;
data mx_all; set mx_all mx; run;