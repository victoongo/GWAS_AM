set more off
set matsize 11000
set maxvar 32767
cd /lustre/scr/v/i/victorw/r5000p989/

foreach m of num 1/6 {
	local n=(`m'-1)*111+`1'
	!plink --bfile 500k --extract snplst/rp`n'.txt --make-bed --out snplst/rp`n'
	!plink --bfile snplst/rp`n' --recodeA --out snplst/rp`n' 
}
