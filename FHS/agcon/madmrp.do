cd D:\AM\FHS550k\agcon\mrplst

usesas using freq_all, clear
save freq_all, replace

use freq_all, clear
lab def col 1 "02/20" 2 "01/10" 3 "11" 4 "00" 5 "12/21" 6 "22"
lab val col col
histogram percent, width(.5) percent xsize(4) ysize(5) by(col, cols(1))
bysort col: sum percent
ta col, sum(percent) nome nof
ta col, sum(percent) nost nof


keep if col==4
histogram percent if col==4, width(.25) percent xsize(4) ysize(5) 
qnorm percent if col==4

insheet using "500k.fam", delimiter(" ") clear
renvars v1-v6 / fid iid fshare mshare sex pheno
keep fid iid sex
sort iid
merge iid using 
tempfile 500k
save `500k', replace

use ..\agconpairs_mp, clear
bysort iid: gen n=_n
keep if n==1
keep iid
gen total=1
tempfile temp1
save `temp1', replace

rename iid iid2
joinby total using `temp1'
drop if iid>=iid2
sort iid
merge m:1 iid using demo, nogen keep(1 3)
renvars fid iid sex birthyr / fid1 iid1 sex1 birthyr1
rename iid2 iid
sort iid
merge m:1 iid using demo, nogen keep(1 3)
renvars fid iid sex birthyr / fid2 iid2 sex2 birthyr2
drop if fid1==fid2 | sex1==sex2
gen birthyrd=birthyr1-birthyr2 if sex1==1
replace birthyrd=birthyr2-birthyr1 if sex1==2
drop if birthyrd<-5 | birthyrd>2
keep iid1 iid2
gen pair=_n
save mrp_all, replace
reshape long iid, i(pair) j(ipid)
save mrp, replace


/*
use ../../500k_mp, clear
sort iid
merge m:1 iid using demo, nogen keep(1 3)
drop fid
bysort fm: gen j=_n
reshape wide iid sex birthyr, i(fm) j(j)
gen birthyrd=birthyr1-birthyr2 if sex1==1
replace birthyrd=birthyr2-birthyr1 if sex1==2
*/
