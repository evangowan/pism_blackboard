#! /bin/bash

# grab files

cp -f ../nc/pism_start.nc .
cp -f ../nc/climate.nc .

bash change_variable.sh
