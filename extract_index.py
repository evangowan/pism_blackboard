#! /usr/bin/python3

import numpy as np
import netCDF4
import csv

import sys


yval = sys.argv[1:]

filename="climate.nc"


nc = netCDF4.Dataset(filename)
nc.variables

glac_index = nc.variables['glac_index'][:]
#y = nc.variables['y'][:]
times = nc.variables['time']
times2= nc.variables['time'][:]
#jd = netCDF4.num2date(times[:],times.units)

combined = np.column_stack((np.array(times2), np.array(glac_index)))


filename="glacial_index.txt"


np.savetxt(filename,combined, delimiter=" ", fmt='%12.4f')
