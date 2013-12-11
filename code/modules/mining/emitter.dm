/obj/machinery/mininglaser
	name = "laser"
	desc = "A heavy duty industrial laser"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)

	var/active = 0
	var/fire_delay = 40
	var/last_shot = 0
	var/state = 0
	var/locked = 0


/obj/machinery/mininglaser/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		usr << "It is fastened to the floor!"
		return 0
	src.dir = turn(src.dir, 90)
	return 1

/obj/machinery/mininglaser/update_icon()
	if (active && !stat)
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/mininglaser/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(state == 2)
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				user << "You turn off [src]."
			else
				src.active = 1
				user << "You turn on [src]."
			update_icon()
		else
			user << "\red The controls are locked!"
	else
		user << "\red The [src.name] needs to be firmly secured to the floor first."
		return 1

/obj/machinery/mininglaser/process()
	if(stat) return

	if(src.state != 2)
		src.active = 0
		update_icon()
		return

	if(active) use_power(100)

	if(((src.last_shot + src.fire_delay) <= world.time) && src.active)
		src.last_shot = world.time
		use_power(300)
		var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/emitter( src.loc )
		playsound(src.loc, 'sound/weapons/emitter.ogg', 25, 1)
		A.dir = src.dir
		switch(dir)
			if(NORTH)
				A.yo = 20
				A.xo = 0
			if(EAST)
				A.yo = 0
				A.xo = 20
			if(WEST)
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
		A.process()	//TODO: Carn: check this out


/obj/machinery/mininglaser/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		if(active)
			user << "Turn off the [src] first."
			return
		switch(state)
			if(0)
				state = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = 0
			if(2)
				user << "\red The [src.name] needs to be unwelded from the floor."
		return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(active)
			user << "Turn off [src] first."
			return
		switch(state)
			if(0)
				user << "\red The [src.name] needs to be wrenched to the floor."
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld [src.name] to the floor.", \
						"You start to weld [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20))
						if(!src || !WT.isOn()) return
						state = 2
						user << "You weld [src] to the floor."
				else
					user << "\red You need more welding fuel to complete this task."
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut [src.name] free from the floor.", \
						"You start to cut [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20))
						if(!src || !WT.isOn()) return
						state = 1
						user << "You cut [src] free from the floor."
				else
					user << "\red You need more welding fuel to complete this task."
		return

	/*if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))
		if(emagged)
			user << "\red The lock seems to be broken"
			return
		if(src.allowed(user))
			if(active)
				src.locked = !src.locked
				user << "The controls are now [src.locked ? "locked." : "unlocked."]"
			else
				src.locked = 0 //just in case it somehow gets locked
				user << "\red The controls can only be locked when the [src] is online"
		else
			user << "\red Access denied."
		return*/


	if(istype(W, /obj/item/weapon/card/emag) && !emagged)
		locked = 0
		emagged = 1
		user.visible_message("[user.name] emags the [src.name].","\red You short out the safety timer.")
		fire_delay = 10
		return

	..()
	return