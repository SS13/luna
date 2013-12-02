/obj/item/weapon/tank/jetpack
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack0"
	w_class = 4
	item_state = "jetpack0"
	var/on = 0
	var/stabilization_on = 0
	var/jettype = ""
	var/datum/effect/system/ion_trail_follow/ion_trail

/obj/item/weapon/tank/jetpack/syndie
	jettype = "_s"
	icon_state = "jetpack0_s"
	item_state = "jetpack0_s"

/obj/item/weapon/tank/jetpack/ce
	jettype = "_ce"
	icon_state = "jetpack0_ce"
	item_state = "jetpack0_ce"

/obj/item/weapon/tank/jetpack/void
	desc = "It works well in a void."
	jettype = "_void"
	icon_state = "jetpack0_void"
	item_state = "jetpack0_void"

/obj/item/weapon/tank/jetpack/New()
	..()
	src.ion_trail = new /datum/effect/system/ion_trail_follow()
	src.ion_trail.set_up(src)
	src.air_contents.oxygen = (6*ONE_ATMOSPHERE)*src.air_contents.volume/(R_IDEAL_GAS_EQUATION*T20C)
	return


/obj/item/weapon/tank/jetpack/MouseDrop(obj/over_object as obj)
	if (istype(usr, /mob/living/carbon/human) || (ticker && ticker.mode.name == "monkey"))
		var/mob/M = usr
		if (!istype(over_object, /obj/effect/screen))
			return ..()
		if (!M.restrained() && !M.stat && M.back == src)
			if (over_object.name == "r_hand")
				if (!M.r_hand)
					M.u_equip(src)
					M.r_hand = src
			else
				if (over_object.name == "l_hand")
					if (!M.l_hand)
						M.u_equip(src)
						M.l_hand = src
			M.update_clothing()
			src.add_fingerprint(usr)
			return
	return


/obj/item/weapon/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!src.on) return 0

	if(num < 0.005 || src.air_contents.total_moles() < num)
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = src.air_contents.remove(num)
	var/allgases = G.carbon_dioxide + G.nitrogen + G.oxygen + G.toxins	//fuck trace gases	-Pete
	if(allgases >= 0.005) return 1

	del(G)
	return


// Maybe it's best to have this hardcoded for whatever we'd add to the map, in order to avoid exploits
// (such as mining base => admin station)
// Note that this assumes the ship's top is at z=1 and bottom at z=4
/obj/item/weapon/tank/jetpack/proc/move_z(cardinal, mob/user as mob)
	if (user.z > 4)
		user << "\red There is nothing of interest in that direction."
		return
	if(allow_thrust(0.005, user))
		switch(cardinal)
			if (UP) // Going up!
				if(user.z != 1) // If we aren't at the very top of the ship
					var/turf/T = locate(user.x, user.y, user.z - 1)
					// You can only jetpack up if there's space above, and you're sitting on either hull (on the exterior), or space
					if(T && istype(T, /turf/space) && (istype(user.loc, /turf/space) || istype(user.loc, /turf/space/hull)))
						user.Move(T)
					else
						user << "\red You bump into the ship's plating."
				else
					user << "\red The ship's gravity well keeps you in orbit!" // Assuming the ship starts on z level 1, you don't want to go past it

			if (DOWN) // Going down!
				if (user.z != 4 && user.z != 5) // If we aren't at the very bottom of the ship, or out in space
					var/turf/T = locate(user.x, user.y, user.z + 1)
					// You can only jetpack down if you're sitting on space and there's space down below, or hull
					if(T && (istype(T, /turf/space) || istype(T, /turf/space/hull)) && istype(user.loc, /turf/space))
						user.Move(T)
					else
						user << "\red You bump into the ship's plating."
				else
					user << "\red The ship's gravity well keeps you in orbit!"


/obj/item/weapon/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"
	src.on = !src.on
	src.icon_state = "jetpack[on][jettype]"
	src.item_state = "jetpack[on][jettype]"

	if(usr.stat) return

	if(src.on)
		src.ion_trail.start()
	else
		src.ion_trail.stop()

	if(ishuman(usr))
		usr:update_clothing()
	usr << "You toggle the jetpack [on? "on":"off"]."
	return

/obj/item/weapon/tank/jetpack/verb/toggle_stabilisation()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"

	if(usr.stat) return

	src.stabilization_on = !src.stabilization_on
	usr << "You toggle the stabilization [stabilization_on? "on":"off"]."
	return