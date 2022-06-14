#! /bin/bash

path="/work/ollie/egowan/PISM/pism_blackboard"

time=$1

percent_cover=$2

#file1=snap_${time}.000.nc

time_id=$(echo ${time} / 50 | bc)

file1=ex_pism.nc?usurf[${time_id}]

file_snap="snap_0.000.nc"

#base_y1=1200000
#base_y2=2800000

base_y1=720000
base_y2=3280000

for intervals in $(seq 0 10)
do




y1=$( echo ${base_y1} ${intervals} | awk '{print $1 - $2 * 20000}')
y2=$( echo ${base_y2} ${intervals} | awk '{print $1 + $2 * 20000}')

x=2000000

x_min=0
x_max=4000000 # 4000 km
y_min=0
y_max=4000000



half_tick=2000000
eighth_tick=500000
sixteeth_tick=250000

R_options="-R${x_min}/${x_max}/${y_min}/${y_max}"

x_min_k=0
x_max_k=4000 # 4000 km
y_min_k=0
y_max_k=4000


half_tick_k=2000
eighth_tick_k=500
sixteeth_tick_k=250

R_options_k="-R${x_min_k}/${x_max_k}/${y_min_k}/${y_max_k}"

map_width=6c

J_options="-JX${map_width}/0"

x_position="3c"
y_position="14c"

max_val=1750
min_val=-1500
interval=125
tick_interval=125

gmt makecpt -Cjet -T${min_val}/${max_val}/${interval} -I > iceshades.cpt


max_val=2000
min_val=-1000
interval=250
tick_interval=250

gmt makecpt -Cjet -T${min_val}/${max_val}/${interval} -I > iceshades_coarse.cpt

plot=ice_surface_ts_${intervals}.ps

gmt grdmath ${file1} 250 GT 0 NAN ${file1} MUL = usurf.nc

gmt grdimage usurf.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -P -Ciceshades.cpt -V -nb > ${plot}

gmt grdcontour usurf.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -Wthin,black -P -Ciceshades_coarse.cpt -An >> ${plot}

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ss0.4 -Gyellow -Wthick,black >> ${plot}
${x} ${y1}
END_CAT

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Sc0.32 -Gyellow -Wthick,black >> ${plot}
${x} ${y2}
END_CAT

gmt psbasemap -Ya${y_position} -Xa${x_position}  ${R_options_k} ${J_options} -Bx+l"x (km)" -By+l"y (km)"+ap  -Ba${half_tick_k}f${eighth_tick_k} -BSWen -K -P -O >> ${plot}

gmt pstext << END  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+cTR -D-0.1/-0.1 -Gwhite >> ${plot}
ice surface elevation
END

gmt pstext << END_CAT -Ya${y_position} -Xa${x_position}  ${J_options} ${R_options} -F+cTL+f12p -D0.1/-0.1 -P -Gwhite -K -O  >> ${plot}
(a)
END_CAT

x_position_s=-3c
y_position_s=10c
gmt psscale  -Ya${y_position_s} -Xa${x_position_s} -Dx9c/2c/6c/0.5ch -P -O -K -Bx500+250f250+l"Ice elevation (m)" -G250/1750 -Ciceshades.cpt --FONT_LABEL=14p -V  >> $plot



x_position="11c"
y_position="14c"

max_val=112.5
min_val=-12.5
interval=25
tick_interval=25


gmt makecpt -Cbatlow -T${min_val}/${max_val}/${interval} -I > cover.cpt


gmt grdmath ${file_snap}?tillcover 100 MUL = tillcover.nc


gmt grdimage tillcover.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ccover.cpt -V -nb >> ${plot}

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ss0.4 -Gyellow -Wthick,black >> ${plot}
${x} ${y1}
END_CAT

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Sc0.32 -Gyellow -Wthick,black >> ${plot}
${x} ${y2}
END_CAT


gmt psbasemap -Ya${y_position} -Xa${x_position}  ${R_options_k} ${J_options} -Bx+l"x (km)" -By+l"y (km)"+ap  -Ba${half_tick_k}f${eighth_tick_k} -BSWen -K -P -O >> ${plot}

gmt pstext << END  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+cTR -D-0.1/-0.1 -Gwhite >> ${plot}
till cover (%)
END

gmt pstext << END_CAT -Ya${y_position} -Xa${x_position}  ${J_options} ${R_options} -F+cTL+f12p -D0.1/-0.1 -K -P -Gwhite  -O  >> ${plot}
(b)
END_CAT

x_position_s=5c
y_position_s=10c
gmt psscale  -Ya${y_position_s} -Xa${x_position_s} -Dx9c/2c/6c/0.5ch -P -K -O -Bx50f25+l"Till cover (%)" -G0/100 -Ccover.cpt --FONT_LABEL=14p -V  >> $plot


x_position=7c
y_position=9c

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Sc0.32 -Gyellow -Wthick,black >> ${plot}
550000 500000
END_CAT


gmt pstext << END_CAT  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+jML  >> ${plot}
850000 500000 Reference
END_CAT

x_position=10c
y_position=9c

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ss0.4 -Gyellow -Wthick,black >> ${plot}
550000 500000
END_CAT


gmt pstext << END_CAT  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+jML  >> ${plot}
850000 500000 Comparison
END_CAT




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


python3 ${path}/extract_ts.py ${y1} ${y2}


x_position="5c"
y_position="4.5c"



gmt psxy ts_1.txt -Xa${x_position} -Ya${y_position} ${J_options} ${R_options} -P -K -O -Wthick,blue >> ${plot}

gmt psxy ts_2.txt -Xa${x_position} -Ya${y_position} -BWSen -Bxa${xint}f${xsubint}+l"Time (years)" -Bya${yint}f${ysubint}+l"Ice Thickness (m)"   ${J_options} ${R_options} -P -O -K -Wthick,red >> ${plot}

gmt psxy << END_CAT ${J_options} ${R_options} -Xa${x_position} -Ya${y_position} -P -K -O -Wthick,blue >> ${plot}
14500 1500
16500 1500
END_CAT

gmt psxy << END_CAT ${J_options} ${R_options}  -Xa${x_position} -Ya${y_position} -P -K -O -Wthick,red >> ${plot}
14500 1300
16500 1300
END_CAT

gmt psxy << END_CAT ${J_options} ${R_options}  -Xa${x_position} -Ya${y_position} -P -K -O -Wthick,black,- >> ${plot}
${time} ${ymin}
${time} ${ymax}
END_CAT

gmt pstext << END_CAT  ${J_options} ${R_options} -Xa${x_position} -Ya${y_position} -P  -K -O -F+f10p,Helvetica,black+jlm >> ${plot}
17000 1500 ${percent_cover}% cover
17000 1300 100% cover
END_CAT

gmt pstext << END_CAT -Xa${x_position} -Ya${y_position}  ${J_options} ${R_options} -F+cTL+f12p -D0.1/-0.1 -P  -O  >> ${plot}
(c)
END_CAT

done

