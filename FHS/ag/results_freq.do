cd "D:\AM\FHS550k\ag"

usesas using agfall.sas7bdat, clear
*reshape wide rhorul prul rhorul prul, i(pair) j(col)
sort pair
merge m:1 pair using ag_pairs_alln, nogen keep(3)
ta col typef, sum(percent) nofreq
