/obj/item/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 1643 && m_amt)
		var/obj/item/weapon/meltedmetal/S = new(src.loc)
		S.desc = "Looks like this was \an [src] some time ago."
		S.m_amt = src.m_amt
		for(var/mob/M in viewers(5, S))
			M << "\red \the [src] melts."
		del(src)
	else if(exposed_temperature >= 1650 && g_amt)
		var/obj/item/weapon/meltedmetal/S = new(src.loc)
		S.desc = "Looks like this was \an [src] some time ago."
		S.g_amt = src.g_amt
		for(var/mob/M in viewers(5, S))
			M << "\red \the [src] melts."
		del(src)
/obj/item/weapon/paper/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 373.15)
		for(var/mob/M in viewers(5, src))
			M << "\red \the [src] burns up."
		del(src)

/obj/item/weapon/pipesegment/
	name = "Pipe segment"
	desc = "used for emergency pipe repairs"
	icon = 'pipes.dmi'
	icon_state = "exposed"
	m_amt = 50


/obj/item/weapon/meltedmetal
	name = "Ruined metal"
	icon = 'chemical.dmi'
	icon_state = "molten"
	m_amt = 0
/obj/item/weapon/meltedglass
	name = "Ruined glass"
	icon = 'chemical.dmi'
	icon_state = "molten"
	m_amt = 0
/obj/item/weapon/meltedmetal/temperature_expose()
	return
/obj/item/weapon/meltedglass/temperature_expose()
	return
/obj/item/weapon/handcuffs/attack(mob/M as mob, mob/user as mob)
	if ((CLUMSY in usr.mutations) && prob(50))
		usr << "\red Uh ... how do those things work?!"
		if (istype(M, /mob/living/carbon/human))
			var/obj/equip_e/human/O = new /obj/equip_e/human(  )
			O.source = user
			O.target = user
			O.item = user.equipped()
			O.s_loc = user.loc
			O.t_loc = user.loc
			O.place = "handcuff"
			M.requests += O
			spawn( 0 )
				O.process()
				return
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if (istype(M, /mob/living/carbon/human))
		var/obj/equip_e/human/O = new /obj/equip_e/human(  )
		O.source = user
		O.target = M
		O.item = user.equipped()
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "handcuff"
		M.requests += O
		spawn( 0 )
			playsound(src.loc, 'handcuffs.ogg', 30, 1, -2)
			O.process()
			return
	else
		var/obj/equip_e/monkey/O = new /obj/equip_e/monkey(  )
		O.source = user
		O.target = M
		O.item = user.equipped()
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "handcuff"
		M.requests += O
		spawn( 0 )
			playsound(src.loc, 'handcuffs.ogg', 30, 1, -2)
			O.process()
			return
	return


/obj/item/weapon/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags = FPRINT | USEDELAY | CONDUCT
	throwforce = 10
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 12.0
	m_amt = 90
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	var/max_water = 50
	var/last_use = 1.0
	var/safety = 1
	var/sprite_name = "fire_extinguisher"

/obj/item/weapon/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	flags = FPRINT | USEDELAY
	throwforce = 2
	w_class = 2.0
	force = 3.0
	m_amt = 0
	max_water = 30
	sprite_name = "miniFE"

/obj/item/weapon/extinguisher/New()
	create_reagents(max_water)
	reagents.add_reagent("water", max_water)

/obj/item/weapon/extinguisher/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.reagents.total_volume)
	..()
	return

/obj/item/weapon/extinguisher/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	user << "The safety is [safety ? "on" : "off"]."
	return

/obj/item/weapon/extinguisher/afterattack(atom/target, mob/user , flag)
	//TODO; Add support for reagents in water.
	if( istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(src,target) <= 1)
		var/obj/o = target
		o.reagents.trans_to(src, 50)
		user << "\blue \The [src] is now refilled"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	if (!safety)
		if (src.reagents.total_volume < 1)
			usr << "\red \The [src] is empty."
			return

		if (world.time < src.last_use + 20)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(usr.buckled && isobj(usr.buckled) && !usr.buckled.anchored )
			spawn(0)
				var/obj/B = usr.buckled
				var/movementdirection = turn(direction,180)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(1)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(1)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(1)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(2)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(2)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(3)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(3)
				B.Move(get_step(usr,movementdirection), movementdirection)
				sleep(3)
				B.Move(get_step(usr,movementdirection), movementdirection)

		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T,T1,T2)

		for(var/a=0, a<5, a++)
			spawn(0)
				var/obj/effect/effect/water/W = new /obj/effect/effect/water( get_turf(src) )
				var/turf/my_target = pick(the_targets)
				var/datum/reagents/R = new/datum/reagents(5)
				if(!W) return
				W.reagents = R
				R.my_atom = W
				if(!W || !src) return
				src.reagents.trans_to(W,1)
				for(var/b=0, b<5, b++)
					step_towards(W,my_target)
					if(!W || !W.reagents) return
					W.reagents.reaction(get_turf(W))
					for(var/atom/atm in get_turf(W))
						if(!W) return
						W.reagents.reaction(atm)
					if(W.loc == my_target) break
					sleep(2)

		if(istype(usr.loc, /turf/space))
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)
	else
		return ..()
	return

/obj/item/weapon/extinguisher/proc/move_z(cardinal, mob/user as mob)
	if (safety) return 0
	if (world.time < src.last_use + 20)	return 0

	if (src.reagents.total_volume < 1)
		usr << "\red \The [src] is empty."
		return 0

	if (user.z > 4)
		user << "\red There is nothing of interest in that direction."
		return 0

	src.last_use = world.time
	playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
	src.reagents.remove_any(5)

	switch(cardinal)
		if (UP) // Going up!
			if(user.z != 1) // If we aren't at the very top of the ship
				var/turf/T = locate(user.x, user.y, user.z - 1)
				// You can only jetpack up if there's space above, and you're sitting on either hull (on the exterior), or space
				if(T && istype(T, /turf/space) && istype(user.loc, /turf/space))
					user.Move(T)
				else user << "\red You bump into the ship's plating."
			else user << "\red The ship's gravity well keeps you in orbit!" // Assuming the ship starts on z level 1, you don't want to go past it

		if (DOWN) // Going down!
			if (user.z != 4 && user.z != 5) // If we aren't at the very bottom of the ship, or out in space
				var/turf/T = locate(user.x, user.y, user.z + 1)
				// You can only jetpack down if you're sitting on space and there's space down below, or hull
				if(T && istype(T, /turf/space) && istype(user.loc, /turf/space))
					user.Move(T)
			else user << "\red The ship's gravity well keeps you in orbit!"


/obj/item/weapon/Bump(mob/M as mob)
	spawn( 0 )
		..()
	return

/obj/manifest/New()
	src.invisibility = 101
	return

/obj/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in world)
		dat += text("    <B>[]</B> -  []<BR>", M.name, (istype(M.wear_id, /obj/item/weapon/card/id) ? text("[]", M.wear_id.assignment) : "Unknown Position"))
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	del(src)
	return

/obj/effect/screen/close/DblClick()
	if (src.master)
		src.master:close(usr)
	return


/mob/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if ( istype(W, /obj/item/weapon/reagent_containers/syringe) && istype(src, /mob/living/silicon/ai) ) // The cyborgs have their own attackby
		return
	var/shielded = 0
	for(var/obj/item/device/shield/S in src)
		if (S.active)
			shielded = 1
		else
	if (locate(/obj/item/weapon/grab, src))
		var/mob/safe = null
		if (istype(src.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.l_hand
			if (G.state == 3 && get_dir(src, user) == src.dir)
				safe = G.affecting
		if (istype(src.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.r_hand
			if (G.state == 3 && get_dir(src, user) == src.dir)
				safe = G.affecting
		if (safe)
			return safe.attackby(W, user)
	if (!shielded || (shielded && prob(45)))
		spawn(0)
			W.attack(src, user)
			return
	return


/obj/item/weapon/stamp/attack_paw(mob/user as mob)
	return src.attack_hand(user)
