proc/empulse(turf/epicenter, heavy_range, light_range, log=0, zLevelSpread=1)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")
		log_game("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse = new/obj/effect/overlay ( epicenter )
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = 1
		spawn(20)
			pulse.delete()

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/atom/T in range(light_range, epicenter))
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.emp_act(1)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(1)
			else
				T.emp_act(2)
		else if(distance <= light_range)
			T.emp_act(2)

	//3D EMP blast
	//Creates two mini-blasts on adj z-levels if on ship
	if(epicenter.z < 4)	empulse(locate(epicenter.x, epicenter.y, epicenter.z + 1), round(heavy_range/2, 1), round(light_range/2, 1) , 0, 0)
	if(epicenter.z > 1 && epicenter.z < 5) empulse(locate(epicenter.x, epicenter.y, epicenter.z - 1), round(heavy_range/2, 1), round(light_range/2, 1) , 0, 0)

	return 1