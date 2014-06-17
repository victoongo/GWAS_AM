set maxvar 32767
set matsize 11000
cd d:\amh\

***** snp info *****
insheet using 500k.bim, tab clear
keep v2
rename v2 rs
save 500ksnps, replace

use 500ksnps, clear
sort rs
merge 1:1 rs using "D:\AM\FHS550k\500ksnpsfhs.dta", nogen keep(3)
save fhshrsmatchfinal, replace
keep ss
sort ss
outsheet using 500ksnpsfhsmatch.txt, nonames noquote replace
!plink --bfile D:\AM\FHS550k\500k --extract 500ksnpsfhsmatch.txt --make-bed --out 500kfhsmatch


***** freq *****
!plink --bfile 500k --freq --out 500khrs
!plink --bfile 500kfhsmatch --freq --out 500kfhsmatch

import excel "D:\AMH\500khrs.xlsx", sheet("500khrs") firstrow case(lower) clear
rename * *_hrs
rename snp_hrs rs
sort rs
save 500khrsfreq, replace
import excel "D:\AMH\500kfhsmatch.xlsx", sheet("500kfhsmatch") firstrow case(lower) clear
rename * *_fhs
rename snp_fhs ss
sort ss
save 500kfhsmatchfreq, replace

use D:\AM\FHS550k\500ksnpsfhs.dta, clear
sort rs
merge 1:1 rs using 500khrsfreq, nogen keep(3)
sort ss
merge 1:1 ss using 500kfhsmatchfreq, nogen keep(3)
sort rs
save 500kfhshrsfreq, replace
gen fhs=a1_fhs+a2_fhs
gen hrs=a1_hrs+a2_hrs
gen fhshrs=fhs+hrs
gen fhshrsa=fhshrs
replace fhshrsa="="+fhshrs if fhs==hrs
replace fhshrsa="-"+fhshrs if inlist(fhshrs,"ACCA","AGGA","ATTA","CAAC","CGGC","GAAG","GCCG","TAAT")
replace fhshrsa="+"+fhshrs if inlist(fhshrsa,"CTGA","GTCA","TCAG","TGAC")
replace fhshrsa="-+"+fhshrs if inlist(fhshrsa,"CTAG","GTAC","TCGA","TGCA")

ta fhshrsa, p
ta fhshrsa, sum(maf_fhs)
ta fhshrsa, sum(maf_hrs)
bysort fhshrsa: corr maf_fhs maf_hrs

corr maf*
ta a1_hrs a1_fhs
ta a2_hrs a2_fhs

ta fhs hrs
ta fhs, sum(maf_fhs)
ta hrs, sum(maf_hrs)


ta a1_hrs a2_hrs
ta a1_fhs a2_fhs
ta a1_hrs, sum(maf_hrs)
ta a2_hrs, sum(maf_hrs)
ta a1_fhs, sum(maf_fhs)
ta a2_fhs, sum(maf_fhs)
