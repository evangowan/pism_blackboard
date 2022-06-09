program create_grids
	implicit none

	character(len=80) :: input_parameter
	integer :: resolution, x, y

	integer :: number_x, number_y

	double precision, parameter :: max_height = 3500 ! maximum ice sheet height, in meters
	double precision :: shear_stress ! shear stress used to calculate ice sheet for climate forcing, calculated based on the ice sheet radius

	double precision, parameter :: rho_ice = 910, g = 9.81

	double precision, parameter :: min_precipitation_lgm = 6e-7, max_precipitation_lgm = 1e-5
	double precision, parameter :: min_precipitation_pi = 6e-6, max_precipitation_pi = 1e-5

	double precision, parameter :: precipitation_scaling=1e-6

	integer, parameter :: number_months = 12
	integer, parameter :: number_days = 365

	double precision, parameter, dimension(14) :: days = &
		 (/-15.5, 15.5, 45., 74.5, 105., 135.5, 166., 196.5, 227.5, 258., 288.5, 319., 349.5, 380.5/)

	! LGM temperature parameters
!	double precision, parameter, dimension(12) :: lgm_temperature_0 = &
!							(/246.9, 250.9, 256.3, 263.7, 271.7, 275.3, 276.0, 274.8, 271.0, 262.7, 253.4, 247.8/)
!	double precision, parameter, dimension(12) :: lgm_temperature_3500 = &
!							(/223.2, 226.1, 230.2, 237.3, 246.2, 252.9, 255.9, 253.8, 247.7, 238.8, 230.0, 224.6/)

	double precision, parameter, dimension(14) :: lgm_temperature_0 = &
							(/243, 242, 246, 251, 259, 267, 270, 271, 270, 266, 258, 248, 243, 242/)
	double precision, parameter, dimension(14) :: lgm_temperature_3500 = &
							(/220, 218, 221, 225, 232, 241, 248, 251, 249, 243, 234, 225, 220, 218/)

	! PI temperature parameters
!	double precision, parameter, dimension(12) :: pi_temperature_0 = &
!							(/269.9, 272.9, 278.6, 284.8, 291.1, 295.8, 298.2, 297.3, 292.8, 284.0, 276.4, 271.5/)
!	double precision, parameter, dimension(12) :: pi_temperature_3500 = &
!							(/255.7, 258.3, 263.9, 270.0, 278.4, 285.0, 287.3, 285.0, 279.9, 272.8, 265.1, 258.8/)
!	double precision, parameter, dimension(12) :: pi_temperature_0 = &
!							(/265, 268, 274, 280, 286, 291, 293, 292, 288, 279, 271, 267/)
!	double precision, parameter, dimension(12) :: pi_temperature_3500 = &
!							(/251, 253, 259, 265, 273, 280, 282, 280, 275, 268, 260, 254/)
	double precision, parameter, dimension(14) :: pi_temperature_0 = &
							(/262, 260, 263, 269, 275, 281, 286, 288, 287, 283, 274, 266, 262, 260/)
	double precision, parameter, dimension(14) :: pi_temperature_3500 = &
							(/249, 246, 248, 254, 260, 268, 275, 277, 275, 270, 263, 255, 249, 246/)



	! for LGM precipitation, there needs to be a more careful parameterization

!	double precision, parameter, dimension(12) :: lgm_precipitation_0 = &
!							(/1.8, 2.4, 2.7, 4.0, 5.6, 5.7, 5.5, 4.9, 4.4, 2.8, 1.9, 1.8/)
!	double precision, parameter, dimension(12) :: lgm_precipitation_1000 = &
!							(/1.5, 2.1, 2.4, 3.7, 5.3, 5.4, 5.2, 4.6, 4.1, 2.5, 1.6, 1.5/)
!	double precision, parameter, dimension(12) :: lgm_precipitation_2000 = &
!							(/0.6, 0.9, 1.0, 1.8, 3.1, 2.8, 2.7, 2.7, 2.5, 1.4, 0.8, 0.7/)
!	double precision, parameter, dimension(12) :: lgm_precipitation_3000 = &
!							(/0.2, 0.2, 0.3, 0.5, 0.8, 0.9, 0.8, 0.8, 0.7, 0.4, 0.2, 0.2/)
!	double precision, parameter, dimension(12) :: lgm_precipitation_3500 = &
!							(/0.1, 0.1, 0.1, 0.3, 0.4, 0.5, 0.6, 0.5, 0.4, 0.3, 0.1, 0.1/)


!	double precision, parameter, dimension(12) :: lgm_precipitation_0 = &
!							(/2.9, 3.2, 4.2, 4.7, 4.9, 5.3, 5.6, 4.7, 3.8, 3.2, 2.5, 2.9/)
!	double precision, parameter, dimension(12) :: lgm_precipitation_3500 = &
!							(/1.9, 2., 2.5, 2.9, 3.5, 4.1, 4.7, 5., 4.3, 3.4, 2.6, 2.1/)

	double precision, parameter, dimension(14) :: lgm_precipitation_0 = &
							(/2.9, 2.9, 3.2, 4.2, 4.7, 4.9, 5.3, 5.6, 4.7, 3.8, 3.2, 2.5, 2.9, 2.9/)
	double precision, parameter, dimension(14) :: lgm_precipitation_3500 = &
							(/2.9, 2.9, 3.2, 4.2, 4.7, 4.9, 5.3, 5.6, 4.7, 3.8, 3.2, 2.5, 2.9, 2.9/)


	! for PI, i am not so concerned
!	double precision, parameter, dimension(12) :: pi_precipitation_0 = &
!							(/2.9, 3.2, 4.2, 4.7, 4.9, 5.3, 5.6, 4.7, 3.8, 3.2, 2.5, 2.9/)
!	double precision, parameter, dimension(12) :: pi_precipitation_3500 = &
!							(/1.9, 2., 2.5, 2.9, 3.5, 4.1, 4.7, 5., 4.3, 3.4, 2.6, 2.1/)

	double precision, parameter, dimension(14) :: pi_precipitation_0 = &
							(/4.9, 4.9, 5.2, 6.2, 6.7, 6.9, 7.3, 7.6, 6.7, 5.8, 5.2, 4.5, 4.9, 4.9/)
	double precision, parameter, dimension(14) :: pi_precipitation_3500 = &
							(/4.9, 4.9, 5.2, 6.2, 6.7, 6.9, 7.3, 7.6, 6.7, 5.8, 5.2, 4.5, 4.9, 4.9/)

	! I want to make sure that the edges of where the ice sheet is expected to go will not be nowhere close to sea level
	double precision, parameter :: topg = 250.0
	
	! the heat flux in the Canadian Shield where the Quebec/Labrador dome formed is between 30 and 50 mW m-2
	double precision, parameter :: bheatflx = 40.0


	! default till friction angle

	double precision, parameter :: tillphi = 30.0

	! default till cover

	double precision, parameter :: tillcover = 1.0

	! radius of the ice sheet, in km

	double precision, parameter :: radius = 1500

	! default ice thickness

	double precision, parameter :: thk = 0.0

	! allocatable variables to store the parameters

	double precision, allocatable, dimension(:,:) :: tillphi_grid, tillcover_grid, bheatflx_grid, topg_grid, usurf_0, usurf_1, thk_grid
	double precision, allocatable, dimension(:,:,:) :: pi_temp_grid, lgm_temp_grid, pi_precip_grid, lgm_precip_grid

	! utility variables
	character(len=80) :: filename, month_text
	integer :: istat

	integer :: month_counter, x_counter, y_counter, day_counter
	double precision :: center_x, center_y, distance

    !interpolate
	double precision :: lgm_precipitation_3500_inter, lgm_precipitation_0_inter
	double precision :: pi_precipitation_3500_inter, pi_precipitation_0_inter
	double precision :: lgm_temperature_3500_inter, lgm_temperature_0_inter
	double precision :: pi_temperature_3500_inter, pi_temperature_0_inter


	character(len=7), parameter :: folder = "output/"

	integer, parameter :: topg_unit=1000, bheatflx_unit = 1001, tillphi_unit=1002, tillcover_unit=1003
	integer, parameter :: usurf_0_unit=1004, usurf_1_unit=1005, thk_unit=1006
	integer :: climate_unit
	integer :: max_width


	! this will be adjusted later depending on the resolution




	call getarg(1,input_parameter)
	read(input_parameter,*) resolution ! needs to be an integer, in km

	call getarg(2,input_parameter)
	read(input_parameter,*) max_width ! width of the domain, needs to be an integer, in km

	number_x = nint(dble(max_width) / dble(resolution)) + 1


	! recalculate the max_width

	max_width = resolution * (number_x-1)

	! for now, just have a square grid

	number_y = number_x

	center_x = dble(number_x-1) / 2.
	center_y = dble(number_y-1) / 2.

	! ice sheet shear stress

	shear_stress = rho_ice * g * (max_height)** 2 / (radius * 1000) / 2.0


	! allocate memory
	allocate(tillphi_grid(number_x, number_y), tillcover_grid(number_x, number_y), bheatflx_grid(number_x, number_y), &
		   topg_grid(number_x, number_y), usurf_0(number_x, number_y), usurf_1(number_x, number_y),&
		   thk_grid(number_x, number_y), pi_temp_grid(number_x, number_y, number_days), &
		   lgm_temp_grid(number_x, number_y, number_days), pi_precip_grid(number_x, number_y, number_days), &
		   lgm_precip_grid(number_x, number_y, number_days), stat=istat)

	if(istat /= 0) THEN
		write(6,*) "problems allocating memory, error: ", istat
		stop
	endif



	do x_counter = 1, number_x

		do y_counter = 1, number_y


			! set to a single value for now
			tillphi_grid(x_counter,y_counter) = tillphi
			tillcover_grid(x_counter,y_counter) = tillcover
			bheatflx_grid(x_counter,y_counter) = bheatflx
			topg_grid(x_counter,y_counter) = topg
			thk_grid(x_counter,y_counter) = thk

			distance = sqrt(((x_counter-1)-center_x)**2 + ((y_counter-1)-center_y)**2) * resolution

			usurf_0(x_counter,y_counter) = topg

			if(distance < radius) THEN
				usurf_1(x_counter,y_counter) = topg + sqrt(-(2*shear_stress)/(rho_ice*g)*(distance-radius)*1000.0) ! plastic ice sheet profile
			else
				usurf_1(x_counter,y_counter) = topg
			endif


			do day_counter = 1, number_days

				do month_counter = 1, 13

					if (dble(day_counter) > days(month_counter) .and. dble(day_counter) <= days(month_counter+1)) THEN

						lgm_temperature_3500_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       lgm_temperature_3500(month_counter), lgm_temperature_3500(month_counter+1))


						lgm_temperature_0_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       lgm_temperature_0(month_counter), lgm_temperature_0(month_counter+1))


						pi_temperature_3500_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       pi_temperature_3500(month_counter), pi_temperature_3500(month_counter+1))

						pi_temperature_0_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       pi_temperature_0(month_counter), pi_temperature_0(month_counter+1))

						lgm_precipitation_3500_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       lgm_precipitation_3500(month_counter), lgm_precipitation_3500(month_counter+1))

						lgm_precipitation_0_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       lgm_precipitation_0(month_counter), lgm_precipitation_0(month_counter+1))


						pi_precipitation_3500_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       pi_precipitation_3500(month_counter), pi_precipitation_3500(month_counter+1))

						pi_precipitation_0_inter = interpolate_function(day_counter, days(month_counter), days(month_counter+1),&
					       pi_precipitation_0(month_counter), pi_precipitation_0(month_counter+1))

					endif


				end do

				if(distance < radius) THEN





					lgm_temp_grid(x_counter,y_counter, day_counter) =&
					  (lgm_temperature_0_inter - lgm_temperature_0_inter) / &
					  max_height * (usurf_1(x_counter,y_counter) - topg) + lgm_temperature_0_inter

					pi_temp_grid(x_counter,y_counter, day_counter) = &
					  (pi_temperature_3500_inter - pi_temperature_0_inter) / &
					  max_height * (usurf_1(x_counter,y_counter) - topg) +  pi_temperature_0_inter


					lgm_precip_grid(x_counter,y_counter, day_counter) = &
					  (lgm_precipitation_3500_inter - lgm_precipitation_0_inter) / &
					  max_height * (usurf_1(x_counter,y_counter) - topg) + lgm_precipitation_0_inter

					pi_precip_grid(x_counter,y_counter, day_counter) = &
					  (pi_precipitation_3500_inter - pi_precipitation_0_inter) / &
					  max_height * (usurf_1(x_counter,y_counter) - topg) + pi_precipitation_0_inter
				else
					pi_temp_grid(x_counter,y_counter, day_counter) =&
					  pi_temperature_0_inter + (distance-radius) / 50. ! 1 degree increase  every 50 km

					lgm_temp_grid(x_counter,y_counter, day_counter) =&
					  lgm_temperature_0_inter + (distance-radius) / 50. ! 1 degree increase  every 100 km

					! no precipitation outside of ice sheet to prevent additional growth
					pi_precip_grid(x_counter,y_counter, day_counter) = 0. 
					lgm_precip_grid(x_counter,y_counter, day_counter) = 0.

				endif

			end do
		end do
	end do
	
	! open files

	filename = folder // "tillphi.txt"

	open(unit=tillphi_unit, file=filename, access="sequential", form="formatted", status="replace")

	filename = folder // "tillcover.txt"

	open(unit=tillcover_unit, file=filename, access="sequential", form="formatted", status="replace")

	filename = folder // "bheatflx.txt"

	open(unit=bheatflx_unit, file=filename, access="sequential", form="formatted", status="replace")



	filename = folder // "topg.txt"

	open(unit=topg_unit, file=filename, access="sequential", form="formatted", status="replace")


	filename = folder // "usurf_0.txt"

	open(unit=usurf_0_unit, file=filename, access="sequential", form="formatted", status="replace")

	filename = folder // "usurf_1.txt"

	open(unit=usurf_1_unit, file=filename, access="sequential", form="formatted", status="replace")


	filename = folder // "thk.txt"

	open(unit=thk_unit, file=filename, access="sequential", form="formatted", status="replace")


	do x_counter = 1, number_x
		do y_counter = 1, number_y

			write(tillphi_unit,*) (x_counter-1) * resolution*1000., &
			  (y_counter-1) * resolution*1000., tillphi_grid(x_counter,y_counter)
			write(tillcover_unit,*) (x_counter-1) * resolution*1000., &
			  (y_counter-1) * resolution*1000., tillcover_grid(x_counter,y_counter)
			write(bheatflx_unit,*) (x_counter-1) * resolution*1000., &
			  (y_counter-1) * resolution*1000., bheatflx_grid(x_counter,y_counter)
			write(topg_unit,*) (x_counter-1) * resolution*1000., &
		  	  (y_counter-1) * resolution*1000., topg_grid(x_counter,y_counter)
			write(thk_unit,*) (x_counter-1) * resolution*1000., &
		  	  (y_counter-1) * resolution*1000., thk_grid(x_counter,y_counter)

			write(usurf_0_unit,*) (x_counter-1) * resolution*1000., &
		  	  (y_counter-1) * resolution*1000., usurf_0(x_counter,y_counter)
			write(usurf_1_unit,*) (x_counter-1) * resolution*1000., &
		  	  (y_counter-1) * resolution*1000., usurf_1(x_counter,y_counter)
		end do
	end do

	close(unit=tillphi_unit)
	close(unit=bheatflx_unit)
	close(unit=bheatflx_unit)
	close(unit=topg_unit)
	close(unit=thk_unit)
	close(unit=usurf_0_unit)
	close(unit=usurf_1_unit)
	




	do day_counter = 1, number_days, 1


		write(filename,*) day_counter
		filename = folder // "pi_temperature_" // trim(adjustl(filename)) // ".txt"
		climate_unit = (day_counter) *10
		open(unit=climate_unit, file=filename, access="sequential", form="formatted", status="replace")

		write(filename,*) day_counter
		filename = folder // "lgm_temperature_" // trim(adjustl(filename)) // ".txt"
		climate_unit = (day_counter) *10 + 1
		open(unit=climate_unit, file=filename, access="sequential", form="formatted", status="replace")

		write(filename,*) day_counter	
		filename = folder // "pi_precipitation_" // trim(adjustl(filename)) // ".txt"
		climate_unit = (day_counter) *10 + 2
		open(unit=climate_unit, file=filename, access="sequential", form="formatted", status="replace")

		write(filename,*) day_counter
		filename = folder // "lgm_precipitation_" // trim(adjustl(filename)) // ".txt"
		climate_unit = (day_counter) *10 + 3
		open(unit=climate_unit, file=filename, access="sequential", form="formatted", status="replace")

		do x_counter = 1, number_x
			do y_counter = 1, number_y

				climate_unit = (day_counter) *10
				write(climate_unit,*) (x_counter-1) * resolution*1000., (y_counter-1)* resolution*1000., &
				  pi_temp_grid(x_counter,y_counter, day_counter)

				climate_unit = (day_counter) *10 + 1
				write(climate_unit,*) (x_counter-1) * resolution*1000., &
				  (y_counter-1)* resolution*1000., lgm_temp_grid(x_counter,y_counter, day_counter)

				climate_unit = (day_counter) *10 + 2
				write(climate_unit,*) (x_counter-1) * resolution*1000., &
				  (y_counter-1)* resolution*1000., pi_precip_grid(x_counter,y_counter, day_counter) * precipitation_scaling

				climate_unit = (day_counter) *10 + 3
				write(climate_unit,*) (x_counter-1) * resolution*1000., &
				  (y_counter-1)* resolution*1000., lgm_precip_grid(x_counter,y_counter, day_counter) * precipitation_scaling
				end do 
			end do


		climate_unit = (day_counter) *10
		close(unit=climate_unit)

		climate_unit = (day_counter) *10 + 1
		close(unit=climate_unit)


		climate_unit = (day_counter) *10 + 2
		close(unit=climate_unit)


		climate_unit = (day_counter) *10 + 3
		close(unit=climate_unit)
	end do




contains

double precision function interpolate_function (day, month_start, month_end, val_start, val_end)
	implicit none
	integer, intent(in) :: day
	double precision, intent(in) :: month_start, month_end, val_start, val_end

	double precision :: double_day, slope, intercept

	double_day = dble(day) 

	slope = (val_end - val_start) / (month_end - month_start)
	intercept = val_end - slope * month_end

	interpolate_function = slope * double_day + intercept


end function interpolate_function

end program create_grids
