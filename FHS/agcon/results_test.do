cd "D:\AM\FHS550k\ag"
use mx_maf_mp, clear
bsample
gen sampleid=0
sort pair
save mp1000\mp0, replace

use mx_maf_mp, clear
rename estimate estimateo
sort pair
merge 1:m pair using mp1000\mp3
corr estimateo estimate

use mx_maf_rp_all, clear
rename estimate estimateo
sort pair
merge 1:m pair using rp1000\rp3
corr estimateo estimate
