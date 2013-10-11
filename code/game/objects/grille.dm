//returns the netnum of a stub cable at this grille loc, or 0 if none

/obj/structure/grille
	desc = "A piece of metal with evenly spaced gridlike holes in it. Blocks large object but lets small items, gas, or energy beams through."
	name = "grille"
	icon = 'structures.dmi'
	icon_state = "grille"
	density = 1
	layer = 2.9
	var/health = 10.0
	var/destroyed = 0.0
	anchored = 1.0
	flags = FPRINT | CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE


/obj/structure/grille/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.health -= 11
				healthcheck()
		else
	return

/obj/structure/grille/blob_act()
	src.health--
	src.healthcheck()


/obj/structure/grille/meteorhit(var/obj/M)
	if (M.icon_state == "flaming")
		src.health -= 2
		healthcheck()
	return

/obj/structure/grille/attack_hand(var/obj/M)
	if ((usr.mutations & HULK))
		usr << text("\blue You kick the grille.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] kicks the grille.", usr)
		src.health -= 2
		healthcheck()
		return
	else if(istype(usr,/mob/living/carbon/human) && usr:zombie) // or zombie
		usr << text("\blue You bang on the grille.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] bangs on the grille.", usr)
		src.health -= 2
		healthcheck()
		return
	else if(!shock(usr, 70)) // or anyone else.
		usr << text("\blue You kick the grille.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] kicks the grille.", usr)
		playsound(src.loc, 'grillehit.ogg', 80, 1)
		src.health -= 1

/obj/structure/grille/attack_paw(var/obj/M)
	if ((usr.mutations & HULK))
		usr << text("\blue You kick the grille.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] kicks the grille.", usr)
		src.health -= 2
		healthcheck()
		return
	else if(!shock(usr, 70))
		usr << text("\blue You kick the grille.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] kicks the grille.", usr)
		playsound(src.loc, 'grillehit.ogg', 80, 1)
		src.health -= 1

/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return 1
	else if (istype(mover, /obj/effects) || istype(mover, /obj/item/weapon/dummy) || istype(mover, /obj/beam) || istype(mover, /obj/effect/meteor/small))
		return 1
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	..()
	src.health -= Proj.damage*0.2
	healthcheck()
	return

/obj/structure/grille/attackby(obj/item/weapon/W, mob/user)
	if (istype(W, /obj/item/weapon/wirecutters))
		if(!shock(user, 100))
			playsound(src.loc, 'Wirecutter.ogg', 100, 1)
			src.health = 0
			if(!destroyed)
				src.health = -100
	else if ((istype(W, /obj/item/weapon/screwdriver) && (istype(src.loc, /turf/simulated) || src.anchored)))
		if(!shock(user, 90))
			playsound(src.loc, 'Screwdriver.ogg', 100, 1)
			src.anchored = !( src.anchored )
			user << (src.anchored ? "You have fastened the grille to the floor." : "You have unfastened the grill.")
			for(var/mob/O in oviewers())
				O << text("\red [user] [src.anchored ? "fastens" : "unfastens"] the grille.")
			return
	else if(istype(W, /obj/item/weapon/shard))	// can't get a shock by attacking with glass shard
		src.health -= W.force * 0.1

	else						// anything else, chance of a shock
		if(!shock(user, 70))
			playsound(src.loc, 'grillehit.ogg', 80, 1)
			switch(W.damtype)
				if("fire")
					src.health -= W.force
				if("brute")
					src.health -= W.force * 0.1

	src.healthcheck()
	..()
	return

/obj/structure/grille/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.icon_state = "brokengrille"
			src.density = 0
			src.destroyed = 1
			new /obj/item/stack/rods( src.loc )

		else
			if (src.health <= -10.0)
				new /obj/item/stack/rods( src.loc )
				//SN src = null
				del(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb)

	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0

	if(!prob(prb))
		return 0

	var/turf/MyLocation = loc
	if(!istype(MyLocation, /turf/simulated/floor))
		return 0

	for (var/obj/cabling/power/Cable in MyLocation)
		var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
		if(!Network)
			return 0
		var/datum/UnifiedNetworkController/PowernetController/Controller = Network.Controller
		Controller.CableTouched(Cable, user)
		return 1