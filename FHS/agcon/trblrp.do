cd "D:\AM\FHS550k\agcon"

usesas using freq, clear
sort pair
merge pair using trblrp
save freq, replace

usesas using freq1, clear
sort pair
merge pair using trblrp1
append using freq
twoway (scatter percent rhorul if col==4, msymbol(point))
, by(col) 
*twoway (scatter count rhorul), by(col)

