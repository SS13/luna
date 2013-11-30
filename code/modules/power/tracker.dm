//Solar tracker

//Machine that tracks the sun and reports it's direction to the solar controllers
//As long as this is working, solar panels on same powernet will track automatically

/obj/machinery/power/tracker
	name = "solar tracker"
	desc = "A solar directional tracker."
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker"
	anchored = 1
	density = 1
	directwired = 1

	var/glass_type = /obj/item/stack/sheet/glass
	var/sun_angle = 0		// sun angle as set by sun datum

	// called by datum/sun/calc_position() as sun's angle changes
	proc/set_angle(var/angle)
		sun_angle = angle

		//set icon dir to show sun illumination
		dir = turn(NORTH, -angle - 22.5)	// 22.5 deg bias ensures, e.g. 67.5-112.5 is EAST

		// check we can draw power
		if(stat & NOPOWER)
			return

		var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
		if(!Network) return 0

		for(var/obj/machinery/power/solar_control/C in Network.Nodes)
			C.tracker_update(angle)

		// Now updates all controllers on network.
		// It was updating all controllers in world before. -- ACCount

	// timed process
	// make sure we can draw power from the powernet
	process()
		var/avail = Surplus()

		if(avail > 500)
			AddLoad(500)
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

	// override power change to do nothing since we don't care about area power
	power_change()
		return

/obj/machinery/power/tracker/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/weapon/crowbar))
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 50))
			new /obj/item/weapon/solar_assembly(src.loc)
			new /obj/item/weapon/circuitboard/tracker(src.loc)
			new glass_type(src.loc, 2)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] takes the glass off the tracker.</span>")
			del(src)
		return
	..()

//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/weapon/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	item_state = "electropack"
	w_class = 4 // Pretty big!
	anchored = 0
	var/tracker = 0

/obj/item/weapon/solar_assembly/attack_hand(var/mob/user)
	if(!anchored && isturf(loc)) // You can't pick it up
		..()

/obj/item/weapon/solar_assembly/attackby(var/obj/item/weapon/W, var/mob/user)
	if(!anchored && isturf(loc))
		if(istype(W, /obj/item/weapon/wrench))
			anchored = 1
			user.visible_message("<span class='notice'>[user] wrenches the solar assembly into place.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return 1
	else
		if(istype(W, /obj/item/weapon/wrench))
			anchored = 0
			user.visible_message("<span class='notice'>[user] unwrenches the solar assembly from it's place.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return 1

		if(istype(W, /obj/item/stack/sheet/glass) || istype(W, /obj/item/stack/sheet/rglass))
			var/obj/item/stack/sheet/S = W
			var/glass_type = S.type
			if(S.use(2))
				playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] places the glass on the solar assembly.</span>")
				var/obj/machinery/power/solar/solar
				if(tracker)
					solar = new /obj/machinery/power/tracker(get_turf(src))
				else
					solar = new /obj/machinery/power/solar(get_turf(src))
				solar.glass_type = glass_type
				del(src)
			return 1

	if(!tracker)
		if(istype(W, /obj/item/weapon/circuitboard/tracker))
			tracker = 1
			user.drop_item()
			del(W)
			user.visible_message("<span class='notice'>[user] inserts the electronics into the solar assembly.</span>")
			return 1
	else
		if(istype(W, /obj/item/weapon/crowbar))
			new /obj/item/weapon/circuitboard/tracker(src.loc)
			tracker = 0
			user.visible_message("<span class='notice'>[user] takes out the electronics from the solar assembly.</span>")
			return 1
	..()

/obj/item/weapon/circuitboard/tracker
	name = "solar tracker electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = 2
