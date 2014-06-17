set more off
set matsize 11000
cd d:\amh\gw_imp

***** results *****
usesas using "mx_mp", clear
sort snp
save mx_mp, replace

*** r5000p989
usesas using mxf_rp_all, clear
sort snp
save mx_rp_all, replace


*****
use mx_mp, clear
replace snp=lower(snp)
sort snp
/*
keep snp
sort snp
save agcon\snplst2\550kg, replace
*/
merge 1:1 snp using mx_rp_all, nogen keep(3)
gen p_rp=1-normal((abs(rho_mp-rho_rp))/std_rp)
gen z_rp=(rho_mp-rho_rp)/std_rp
gen chi_rp=z_rp*z_rp
sort p_rp
format rho_mp %8.3f
format rho_rp %8.4f
format p_mp p_rp %8.4g
/*
* compare top snps between fhs hrs
keep snp rho_mp p_rp
rename (snp rho_mp p_rp) (rs rho_mp_hrs p_rp_hrs)
merge 1:1 rs using fhshrsmatchfinal, nogen keep(3)
sort ss 
rename ss snp
merge 1:1 snp using "D:\AM\FHS550k\gw\mx_gw_all_n.dta", nogen keep(3)
drop rho_sp rho_pc
rename (rho_mp p_rp) (rho_mp_fhs p_rp_fhs)
twoway (scatter rho_mp_hrs rho_mp_fhs, msymbol(point))
twoway (scatter p_rp_hrs p_rp_fhs, msymbol(point))
sort p_rp_fhs 
gen n_p_rp_fhs=_n
list in 1/100 if p_rp_hrs<.05


gsort -rho_mp_fhs 
gen n_rho_mp_fhs=_n
gsort -rho_mp_hrs 
gen n_rho_mp_hrs=_n
corr rho_mp_hrs rho_mp_fhs
sort rs
merge 1:1 rs using 500kfhshrsfreq, nogen

twoway (scatter rho_mp_fhs maf_fhs, msymbol(point))
twoway (scatter rho_mp_hrs maf_hrs, msymbol(point))
twoway (scatter maf_fhs maf_hrs, msymbol(point))
*/
/* QQ plot
la var z_rp "Observed Z-score"
qnorm z_rp, msize(small) yti(, size(large)) xti("Normal theoretical quantiles", size(large)) title("a. All SNPs") name(all, replace)
keep if p_rp>0.00000005
qnorm z_rp, msize(small) yti(, size(large)) xti("Normal theoretical quantiles", size(large)) title("b. Most Significant SNPs Excluded") name(all2, replace)
graph combine all all2, ycom xcom 
*/

list snp rho_mp p_mp rho_rp p_rp if p_rp<.00000005 
/*
keep snp p_rp rho_mp 
sort snp
save gw\mx_gw_all_n, replace
*/
/*
keep snp rho_mp p_mp rho_rp p_rp 
sort snp
save gw\mx_gw_all_pheno, replace
*/
sort p_rp
gen n=_n
keep if n<=30

split snp, p(ss)
drop snp snp1
rename snp2 snp
order snp rho_mp p_mp rho_rp p_rp n
/*
keep rs
outsheet using gw\snp20.txt, nonames noquote replace
*/
sort snp
rename snp rs
*merge 1:1 ss using "D:\AM\FHS550k\ss\50kmarker37.dta", nogen keep(1 3)
merge 1:1 rs using "D:\AM\FHS550k\ss\500kmarker37.dta", nogen keep(1 3) update
merge 1:1 rs using ss\500kmarkerinfof, nogen keep(1 3)
sort n
order rs chr pos37 rho_mp p_mp rho_rp p_rp 
sort rs
merge 1:1 rs using gw\snp_info, nogen
sort n
list rs chr pos37 refa refaf rho_mp p_mp rho_rp p_rp 
list rs rho_mp p_mp rho_rp p_rp 
/* HLA test
sort snp
merge 1:1 snp using hla, nogen keep(3)
sort p_rp
list rs chr pos37 refa refaf rho_mp p_mp rho_rp p_rp in 1/5 
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
outfile using "D:\AMH\gw\results_all.raw", nolabel noquote replace wide rjs

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
