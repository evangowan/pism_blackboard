#! /bin/bash


variable=tillcover

gmt grdmath pism_start.nc?${variable} 0 MUL = zero_grid.nc

replace_value=0.95

low_range=0.4
high_range=0.6

gmt grdmath zero_grid.nc  X  ADD XMAX XMIN SUB ${low_range} MUL XMIN ADD XMAX XMIN SUB ${high_range} MUL XMIN ADD INRANGE = x_values.nc

low_range=0
high_range=0.45
gmt grdmath zero_grid.nc  Y  ADD YMAX YMIN SUB ${low_range} MUL YMIN ADD YMAX YMIN SUB ${high_range} MUL YMIN ADD INRANGE = y_values.nc

gmt grdmath x_values.nc y_values.nc MUL = mask.nc

gmt grdmath  mask.nc ${replace_value} pism_start.nc?${variable} IFELSE = ${variable}_replace.nc
ncrename -O -v z,${variable} ${variable}_replace.nc

ncap -O -s "${variable}=double(${variable});"  ${variable}_replace.nc ${variable}_replace2.nc


cdo -O merge  pism_start.nc ${variable}_replace2.nc testing.nc

ncap2 -Oh -s "${variable}=${variable}_2;" testing.nc testing2.nc

ncks -O -x -v ${variable}_2 testing2.nc testing3.nc

# change value of tillphi

ncap2 -s 'where(tillphi == 30) tillphi=20' testing3.nc testing4.nc

mv -f testing4.nc pism_start.nc 

rm  testing.nc testing2.nc ${variable}_replace2.nc ${variable}_replace.nc y_values.nc x_values.nc mask.nc zero_grid.nc tillcover_temp.nc testing3.nc
