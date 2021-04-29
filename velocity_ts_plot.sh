#! /bin/bash

path="/work/ollie/egowan/PISM/pism_blackboard"

fonts=" --FONT_ANNOT_PRIMARY=10p --FONT_ANNOT_SECONDARY=8p --FONT_LABEL=10p --FONT_TITLE=10p --MAP_TICK_LENGTH_PRIMARY=4p --MAP_ANNOT_OFFSET_PRIMARY=2p --MAP_LABEL_OFFSET=20p "

height=4c

percent_cover=$1

xmin=25015
xmax=25020
xint=1
xsubint=0.25
ymin=0
ymax=29
yint=10
ysubint=5

y_label_position=25014.5


J_options="-JX12c/${height}"
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

gmt psxy ts_2.txt  -BWSen -Bxa${xint}f${xsubint}+l"Model Time (years)" -Bya${yint}f${ysubint}   ${J_options} ${R_options} -P -O -K -Wthick,red ${fonts} >> ${plot}

gmt psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,blue >> ${plot}
25015.25 27
25015.75 27
END_CAT

gmt psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,red >> ${plot}
25015.25 24
25015.75 24
END_CAT

gmt pstext << END_CAT  ${J_options} ${R_options} -P -K -O -F+f10p,Helvetica,black+jlm+a-90 >> ${plot}
25016 27 ${percent_cover}% cover
25016 24 100% cover
END_CAT

y_mid=$( echo "${ymin} ${ymax}" | awk '{print ($1 + $2) / 2}')

gmt text << END_CAT  ${J_options} ${R_options}  -P -K -O -F+f10p,Helvetica,black+jcb -N  >> ${plot}
${y_label_position} ${y_mid} Velocity (m/yr)
END_CAT

# sliding mechanism

cat << EOF >| yannots.txt
0 a none
1 a sed
2 a hydro
3 a sgl
EOF


python3 ${path}/extract_ts_sliding.py ${y1} ${y2}



ymin=-.5
ymax=3.5
yint=1
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

gmt psxy ts_1.txt -Y${height}  ${J_options} ${R_options} -O -P -K -Wthick,blue >> ${plot}

#gmt psxy ts_2.txt  -BWSen  -Bya${yint}+l"Sliding mechanism"   ${J_options} ${R_options} -P -O -K -Wthick,red ${fonts} >> ${plot}

gmt psxy ts_2.txt  -BWSen -Bpycyannots.txt  ${J_options} ${R_options} -P -O -K -Wthick,red ${fonts} >> ${plot}

y_mid=$( echo "${ymin} ${ymax}" | awk '{print ($1 + $2) / 2}')

gmt text << END_CAT  ${J_options} ${R_options}  -P -K -O -F+f10p,Helvetica,black+jcb -N >> ${plot}
${y_label_position} ${y_mid} Sliding mechanism
END_CAT


# hydrology type

cat << EOF >| yannots.txt
0 a dry
1 a tun
2 a cav
3 a ob
EOF



python3 ${path}/extract_ts_hydrology.py ${y1} ${y2}



ymin=-0.5
ymax=3.5
yint=1
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

gmt psxy ts_1.txt -Y${height}  ${J_options} ${R_options} -P -K -O -Wthick,blue >> ${plot}

#gmt psxy ts_2.txt  -BWSen  -Bya${yint}+l"Hydrology type"   ${J_options} ${R_options} -P -O -K -Wthick,red  ${fonts} >> ${plot}

gmt psxy ts_2.txt  -BWSen   -Bpycyannots.txt  ${J_options} ${R_options} -P -O -K -Wthick,red  ${fonts} >> ${plot}

gmt text << END_CAT  ${J_options} ${R_options}  -P -K -O -F+f10p,Helvetica,black+jcb -N >> ${plot}
${y_label_position} ${y_mid} Hydrology type
END_CAT


python3 ${path}/extract_ts_waterflux.py ${y1} ${y2}

ymin=1
ymax=10000
yint=1
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

J_options="-JX12c/${height}l"

awk -v minval=${ymin} '{if($2 < minval) {print $1, minval} else {print $1, $2}}' ts_1.txt > ts_1_m.txt

gmt psxy ts_1_m.txt -Y${height}  ${J_options} ${R_options} -P -O -K -Wthick,blue >> ${plot}

awk -v minval=${ymin} '{if($2 < minval) {print $1, minval} else {print $1, $2}}' ts_2.txt > ts_2_m.txt

gmt psxy ts_2_m.txt  -BWSen  -Bya1f3p   ${J_options} ${R_options} -P -K -O  -Wthick,red ${fonts} >> ${plot}

gmt text << END_CAT  ${J_options} ${R_options}  -P -O -F+f10p,Helvetica,black+jcb -N >> ${plot}
${y_label_position} ${y_mid} Water volume flux (m@+3@+/s)
END_CAT


