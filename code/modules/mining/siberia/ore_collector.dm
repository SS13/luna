/obj/machinery/mineral/siberia_ore_collector
	name = "ore collector"
	icon_state = "orecollector"
	density = 0
	var/list/ore_cost = list("rock" = 0, "slag" = 0, "sand" = 0.1, "iron ore" = 1, "plasma ore" = 2, "silver ore" = 4,
							 "gold ore" = 5, "uranium ore" = 3, "diamond ore" = 20, "bananium ore" = 1337) // Well, if you managed to find bananium, you deserve it.

/obj/machinery/mineral/siberia_ore_collector/New()
	..()
	spawn(5)
		for(var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break

		if(!siberia_controller)
			siberia_controller = new /datum/siberia_controller()

/obj/machinery/mineral/siberia_ore_collector/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!src.output || !siberia_controller) return

	if(istype(W, /obj/item/weapon/ore))
		user << "\blue You place [W] into the ore collector."
		user.drop_item()
		W.loc = src.output
		if(ore_cost[W.name])
			siberia_controller.adjust_points(user.name, ore_cost[W.name])
			user << siberia_controller.get_points_text(user.name)

	else if(istype(W, /obj/item/weapon/satchel/ore))
		var/points
		for(var/obj/item/weapon/ore/O in W)
			points += ore_cost[O.name]
			O.loc = src.output
		if(points)
			user << "\blue You empty [W] into [src]."
			siberia_controller.adjust_points(user.name, points)
			user << siberia_controller.get_points_text(user.name)
	return