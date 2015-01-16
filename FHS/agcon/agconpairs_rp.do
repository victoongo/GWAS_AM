cd D:\AM\FHS550k\agcon

insheet using "snplst/500k.fam", delimiter(" ") clear
renvars v1-v6 / fid iid fshare mshare sex pheno
keep fid iid sex
sort iid
tempfile 500k
save `500k', replace

use ag_pairs_rp, clear
rename iid1 iid
sort iid
merge m:1 iid using `500k', nogen keep(3)
rename iid iid1 
rename iid2 iid
sort iid
merge m:1 iid using `500k', nogen keep(3)

