/obj/effect/proc_holder/spell/targeted/ethereal_jaunt
	name = "Ethereal Jaunt"
	desc = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."

	school = "transmutation"
	charge_max = 300
	clothes_req = 1
	invocation = "none"
	invocation_type = "none"
	range = -1
	include_user = 1

	var phaseshift = 0
	var/jaunt_duration = 50 //in deciseconds

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/cast(list/targets) //magnets, so mostly hardcoded
	for(var/mob/living/target in targets)
		spawn(0)
			var/mobloc = get_turf(target.loc)
			var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt( mobloc )
			var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
			animation.name = "water"
			animation.density = 0
			animation.anchored = 1
			animation.icon = 'icons/mob/mob.dmi'
			animation.icon_state = "liquify"
			animation.layer = 5
			animation.master = holder
			if(target.buckled)
				target.buckled.unbuckle()
			if(phaseshift == 1)
				animation.dir = target.dir
				flick("phase_shift",animation)
				target.loc = holder
				target.client.eye = holder
				sleep(jaunt_duration)
				mobloc = get_turf(target.loc)
				animation.loc = mobloc
				target.canmove = 0
				sleep(20)
				animation.dir = target.dir
				flick("phase_shift2",animation)
				sleep(5)
				if(!target.Move(mobloc))
					for(var/direction in list(1,2,4,8,5,6,9,10))
						var/turf/T = get_step(mobloc, direction)
						if(T)
							if(target.Move(T))
								break
				target.canmove = 1
				target.client.eye = target
				del(animation)
				del(holder)
			else
				flick("liquify",animation)
				target.loc = holder
				target.client.eye = holder
				var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
				steam.set_up(10, 0, mobloc)
				steam.start()
				sleep(jaunt_duration)
				mobloc = get_turf(target.loc)
				animation.loc = mobloc
				steam.location = mobloc
				steam.start()
				target.canmove = 0
				sleep(20)
				flick("reappear",animation)
				if(!target.Move(mobloc))
					for(var/direction in list(1,2,4,8,5,6,9,10))
						var/turf/T = get_step(mobloc, direction)
						if(T)
							if(target.Move(T))
								break
				sleep(5)
				target.canmove = 1
				target.client.eye = target
				del(animation)
				del(holder)

/obj/effect/dummy/spell_jaunt
	name = "water"
	icon = 'icons/effects/effects.dmi'
	var/datum/gas_mixture/air_contents = null
	icon_state = "nothing"
	var/canmove = 1
	density = 0
	anchored = 1
	layer = 4.1

/obj/effect/dummy/spell_jaunt/New()
	..()
	// Make a breatheable atmosphere for our little wizard...
	src.air_contents = new /datum/gas_mixture()
	src.air_contents.volume = 70 //liters
	src.air_contents.temperature = T20C
	src.air_contents.oxygen = ONE_ATMOSPHERE * src.air_contents.volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	src.air_contents.nitrogen = ONE_ATMOSPHERE * src.air_contents.volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD


/obj/effect/dummy/spell_jaunt/relaymove(var/mob/user, direction)
	if (!src.canmove) return
	var/turf/newLoc = get_step(src,direction)

	if(!newLoc) return

	if(newLoc.flags & NOJAUNT)
		user << "<span class='warning'>Some strange aura is blocking the way!</span>"
	else if((loc.z in list(1,2,3,4)) && !(newLoc.z in list(1,2,3,4)))
		user << "<span class='warning'>Some strange aura is blocking the way!</span>"
	else if(loc.z != newLoc.z)
		user << "<span class='warning'>Some strange aura is blocking the way!</span>"
	else
		loc = newLoc
	src.canmove = 0
	spawn(2) src.canmove = 1


/obj/effect/dummy/spell_jaunt/remove_air(amount)
	return air_contents.remove(amount)

/obj/effect/dummy/spell_jaunt/return_air()
	return air_contents

/obj/effect/dummy/spell_jaunt/Del()
	for(var/atom/movable/A in src)
		A.loc = src.loc
	..()

/obj/effect/dummy/spell_jaunt/ex_act(blah)
	return
/obj/effect/dummy/spell_jaunt/bullet_act(blah)
	return