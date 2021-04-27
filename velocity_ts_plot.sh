#! /bin/bash

path="/work/ollie/egowan/PISM/pism_blackboard"

percent_cover=$1

xmin=25040
xmax=25050
xint=2
xsubint=0.5
ymin=0
ymax=30
yint=10
ysubint=5

J_options="-JX12c/4c"
R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

x=2000000

y1=1100000
y2=2900000

y1=1000000
y2=3000000


y1=900000
y2=3100000

y1=800000
y2=3200000

y1=700000
y2=3300000

#y1=600000
#y2=3400000


python3 ${path}/extract_ts_vel.py ${y1} ${y2}

plot="velocity_compare.ps"

gmt psxy ts_1.txt  ${J_options} ${R_options} -P -K -Wthick,blue > ${plot}

gmt psxy ts_2.txt  -BWSen -Bxa${xint}f${xsubint}+l"Time (years)" -Bya${yint}f${ysubint}+l"Ice surface velocity (m/yr)"   ${J_options} ${R_options} -P -O -K -Wthick,red >> ${plot}

gmt psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,blue >> ${plot}
25041 27
25042 27
END_CAT

gmt psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,red >> ${plot}
25041 22
25042 22
END_CAT

gmt pstext << END_CAT  ${J_options} ${R_options} -P  -O -F+f10p,Helvetica,black+jlm >> ${plot}
25042.5 27 ${percent_cover}% cover
25042.5 22 100% cover
END_CAT
