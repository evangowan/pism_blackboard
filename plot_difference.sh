#! /bin/bash

file1=$1
file2=$2

x_min=0
x_max=4000000 # 4000 km
y_min=0
y_max=4000000

half_tick=2000000
eighth_tick=500000
sixteeth_tick=250000

R_options="-R${x_min}/${x_max}/${y_min}/${y_max}"

map_width=15c

J_options="-JX${map_width}/0"

x_position="3c"
y_position="8c"

max_diff=1625
min_diff=-1625

makecpt -Cpolar -T${min_diff}/${max_diff}/250 -I > shades_diff.cpt

# create thickness difference

grdmath ${file1}?thk ${file2}?thk SUB = diff.nc
grdmath diff.nc ${min_diff} GT diff.nc ${min_diff} IFELSE = diff2.nc
grdmath diff.nc ${max_diff} LT diff2.nc ${max_diff} IFELSE = diff3.nc

plot=thickness_difference.ps

grdimage diff3.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -Bx+l"x (m)" -By+l"y (m)"  -Ba${half_tick}f${eighth_tick} -BSWen -K -P -Cshades_diff.cpt -V -nb > ${plot}

pstext << END  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+cTL -D0.1/-0.1 -Gwhite >> ${plot}
${file1} - ${file2}
END


x_position="6c"
y_position="5.5c"

psscale  -Dx${x_position}/${y_position}+w9c/0.5c+h  -O -Cshades_diff.cpt -Bx500+l"Thickness difference (m)"  -V --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=12p --MAP_ANNOT_OFFSET_PRIMARY=1p --MAP_TICK_LENGTH_PRIMARY=2p >> ${plot}


grdmath ${file1}?thk 0 GT = mask1.nc

grdmath ${file2}?thk 0 GT = mask2.nc

grdmath mask1.nc mask2.nc MUL 0 NAN = mask3.nc

# create velocity difference

max_diff=52.5
min_diff=-52.5

makecpt -Cpolar -T${min_diff}/${max_diff}/5 -I > shades_diff.cpt


grdmath ${file1}?velsurf_mag 0 DENAN ${file2}?velsurf_mag 0 DENAN SUB = diff.nc
grdmath diff.nc ${min_diff} GT diff.nc ${min_diff} IFELSE = diff2.nc
grdmath diff.nc ${max_diff} LT diff2.nc ${max_diff} IFELSE mask3.nc MUL = diff3.nc

plot=velocity_difference.ps


x_position="3c"
y_position="8c"

grdimage diff3.nc -Xa${x_position} -Ya${y_position}  ${R_options} ${J_options} -Bx+l"x (m)" -By+l"y (m)"  -Ba${half_tick}f${eighth_tick} -BSWen -K -P -Cshades_diff.cpt -V -nb > ${plot}

pstext << END  -Ya${y_position} -Xa${x_position}  ${R_options} ${J_options} -O -K -P -F+f10p,Helvetica,black+cTL -D0.1/-0.1 -Gwhite >> ${plot}
${file1} - ${file2}
END

x_position="6c"
y_position="5.5c"

psscale  -Dx${x_position}/${y_position}+w9c/0.5c+h  -O -Cshades_diff.cpt -Bx10+l"Velocity difference (m/year)"  -V --FONT_ANNOT_PRIMARY=10p --FONT_LABEL=12p --MAP_ANNOT_OFFSET_PRIMARY=1p --MAP_TICK_LENGTH_PRIMARY=2p >> ${plot}


