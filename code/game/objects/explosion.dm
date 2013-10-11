/client/proc/cmd_explode_turf(obj/O as turf in world)
	var/A = input("Explosion") as num
	explosion(O, A, A*1.5, A*2, A*3, A*3)
	//if (!usr:holder)
	//	message_admins("\red <b>Explosion spawn by [usr.client.key] blocked</b>")
	//	return

	message_admins("\red <b>Explosion spawned by [usr.client.key]</b>")

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, force = 0)
	if(!epicenter) return
	//Machines which report explosions.
	for(var/i,i<=doppler_arrays.len,i++)
		var/obj/machinery/doppler_array/Array = doppler_arrays[i]
		if(Array)
			Array.sense_explosion(epicenter.x, epicenter.y, epicenter.z, devastation_range, heavy_impact_range, light_impact_range)

	if(devastation_range <= 1)
		//3D explosions works horrible with small booms. Dirty fix!
		tg_explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
		return

	if(!force) return

	spawn(0)
		if(devastation_range > 1)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name]. (<a href=\"byond://?src=%admin_ref%;teleto=\ref[epicenter]\">Jump</a>)", admin_ref = 1)

		defer_cables_rebuild++
		//stop_zones++

		sleep(5 * tick_multiplier)

		//playsound(epicenter.loc, 'explosionfar.ogg', 100, 1, round(devastation_range*2,1) )
		playsound(epicenter.loc, "explosion", 100, 1, round(devastation_range,1) )
		var/sound/distant_explosion = sound('explosionfar.ogg')
		for(var/mob/M)
			M << distant_explosion

		//NEW EXPLOSION CODE - NICER (3D TOO!!) BLASTS
		//epicenter.overlays += image('status_display.dmi', "epicenter")

		var/list/fillqueue = list( )
		var/list/floordist = list( )

		var/list/detonate  = list( )
		var/list/detdists  = list( )

		var/list/checked   = list( )
		var/list/list/orderdetonate = list( )
		var/maxdet

		var/list/redo_zones = list()

		fillqueue += epicenter
		checked += epicenter
		floordist[epicenter] = 0

		var/obj/item/weapon/dummy/D = new /obj/item/weapon/dummy(epicenter)

		while (fillqueue.len > 0)

			var/turf/T = fillqueue[1]
			fillqueue -= T

			if(T.zone)
				redo_zones += T.zone

			if ((floordist[T] > flash_range))
				continue

			if (0) //TODO replace 0 with locate() for a shield object
				//TODO damage shield
				continue

			detonate += T
			detdists[T] = floordist[T]
			if(orderdetonate["[floordist[T]]"])
				orderdetonate["[floordist[T]]"] += T
			else
				orderdetonate["[floordist[T]]"] = list ( )
				orderdetonate["[floordist[T]]"] += T
			if(floordist[T] > maxdet)
				maxdet = floordist[T]

			D.loc = T

			for(var/dir in cardinal3d) //TODO replace with "IsSameStation" checks
				var/turf/U = get_step_3d(T, dir)

				if(!U)
					continue


				var/addition = U.explosionstrength

				if (dir == DOWN)
					addition = T.floorstrength
				else if (dir == UP)
					addition = U.floorstrength

				var/newdist = floordist[T] + addition

				for(var/obj/O in U)
					if (!O.CanPass(D, T, 0, 2)) //If an object on the turf is blocking the blast wave...

						//Preblast, useful for things that may block shields but still react to them (shields)
						//Use of negative values will prevent blast damage from being simulated unintentionally
						if(floordist[T] <= devastation_range)
							O.ex_act(-3)
						else if (floordist[T] <= heavy_impact_range)
							O.ex_act(-2)
						else if (floordist[T] <= light_impact_range)
							O.ex_act(-1)

						newdist += O.explosionstrength	//Then add its explosion resistance to the distance-from-epicenter var


				if(U in checked) //Now, has this turf been looked at before?
					if (U in fillqueue)//Yes, so only compare epicenter distances
						if (newdist < floordist[U])
							//world << "reassigning dist at [U.x] [U.y] [U.z] - [newdist] < [floordist[U]]"
							floordist[U] = newdist
					else
						if (newdist < detdists[U])
							//world << "reassigning dist at [U.x] [U.y] [U.z] - [newdist] < [detdists[U]]"
							detdists[U] = newdist
				else //No, so store the current epicenter dist and mark this turf for further flood-filling
					fillqueue += U
					checked += U
					floordist[U] = newdist

				//T.overlays += image('status_display.dmi', "black")


		del D

		//for(var/turf/T in detonate)
		//	T.overlays += image('status_display.dmi', "red")
		//	var/image/I = image('status_display.dmi', "[detdists[T]]")
		//	I.pixel_x = 1
		//	I.pixel_y = -1
		//	T.overlays += I

		//return


		//OLD EXPLOSION CODE, RETROFITTED TO SUPPORT ABOVE
		var/sleep
		spawn(0)
			if(heavy_impact_range > 1)
				var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
				E.set_up(epicenter)
				E.start()

			for(var/Z = 0 to maxdet)
				if(orderdetonate["[Z]"])
					for(var/turf/T in orderdetonate["[Z]"])
						var/turf/AboveTurf = locate(T.x, T.y, (T.z - 1))
						var/DestroyAbove = 0
						if(istype(AboveTurf, /turf/simulated)) DestroyAbove = 1

						sleep += 1
						if(sleep > 20)
							sleep(15)
							sleep = 0
						var/distance = detdists[T]
						if(distance < 0)
							distance = 0
						if(distance < devastation_range)
							for(var/atom/object in T.contents)
								object.ex_act(1)
							if(prob(5))
								T.ex_act(2)
								if(DestroyAbove) AboveTurf.ex_act(3)
							else
								T.ex_act(1)
								if(DestroyAbove) AboveTurf.ex_act(2)
						else if(distance < heavy_impact_range)
							for(var/atom/object in T.contents)
								object.ex_act(2)
							T.ex_act(2)
							if(DestroyAbove) AboveTurf.ex_act(3)
						else if (distance == heavy_impact_range)
							for(var/atom/object in T.contents)
								object.ex_act(2)
							if(prob(15) && devastation_range > 2 && heavy_impact_range > 2)
								secondaryexplosion(T, 1)
							else
								T.ex_act(2)
						else if(distance <= light_impact_range)
							for(var/atom/object in T.contents)
								object.ex_act(3)
							T.ex_act(3)
						for(var/mob/living/carbon/mob in T)
							flick("flash", mob:flash)


			defer_cables_rebuild --
			//stop_zones--
			if (!defer_cables_rebuild)
				HandleUNExplosionDamage()

	return 1


proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2)

//A very crude linear approximatiaon of pythagoras theorem.
/proc/cheap_pythag(var/dx, var/dy)
	dx = abs(dx); dy = abs(dy);
	if(dx>=dy)	return dx + (0.5*dy)	//The longest side add half the shortest side approximates the hypotenuse
	else		return dy + (0.5*dx)

proc/tg_explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	src = null	//so we don't abort once src is deleted
	epicenter = get_turf(epicenter)

	// Clamp all values to MAX_EXPLOSION_RANGE
	devastation_range = min (3, devastation_range)
	heavy_impact_range = min (7, heavy_impact_range)
	light_impact_range = min (14, light_impact_range)
	flash_range = min (28, flash_range)

	spawn(0)

		message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
		log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

		var/sound/distant_explosion = sound('explosionfar.ogg')
		for(var/mob/M)
			M << distant_explosion
		playsound(epicenter, "explosion", 100, 1, round(devastation_range,1) )

		defer_cables_rebuild++
		//stop_zones++

		//var/lighting_controller_was_processing = lighting_controller.processing	//Pause the lighting updates for a bit
		//lighting_controller.processing = 0
		//var/powernet_rebuild_was_deferred_already = defer_powernet_rebuild
		//if(defer_powernet_rebuild != 2)
		//	defer_powernet_rebuild = 1

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x0 = epicenter.x
		var/y0 = epicenter.y

		for(var/turf/T in range(epicenter, max(devastation_range, heavy_impact_range, light_impact_range)))
			var/dist = cheap_pythag(T.x - x0,T.y - y0)

			if(dist < devastation_range)		dist = 1
			else if(dist < heavy_impact_range)	dist = 2
			else if(dist < light_impact_range)	dist = 3
			else								continue

			T.ex_act(dist)
			if(T)
				for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					var/atom/movable/AM = atom_movable
					if(AM)	AM.ex_act(dist)

		sleep(8)

		defer_cables_rebuild --
		//stop_zones--
		if (!defer_cables_rebuild)
			HandleUNExplosionDamage()

	return 1