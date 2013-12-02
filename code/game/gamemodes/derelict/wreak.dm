/proc/wreakstation()
	world << "Preparing pre-round preparations"
	var/calc = 0
	for(var/obj/machinery/power/apc/a in world)
		if(a.z > 4)	continue

		a.cell.charge = 0
		if(prob(25))
			del a.cell
		else if(prob(40))
			a.set_broken()
		calc += 1
		if(calc > 50)
			sleep(0)
			calc = 0
	world << "Damaging floors"
	sleep(20*tick_multiplier)
	for(var/turf/simulated/floor/a in world)
		if(a.z > 4)	continue

		if(prob(70) && !(locate(/obj/effect/landmark/derelict/nodamage) in a))
			a.ex_act(3)
		calc += 1
		if(calc > 50)
			sleep(0)
			calc = 0
		if(prob(1) && prob(5))
			if(locate(/obj/effect/landmark/derelict/noblast) in a)
				continue
			explosion(a,3,5,7,9, 1)
	world << "Destroying walls (SLOW)"
	sleep(20*tick_multiplier)
	for(var/turf/simulated/wall/a in world)
		if(a.z > 4)	continue

		if(locate(/obj/effect/landmark/derelict/nodamage) in a)
			continue
		calc += 1
		if(calc > 50)
			sleep(0)
			calc = 0
		if(prob(40))
			a.ex_act(3)
	world << "Smashing windows"
	sleep(20*tick_multiplier)
	for(var/obj/structure/window/a in world)
		if(a.z > 4)	continue

		if(locate(/obj/effect/landmark/derelict/nodamage) in get_turf(a))
			continue
		if(prob(40))
			a.ex_act(3)
		calc += 1
		if(calc > 50)
			sleep(0)
			calc = 0
	world << "Hacking airlocks"
	sleep(20*tick_multiplier)
	for(var/obj/structure/window/a in world)
		if(a.z > 4)	continue

		if(locate(/obj/effect/landmark/derelict/nodamage) in get_turf(a))
			continue
		if(prob(65))
			a.ex_act(3)
		calc += 1
		if(calc > 50)
			sleep(0)
			calc = 0
	world << "Breaking alarms"
	sleep(20*tick_multiplier)

	for(var/obj/machinery/alarm/a in world)
		if(a.z > 4)	continue

		if(locate(/obj/effect/landmark/derelict/nodamage) in get_turf(a))
			continue
		if(prob(80))
			a.stat |= BROKEN
		calc += 1
		if(calc > 50)
			sleep(0)
			calc = 0
	world << "Stealing items"
	for(var/obj/machinery/bot/b in world)
		del b

	for(var/turf/a in world)
		if(a.z > 4)	continue

		for(var/obj/item/w in a)
			if(w.anchored) continue
			for(var/i = 0 to rand(1,5))
				step(w,pick(cardinal))

			if(prob(10) && !istype(w,/obj/item/weapon/card/id/captains_spare))
				del w

	var/area/hangar = locate(/area/hangar)
	var/list/b = get_area_all_objects(/area/hangar/derelict)
	for(var/obj/a in b)
		a.Move(locate(a.x, a.y, hangar.z))

	world << "Spawning tools"

	for(var/obj/effect/landmark/derelict/glass/glass in world)
		new /obj/item/stack/sheet/glass(glass.loc, rand(5, 50))

	for(var/obj/effect/landmark/derelict/metal/metal in world)
		new /obj/item/stack/sheet/metal(metal.loc, rand(5, 50))

	for(var/obj/effect/landmark/derelict/o2canister/o2 in world)
		if(prob(40)) new /obj/machinery/portable_atmospherics/canister/air(o2.loc)
		else		 new /obj/machinery/portable_atmospherics/canister/oxygen(o2.loc)

	for(var/obj/effect/landmark/derelict/o2crate/o2 in world)
		new /obj/structure/closet/crate/internalsoxy(o2.loc)


	for(var/obj/effect/landmark/derelict/superpacman/superpacman in world)
		new /obj/machinery/power/port_gen/pacman/super(superpacman.loc)
		new /obj/item/stack/sheet/mineral/uranium(superpacman.loc, 50)
		new /obj/item/stack/sheet/mineral/uranium(superpacman.loc, 50)

	for(var/obj/effect/landmark/derelict/supplycrate/supplycrate in world)
		new /obj/item/weapon/tank/emergency_oxygen/engi(supplycrate.loc)
		new /obj/item/weapon/tank/emergency_oxygen/engi(supplycrate.loc)
		new /obj/item/weapon/tank/emergency_oxygen/engi(supplycrate.loc)
		new /obj/item/weapon/tank/emergency_oxygen/engi(supplycrate.loc)
		new /obj/item/weapon/storage/belt/utility(supplycrate.loc)
		new /obj/item/weapon/storage/belt/utility(supplycrate.loc)
		new /obj/item/weapon/storage/toolbox/mechanical(supplycrate.loc)
		new /obj/item/weapon/storage/toolbox/electrical(supplycrate.loc)
		new /obj/item/clothing/gloves/yellow(supplycrate.loc)
		new /obj/item/clothing/gloves/yellow(supplycrate.loc)
		new /obj/item/device/multitool(supplycrate.loc)
		new /obj/item/device/multitool(supplycrate.loc)
		new /obj/item/clothing/shoes/magnetic(supplycrate.loc)
		new /obj/item/clothing/shoes/magnetic(supplycrate.loc)
		new /obj/structure/closet/crate/engineering(supplycrate.loc)