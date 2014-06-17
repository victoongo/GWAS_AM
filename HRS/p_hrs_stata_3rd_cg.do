cd d:\amh\cg

use otrn, clear
rename (snp rs) (ss snp)
merge m:1 snp using ..\gw\mx_gw_all_pheno, nogen keep(3)
sort pheno p_rp
by pheno: gen n=_n
keep if (pheno~="HLA" & n<=10) | (pheno=="HLA" & n<=5)
order snp chromosome position gene location referenceallele referenceallelefrequency rho_mp p_mp rho_rp p_rp
