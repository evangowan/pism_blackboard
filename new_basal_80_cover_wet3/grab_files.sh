#! /bin/bash

# grab files

cp -f ../nc/pism_start.nc .
cp -f ../nc/climate.nc .

gmt grdmath pism_start.nc?tillcover 0.8 MUL = tillcover_temp.nc


