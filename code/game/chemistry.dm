#define REGULATE_RATE 5

/obj/item/weapon/grenade
	icon = 'grenade.dmi'
	icon_state = "flashbang"
	item_state = "flashbang"
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	flags =  FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	var/state = null
	var/det_time = 20.0

	proc/prime()
		return

/obj/item/weapon/grenade/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "smoke bomb"
	flags = FPRINT | CONDUCT | USEDELAY
	slot_flags = SLOT_BELT
	var/datum/effect/system/bad_smoke_spread/smoke

/obj/item/weapon/grenade/incendiarygrenade
	desc = "It is set to detonate in 3 seconds."
	name = "incendiary grenade"
	var/firestrength = 100

/obj/item/weapon/grenade/mustardbomb
	desc = "It is set to detonate in 4 seconds."
	name = "mustard gas bomb"
	det_time = 40.0
	var/datum/effect/system/mustard_gas_spread/mustard_gas

/obj/item/weapon/grenade/smokebomb/New()
	..()
	src.smoke = new /datum/effect/system/bad_smoke_spread/
	src.smoke.attach(src)
	src.smoke.set_up(10, 0, usr.loc)

/obj/item/weapon/grenade/mustardbomb/New()
	..()
	src.mustard_gas = new /datum/effect/system/mustard_gas_spread/
	src.mustard_gas.attach(src)
	src.mustard_gas.set_up(5, 0, usr.loc)

/obj/item/weapon/grenade/smokebomb/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 60)
			src.det_time = 20
			user.show_message("\blue You set the smoke bomb for a 2 second detonation time.")
			src.desc = "It is set to detonate in 2 seconds."
		else
			src.det_time = 60
			user.show_message("\blue You set the smoke bomb for a 6 second detonation time.")
			src.desc = "It is set to detonate in 6 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/grenade/incendiarygrenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 60)
			src.det_time = 30
			user.show_message("\blue You set the incendiary grenade for a 3 second detonation time.")
			src.desc = "It is set to detonate in 3 seconds."
		else
			src.det_time = 60
			user.show_message("\blue You set the incendiary grenade for a 6 second detonation time.")
			src.desc = "It is set to detonate in 6 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/grenade/smokebomb/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (!src.state)
			user << "\red You prime the smoke bomb! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/grenade/incendiarygrenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (!src.state)
			user << "\red You prime the incendiary grenade! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/grenade/incendiarygrenade/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/grenade/incendiarygrenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/grenade/smokebomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/grenade/smokebomb/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/grenade/smokebomb/prime()
	playsound(src.loc, 'smoke.ogg', 50, 1, -3)
	spawn(0)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()

	for(var/obj/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update()
	sleep(80)
	del(src)
	return

/obj/item/weapon/grenade/incendiarygrenade/prime()
	playsound(src.loc, 'bamf.ogg', 75, 1, -2)
	var/turf/T = src.loc
	var/turf/Tx1 = src.x + 1
	var/turf/Txm1 = src.x - 1
	var/turf/Ty1 = src.y + 1
	var/turf/Tym1 = src.y - 1
	for(var/turf/simulated/floor/target_tile in list(T,Tx1,Txm1,Ty1,Tym1))
		//if(target_tile.parent)// && target_tile.parent.group_processing)
			//target_tile.parent.suspend_group_processing()

		var/datum/gas_mixture/napalm = new
		var/datum/gas/volatile_fuel/fuel = new

		fuel.moles = 55
		napalm.trace_gases += fuel

		target_tile.assume_air(napalm)

		spawn target_tile.hotspot_expose(SPARK_TEMP, 800)

	for(var/obj/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update()

	sleep(10)
	del(src)
	return


/obj/item/weapon/grenade/smokebomb/attack_self(mob/user as mob)
	if (!src.state)
		user << "\red You prime the smoke bomb! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn( src.det_time )
			prime()
			return
	return

/obj/item/weapon/grenade/incendiarygrenade/attack_self(mob/user as mob)
	if (!src.state)
		user << "\red You prime the incendiary grenade! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn( src.det_time )
			prime()
			return
	return

/obj/item/weapon/grenade/mustardbomb/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 80)
			src.det_time = 40
			user.show_message("\blue You set the mustard gas bomb for a 4 second detonation time.")
			src.desc = "It is set to detonate in 4 seconds."
		else
			src.det_time = 80
			user.show_message("\blue You set the mustard gas bomb for a 8 second detonation time.")
			src.desc = "It is set to detonate in 8 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/grenade/mustardbomb/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (!src.state)
			user << "\red You prime the mustard gas bomb! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/grenade/mustardbomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/grenade/mustardbomb/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/grenade/mustardbomb/prime()
	playsound(src.loc, 'smoke.ogg', 50, 1, -3)
	spawn(0)
		src.mustard_gas.start()
		sleep(10)
		src.mustard_gas.start()
		sleep(10)
		src.mustard_gas.start()
		sleep(10)
		src.mustard_gas.start()

	for(var/obj/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update()
	sleep(100)
	del(src)
	return

/obj/item/weapon/grenade/mustardbomb/attack_self(mob/user as mob)
	if (!src.state)
		user << "\red You prime the mustard gas bomb! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn(src.det_time)
			prime()
			return
	return

/obj/item/weapon/storage/box/beaker
	name = "Beaker Box"
	icon_state = "beaker"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/beaker/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )

/obj/item/weapon/storage/box/pillbottle
	name = "Pill Bottle Box"
	icon_state = "pillbottle"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/pillbottle/New()
	..()
	new /obj/item/weapon/storage/pill_bottle( src )
	new /obj/item/weapon/storage/pill_bottle( src )
	new /obj/item/weapon/storage/pill_bottle( src )
	new /obj/item/weapon/storage/pill_bottle( src )
	new /obj/item/weapon/storage/pill_bottle( src )
	new /obj/item/weapon/storage/pill_bottle( src )
	new /obj/item/weapon/storage/pill_bottle( src )
