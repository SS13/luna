//returns the netnum of a stub cable at this grille loc, or 0 if none

/obj/structure/grille
	desc = "A piece of metal with evenly spaced gridlike holes in it. Blocks large object but lets small items, gas, or energy beams through."
	name = "grille"
	icon = 'structures.dmi'
	icon_state = "grille"
	density = 1
	layer = 2.9
	var/health = 10
	var/destroyed = 0
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

/obj/structure/grille/Bumped(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/grille/blob_act()
	src.health--
	src.healthcheck()

/obj/structure/grille/meteorhit(var/obj/M)
	if (M.icon_state == "flaming")
		src.health -= 2
		healthcheck()
	return

/obj/structure/grille/attack_hand(var/obj/M)
	if (HULK in usr.mutations)
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

/obj/structure/grille/attack_slime(mob/user as mob)
	if(!istype(user, /mob/living/carbon/slime/adult))	return

	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
	user.visible_message("<span class='warning'>[user] smashes against [src].</span>", \
						 "<span class='warning'>You smash against [src].</span>", \
						 "You hear twisting metal.")

	health -= rand(2,3)
	healthcheck()
	return

/obj/structure/grille/attack_paw(var/obj/M)
	if (HULK in usr.mutations)
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
	src.health -= Proj.damage*0.3
	healthcheck()
	return

/obj/structure/grille/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters))
		if(!shock(user, 100))
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			if(destroyed)
				new /obj/item/stack/rods(loc)
			else
				new /obj/item/stack/rods(loc, 2)
			del(src)
	else if ((istype(W, /obj/item/weapon/screwdriver) && (istype(src.loc, /turf/simulated) || src.anchored)))
		if(!shock(user, 90))
			playsound(src.loc, 'Screwdriver.ogg', 100, 1)
			src.anchored = !src.anchored
			user << (src.anchored ? "You have fastened the grille to the floor." : "You have unfastened the grill.")

			if(anchored)
				TryConnect()
			else
				TryDisconnect()

			for(var/mob/O in oviewers())
				O << text("\red [user] [src.anchored ? "fastens" : "unfastens"] the grille.")
			return

//window placing begin
	else if( istype(W,/obj/item/stack/sheet/rglass) || istype(W,/obj/item/stack/sheet/glass) )
		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( x == user.x || y == user.y ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				user << "<span class='notice'>You can't reach.</span>"
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				user << "<span class='notice'>There is already a window facing this way there.</span>"
				return
		user << "<span class='notice'>You start placing the window.</span>"
		if(do_after(user,20))
			if(!src) return //Grille destroyed while waiting
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					user << "<span class='notice'>There is already a window facing this way there.</span>"
					return
			var/obj/structure/window/WD
			if(istype(W,/obj/item/stack/sheet/rglass))
				WD = new/obj/structure/window/reinforced(loc) //reinforced window
			else
				WD = new/obj/structure/window(loc) //normal window
			WD.dir = dir_to_set
			WD.ini_dir = dir_to_set
			WD.anchored = 0
			WD.state = 0
			var/obj/item/stack/ST = W
			ST.use(1)
			user << "<span class='notice'>You place the [WD] on [src].</span>"
		return
//window placing end

	else
		if(W.flags && CONDUCT) 	// anything conductive, chance of a shock
			shock(user, 70)
		playsound(src.loc, 'grillehit.ogg', 80, 1)
		switch(W.damtype)
			if("fire")
				src.health -= W.force
			if("brute")
				src.health -= W.force * 0.5

	src.healthcheck()
	..()
	return

/obj/structure/grille/proc/healthcheck()
	if (src.health <= 0)
		if (!src.destroyed)
			src.icon_state = "brokengrille"
			src.density = 0
			src.destroyed = 1
			new /obj/item/stack/rods(src.loc)

		else
			if (src.health <= -10.0)
				new /obj/item/stack/rods(src.loc)
				del(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/living/user, prb)
	if(!anchored || destroyed)		// !anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	if(!istype(user))
		return 0

	var/turf/MyLocation = loc
	if(!istype(MyLocation, /turf/simulated/floor))
		return 0

	var/power = Surplus()
	if(power)
		if(user.electrocute_act(power/4000, src))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
			return 1
	else
		return 0

// Powernet Interaction - copied from /obj/machinery/power
/obj/structure/grille/proc/GetPowernet()
	var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
	if (!Network)
		return null
	return Network.Controller

/obj/structure/grille/proc/Surplus()
	var/datum/UnifiedNetworkController/PowernetController/Controller = GetPowernet()
	if (!Controller)
		return 0
	return Controller.SurplusPower()

/obj/structure/grille/proc/TryConnect()
	TryDisconnect()
	for(var/obj/cabling/power/cable in get_turf(src))
		cable.ObjectBuilt(src)

/obj/structure/grille/proc/TryDisconnect()
	var/datum/UnifiedNetwork/CurrentNetwork = Networks[/obj/cabling/power]

	if (CurrentNetwork)
		CurrentNetwork.Controller.DetachNode(src)
		CurrentNetwork.Nodes -= src
	Networks[/obj/cabling/power] = null
	NetworkNumber[/obj/cabling/power] = 0
	return