cd d:\am\fhs550k

use gw\mx_gw_all, clear
split snp, p("_")
rename snp snpd
rename snp1 snp
sort snp
merge 1:1 snp using rp\r5000p1023\mx_rp_all, nogen /*keep(3)*/
gen p_rp=1-normal((abs(rho_mp-rho_rp))/std_rp)
sum if rho_pc<.3 | rho_pc>0.7
sum if rho_sp<.2 | rho_sp>0.8
gen dlst=1 if rho_pc<.3 | rho_pc>0.7 | rho_sp<.2 | rho_sp>0.8
gen p=cond(rho_mp<0,0,cond(rho_mp>=0,1,.))
sort p p_rp
by p: gen n=_n
replace dlst=1 if n<=120 & p==1
keep if dlst==1
merge 1:1 snp using agcon\500ksnps, nogen keep(3)
keep snpd


