/*
CONTAINS:
RCD
*/

/obj/item/weapon/rcd
	name = "rapid construction device"
	desc = "A device used to rapidly build walls/floor."
	icon = 'items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/matter = 0
	var/max_matter = 30
	var/mode = 1
	origin_tech = "engineering=4;materials=2"
	flags = FPRINT | CONDUCT
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	m_amt = 75000
	g_amt = 15000
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/rcd/industrial
	name = "industrial rapid construction device"
	max_matter = 100
	matter = 100
	icon_state = "rcd_industrial"
	origin_tech = "engineering=5;materials=3"

/obj/item/weapon/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	w_class = 1
	opacity = 0
	density = 0
	anchored = 0.0
	var/matter = 10
	m_amt = 20000
	g_amt = 8000
	origin_tech = "materials=2"

/obj/item/weapon/rcd_ammo/super
	name = "hypercompressed matter cartridge"
	matter = 30
	m_amt = 60000
	g_amt = 24000


/obj/item/weapon/rcd/New()
	desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
	src.spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/weapon/rcd/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/rcd_ammo))
		if ((matter + W:matter) > max_matter)
			user << "The RCD can't hold any more matter."
			return
		matter += W:matter
		del(W)
		playsound(src.loc, 'click.ogg', 50, 1)
		user << "The RCD now holds [matter]/[max_matter] matter-units."
		desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
		return

/obj/item/weapon/rcd/attack_self(mob/user as mob)
	if(crit_fail)
		return

	playsound(src.loc, 'pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		user << "Changed mode to 'Airlock'"
		return
	if (mode == 2)
		mode = 3
		user << "Changed mode to 'Deconstruct'"
		return
	if (mode == 3)
		mode = 1
		user << "Changed mode to 'Floor & Walls'"
		return
	// Change mode

/obj/item/weapon/rcd/afterattack(atom/A, mob/user as mob)
	if (!(istype(A, /turf) || istype(A, /obj/machinery/door/airlock)))
		return

	if(crit_fail)
		return

	if (istype(A, /turf) && mode == 1)
		if (istype(A, /turf/space) && matter >= 1)
			user << "Building Floor (1)..."
			playsound(src.loc, 'Deconstruct.ogg', 50, 1)
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			A:ReplaceWithFloor()
			matter--
			user << "The RCD now holds [matter]/[max_matter] matter-units."
			desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return
		if (istype(A, /turf/simulated/floor/open) && matter >= 1)
			user << "Building Floor (1)..."
			playsound(src.loc, 'Deconstruct.ogg', 50, 1)
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			A:ReplaceWithFloor()
			matter--
			user << "The RCD now holds [matter]/[max_matter] matter-units."
			desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return
		if (istype(A, /turf/simulated/floor) && matter >= 3)
			user << "Building Wall (3)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 20))
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				A:ReplaceWithWall()
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				matter -= 3
				user << "The RCD now holds [matter]/[max_matter] matter-units."
				desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return
	else if (istype(A, /turf/simulated/floor) && mode == 2 && matter >= 10)
		user << "Building Airlock (10)..."
		playsound(src.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock( A )
			matter -= 10
			T.autoclose = 1
			playsound(src.loc, 'Deconstruct.ogg', 50, 1)
			user << "The RCD now holds [matter]/[max_matter] matter-units."
			desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			playsound(src.loc, 'sparks2.ogg', 50, 1)
		return
	else if (mode == 3 && (istype(A, /turf) || istype(A, /obj/machinery/door/airlock) ) )
		if (istype(A, /turf/simulated/wall) && matter >= 5)
			user << "Deconstructing Wall (5)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				matter -= 5
				A:ReplaceWithFloor()
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				user << "The RCD now holds [matter]/[max_matter] matter-units."
				desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return
		if (istype(A, /turf/simulated/wall/r_wall) && matter >= 5)
			user << "Deconstructing RWall (5)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				matter -= 5
				A:ReplaceWithWall()
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				user << "The RCD now holds [matter]/[max_matter] matter-units."
				desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return
		if (istype(A, /turf/simulated/floor) && matter >= 3)
			user << "Deconstructing Floor (3)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				matter -= 3
				A:ReplaceWithOpen()
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				user << "The RCD now holds [matter]/[max_matter] matter-units."
				desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return
		if (istype(A, /obj/machinery/door/airlock) && matter >= 10)
			user << "Deconstructing Airlock (10)..."
			playsound(src.loc, 'click.ogg', 50, 1)
			if(do_after(user, 50))
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				matter -= 10
				del(A)
				playsound(src.loc, 'Deconstruct.ogg', 50, 1)
				user << "The RCD now holds [matter]/[max_matter] matter-units."
				desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
			return

/obj/item/weapon/rcd_ammo/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(user, /mob/living/silicon/robot))
		if (istype(W, /obj/item/weapon/rcd))
			var/obj/item/weapon/rcd/N = W
			if ((N.matter + matter) > N.max_matter)
				user << "The RCD can't hold any more matter."
				return
			N.matter += matter
			playsound(src.loc, 'click.ogg', 50, 1)
			user << "The RCD now holds [N.matter]/[N.max_matter] matter-units."
			desc = "A RCD. It currently holds [N.matter]/[N.max_matter] matter-units."
			del(src)
			return