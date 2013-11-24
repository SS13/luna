/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	flag = "energy"


/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = 1
	stun = 10
	weaken = 10
	stutter = 12

	on_hit(var/atom/target, var/blocked = 0)
		if(!ismob(target)) //Fully blocked by mob or collided with dense object - burst into sparks!
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
			sparks.set_up(1, 1, src)
			sparks.start()
		..()


/obj/item/projectile/energy/declone
	name = "declown"
	icon_state = "declone"
	nodamage = 1
	damage_type = CLONE
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	weaken = 5


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 20
	damage_type = TOX
	nodamage = 0
	weaken = 10
	stutter = 10

/obj/item/projectile/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"
	var/life = 20

	Bump(atom/A)
		A.bullet_act(src, def_zone)
		src.life -= 10
		if(life <= 0)
			del(src)
		return

/obj/item/projectile/energy/bolt/large
	name = "large bolt"
	damage = 33
	weaken = 12

/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 10



