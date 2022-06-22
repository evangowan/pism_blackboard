#! /bin/bash

mkdir plots

fonts=" --FONT_ANNOT_PRIMARY=10p --FONT_ANNOT_SECONDARY=8p --FONT_LABEL=12p --FONT_TITLE=10p --MAP_TICK_LENGTH_PRIMARY=4p --MAP_ANNOT_OFFSET_PRIMARY=2p --MAP_LABEL_OFFSET=10p "

height="4"

percent_cover=$1

x=2000000

corner_label=12p





cover=50





cat << end_cat > phi_val_1.txt
new_basal_50_cover_lowangle_wet3 0.5 1 30
new_basal_50_cover_lowangle_phi20_wet3 0.5 1 20
new_basal_50_cover_lowangle2_wet3 1 2 30
new_basal_50_cover_lowangle2_phi20_wet3 1 2 20
end_cat


cat << end_cat > phi_val_2.txt
new_basal_50_cover_lowangle3_wet3 2 5 30
new_basal_50_cover_lowangle3_phi20_wet3 2 5 20
new_basal_50_cover_wet3 5 15 30
new_basal_50_cover_default_phi20_wet3 5 15 20
end_cat

for loop_num in 1 2
do

first=true

plot="plots/velocity_compare_sedphi_${loop_num}.ps"

for line in 1 2 3 4
do

experiment=$( awk -v line=${line} '{if(NR==line) {print $1}}' phi_val_${loop_num}.txt )
phi_sc=$( awk -v line=${line} '{if(NR==line) {print $2}}' phi_val_${loop_num}.txt )
phi_rc=$( awk -v line=${line} '{if(NR==line) {print $3}}' phi_val_${loop_num}.txt )
phi_sed=$( awk -v line=${line} '{if(NR==line) {print $4}}' phi_val_${loop_num}.txt )

xmin=25015.9
xmax=25017.1
xint=0.5
xsubint=0.08333
ymin=0
ymax=29
yint=10
ysubint=5

y_label_position=25015.4


J_options="-JX3c/${height}c"
R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"



# velocity


if ${first}
then

	labelling="-BWbrt -Bxa${xint}f${xsubint} -Bya${yint}f${ysubint}"

	gmt psxy -Y6c ${experiment}/ts_velsurf_mag_1.txt  ${J_options} ${R_options} -P -K -Wthick,blue > ${plot}


else

	labelling="-Blbrt"

	shift_down="-$(echo "${height} * 3" | bc)c"


	shift_right=3c

	gmt psxy ${experiment}/ts_velsurf_mag_1.txt -Y${shift_down} -X${shift_right} ${J_options} ${R_options} -P -K -Wthick,blue -O >> ${plot}

fi

gmt psxy ${experiment}/ts_velsurf_mag_2.txt  ${labelling}   ${J_options} ${R_options} -P -O -K -Wthick,red ${fonts} >> ${plot}



y_mid=$( echo "${ymin} ${ymax}" | awk '{print ($1 + $2) / 2}')

if ${first}
then
	gmt pstext << END_CAT  ${J_options} ${R_options}  -P -K -O -F+f12p,Helvetica,black+jcb+a90 -N  >> ${plot}
${y_label_position} ${y_mid} Velocity (m/yr)
END_CAT

	gmt pstext << END_CAT -R -JX -F+cTL+f${corner_label} -D0.1/-0.1 -P -K -O  >> ${plot}
(d)
END_CAT

fi


cat << EOF >| yannots.txt
0 a J
1 a F
2 a M
3 a A
4 a M
5 a J
6 a J
7 a A
8 a S
9 a O
10 a N
11 a D
EOF

xmin=-1
xmax=12
xint=3
xsubint=1

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

labelling="-BS -Bxa${xint}f${xsubint}  -Bpxcyannots.txt"

gmt psbasemap  ${labelling}  ${J_options} ${R_options} -P -O -K  --FONT_ANNOT_PRIMARY=7p >> ${plot}

xmin=25015.9
xmax=25017.1
xint=0.5
xsubint=0.08333

# sliding mechanism

cat << EOF >| yannots.txt
0 a none
1 a def
2 a hydro
3 a sgl
EOF




ymin=-.5
ymax=3.5
yint=1
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"


if ${first}
then
	labelling="-BWSrt -Bpycyannots.txt"
else
	labelling="-Blbrt"
fi

gmt psxy ${experiment}/ts_sliding_mechanism_1.txt -Y${height}c  ${J_options} ${R_options} -O -P -K -Wthick,blue >> ${plot}

#gmt psxy ts_2.txt  -BWSen  -Bya${yint}+l"Sliding mechanism"   ${J_options} ${R_options} -P -O -K -Wthick,red ${fonts} >> ${plot}

gmt psxy ${experiment}/ts_sliding_mechanism_2.txt  ${labelling}  ${J_options} ${R_options} -P -O -K -Wthick,red ${fonts} >> ${plot}

y_mid=$( echo "${ymin} ${ymax}" | awk '{print ($1 + $2) / 2}')

if ${first}
then
	gmt pstext << END_CAT  ${J_options} ${R_options}  -P -K -O -F+f12p,Helvetica,black+jcb+a90 -N >> ${plot}
${y_label_position} ${y_mid} Sliding mechanism
END_CAT

	gmt pstext << END_CAT -R -JX -F+cTL+f${corner_label} -D0.1/-0.1 -P -K -O  >> ${plot}
(c)
END_CAT

fi

# hydrology type

cat << EOF >| yannots.txt
0 a dry
1 a tun
2 a cav
3 a ob
EOF






ymin=-0.5
ymax=3.5
yint=1
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"





gmt psxy ${experiment}/ts_hydrology_type_1.txt -Y${height}c  ${J_options} ${R_options} -P -K -O -Wthick,blue >> ${plot}


gmt psxy ${experiment}/ts_hydrology_type_2.txt  ${labelling}  ${J_options} ${R_options} -P -O -K -Wthick,red  ${fonts} >> ${plot}

y_mid=$( echo "${ymin} ${ymax}" | awk '{print ($1 + $2) / 2}')


if ${first}
then
	gmt pstext << END_CAT  ${J_options} ${R_options}  -P -K -O -F+f12p,Helvetica,black+jcb+a90 -N >> ${plot}
${y_label_position} ${y_mid} Hydrology type
END_CAT

	gmt pstext << END_CAT -R -JX -F+cTL+f${corner_label} -D0.1/-0.1 -P -K -O  >> ${plot}
(b)
END_CAT

fi

# water flux

ymin=1
ymax=1000
yint=1
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

J_options="-JX3c/${height}cl"

if ${first}
then
	labelling="-BWSrt  -Bya1f3p "
else
	labelling="-Blbrt"
fi


awk -v minval=${ymin} '{if($2 < minval) {print $1, minval} else {print $1, $2}}' ${experiment}/ts_volume_water_flux_1.txt  > ts_1_m.txt

gmt psxy ts_1_m.txt -Y${height}c  ${J_options} ${R_options} -P -O -K -Wthick,blue -B+t"@~\147@~@-sc@-=${phi_sc}  @~\147@~@-rc@-=${phi_rc}  @~\146@~@-sed@-=${phi_sed}" --FONT_TITLE=8p >> ${plot}

awk -v minval=${ymin} '{if($2 < minval) {print $1, minval} else {print $1, $2}}' ${experiment}/ts_volume_water_flux_2.txt > ts_2_m.txt

gmt psxy ts_2_m.txt  ${labelling}   ${J_options} ${R_options} -P -K -O  -Wthick,red ${fonts} >> ${plot}

y_mid=$( echo "${ymin} ${ymax}" | awk '{print 10^((log($1)/log(10) + log($2)/log(10)) / 2)}')

if ${first}
then
	gmt pstext << END_CAT  ${J_options} ${R_options}  -P -O -K -F+f12p,Helvetica,black+jcb+a90 -N >> ${plot}
${y_label_position} ${y_mid} Water flux (m@+3@+/s)
END_CAT

	gmt pstext << END_CAT -R -JX -F+cTL+f${corner_label} -D0.1/-0.1 -P -O -K >> ${plot}
(a)
END_CAT

fi

first=false

done

xmin=25015
xmax=25020

ymin=0
ymax=30
yint=10
ysubint=5

R_options="-R${xmin}/${xmax}/${ymin}/${ymax}"

J_options="-JX16c/${height}c"

gmt psxy << END_CAT ${J_options} ${R_options} -Y-16c -X-12c -P -K -O -Wthick,blue >> ${plot}
25016 17
25016.5 17
END_CAT

gmt psxy << END_CAT ${J_options} ${R_options}  -P -K -O -Wthick,red >> ${plot}
25017.5 17
25018 17
END_CAT
gmt pstext << END_CAT  ${J_options} ${R_options} -P  -O -K -F+f12p,Helvetica,black+jlm >> ${plot}
25017.5 23 Time (months)
END_CAT

gmt pstext << END_CAT  ${J_options} ${R_options} -P  -O -F+f10p,Helvetica,black+jlm >> ${plot}
25016.75 17 ${cover}% cover
25018.25 17 100% cover
END_CAT


gmt psconvert -Tf -A ${plot}

rm phi_val_${loop_num}.txt ts_1_m.txt ts_2_m.txt
done
