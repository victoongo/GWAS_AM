set more off
set matsize 11000
cd d:\amh\

***** results *****
usesas using "gw\mx_gw_all", clear
sort snp
save gw\mx_gw_all, replace

*** r5000p989
usesas using rp\r5000p989\mxf_rp_all, clear
split snp, p("_")
drop snp snp2
rename snp1 snp
sort snp
save rp\r5000p989\mx_rp_all, replace

use rp\r5000p989\mx_rp_all, clear

*****
use gw\mx_gw_all, clear
split snp, p("_")
drop snp snp2
rename snp1 snp
sort snp
/*
keep snp
sort snp
save agcon\snplst2\550kg, replace
*/
merge 1:1 snp using rp\r5000p989\mx_rp_all, nogen keep(3)
gen p_rp=1-normal((abs(rho_mp-rho_rp))/std_rp)
gen z_rp=(rho_mp-rho_rp)/std_rp
gen chi_rp=z_rp*z_rp
sort p_rp
format rho_mp rho_sp rho_pc %8.2f
format rho_rp %8.4f
format p_mp p_rp p_sp p_pc %8.4g
/* QQ plot
la var z_rp "Observed Z-score"
qnorm z_rp, msize(small) yti(, size(large)) xti("Normal theoretical quantiles", size(large)) title("a. All SNPs") name(all, replace)
keep if p_rp>0.00000005
qnorm z_rp, msize(small) yti(, size(large)) xti("Normal theoretical quantiles", size(large)) title("b. Most Significant SNPs Excluded") name(all2, replace)
graph combine all all2, ycom xcom 
*/

list snp rho_mp p_mp rho_rp p_rp if p_rp<.00000005 
/*
keep snp p_rp rho_mp rho_sp rho_pc
sort snp
save gw\mx_gw_all_n, replace
*/
sort p_rp
gen n=_n
keep if n<=20
/*
keep rs
outsheet using gw\snp20.txt, nonames noquote replace
*/
sort snp
rename snp ss
*merge 1:1 ss using "D:\AM\FHS550k\ss\50kmarker37.dta", nogen keep(1 3)
merge 1:1 ss using "D:\AM\FHS550k\ss\500kmarker37.dta", nogen keep(1 3) update
merge 1:1 ss using ss\500kmarkerinfof, nogen keep(1 3)
sort n
order rs chr pos37 rho_mp p_mp rho_rp p_rp rho_sp p_sp rho_pc p_pc
sort rs
merge 1:1 rs using gw\snp_info, nogen
sort n
list rs chr pos37 refa refaf rho_mp p_mp rho_rp p_rp rho_sp p_sp rho_pc p_pc
/* HLA test
sort snp
merge 1:1 snp using hla, nogen keep(3)
sort p_rp
list rs chr pos37 refa refaf rho_mp p_mp rho_rp p_rp rho_sp p_sp rho_pc p_pc in 1/5 
*/
*** background info 1
insheet using "ss\500Kmarker.txt", comma clear
keep chr ss rs
sort ss
save ss\500kmarkerinfof, replace

*** background info 2

insheet using "500k.bim", nonames clear
keep v1 v2 v4 v5
rename v2 snp
gen n=_n
sort snp
merge 1:1 snp using gw\mx_gw_all_n, nogen keep(3)
sort n
drop n
renvars v1 v4 v5 / chr bp a1
replace p_rp=-log10(p_rp)
format p_rp %11.3f
format rho_mp %10.0g
drop if chr==23
outfile using "D:\AM\FHS550k\gw\results_all.raw", nolabel noquote replace wide rjs

*** get the info for all snps
*infile using "gw\550k.frq", names clear
sort snp
save gw\550kfrq, replace
*infile using "gw\550k.hwe", names clear
keep if test=="ALL"
sort snp
save gw\550khwe, replace
*infile using "gw\550k.lmiss", names clear
sort snp
save gw\550klmiss, replace
*infile using "gw\550k.lmendel", names clear
sort snp
save gw\550klmendel, replace

*** snp info
insheet using "gw/snpinfo/snp.txt", names clear
renvars variationname minorallele ancestralallele minorallelefrequency consequencetotranscript ensemblgeneid / rs ma refa refaf location eid
replace refa=trim(refa)
replace ma=trim(ma)
replace eid=trim(eid)
replace refaf=1-refaf if refa~=ma
sort eid
merge m:1 eid using gene, nogen
drop ma eid
bysort rs gene location: gen n2=_n
ta n2
list rs refa refaf location gene if n2==1


*** gene info
insheet using "gw/snpinfo/gene.txt", names clear
renvars ensemblgeneid associatedgenename / eid gene
replace eid=trim(eid)
replace gene=trim(gene)
sort eid
save gene, replace
