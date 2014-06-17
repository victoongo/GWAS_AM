cd d:\am\fhs550k\cg

insheet using "bmi_in_550.txt", names tab clear
destring referenceallelefrequency otherallelefrequency, replace ignore("#N/A")
gen pheno="bmi"
save obmi, replace
insheet using "height_in_550.txt", names tab clear
destring referenceallelefrequency otherallelefrequency, replace ignore("#N/A")
gen pheno="height"
save oheight, replace
insheet using "behavior_in_550.txt", names tab clear
destring referenceallelefrequency otherallelefrequency, replace ignore("#N/A")
destring chromosome, replace ignore("X")
replace chromosome=23 if chromosome==.
gen pheno="behavior"
save obehavior, replace

use ..\500ksnpsfhs, clear
sort ss
tempfile 500ksnpsfhs_ss
save `500ksnpsfhs_ss', replace
sort rs 
tempfile 500ksnpsfhs_rs
save `500ksnpsfhs_rs', replace

use obmi, clear
append using oheight
append using obehavior
drop polyphen sift
rename markerid rs
*sort snpr
*by snpr: gen n=_n
*drop if n==2
*drop n
append using hla
rename snp ss
merge m:1 rs using `500ksnpsfhs_rs', nogen keep(1 3 4 5) update
merge m:1 ss using `500ksnpsfhs_ss', nogen keep(1 3 4 5) update
rename ss snp
sort snp
drop if rs=="" | snp==""
save otrn, replace

use otrn, clear
merge m:1 snp using ..\gw\mx_gw_all_pheno, nogen keep(3)
sort pheno p_rp
by pheno: gen n=_n
keep if (pheno~="HLA" & n<=10) | (pheno=="HLA" & n<=5)
order rs chromosome position gene location referenceallele referenceallelefrequency rho_mp p_mp rho_rp p_rp rho_pc p_pc rho_sp p_sp
