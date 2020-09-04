FC = gfortran

#FCFLAGS = -g -fbacktrace -fbounds-check 
FCFLAGS = -O2

# if compiling with the Intel Fortran compiler, you need to add an extra flag
#FCFLAGS = -O2 -assume byterecl



create_grids: create_grids.f90
	$(FC) -o create_grids $(FCFLAGS) create_grids.f90

