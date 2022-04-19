#! /usr/bin/python3

import numpy as np
import netCDF4
import csv

import sys


yval = sys.argv[1:]

filename="ex_pism.nc"




# desired station time series location

x_loc = 2000000

nc = netCDF4.Dataset(filename)
nc.variables

x = nc.variables['x'][:]
y = nc.variables['y'][:]
times = nc.variables['time']
times2= nc.variables['time'][:]
jd = netCDF4.num2date(times[:],times.units)

def near(array,value):
    idx=(np.abs(array-value)).argmin()
    return idx


counter=0

for y_loc in yval:

	counter += 1


	# find nearest point to desired location
	ix = near(x, x_loc)
	iy = near(y, float(y_loc))

	# get all time records of variable [vname] at indices [iy,ix]
	vname = 'thk'
	var = nc.variables[vname]
	h = var[:,iy,ix]

	multiplied_time = times2 / (365.0 * 24.0 * 3600.0)



	combined = np.column_stack((np.array(multiplied_time), np.array(h)))

	filename=f"ts_{vname}_{counter}.txt"
	print(filename)

	np.savetxt(filename,combined, delimiter=" ")

