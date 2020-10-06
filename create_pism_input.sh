#! /bin/bash

mkdir output
rm output/*

folder=nc

mkdir ${folder}
rm ${folder}/*

resolution=20 # in km
resolution_m=${resolution}000 # in m


# create index

time_interval=100
time_start=0
time_end=40000

seq ${time_start} ${time_interval} ${time_end} > time_values.txt

awk -v start_val=${time_start} -v interval=${time_interval} '{if($1==start_val) {print 0, $1, $1} else {print 0, $1, $1-interval/2}}' time_values.txt > tbnds.txt
awk -v end_val=${time_end} -v interval=${time_interval} '{if($1==end_val) {print 1, $1, $1} else {print 1, $1, $1+interval/2}}' time_values.txt >> tbnds.txt

xyz2grd tbnds.txt -G${folder}/ts_temp.nc -R0/1/${time_start}/${time_end} -I1/${time_interval}



# equation for making the glacial index
#ncap2 -Oh -s 'glac_index[y]=1.2 * cos( 2 *  3.14159265359 / 40000 * (y-20000  )) / 2 + 0.6;' ${folder}/ts_temp.nc ${folder}/ts_temp2.nc
ncap2 -Oh -s 'glac_index[y]=cos( 2 *  3.14159265359 / 40000 * (y-20000  )) / 2 + 0.5;' ${folder}/ts_temp.nc ${folder}/ts_temp2.nc

ncrename -d y,time -v y,time -dx,bnds -v x,bnds -v z,tbnds  ${folder}/ts_temp2.nc


ncatted  -a  long_name,time,o,c,"Time (years before present)"  ${folder}/ts_temp2.nc
ncatted  -a  standard_name,time,o,c,"time"    ${folder}/ts_temp2.nc
ncatted -a units,time,o,c,"years since 1-1-1" ${folder}/ts_temp2.nc
ncatted -a calendar,time,o,c,"365_day" ${folder}/ts_temp2.nc



ncatted  -a  long_name,bnds,o,c,"bnds" ${folder}/ts_temp2.nc
ncatted  -a  standard_name,bnds,o,c,"bnds"   ${folder}/ts_temp2.nc


ncatted  -a  long_name,tbnds,o,c,"Time (years before present)"  ${folder}/ts_temp2.nc
ncatted  -a  standard_name,tbnds,o,c,"time"    ${folder}/ts_temp2.nc
ncatted -a units,tbnds,o,c,"years since 1-1-1" ${folder}/ts_temp2.nc
ncatted -a calendar,tbnds,o,c,"365_day" ${folder}/ts_temp2.nc


# maybe needs "unit", but in the standard file it is blank, and ncatted doesn't allow it to be blank
ncatted  -a  long_name,glac_index,o,c,"glac_index"  ${folder}/ts_temp2.nc
ncatted -a calendar,glac_index,o,c,"365_day" ${folder}/ts_temp2.nc

mv ${folder}/ts_temp2.nc ${folder}/glacial_index.nc

rm ${folder}/ts_temp.nc



grid_width=4000
grid_width_m=${grid_width}000

./create_grids ${resolution} ${grid_width}




#########
# tillphi
#########

variable=tillphi

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short} [degrees]" # always include units
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
title="phi" # title for the data
fillval="NaN"
remark="friction angle for till under grounded ice sheet"
units="degrees"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc

#########
# tillcover
#########

variable=tillcover

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short}" 
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
fillval="NaN"
remark="fraction of surface that is covered in till"
units="1"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc


#########
# topg
#########

variable=topg

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short}" 
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
fillval="NaN"
standard="bedrock_altitude"
remark="bedrock surface elevation"
units="m"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted  -a  standard_name,${z_name_short},c,c,"${standard}"    ${folder}/temp2.nc
#ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc

#########
# thk
#########

variable=thk

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short}" 
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
fillval="NaN"
standard="land_ice_thickness"
remark="Thickness of the Ice Sheet"
units="m"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted  -a  standard_name,${z_name_short},c,c,"${standard}"    ${folder}/temp2.nc
#ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc

#########
# bheatflx
#########

variable=bheatflx

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short}" 
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
fillval="NaN"
standard="geothermal flux"
remark=""
units="mW m-2"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



#ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted  -a  standard_name,${z_name_short},c,c,"${standard}"    ${folder}/temp2.nc
#ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc

#########
# usurf_0
#########

variable=usurf_0

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short}"
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
fillval="NaN"
remark="topography at time zero"
units="m"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc

#########
# usurf_1
#########

variable=usurf_1

x_name=x
y_name=y
z_name_short="${variable}"
z_name="${z_name_short}"
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
fillval="NaN"
remark="topography at time lgm"
units="m"

xyz2grd output/${variable}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncrename -O -v z,${z_name_short} ${folder}/temp.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp.nc ${folder}/temp2.nc



ncatted -O -a long_name,${z_name_short},o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a units,${z_name_short},o,c,"${units}" ${folder}/temp2.nc
ncatted -O -a _FillValue,${z_name_short},o,c,${fillval} ${folder}/temp2.nc
ncatted -O -a pism_intent,${z_name_short},o,c,"model_state" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc

mv -f ${folder}/temp2.nc ${folder}/${variable}.nc

rm temp.nc

#########
# climate parameters
#########


for month in $(seq 1 12)
do



case ${month} in
	1) day=0.0 ; day1=31.0 ;;
	2) day=31.0; day1=59.0 ;;
	3) day=59.0; day1=90.0 ;;
	4) day=90.0; day1=120.0 ;;
	5) day=120.0; day1=151.0 ;;
	6) day=151.0; day1=181.0 ;;
	7) day=181.0; day1=212.0 ;;
	8) day=212.0; day1=243.0 ;;
	9) day=243.0; day1=273.0 ;;
	10) day=273.0; day1=304.0 ;;
	11) day=304.0; day1=334.0 ;;
	12) day=334.0; day1=365.0 ;;
esac

#########
# airtemp_0
#########

variable=airtemp_0

x_name=x
y_name=y
z_name_short="${variable}"
z_name="air_temperature" # always include units
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
title="phi" # title for the data
fillval="NaN"
remark="Annual cycle 2m temperature"
units="K"

xyz2grd output/pi_temperature_${month}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncecat -O -u time_per ${folder}/temp.nc ${folder}/temp4.nc



ncrename -O -v z,${z_name_short} ${folder}/temp4.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp4.nc ${folder}/temp2.nc



ncatted -O -a long_name,"${z_name_short}",o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a standard_name,"${z_name_short}",o,c,"${z_name}" ${folder}/temp2.nc
ncatted -O -a units,"${z_name_short}",o,c,"${units}" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc


day2=$( echo "${day1} - ${day}" | bc)

echo ${day} ${day1} ${day2}

ncap2 -Oh -s "defdim(\"bnds\",2); bnds[bnds]={0,1} ; time_per[time_per]={ ${day}} ; time_per@units=\"days since 1950-01-01\" ; time_per@bounds=\"time_bnds\"; time_per@standard_name=\"time\"; time_per@long_name=\"time\"; time_per@calendar=\"standard\"; time_per@axis=\"T\"" ${folder}/temp2.nc ${folder}/temp3.nc




ncap2 -Oh -s "time_bnds1[bnds]=array(${day},${day2},bnds);" ${folder}/temp3.nc ${folder}/temp5.nc
ncap2 -Oh -s 'time_bnds[time_per,bnds]=time_bnds1' ${folder}/temp5.nc ${folder}/temp6.nc

ncks -O -x -v time_bnds1 ${folder}/temp6.nc ${folder}/temp7.nc


if [ "${month}" -gt "9" ]
then
	mv -f ${folder}/temp7.nc ${folder}/${variable}_${month}.nc
else
	mv -f ${folder}/temp7.nc ${folder}/${variable}_0${month}.nc
fi


#########
# airtemp_1
#########

variable=airtemp_1

x_name=x
y_name=y
z_name_short="${variable}"
z_name="air_temperature" # always include units
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
title="phi" # title for the data
fillval="NaN"
remark="Annual cycle 2m temperature"
units="K"

xyz2grd output/lgm_temperature_${month}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncecat -O -u time_per ${folder}/temp.nc ${folder}/temp4.nc



ncrename -O -v z,${z_name_short} ${folder}/temp4.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp4.nc ${folder}/temp2.nc



ncatted -O -a long_name,"${z_name_short}",o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a standard_name,"${z_name_short}",o,c,"${z_name}" ${folder}/temp2.nc
ncatted -O -a units,"${z_name_short}",o,c,"${units}" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc


day2=$( echo "${day1} - ${day}" | bc)

echo ${day} ${day1} ${day2}

ncap2 -Oh -s "defdim(\"bnds\",2); bnds[bnds]={0,1} ; time_per[time_per]={ ${day}} ; time_per@units=\"days since 1950-01-01\" ; time_per@bounds=\"time_bnds\"; time_per@standard_name=\"time\"; time_per@long_name=\"time\"; time_per@calendar=\"standard\"; time_per@axis=\"T\"" ${folder}/temp2.nc ${folder}/temp3.nc




ncap2 -Oh -s "time_bnds1[bnds]=array(${day},${day2},bnds);" ${folder}/temp3.nc ${folder}/temp5.nc
ncap2 -Oh -s 'time_bnds[time_per,bnds]=time_bnds1' ${folder}/temp5.nc ${folder}/temp6.nc

ncks -O -x -v time_bnds1 ${folder}/temp6.nc ${folder}/temp7.nc


if [ "${month}" -gt "9" ]
then
	mv -f ${folder}/temp7.nc ${folder}/${variable}_${month}.nc
else
	mv -f ${folder}/temp7.nc ${folder}/${variable}_0${month}.nc
fi



#########
# precip_0 
#########

variable=precip_0

x_name=x
y_name=y
z_name_short="${variable}"
z_name="lwe_precipitation_rate" # always include units
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
title="phi" # title for the data
fillval="NaN"
remark="Annual cycle total precipitation"
units="kg m-2 s-1"

xyz2grd output/pi_precipitation_${month}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncecat -O -u time_per ${folder}/temp.nc ${folder}/temp4.nc



ncrename -O -v z,${z_name_short} ${folder}/temp4.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp4.nc ${folder}/temp2.nc



ncatted -O -a long_name,"${z_name_short}",o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a standard_name,"${z_name_short}",o,c,"${z_name}" ${folder}/temp2.nc
ncatted -O -a units,"${z_name_short}",o,c,"${units}" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc


day2=$( echo "${day1} - ${day}" | bc)

echo ${day} ${day1} ${day2}

ncap2 -Oh -s "defdim(\"bnds\",2); bnds[bnds]={0,1} ; time_per[time_per]={ ${day}} ; time_per@units=\"days since 1950-01-01\" ; time_per@bounds=\"time_bnds\"; time_per@standard_name=\"time\"; time_per@long_name=\"time\"; time_per@calendar=\"standard\"; time_per@axis=\"T\"" ${folder}/temp2.nc ${folder}/temp3.nc




ncap2 -Oh -s "time_bnds1[bnds]=array(${day},${day2},bnds);" ${folder}/temp3.nc ${folder}/temp5.nc
ncap2 -Oh -s 'time_bnds[time_per,bnds]=time_bnds1' ${folder}/temp5.nc ${folder}/temp6.nc

ncks -O -x -v time_bnds1 ${folder}/temp6.nc ${folder}/temp7.nc


if [ "${month}" -gt "9" ]
then
	mv -f ${folder}/temp7.nc ${folder}/${variable}_${month}.nc
else
	mv -f ${folder}/temp7.nc ${folder}/${variable}_0${month}.nc
fi

#########
# precip_1 
#########

variable=precip_1

x_name=x
y_name=y
z_name_short="${variable}"
z_name="lwe_precipitation_rate" # always include units
z_scale="1"
z_offset="0" # applied after scaling
z_invalid="0" # value for areas without data
title="phi" # title for the data
fillval="NaN"
remark="Annual cycle total precipitation"
units="kg m-2 s-1"

xyz2grd output/lgm_precipitation_${month}.txt -G${folder}/temp.nc -R0/${grid_width_m}/0/${grid_width_m} -I${resolution_m}

ncecat -O -u time_per ${folder}/temp.nc ${folder}/temp4.nc



ncrename -O -v z,${z_name_short} ${folder}/temp4.nc


ncap -O -s "${z_name_short}=double(${z_name_short})"  ${folder}/temp4.nc ${folder}/temp2.nc



ncatted -O -a long_name,"${z_name_short}",o,c,"${remark}" ${folder}/temp2.nc
ncatted -O -a standard_name,"${z_name_short}",o,c,"${z_name}" ${folder}/temp2.nc
ncatted -O -a units,"${z_name_short}",o,c,"${units}" ${folder}/temp2.nc

ncatted -a  axis,x,c,c,"X"  ${folder}/temp2.nc
ncatted  -a  long_name,x,c,c,"X-coordinate in Cartesian system"  ${folder}/temp2.nc
ncatted  -a  standard_name,x,c,c,"projection_x_coordinate"    ${folder}/temp2.nc
ncatted -a units,x,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,x,o,c,"${resolution_m}" ${folder}/temp2.nc


ncatted -a  axis,y,c,c,"Y"  ${folder}/temp2.nc
ncatted  -a  long_name,y,c,c,"Y-coordinate in Cartesian system" ${folder}/temp2.nc
ncatted  -a  standard_name,y,c,c,"projection_y_coordinate"   ${folder}/temp2.nc
ncatted -a units,y,o,c,"m" ${folder}/temp2.nc
ncatted -a spacing_meters,y,o,c,"${resolution_m}" ${folder}/temp2.nc


day2=$( echo "${day1} - ${day}" | bc)

echo ${day} ${day1} ${day2}

ncap2 -Oh -s "defdim(\"bnds\",2); bnds[bnds]={0,1} ; time_per[time_per]={ ${day}} ; time_per@units=\"days since 1950-01-01\" ; time_per@bounds=\"time_bnds\"; time_per@standard_name=\"time\"; time_per@long_name=\"time\"; time_per@calendar=\"standard\"; time_per@axis=\"T\"" ${folder}/temp2.nc ${folder}/temp3.nc




ncap2 -Oh -s "time_bnds1[bnds]=array(${day},${day2},bnds);" ${folder}/temp3.nc ${folder}/temp5.nc
ncap2 -Oh -s 'time_bnds[time_per,bnds]=time_bnds1' ${folder}/temp5.nc ${folder}/temp6.nc

ncks -O -x -v time_bnds1 ${folder}/temp6.nc ${folder}/temp7.nc

echo ${folder}/${variable}_${month}.nc
if [ "${month}" -gt "9" ]
then
	mv -f ${folder}/temp7.nc ${folder}/${variable}_${month}.nc
else
	mv -f ${folder}/temp7.nc ${folder}/${variable}_0${month}.nc
fi


done

for variable in precip_0 precip_1 airtemp_0 airtemp_1
do
ncrcat -O ${folder}/${variable}_??.nc  nc/${variable}.nc
done

cdo -O merge ${folder}/precip_0.nc ${folder}/precip_1.nc ${folder}/airtemp_0.nc ${folder}/airtemp_1.nc ${folder}/usurf_0.nc ${folder}/usurf_1.nc ${folder}/climate.nc
ncks -v glac_index,tbnds -A ${folder}/glacial_index.nc ${folder}/climate.nc

 
cdo -O merge  ${folder}/bheatflx.nc ${folder}/thk.nc ${folder}/topg.nc ${folder}/tillphi.nc ${folder}/tillcover.nc  ${folder}/pism_start.nc
