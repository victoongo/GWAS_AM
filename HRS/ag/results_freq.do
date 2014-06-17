cd "D:\AMH\ag"

usesas using agfall.sas7bdat, clear
*reshape wide rhorul prul rhorul prul, i(pair) j(col)
sort pair
merge m:1 pair using ag_pairs_all, nogen keep(3)
ta col typef if typef~="pc", sum(percent) nofreq
