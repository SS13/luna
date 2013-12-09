/* This is an attempt to make some easily reusable "particle" type effects, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/


/obj/effects
	name = "effects"
	icon = 'effects.dmi'
	mouse_opacity = 0
	flags = 0

/obj/effects/smoke
	name = "smoke"
	icon = 'water.dmi'
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 8.0


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effects/steam
	name = "steam"
	icon = 'effects.dmi'
	icon_state = "extinguish"
	density = 0

/datum/effect/system/steam_spread
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder

/datum/effect/system/steam_spread/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect/system/steam_spread/proc/attach(atom/atom)
	holder = atom

/datum/effect/system/steam_spread/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effects/steam/steam = new /obj/effects/steam(src.location)
			var/direction
			if(src.cardinals)
				direction = pick(cardinal)
			else
				direction = pick(cardinal8)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(steam,direction)
			spawn(20)
				del(steam)







/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effects/sparks
	name = "sparks"
	icon_state = "sparks"
	var/amount = 6.0
	anchored = 1.0
	mouse_opacity = 0

/obj/effects/sparks/New()
	..()
	playsound(src.loc, "sparks", 100, 1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(3000,100)
	spawn (100)
		del(src)
	return

/obj/effects/sparks/Del()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(3000,100)
	..()
	return

/obj/effects/sparks/Move()
	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(3000,100)
	return


//////////////////////////////////
//////SPARKELS FIREWORKS
/////////////////////////////////
////////////////////////////
/obj/effects/sparkels
	name = "sparkel"
	icon = 'fireworks.dmi'//findback
	icon_state = "sparkel"
	var/amount = 6.0
	anchored = 1.0
	mouse_opacity = 0
/obj/effects/sparkels/New()
	..()
	var/icon/I = new(src.icon,src.icon_state)
	var/r = rand(0,255)
	var/g = rand(0,255)
	var/b = rand(0,255)
	world.log << "Colour , [r],[g],[b]"
	I.Blend(rgb(r,g,b),ICON_MULTIPLY)
	src.icon = I
	playsound(src.loc, "sparks", 100, 1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(3000,100)
	spawn (100)
		del(src)
	return

/obj/effects/sparkels/Del()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(3000,100)
	..()
	return
/obj/effects/sparkels/Move()
	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(3000,100)
	return


/datum/effect/system/sparkel_spread
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect/system/sparkel_spread/proc/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/system/sparkel_spread/proc/attach(atom/atom)
	holder = atom

/datum/effect/system/sparkel_spread/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_sparks > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effects/sparkels/sparks = new(src.location)
			src.total_sparks++
			var/direction
			if(src.cardinals)
				direction = pick(cardinal)
			else
				direction = pick(cardinal8)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(sparks,direction)
			spawn(20)
				del(sparks)
				src.total_sparks--






/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////

/obj/effects/harmless_smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0
	//Remove this bit to use the old smoke
	icon = '96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effects/harmless_smoke/New()
	..()
	spawn (100)
		del(src)
	return

/obj/effects/harmless_smoke/Move()
	..()
	return

/datum/effect/system/harmless_smoke_spread
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction

/datum/effect/system/harmless_smoke_spread/proc/set_up(n = 5, c = 0, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct


/datum/effect/system/harmless_smoke_spread/proc/attach(atom/atom)
	holder = atom

/datum/effect/system/harmless_smoke_spread/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effects/harmless_smoke/smoke = new /obj/effects/harmless_smoke(src.location)
			src.total_smoke++
			var/direction = src.direction
			if(!direction)
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(cardinal8)
			for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
				sleep(10)
				step(smoke,direction)
			spawn(75+rand(10,30))
				del(smoke)
				src.total_smoke--







/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effects/bad_smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0
	//Remove this bit to use the old smoke
	icon = '96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effects/bad_smoke/New()
	..()
	spawn (200+rand(10,30))
		del(src)
	return

/obj/effects/bad_smoke/Move()
	..()
	for(var/mob/living/carbon/M in get_turf(src))
		if (M.internal != null && M.wear_mask && (M.wear_mask.flags & MASKINTERNALS))
		else
			M.drop_item()
			M.oxyloss += 1
			if (M.coughedtime != 1)
				M.coughedtime = 1
				M.emote("cough")
				spawn ( 20 )
					M.coughedtime = 0
	for(var/atom/A in src)
		reagents.reaction(A, 1, 1)
	return

/obj/effects/bad_smoke/HasEntered(mob/living/carbon/M as mob )
	..()
	if(istype(M, /mob/living/carbon))
		if (!(M.internal != null && M.wear_mask && (M.wear_mask.flags & MASKINTERNALS)))
			M.drop_item()
			M.oxyloss += 1
			if (M.coughedtime != 1)
				M.coughedtime = 1
				M.emote("cough")
				spawn ( 20 )
					M.coughedtime = 0
		if(reagents)
			src.reagents.reaction(M, 1, 1)
	return

/datum/effect/system/bad_smoke_spread
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/list/carried_reagents

/datum/effect/system/bad_smoke_spread/proc/set_up(n = 5, c = 0, loca, direct, var/datum/reagents/carry = null)
	if(n > 20)
		n = 20
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct
	if(carry)
		for(var/datum/reagent/RE in carry.reagent_list)
			carried_reagents += RE.id

/datum/effect/system/bad_smoke_spread/proc/attach(atom/atom)
	holder = atom

/datum/effect/system/bad_smoke_spread/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effects/bad_smoke/smoke = new /obj/effects/bad_smoke(src.location)
			src.total_smoke++
			var/direction = src.direction
			if(!direction)
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(cardinal8)
			for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
				sleep(10)
				step(smoke,direction)
			smoke.create_reagents(50)
			for(var/datum/reagent/RE in src.carried_reagents)
				smoke.reagents.add_reagent(RE, 5)
			spawn(150+rand(10,30))
				del(smoke)
				src.total_smoke--


/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////


/obj/effects/mustard_gas
	name = "mustard gas"
	icon_state = "mustard"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0

/obj/effects/mustard_gas/New()
	..()
	spawn (100)
		del(src)
	return

/obj/effects/mustard_gas/Move()
	..()
	for(var/mob/living/carbon/human/R in get_turf(src))
		if (R.internal != null && usr.wear_mask && (R.wear_mask.flags & MASKINTERNALS) && R.wear_suit != null && !istype(R.wear_suit, /obj/item/clothing/suit/storage/labcoat) && !istype(R.wear_suit, /obj/item/clothing/suit/straight_jacket) && !istype(R.wear_suit, /obj/item/clothing/suit/straight_jacket && !istype(R.wear_suit, /obj/item/clothing/suit/armor)))
		else
			R.burn_skin(0.75)
			if (R.coughedtime != 1)
				R.coughedtime = 1
				R.emote("gasp")
				spawn (20)
					R.coughedtime = 0
			R.updatehealth()
	return

/obj/effects/mustard_gas/HasEntered(mob/living/carbon/human/R as mob )
	..()
	if (istype(R, /mob/living/carbon/human))
		if (R.internal != null && usr.wear_mask && (R.wear_mask.flags & MASKINTERNALS) && R.wear_suit != null && !istype(R.wear_suit, /obj/item/clothing/suit/storage/labcoat) && !istype(R.wear_suit, /obj/item/clothing/suit/straight_jacket) && !istype(R.wear_suit, /obj/item/clothing/suit/straight_jacket && !istype(R.wear_suit, /obj/item/clothing/suit/armor)))
			return
		R.burn_skin(0.75)
		if (R.coughedtime != 1)
			R.coughedtime = 1
			R.emote("gasp")
			spawn (20)
				R.coughedtime = 0
		R.updatehealth()
	return

/datum/effect/system/mustard_gas_spread
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction

/datum/effect/system/mustard_gas_spread/proc/set_up(n = 5, c = 0, loca, direct)
	if(n > 20)
		n = 20
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect/system/mustard_gas_spread/proc/attach(atom/atom)
	holder = atom

/datum/effect/system/mustard_gas_spread/proc/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effects/mustard_gas/smoke = new /obj/effects/mustard_gas(src.location)
			src.total_smoke++
			var/direction = src.direction
			if(!direction)
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(cardinal8)
			for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
				sleep(10)
				step(smoke,direction)
			spawn(100)
				del(smoke)
				src.total_smoke--





/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/obj/effects/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = 1.0

/datum/effect/system/ion_trail_follow
	var/atom/holder
	var/turf/oldposition
	var/processing = 1
	var/on = 1

/datum/effect/system/ion_trail_follow/proc/set_up(atom/atom)
	holder = atom
	oldposition = get_turf(atom)

/datum/effect/system/ion_trail_follow/proc/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			var/turf/T = get_turf(src.holder)
			if(T != src.oldposition)
				if(istype(T, /turf/space))
					var/obj/effects/ion_trails/I = new /obj/effects/ion_trails(src.oldposition)
					src.oldposition = T
					I.dir = src.holder.dir
					flick("ion_fade", I)
					I.icon_state = "blank"
					spawn( 20 )
						del(I)
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect/system/ion_trail_follow/proc/stop()
	src.processing = 0
	src.on = 0