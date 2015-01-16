cd "D:\AM\FHS550k\agcon"

usesas using agconmad1, clear
sort iid
save agconmad1, replace

usesas using plst/agp1, clear
sort iid
merge m:1 iid using agconmad1, nogen keep(3)
save agp1, replace

use agp1, clear
reshape wide ss*, i(pair) j(iid)

bysort pair: 
xpose, clear varname

