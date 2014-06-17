set more off
set matsize 11000
cd d:\amh\

usesas using "gw\gw34", clear
sort iid
merge 1:m iid using 500k_mp, nogen keep(3)
keep fm iid rs132550_a rs6005975_a rs134559_a rs134651_a rs132277_c rs469983_c
bysort fm: gen j=_n
reshape wide iid rs*, i(fm) j(j)
pwcorr rs*

insheet using CIDR_HRS_filtered.bim, tab clear
ta v5 v6

insheet using 500k.bim, tab clear
rename v2 rs
sort rs
save 500kbim, replace

cd d:\am\fhs550k
usesas using "gw\gw29", clear
sort iid
merge 1:m iid using 500k_mp, nogen keep(3)
keep fm iid ss66212*
bysort fm: gen j=_n
reshape wide iid ss*, i(fm) j(j)
pwcorr ss*


insheet using 500k.bim, tab clear
rename v2 ss
sort ss
merge 1:1 ss using "D:\AM\FHS550k\500ksnpsfhs.dta", nogen keep(3)
ta v5 v6
rename v* fhs*
sort rs
merge 1:1 rs using d:\amh\500kbim, nogen keep(3)
rename v* hrs*
ta fhs5 hrs5
ta fhs6 hrs6
ta fhs5 fhs6
ta hrs5 hrs6
