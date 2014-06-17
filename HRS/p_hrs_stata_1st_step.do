set more off
set maxvar 32767
set matsize 11000
cd d:\amh\

***** snp info *****
insheet using 500k.bim, tab clear
keep v2
rename v2 rs
save 500ksnps, replace

***** eigen pc *****
*infile iid eig1 eig2 eig3 eig4 eig5 eig6 eig7 eig8 eig9 eig10 type using "D:\AMH\CIDR_HRS_pruned_recode.pca.evec", clear
* had problem reading the first variable iid
use eig_all, clear
rename (var1-var12) (iid eig1 eig2 eig3 eig4 eig5 eig6 eig7 eig8 eig9 eig10 type)
drop type eig8-eig10 n
sort iid
save eig, replace

use eig, clear
sort iid
savasas using eig, replace

***** common snps between fhs and hrs from Tom *****
insheet using HRS_Fram_common.txt, tab clear
rename v1 rs
sort rs
save matchtom, replace

***** find the match of fhs final and hrs *****
insheet using CIDR_HRS_filtered.bim, tab clear
rename v2 rs
sort rs
merge 1:1 rs using "D:\AM\FHS550k\500ksnpsfhs.dta", nogen keep(3)
keep if inrange(v1,1,22)
keep rs
sort rs
save match, replace

