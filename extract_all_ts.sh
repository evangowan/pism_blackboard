#! /bin/bash

path="/work/ollie/egowan/PISM/pism_blackboard"

mkdir ${path}/time_series

base_y1=720000
base_y2=3280000

for intervals in 8 #$(seq 0 10)
do

y1=$( echo ${base_y1} ${intervals} | awk '{print $1 - $2 * 20000}')
y2=$( echo ${base_y2} ${intervals} | awk '{print $1 + $2 * 20000}')


for experiment in new_basal_50_cover_lowangle2_phi20_wet new_basal_50_cover_lowangle2_phi20_wet0 new_basal_50_cover_lowangle2_phi20_wet2 new_basal_50_cover_lowangle2_phi20_wet3 new_basal_50_cover_lowangle2_phi20_wet4 new_basal_50_cover_lowangle2_phi20 #new_basal_50_cover new_basal_50_cover_lowangle2  new_basal_50_cover_lowangle2_phi20_rand new_basal_50_cover_lowangle2_phi20_rand2  new_basal_50_cover_lowangle2_rand new_basal_50_cover_lowangle2_rand2 new_basal_50_cover_lowangle3 new_basal_50_cover_lowangle3_phi20 new_basal_80_cover new_basal_95_cover new_basal_95_cover_default new_basal_95_cover_default_phi20 new_basal_95_cover_lowangle new_basal_95_cover_lowangle2 new_basal_95_cover_lowangle2_phi20 new_basal_95_cover_lowangle3 new_basal_95_cover_lowangle3_phi20 new_basal_99_cover
do

directory=${path}/${experiment}/high

if [ -d "$directory" ]; then

cd ${directory}

mkdir ${path}/time_series/${experiment}

vartype=thk
python3 ${path}/extract_ts.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}/ts_${vartype}_${counter}.txt
done

vartype=volume_water_flux
python3 ${path}/extract_ts_waterflux.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}/ts_${vartype}_${counter}.txt
done


vartype=velsurf_mag
python3 ${path}/extract_ts_vel.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}/ts_${vartype}_${counter}.txt
done


vartype=hydrology_type
python3 ${path}/extract_ts_hydrology.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}/ts_${vartype}_${counter}.txt
done


vartype=usurf
python3 ${path}/extract_ts_usurf.py ${y1} ${y2}


for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}/ts_${vartype}_${counter}.txt
done




vartype=sliding_mechanism
python3 ${path}/extract_ts_sliding.py ${y1} ${y2}


for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}/ts_${vartype}_${counter}.txt
done

cd ${path}

fi

done
done


# extract extra experiments

for experiment in  new_basal_50_cover_lowangle2_phi20_wet3 
do

for subexperiment in higher high_20000 high_30000 high_35000 high_40000
directory=${path}/${experiment}/${subexperiment}

if [ -d "$directory" ]; then

cd ${directory}

mkdir ${path}/time_series/${experiment}_${subexperiment}

vartype=thk
python3 ${path}/extract_ts.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}_${subexperiment}/ts_${vartype}_${counter}.txt
done

vartype=volume_water_flux
python3 ${path}/extract_ts_waterflux.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}_${subexperiment}/ts_${vartype}_${counter}.txt
done


vartype=velsurf_mag
python3 ${path}/extract_ts_vel.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}_${subexperiment}/ts_${vartype}_${counter}.txt
done


vartype=hydrology_type
python3 ${path}/extract_ts_hydrology.py ${y1} ${y2}

for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}_${subexperiment}/ts_${vartype}_${counter}.txt
done


vartype=usurf
python3 ${path}/extract_ts_usurf.py ${y1} ${y2}


for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}_${subexperiment}/ts_${vartype}_${counter}.txt
done




vartype=sliding_mechanism
python3 ${path}/extract_ts_sliding.py ${y1} ${y2}


for counter in 1 2
do
cp ts_${vartype}_${counter}.txt ${path}/time_series/${experiment}_${subexperiment}/ts_${vartype}_${counter}.txt
done

cd ${path}

fi

done
done
