// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

/obj/item/frame/proc/try_build(turf/on_wall)
	return

/obj/item/frame/light_fixture
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	flags = FPRINT| CONDUCT
	var/fixture_type = "tube"
	var/obj/machinery/light/newlight = null
	var/sheets_refunded = 2

/obj/item/frame/light_fixture/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
		del(src)
		return
	..()

/obj/item/frame/light_fixture/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in cardinal))
		return
	var/turf/loc = get_turf_loc(usr)
	if (!istype(loc, /turf/simulated/floor))
		usr << "\red [src.name] cannot be placed on this spot."
		return
	usr << "Attaching [src] to the wall."
	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
	var/constrdir = usr.dir
	var/constrloc = usr.loc
	if (!do_after(usr, 30))
		return
	switch(fixture_type)
		if("bulb")
			newlight = new /obj/machinery/light_construct/small(constrloc)
		if("tube")
			newlight = new /obj/machinery/light_construct(constrloc)
	newlight.dir = constrdir
	newlight.fingerprints = src.fingerprints
	newlight.fingerprintshidden = src.fingerprintshidden
	newlight.fingerprintslast = src.fingerprintslast

	usr.visible_message("[usr.name] attaches [src] to the wall.", \
		"You attach [src] to the wall.")
	del(src)

/obj/item/frame/light_fixture/small
	name = "small light fixture frame"
	desc = "Used for building small lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-item"
	flags = FPRINT| CONDUCT
	fixture_type = "bulb"
	sheets_refunded = 1


/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = 5
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_construct/New()
	..()
	if (fixture_type == "bulb")
		icon_state = "bulb-construct-stage1"

/obj/machinery/light_construct/examine()
	set src in view()
	..()
	if (!(usr in view(2))) return
	switch(src.stage)
		if(1)
			usr << "It's an empty frame."
			return
		if(2)
			usr << "It's wired."
			return
		if(3)
			usr << "The casing is closed."
			return

/obj/machinery/light_construct/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/weapon/wrench))
		if (src.stage == 1)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			usr << "You begin deconstructing [src]."
			if (!do_after(usr, 30))
				return
			new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
			user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
			del(src)
		if (src.stage == 2)
			usr << "You have to remove the wires first."
			return

		if (src.stage == 3)
			usr << "You have to unscrew the case first."
			return

	if(istype(W, /obj/item/weapon/wirecutters))
		if (src.stage != 2) return
		src.stage = 1
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage1"
			if("bulb")
				src.icon_state = "bulb-construct-stage1"
		new /obj/item/weapon/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message("[user.name] removes the wiring from [src].", \
			"You remove the wiring from [src].", "You hear a noise.")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return

	if(istype(W, /obj/item/weapon/cable_coil))
		if (src.stage != 1) return
		var/obj/item/weapon/cable_coil/coil = W
		coil.use(1)
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage2"
			if("bulb")
				src.icon_state = "bulb-construct-stage2"
		src.stage = 2
		user.visible_message("[user.name] adds wires to [src].", \
			"You add wires to [src].")
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if (src.stage == 2)
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-empty"
				if("bulb")
					src.icon_state = "bulb-empty"
			src.stage = 3
			user.visible_message("[user.name] closes [src]'s casing.", \
				"You close [src]'s casing.", "You hear a noise.")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)

			switch(fixture_type)
				if("tube")
					newlight = new /obj/machinery/light/built(src.loc)
				if("bulb")
					newlight = new /obj/machinery/light/small/built(src.loc)

			newlight.dir = src.dir
			del(src)
			return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = 5
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1


// the standard tube light fixture

/obj/machinery/light
	name = "light fixture"
	icon = 'lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	var/on = 0					// 1 if on, 0 if off
	var/burnchance = 0.001
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/isalert = 0
	var/switching = 0
	var/flickering = 0			// 0 or 1. Prevents ghosts from flickering lights while that light is already being flickered

	var/light_type = /obj/item/weapon/light/tube		// the type of light item

	var/brightnessred = 8
	var/brightnessgreen = 8
	var/brightnessblue = 8

	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

	blue
		brightnessblue = 7
		brightnessred = 5
		brightnessgreen = 5

	red
		brightnessgreen = 2
		brightnessblue = 2

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightnessred = 5
	brightnessgreen = 5
	brightnessblue = 4
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb

	red
		brightnessgreen = 0
		brightnessblue = 0

	floor
		icon_state = "floor1"
		base_state = "floor"
		brightnessblue = 6
		brightnessred = 6
		brightnessgreen = 5


/obj/machinery/light/broken
	icon_state = "tube-broken"
	status = LIGHT_BROKEN

// create a new lighting fixture
/obj/machinery/light/New()
	..()
	spawn(1)
		update()


/obj/machinery/light/small/New()
	..()
	if(prob(5))
		status = LIGHT_BROKEN

	spawn(1)
		update()

// update the icon_state and luminosity of the light depending on its state
// skip_check is currently used for ghosts flickering lights. It skips the status check, so that burned lights can also work.
// It also skips the burning probability check. In flickering, that means the light has a chance of burning only when it reverts to its default state
/obj/machinery/light/proc/update(var/skip_check = 0)
	set background=1
	if (switching)
		return
	if(!skip_check)
		switch(status)		// set icon_states
			if(LIGHT_OK)
				icon_state = "[base_state][on]"
			if(LIGHT_EMPTY)
				icon_state = "[base_state]-empty"
				on = 0
			if(LIGHT_BURNED)
				icon_state = "[base_state]-burned"
				on = 0
			if(LIGHT_BROKEN)
				icon_state = "[base_state]-broken"
				on = 0
	else
		icon_state = "[base_state][on]"

	var/oldlum = ul_Luminosity()

	//luminosity = on * brightness
	ul_SetLuminosity(on * brightnessred, on * brightnessgreen * !isalert, on * brightnessblue * !isalert)		// *UL*

	// if the state changed, inc the switching counter
	if(oldlum != ul_Luminosity())
		switchcount++

		// now check to see if the bulb is burned out
		if(status == LIGHT_OK)
			if(on && rigged)
				explode()
			if( prob(min(60, switchcount*switchcount*burnchance)) && !skip_check )
				status = LIGHT_BURNED
				icon_state = "[base_state]-burned"
				on = 0
				ul_SetLuminosity(0)



// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/machinery/light/examine()
	set src in oview(1)
	if(usr && !usr.stat)
		switch(status)
			if(LIGHT_OK)
				usr << "[desc] It is turned [on? "on" : "off"]."
			if(LIGHT_EMPTY)
				usr << "[desc] The [fitting] has been removed."
			if(LIGHT_BURNED)
				usr << "[desc] The [fitting] is burnt out."
			if(LIGHT_BROKEN)
				usr << "[desc] The [fitting] has been smashed."


// flicker lights on and off - ghosts
/obj/machinery/light/Click()
	..()
	//if(flickering)
	//	return
	if(istype(usr, /mob/dead/observer) && get_dist(usr,src) <= 1 && !flickering)
		flickering = 1

		if(status == LIGHT_EMPTY || status == LIGHT_BROKEN)
			usr << "There is no [fitting] in this light."
			return
		if(on)
			usr << "Your touch robs the [fitting] of its energy!"
		else
			usr << "Your touch breathes energy into the [fitting]!"

		on = !on
		update(1) // Flicker once
		sleep(10)
		on = !on
		update(1) // Flicker back to initial state
		sleep(10)
		on = !on
		update(1) // Flicker again
		sleep(30)
		on = !on
		update()	// And return to default state

		sleep(20)
		flickering = 0

	return

///obj/machinery/light/verb/flicker(obj/machinery/light/L in view())
//	set name = "Flicker"
//	set src in view()
//	set invisibility = 15
//	if(!istype(usr, /mob/dead/observer))
//		usr << "You can not find a way to flicker the lights from here."
//		return
//	L.flickerL(usr, L)


// attack with item - insert light (if right type), otherwise try to break the light
/obj/machinery/light/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return
	if (istype(user, /mob/living/silicon))
		return

	// attempt to insert light
	if(istype(W, /obj/item/weapon/light))
		if((status == LIGHT_BURNED) | (status == LIGHT_BROKEN))
			var/obj/item/weapon/light/L = W
			if(istype(L, light_type))
				var/obj/item/weapon/light/oL = new light_type(src.loc)
				oL.status = status
				oL.rigged = rigged
				oL.update()
				oL.add_fingerprint(user)

				status = L.status
				user << "You replace the [oL.name]."
				switchcount = L.switchcount
				rigged = L.rigged
				del(L)

				on = has_power()
				update()
				user.update_clothing()
				if(on && rigged)
					explode()
			else
				user << "This type of light requires a [fitting]."
				return
		else if(status == LIGHT_EMPTY)
			src.add_fingerprint(user)
			var/obj/item/weapon/light/L = W
			if(istype(L, light_type))
				status = L.status
				user << "You insert the [L.name]."
				switchcount = L.switchcount
				rigged = L.rigged
				del(L)

				on = has_power()
				update()
				user.update_clothing()
				if(on && rigged)
					explode()
			else
				user << "This type of light requires a [fitting]."
				return
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/weapon/screwdriver)) //If it's a screwdriver open it.
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(src.loc)
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/machinery/light_construct/small(src.loc)
					newlight.icon_state = "bulb-construct-stage2"
			newlight.dir = src.dir
			newlight.stage = 2
			newlight.fingerprints = src.fingerprints
			newlight.fingerprintshidden = src.fingerprintshidden
			newlight.fingerprintslast = src.fingerprintslast
			del(src)
			return

		// attempt to break the light

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)

		if(prob((1+W.force)*12))
			user << "You hit the light, and it smashes!"
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				if(!(COLD_RESISTANCE in user.mutations))
					Electrocute(user, 50, null, 20000)
			broken()


		else
			user << "You hit the light!"

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		user << "You stick \the [W.name] into the light socket!"
		if(has_power() && (W.flags & CONDUCT))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(!(COLD_RESISTANCE in user.mutations))
				Electrocute(user, 75, null, 20000)


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/area/A = src.loc.loc
	return A.master.lightswitch && A.master.power_light


// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/machinery/light/attack_hand(mob/user)
	if (istype(user, /mob/living/silicon))
		return
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))

			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				prot = (G.heat_transfer_coefficient < 0.5)	// *** TODO: better handling of glove heat protection
		else
			prot = 1

		if(prot > 0 || (COLD_RESISTANCE in user.mutations))
			user << "You remove the light [fitting]"
		else if(istype(H) && H.a_intent == "harm")
			user << "You smash the light [fitting], but burn your hand on it!"

			var/datum/organ/external/affecting = H.organs["[user.hand ? "l" : "r" ]_hand"]

			affecting.take_damage(2, 6)		// 6 burn damage and 2 brute
			broken()
			H.UpdateDamageIcon()
			H.updatehealth()
			return				// if burned, don't remove the light
		else
			user << "You try to remove the light [fitting], but burn your hand on it!"

			var/datum/organ/external/affecting = H.organs["[user.hand ? "l" : "r" ]_hand"]

			affecting.take_damage(0, 5)		// 5 burn damage

			H.UpdateDamageIcon()
			H.fireloss += 5
			H.updatehealth()
			return				// if burned, don't remove the light

	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new light_type()
	L.status = status
	L.rigged = rigged
	L.loc = usr
	L.layer = 20
	if(user.hand)
		user.l_hand = L
	else
		user.r_hand = L

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0


	L.update()
	L.add_fingerprint(user)

	status = LIGHT_EMPTY
	update()
	user.update_clothing()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken()
	if(status == LIGHT_EMPTY)
		return

	if(status == LIGHT_OK || status == LIGHT_BURNED)
		playsound(src.loc, 'Glasshit.ogg', 75, 1)
	if(on)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
	status = LIGHT_BROKEN
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(75))
				broken()
		if(3.0)
			if (prob(50))
				broken()
	return

//blob effect

/obj/machinery/light/blob_act()
	if(prob(50))
		broken()


// timed process
// use power

#define LIGHTING_POWER_FACTOR 25		//25W per unit luminosity

/obj/machinery/light/process()
	set background=1
	if(on)
		use_power(ul_Luminosity() * LIGHTING_POWER_FACTOR, LIGHT)
		if(switching)
			return
		var/area/A = get_area(src)
		if (isalert != A.redalert)
			switching = 1
			spawn(rand(0, 5))
				on = 0
				switching = 0
				update()
				switching = 1
				isalert = A.redalert
				on = 1
				sleep(10)
				switching = 0
				update()


// called when area power state changes

/obj/machinery/light/power_change()
	spawn(rand(0,15))
		var/area/A = src.loc.loc
		A = A.master
		seton(A.lightswitch && A.power_light)


// called when on fire

/obj/machinery/light/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 1, 2, 2, 1)
		sleep(1)
		del(src)


// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/weapon/light
	icon = 'lighting.dmi'
	flags = FPRINT
	force = 2
	throwforce = 5
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	m_amt = 60
	var/rigged = 0		// true if rigged to explode

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	w_class = 2.0
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	g_amt = 100

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	w_class = 2.0
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	g_amt = 50

// update the icon state and description of the light
/obj/item/weapon/light
	proc/update()
		switch(status)
			if(LIGHT_OK)
				icon_state = base_state
				desc = "A replacement [name]."
			if(LIGHT_BURNED)
				icon_state = "[base_state]-burned"
				desc = "A burnt-out [name]."
			if(LIGHT_BROKEN)
				icon_state = "[base_state]-broken"
				desc = "A broken [name]."


/obj/item/weapon/light/New()
	..()
	update()


/obj/machinery/light/built
	icon_state = "tube-broken"
	New()
		status = LIGHT_EMPTY
		update()
		..()

/obj/machinery/light/small/built
	icon_state = "bulb-broken"
	New()
		status = LIGHT_EMPTY
		update()
		..()


// attack bulb/tube with object
// if a syringe, can inject plasma to make it explode
/obj/item/weapon/light/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I

		user << "You inject the solution into the [src]."

		if(S.reagents.has_reagent("plasma", 5))
			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/weapon/light/afterattack(atom/target, mob/user)
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != "harm")
		return

	if(status == LIGHT_OK || status == LIGHT_BURNED)
		user << "The [name] shatters!"
		status = LIGHT_BROKEN
		force = 5
		playsound(src.loc, 'Glasshit.ogg', 75, 1)
		update()



// a box of replacement light items

/obj/item/weapon/storage/box/light
	name = "replacement lights"
	icon = 'storage.dmi'
	icon_state = "lightmixed"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/light/tubes
	name = "replacement tubes"
	icon_state = "light_tube"

/obj/item/weapon/storage/box/light/bulb
	name = "replacement bulbs"
	icon = 'storage.dmi'
	icon_state = "light_bulb"

/obj/item/weapon/storage/box/light/mixed/New()
	..()
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)


/obj/item/weapon/storage/box/light/tubes/New()
	..()
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)
	new /obj/item/weapon/light/tube(src)

/obj/item/weapon/storage/box/light/bulb/New()
	..()
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)
	new /obj/item/weapon/light/bulb(src)

