set more off
set matsize 11000
set maxvar 32767
cd d:\amh\

insheet using "500kx.fam", delimiter(" ") clear
rename v1 fid
rename v2 iid
rename v3 fshare
rename v4 mshare
rename v5 sex
rename v6 pheno
sort iid
save 500k_fam1, replace

***** des *****
use 500k_fam1, clear
bysort fid: gen n=_n
bysort fid: gen n2=_N
ta n

use 500k_fam1, clear
bysort iid: gen n=_n
ta n
* share ids are unique

***** pairdef mp *****
insheet using "spouse\Cross_reference.csv", clear
sort hhid pn
save spouse\Cross_reference.dta, replace
insheet using "spouse\subjectID2scanID.csv", clear
keep family subjectid local_id sex
rename (family subjectid sex) (fid iid sexc)
merge 1:1 iid using 500k_fam1, nogen keep(3)
keep fid iid local_id sexc
rename sexc sex
sort local_id
save spouse\subjectID2scanID.dta, replace

insheet using "spouse\HRS_SP_Unique.csv", clear
sum
bysort hhid: gen n=_n
bysort hhid: gen n2=_N
ta n
gen nall=_n
egen lid=rowmin(pn spn)
egen sid=rowmax(pn spn)
duplicates drop hhid lid sid, force
bysort hhid: gen n2a=_N
keep hhid lid sid
gen fm=_n
rename sid pn
sort hhid pn
merge 1:1 hhid pn using spouse\Cross_reference, nogen keep(3)
rename (pn local_id lid) (pn1 local_id1 pn)
sort hhid pn
merge m:1 hhid pn using spouse\Cross_reference, nogen keep(3)
rename (pn local_id) (pn2 local_id2)
rename local_id1 local_id
sort local_id
merge 1:1 local_id using spouse\subjectID2scanID, nogen keep(3)
rename (local_id fid iid sex local_id2) (local_id1 fid1 iid1 sex1 local_id)
sort local_id
merge m:1 local_id using spouse\subjectID2scanID, nogen keep(3)
rename (local_id fid iid sex) (local_id2 fid2 iid2 sex2)
*gen fam12=1 if family1==family2
keep fm iid1 iid2 sex1 sex2
drop if sex1==sex2
gen long iid3=iid1 if sex1=="M"
replace iid3=iid2 if sex2=="M"
gen long iid4=iid1 if sex1=="F"
replace iid4=iid2 if sex2=="F"
keep fm iid3 iid4
rename (iid3 iid4) (iid1 iid2)
save 500k_mp_w, replace
reshape long iid, i(fm)
drop _j
save 500k_mp, replace

use 500k_mp, clear
sort iid
savasas using mp, replace

***** create mp list for exclusion from mrp and rp *****
use 500k_mp_w, clear
keep iid1 iid2
sort iid1 iid2
save mp_exclude, replace

***** pairdef sp *****
use iid fshare mshare using "500k_fam1.dta", clear
drop if fshare=="NA" & mshare=="NA"
drop if fshare=="0" & mshare=="0"
destring fshare mshare, replace
bysort fshare mshare: egen c1=count(fshare)
drop if c1==1
* there are no siblings

***** pairdef pc *****
use iid fshare mshare using 500k_fam1, clear
drop if fshare=="NA" & mshare=="NA"
drop if fshare=="0" & mshare=="0"
destring fshare mshare, replace
renvars fshare mshare \ share1 share2
gen n=_n
reshape long share, i(n)
drop n _j
drop if share==0
rename iid iid1
rename share iid
sort iid
merge m:1 iid using 500k_fam1, keepusing(iid) nogen keep(3)
rename iid iid2
gen pair=_n
gen type=3
gen typef="pc"
save 500k_pc_w, replace
reshape long iid, i(pair)
drop _j
save 500k_pc, replace

use 500k_pc, clear
sort iid
savasas using pc, replace
* there are 25 households with father mother and child. no other parent child pairs in the current geno data

***** create pc and mp list from exclusion from mrp and rp *****
use iid fshare mshare sex using 500k_fam1, clear
drop if fshare=="NA" & mshare=="NA"
drop if fshare=="0" & mshare=="0"
destring fshare mshare, replace
tempfile pc
save `pc', replace
keep if sex==1
keep iid mshare
rename (iid mshare) (iid1 iid2) 
keep iid1 iid2
tempfile sonmother
save `sonmother', replace
use `pc', clear
keep if sex==2
keep iid fshare
rename (fshare iid) (iid1 iid2) 
keep iid1 iid2
tempfile fatherdaughter
save `fatherdaughter', replace
use `pc', clear
keep fshare mshare
rename (fshare mshare) (iid1 iid2) 
keep iid1 iid2
append using `sonmother'
append using `fatherdaughter'
bysort iid1 iid2: keep if _n==1
sort iid1 iid2
save pc_exclude, replace

***** mrp *****
use 500k_mp, clear
bysort iid: gen n=_n
keep if n==1
keep iid
sort iid 
merge 1:1 iid using spouse\subjectID2scanID, nogen keep(3)
sort local_id
merge m:1 local_id using spouse\Cross_reference, nogen keep(3)
gen total=1
tempfile temp
save `temp', replace

keep if sex=="M"
drop sex pn
rename (hhid fid iid) (hhid1 fid1 iid1)
tempfile temp1
save `temp1'
use `temp', clear
keep if sex=="F"
drop sex pn
rename (hhid fid iid) (hhid2 fid2 iid2)
joinby total using `temp1'
drop total
drop if fid1==fid2
drop if hhid1==hhid2
keep iid1 iid2
sort iid1 iid2
merge 1:1 iid1 iid2 using mp_exclude, nogen keep(1)
merge 1:1 iid1 iid2 using pc_exclude, nogen keep(1)
save mrp_all, replace

use mrp_all, clear
sample 200000, count
gen typef="mrp"
gen type=5
gen pair=_n+500000
save mrp, replace

***** create master list for all rpos *****
use 500k_fam1, clear
keep iid
sort iid
merge 1:1 iid using spouse\subjectID2scanID, nogen keep(1 3)
sort local_id
merge m:1 local_id using spouse\Cross_reference, nogen keep(1 3)
gen total=1
tempfile temp
save `temp', replace

keep if sex=="M"
drop sex pn
rename (hhid fid iid) (hhid1 fid1 iid1)
tempfile temp1
save `temp1'
use `temp', clear
keep if sex=="F"
drop sex pn
rename (hhid fid iid) (hhid2 fid2 iid2)
joinby total using `temp1'
drop total
drop if fid1==fid2
drop if hhid1==hhid2
keep iid1 iid2
sort iid1 iid2
merge 1:1 iid1 iid2 using mp_exclude, nogen keep(1)
merge 1:1 iid1 iid2 using pc_exclude, nogen keep(1)
save rp_all, replace
savasas using rp\rp_all, replace
*****  create rpos sample of 200000 *****
use rp_all, clear
sample 200000, count
gen typef="rp"
gen type=4
gen pair=_n+100000
save rp, replace
*****  create 5000 rpos samples with 3474 each *****
*** create the pair data for sas and use the proc surveyselect to draw 5000 samples
*** the following works but is way too slow 
/*
use rp_all, clear
preserve
foreach n of num 1/5 {
	restore, preserve
	sample 3474, count
	gen pair=_n
	gen replicate=`n'*1000+1
	save rp\rp`n', replace
	foreach m of num 2/3 {
		restore, preserve
		sample 3474, count
		gen pair=_n
		gen replicate=`n'*1000+`m'
		append using rp\rp`n'
		save rp\rp`n', replace
	}
	reshape long iid, i(pair)
	drop _j
	savasas using rp\rp`n', replace
}
*/


**** merge all mp, pc, mrp, rp pairs
use 500k_mp_w, clear
rename fm pair
gen type=1
gen typef="mp"
append using 500k_pc_w
append using mrp
append using rp
sort type
replace pair=_n
replace pair=pair+24 if pair>3474
save ag\ag_pairs_all, replace

use ag\ag_pairs_all, clear
drop typef type
reshape long iid, i(pair)
rename _j ipid
save ag\ag_pairs, replace
savasas using ag\plst\ag_pairs, replace
