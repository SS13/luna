/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 2
	damage_type = BURN
	flag = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		empulse(target, 1, 1)
		return 1

/obj/item/projectile/energy/teleshot
	nodamage = 1
	name = "teleshot"

/obj/item/projectile/energy/teleshot/on_hit(var/atom/A, var/blocked = 0)
	var/failchance = 5
	var/obj/item/target = null

	if(istype(shot_from, /obj/item/weapon/gun/energy/teleport_gun))
		var/obj/item/weapon/gun/energy/teleport_gun/T = shot_from
		target = T.target
		failchance = 100 - T.reliability

	if(target == null)
		var/list/turfs = list(	)
		for(var/turf/T in orange(10, src))
			if(T.x>world.maxx-4 || T.x<4)	continue	//putting them at the edge is dumb
			if(T.y>world.maxy-4 || T.y<4)	continue
			turfs += T
		if(turfs)
			target = pick(turfs)
	if(!target)
		del(src)
		return
	spawn(0)
		if(A)
			var/turf/T = get_turf(A)
			for(var/atom/movable/M in T)
				if(istype(M, /obj/effects)) //sparks don't teleport
					continue
				if (M.anchored)
					continue
				if (istype(M, /atom/movable))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, M)
					s.start()
					if(prob(failchance)) //oh dear a problem, put em in deep space
						do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), getZLevel(Z_SPACE)), 0)
					else
						do_teleport(M, target, 1)
		del(src)
	return	..()

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	flag = "bullet"


	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	var/temperature = 300


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	flag = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.meteorhit(src)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				delete()
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		if(iscarbon(target))
			var/mob/living/carbon/M = target
			if(M.dna && M.dna.mutantrace == "plant") //Plantmen possibly get mutated and damaged by the rays.
				if(prob(15))
					M.apply_effect((rand(30,80)),IRRADIATE)
					M.Weaken(5)
					for (var/mob/V in viewers(src))
						V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
				if(prob(35))
				//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
				//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
					if(prob(80))
						randmutb(M)
						domutcheck(M,null)
					else
						randmutg(M)
						domutcheck(M,null)
				else
					M.adjustFireLoss(rand(5,15))
					M.show_message("\red The radiation beam singes you!")
				//	for (var/mob/V in viewers(src))
				//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
			else
			//	for (var/mob/V in viewers(src))
			//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
				M.show_message("\blue The radiation beam dissipates harmlessly through your body.")

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(mob/living/carbon/target, var/blocked = 0)
		if(iscarbon(target))
			if(ishuman(target) && target.dna && target.dna.mutantrace == "plant")	//These rays make plantmen fat.
				target.nutrition = min(target.nutrition+30, 500)
			else
				target.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.adjustBrainLoss(20)
			M.hallucination += 20
