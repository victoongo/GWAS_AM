cd d:\am\fhs550k\pheno

usesas using mxf_rall, clear
sort pheno
save mxf_rall, replace

usesas using mx_r6, clear
keep if subject=="PAIR"
keep replicate estimate stderr zvalue probz pheno
gen type="mp" if replicate==6001
replace type="pcos" if replicate==6002
replace type="pcss" if replicate==6003
replace type="spos" if replicate==6004
replace type="spss" if replicate==6005
replace type="spmm" if replicate==6006
replace type="spff" if replicate==6007
keep type estimate probz pheno
renvars estimate probz / rho_ p_
reshape wide rho_ p_, i(pheno) j(type, string)
sort pheno
merge m:1 pheno using mxf_rall, nogen
gen p_rp=1-normal((abs(rho_mp-rho_rp))/std_rp)
format rho_* %8.3f
format rho_rp %8.5f
list pheno rho_mp p_mp rho_rp p_rp 
list pheno rho_pcos p_pcos rho_spos p_spos rho_spss p_spss
keep pheno rho* 
reshape long rho_ p_, i(pheno) j(type, string)

la var rho_ "Rho"
gen typen=cond(type=="mp",1,cond(type=="rp",2,cond(type=="pcos",3,cond(type=="pcss",4,cond(type=="spos",5,cond(type=="spss",6,cond(type=="spmm",7,.)))))))
lab de typ 1 "Married Couples" 2 "Randomly Paired Pairs (opposite sex)" 3 "Parent-child Pairs (opposite sex)" 4 "Parent-child Pairs (same sex)" 5 "Full Sibling Pairs (opposite sex)" /*
*/ 6 "Full Sibling Pairs (same sex)" 7 "Full Sibling Pairs (both males)" 8 "Full Sibling Pairs (both females)" 
lab val typen typ
graph hbar (mean) rho_ if pheno=="ZHEIGHTG ", over(typen, gap(60) label(angle(0) labsize(medlarge) labgap(1))) xsize(5) ysize(3) yti("Correlation", size(medlarge))
graph hbar (mean) rho_ if pheno=="ZHEIGHTG ", over(typen, gap(60) label(angle(0) labsize(large) labgap(1))) xsize(5) ysize(3) yti("Correlation", size(large))
*graph hbar (mean) rho_ if pheno=="zheightgy", over(typen) xsize(5) ysize(3) yti("Correlation")
