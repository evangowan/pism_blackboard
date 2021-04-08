#! /bin/bash

file1=$1

x=2000000
y1=1100000
y2=2900000

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
y_position="8c"

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

plot=ice_surface.ps

gmt grdmath ${file1}?usurf 250 GT 0 NAN ${file1}?usurf MUL = usurf.nc

gmt grdimage usurf.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -P -Ciceshades.cpt -V -nb > ${plot}

gmt grdcontour usurf.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -Wthin,black -P -Ciceshades_coarse.cpt -An >> ${plot}

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ss0.4 -Gwhite -Wthick,black >> ${plot}
${x} ${y1}
END_CAT

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Sa0.4 -Gwhite -Wthick,black >> ${plot}
${x} ${y2}
END_CAT

gmt psbasemap -Ya${y_position} -Xa${x_position}  ${R_options_k} ${J_options} -Bx+l"x (km)" -By+l"y (km)"+ap  -Ba${half_tick_k}f${eighth_tick_k} -BSWen -K -P -O >> ${plot}

gmt pstext << END  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+cTL -D0.1/-0.1 -Gwhite >> ${plot}
ice surface elevation
END

x_position_s=-3c
y_position_s=4c
gmt psscale  -Ya${y_position_s} -Xa${x_position_s} -Dx9c/2c/6c/0.5ch -P -O -K -Bx500+250f250+l"Ice elevation (m)" -G250/1750 -Ciceshades.cpt --FONT_LABEL=14p -V  >> $plot



x_position="11c"
y_position="8c"

max_val=112.5
min_val=-12.5
interval=25
tick_interval=25


gmt makecpt -Cbatlow -T${min_val}/${max_val}/${interval} -I > cover.cpt


gmt grdmath ${file1}?tillcover 100 MUL = tillcover.nc


gmt grdimage tillcover.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ccover.cpt -V -nb >> ${plot}

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ss0.4 -Gwhite -Wthick,black >> ${plot}
${x} ${y1}
END_CAT

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Sa0.4 -Gwhite -Wthick,black >> ${plot}
${x} ${y2}
END_CAT


gmt psbasemap -Ya${y_position} -Xa${x_position}  ${R_options_k} ${J_options} -Bx+l"x (km)" -By+l"y (km)"+ap  -Ba${half_tick_k}f${eighth_tick_k} -BSWen -K -P -O >> ${plot}

gmt pstext << END  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+cTL -D0.1/-0.1 -Gwhite >> ${plot}
till cover (%)
END

x_position_s=5c
y_position_s=4c
gmt psscale  -Ya${y_position_s} -Xa${x_position_s} -Dx9c/2c/6c/0.5ch -P -K -O -Bx50f25+l"Till cover (%)" -G0/100 -Ccover.cpt --FONT_LABEL=14p -V  >> $plot


x_position=7c
y_position=2.5c

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Sa0.4 -Gwhite -Wthick,black >> ${plot}
500000 500000
END_CAT


gmt pstext << END_CAT  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+jML  >> ${plot}
800000 500000 Reference
END_CAT

x_position=10c
y_position=2.5c

gmt psxy << END_CAT -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -K -O -P -Ss0.4 -Gwhite -Wthick,black >> ${plot}
500000 500000
END_CAT


gmt pstext << END_CAT  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O  -P -F+f10p,Helvetica,black+jML  >> ${plot}
800000 500000 Comparison
END_CAT


