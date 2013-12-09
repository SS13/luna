/obj/item/weapon/staff/magical //Now with REAL MAGIC
	flags = FPRINT | NOSHIELD | USEDELAY

	var/obj/effect/proc_holder/spell/mob_spell
	var/obj/effect/proc_holder/spell/turf_spell
	var/obj/effect/proc_holder/spell/obj_spell
	var/obj/effect/proc_holder/spell/aoe_turf/knock/door_spell // Only possible door spell!
	var/obj/effect/proc_holder/spell/attackself_spell

	var/uses = -1 // -1 for infinite
	var/cooldown = 0
	var/last_use = 0

/obj/item/weapon/staff/magical/afterattack(atom/target as mob|obj|turf, mob/living/user, flag, params)
	if(uses == 0)
		return

	if(cooldown && last_use+cooldown >= world.time)
		return

	if(flag)	//we're placing staff on a table or in backpack
		return

	var/casted = 0
	if(istype(target, /mob) && mob_spell && !casted)
		mob_spell.cast(list(target), user)
		casted = 1

	if(istype(target, /turf) && turf_spell && !casted)
		turf_spell.cast(list(target), user)
		casted = 1

	if(istype(target, /obj/machinery/door) && door_spell && !casted)
		target = get_turf(target)
		door_spell.cast(list(target), user)
		casted = 1

	if(istype(target, /obj) && obj_spell && !casted)
		obj_spell.cast(list(target), user)
		casted = 1

	if(casted)
		uses--
		last_use = world.time

/obj/item/weapon/staff/magical/attack_self(mob/user as mob)
	if(uses == 0) return 0
	if(cooldown && last_use+cooldown >= world.time) return 0

	last_use = world.time

	if(attackself_spell)
		attackself_spell.cast(list(user), user)
		uses--
		last_use = world.time

/obj/item/weapon/staff/magical/test/New()
	..()
	mob_spell = new /obj/effect/proc_holder/spell/dumbfire/fireball()
	turf_spell = new /obj/effect/proc_holder/spell/aoe_turf/conjure/lesserforcewall()
	//obj_spell - not sure what spell to give
	door_spell = new /obj/effect/proc_holder/spell/aoe_turf/knock()
	attackself_spell = new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt()



/obj/item/weapon/staff/magical/random/New()
	..()
	cooldown = 200 + rand(-100, 200)
	if(prob(20))
		door_spell = new /obj/effect/proc_holder/spell/aoe_turf/knock()