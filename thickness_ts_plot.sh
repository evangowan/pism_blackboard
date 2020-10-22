#! /bin/bash

path="/work/ollie/egowan/PISM/pism_blackboard"

percent_cover=$1

xmin=10000
xmax=35000
xint=5000
xsubint=1000
ymin=0
ymax=1600
yint=400
ysubint=100

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


python3 ${path}/extract_ts.py ${y1} ${y2}

plot="thickness_compare.ps"

psxy ts_1.txt  ${J_options} ${R_options} -P -K -Wthick,blue > ${plot}

psxy ts_2.txt  -BWSen -Bxa${xint}f${xsubint}+l"Time (years)" -Bya${yint}f${ysubint}+l"Ice Thickness (m)"   ${J_options} ${R_options} -P -O -K -Wthick,red >> ${plot}

psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,blue >> ${plot}
11000 1500
13000 1500
END_CAT

psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,red >> ${plot}
11000 1300
13000 1300
END_CAT

pstext << END_CAT  ${J_options} ${R_options} -P  -O -F+f10p,Helvetica,black+jlm >> ${plot}
13500 1500 ${percent_cover}% cover
13500 1300 100% cover
END_CAT
