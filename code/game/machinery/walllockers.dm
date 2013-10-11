/obj/machinery/walllocker
	name = "Wall locker"
	icon = 'lockwall.dmi'
	icon_state = "emerg"
	anchored = 1
	var/list/items_inside = list()
	var/list/item_1 = (/obj/item/weapon/cigpacket) // Something different from null
	var/list/item_2 = (/obj/item/weapon/lighter) // Normal locker won't be used anyway
	var/list/item_3 = (/obj/item/weapon/reagent_containers/food/drinks/coffee)
	var/obj/spawn_1
	var/obj/spawn_2
	var/obj/spawn_3
	var/message_disp = "Dispenced a" // scout here!
	var/spawned_1
	var/spawned_2
	var/spawned_3

	attack_hand(mob/user as mob)
		if(istype(user, /mob/living/silicon/ai))
			return
		if(!items_inside.len)
			usr << "It's empty..."
			return
		if(items_inside.len)
			dispence(item_1, item_2, item_3)
		return

	attackby(var/obj/O as obj, mob/user as mob)
		if(istype(O, spawn_1))
			item_1.Add(spawn_1) ; var/obj/item = spawn_1 ; usr << "You put the [item.name] back in the locker."
		if(istype(O, spawn_2))
			item_2.Add(spawn_2) ; var/obj/item = spawn_2 ; usr << "You put the [item.name] back in the locker."
		if(istype(O, spawn_3))
			item_3.Add(spawn_3) ; var/obj/item = spawn_3 ; usr << "You put the [item.name] back in the locker."
		reset()

	proc/dispence(item_1, item_2, item_3) // that's so redundant, oh god
		var/obj/first ; var/obj/second ; var/obj/third// ; var/message
		if(!isnull(item_1))
			first = new spawn_1(src.loc) ; spawned_1 = 1 ; item_1 -= spawn_1
		if(!isnull(item_2))
			second = new spawn_2(src.loc) ; spawned_2 = 1 ; item_2 -= spawn_2
		if(!isnull(item_3))
			third = new spawn_3(src.loc) ; spawned_3 = 1 ; item_3 -= spawn_3
		if(spawned_1 && spawned_2 && spawned_3) usr << "[message_disp] [first.name], [second.name] and [third.name]." // Make the dispencer say that outloud, not only to a user.
		else if(spawned_1 && spawned_2) usr << "[message_disp] [first.name] and [second.name]."
		else if(spawned_1) usr << "[message_disp] [first.name]."
		reset() // calling a proc to make this less redundant

	New()
		reset()

	proc/reset()
		items_inside = item_1 + item_2 + item_3
		spawn_1 = pick(item_1) ; spawn_2 = pick(item_2) ; spawn_3 = pick(item_3)
		spawned_1 = 0 ; spawned_2 = 0 ; spawned_3 = 0

/obj/machinery/walllocker/emerglocker
	name = "Emergency locker"
	desc = "It contains a set of three crowbars, oxygen tanks and masks"

	item_1 = list(/obj/item/weapon/crowbar, /obj/item/weapon/crowbar, /obj/item/weapon/crowbar)
	item_2 = list(/obj/item/clothing/mask/breath, /obj/item/clothing/mask/breath, /obj/item/clothing/mask/breath)
	item_3 = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/weapon/tank/emergency_oxygen, /obj/item/weapon/tank/emergency_oxygen)

/obj/machinery/walllocker/emerglocker/north
	pixel_y = 32
	dir = SOUTH
/obj/machinery/walllocker/emerglocker/south
	pixel_y = -32
	dir = NORTH
/obj/machinery/walllocker/emerglocker/west
	pixel_x = -32
	dir = WEST
/obj/machinery/walllocker/emerglocker/east
	pixel_x = 32
	dir = EAST
