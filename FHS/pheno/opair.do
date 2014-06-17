cd d:\am\fhs550k

use 500k_mp, clear
bysort fm: gen j=_n
reshape wide iid, i(fm) j(j)
drop fm
gen type="mp"
gen replicate=6001
save pheno/pair_mp, replace

use 500k_pc, clear
sort iid
merge m:1 iid using pheno\sex, nogen keep(3)
bysort pc: gen j=_n
reshape wide iid sex, i(pc) j(j)
drop if sex1==sex2
drop pc sex1 sex2
gen type="pcos"
gen replicate=6002
save pheno/pair_pcos, replace

use 500k_pc, clear
sort iid
merge m:1 iid using pheno\sex, nogen keep(3)
bysort pc: gen j=_n
reshape wide iid sex, i(pc) j(j)
keep if sex1==sex2
drop pc sex1 sex2
gen type="pcss"
gen replicate=6003
save pheno/pair_pcss, replace

use 500k_sp, clear
sort iid
merge m:1 iid using pheno\sex, nogen keep(3)
bysort sib: gen j=_n
reshape wide iid sex, i(sib) j(j)
drop if sex1==sex2
drop sib sex1 sex2
gen type="spos"
gen replicate=6004
save pheno/pair_spos, replace

use 500k_sp, clear
sort iid
merge m:1 iid using pheno\sex, nogen keep(3)
bysort sib: gen j=_n
reshape wide iid sex, i(sib) j(j)
keep if sex1==sex2
drop sib sex1 sex2
gen type="spss"
gen replicate=6005
save pheno/pair_spss, replace
/*
use 500k_sp, clear
sort iid
merge m:1 iid using pheno\sex, nogen keep(3)
bysort sib: gen j=_n
reshape wide iid sex, i(sib) j(j)
keep if sex1==1 & sex2==1
drop sib sex1 sex2
gen type="spmm"
gen replicate=6006
save pheno/pair_spmm, replace

use 500k_sp, clear
sort iid
merge m:1 iid using pheno\sex, nogen keep(3)
bysort sib: gen j=_n
reshape wide iid sex, i(sib) j(j)
keep if sex1==2 & sex2==2
drop sib sex1 sex2
gen type="spff"
gen replicate=6007
save pheno/pair_spff, replace
*/
cd d:\am\fhs550k\pheno
use pair_mp, clear
append using pair_pcos
append using pair_pcss
append using pair_spos
append using pair_spss
*append using pair_spmm
*append using pair_spff
gen pair=_n
save opairtype, replace
reshape long iid, i(pair) j(j)
*gen replicate=cond(type=="mp",6001,cond(type=="spss",6002,cond(type=="pcos",6003,cond(type=="spos",6004,.))))
drop j type
sort iid
save opair, replace
savasas using r6000p1023.sas7bdat, replace

