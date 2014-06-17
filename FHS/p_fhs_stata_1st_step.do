set more off
set matsize 11000
cd d:\am\fhs550k

***** build 36 to 37 ******
insheet using "ss\500kmarker.txt", comma clear
keep chr pos ss
drop if pos==.
replace chr="chr"+chr
clonevar pose=pos
replace pose=pose+1
order chr pos pose ss
outsheet using "ss\500kmarker36.bed", nonames noquote replace
sort ss
save ss\500kmarker36, replace

insheet using "ss\500kmarker37.bed", tab clear
drop v1 v3
*rename v1 chr37
rename v2 pos37
rename v4 ss
order ss pos37
sort ss
save ss\500kmarker37, replace
*merge ss using ss\500kmarker36
outsheet using ss\500kb37.txt, nonames noquote replace
keep ss
outsheet using ss\500kb37ss.txt, nonames noquote replace


*** extract the snps with new info
!plink --bfile 500k --extract 500kb37ss.txt --make-bed --out 500kt

*** update the location info
!plink --bfile 500kt --update-map 500kb37.txt --make-bed --out ..\qc\500k


***** qc *****
!plink --bfile 500k --mind 0.05 --geno 0.01 --maf 0.01 --make-bed --out ..\500kx

***** extract x chr *****
!plink --bfile 500kx --chr 23 --make-bed --out x

***** remove x *****
insheet using x.bim, tab clear
keep v2
outsheet using x.txt, nonames noquote replace
!plink --bfile 500kx --exclude x.txt --make-bed --out 500k

*** des info for the paper
!plink --bfile 500k --missing --out 500kqc
!plink --bfile 500k --hardy --out 500kqch
!plink --bfile 500k --hardy --nonfounder --out 500kqcha

***** snp info *****
insheet using 500k.bim, tab clear
keep v2
save 500ksnps, replace

***** rs snp list for hrs match *****
insheet using "ss\500kmarker.txt", comma clear
keep rs ss
sort ss
save 500krsssfhs, replace

use 500ksnps, clear
rename v2 ss
sort ss
merge 1:1 ss using 500krsssfhs, nogen keep(3)
sort rs
save 500ksnpsfhs, replace

***** eigen pc *****
infile iid eig1 eig2 eig3 eig4 eig5 eig6 eig7 eig8 eig9 eig10 type using "D:\AM\FHS550k\k500_pruned_recode.pca.evec", clear
drop type eig8-eig10
sort iid
save eig, replace

use eig, clear
sort iid
savasas using eig, replace
