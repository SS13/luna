/proc/gibs(atom/location, var/list/viruses)
	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	// NORTH
	gib = new /obj/effect/decal/cleanable/blood/gibs(location)
	if (prob(30))
		gib.icon_state = "gibup1"
	gib.CopyViruses(viruses)
	gib.streak(list(NORTH, NORTHEAST, NORTHWEST))

	// SOUTH
	gib = new /obj/effect/decal/cleanable/blood/gibs(location)
	if (prob(30))
		gib.icon_state = "gibdown1"
	gib.CopyViruses(viruses)
	gib.streak(list(SOUTH, SOUTHEAST, SOUTHWEST))

	// WEST
	gib = new /obj/effect/decal/cleanable/blood/gibs(location)
	gib.CopyViruses(viruses)
	gib.streak(list(WEST, NORTHWEST, SOUTHWEST))

	// EAST
	gib = new /obj/effect/decal/cleanable/blood/gibs(location)
	gib.CopyViruses(viruses)
	gib.streak(list(EAST, NORTHEAST, SOUTHEAST))

	// RANDOM BODY
	gib = new /obj/effect/decal/cleanable/blood/gibs/body(location)
	gib.CopyViruses(viruses)
	gib.streak(cardinal8)

	// RANDOM LIMBS
	for (var/i = 0, i < pick(0, 1, 2), i++)
		gib = new /obj/effect/decal/cleanable/blood/gibs/limb(location)
		gib.CopyViruses(viruses)
		gib.streak(cardinal8)

	// CORE
	gib = new /obj/effect/decal/cleanable/blood/gibs/core(location)
	gib.CopyViruses(viruses)

/proc/robogibs(atom/location, var/datum/disease/virus)
	var/obj/effect/decal/cleanable/robot_debris/gib = null

	// RUH ROH
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()

	// NORTH
	gib = new /obj/effect/decal/cleanable/robot_debris(location)
	if (prob(25))
		gib.icon_state = "gibup1"
	gib.streak(list(NORTH, NORTHEAST, NORTHWEST))

	// SOUTH
	gib = new /obj/effect/decal/cleanable/robot_debris(location)
	if (prob(25))
		gib.icon_state = "gibdown1"
	gib.streak(list(SOUTH, SOUTHEAST, SOUTHWEST))

	// WEST
	gib = new /obj/effect/decal/cleanable/robot_debris(location)
	gib.streak(list(WEST, NORTHWEST, SOUTHWEST))

	// EAST
	gib = new /obj/effect/decal/cleanable/robot_debris(location)
	gib.streak(list(EAST, NORTHEAST, SOUTHEAST))

	// RANDOM
	gib = new /obj/effect/decal/cleanable/robot_debris(location)
	gib.streak(cardinal8)

	// RANDOM LIMBS
	for (var/i = 0, i < pick(0, 1, 2), i++)
		gib = new /obj/effect/decal/cleanable/robot_debris/limb(location)
		gib.streak(cardinal8)