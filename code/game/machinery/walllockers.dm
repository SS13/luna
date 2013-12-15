/obj/machinery/walllocker
	name = "wall locker"
	icon = 'lockwall.dmi'
	icon_state = "emerg"
	anchored = 1

	var/amount = 3

	var/item_1 = /obj/item/weapon/cigpacket // Something different from null
	var/item_2 = /obj/item/weapon/lighter // Normal locker won't be used anyway
	var/item_3 = /obj/item/weapon/reagent_containers/food/drinks/coffee

	var/list/items_1 = list()
	var/list/items_2 = list()
	var/list/items_3 = list()
	var/message_disp = "Dispenced a" // scout here!

	attack_hand(mob/user as mob)
		if(istype(user, /mob/living/silicon/ai))
			return
		if(!items_1.len && !items_2.len && !items_3.len)
			usr << "It's empty..."
			return
		else
			dispence()

	attackby(var/obj/item/O as obj, mob/user as mob)
		if(istype(user, /mob/living/silicon))
			return

		if(istype(O, item_1) && items_1.len < amount)
			items_1.Add(O)
			user << "You put [O] back in the locker."
		else if(istype(O, item_2) && items_2.len < amount)
			items_2.Add(O)
			user << "You put [O] back in the locker."
		else if(istype(O, item_3) && items_3.len < amount)
			items_3.Add(O)
			user << "You put [O] back in the locker."
		else
			return

		user.drop_item()
		O.loc = src

	proc/dispence() // that's so redundant, oh god
		var/message = message_disp
		var/obj/item/I

		var/list/names = list()

		if(items_1.len)
			I = pick(items_1)
			I.loc = src.loc
			items_1.Remove(I)
			names.Add(I.name)

		if(items_2.len)
			I = pick(items_2)
			I.loc = src.loc
			items_2.Remove(I)
			names.Add(I.name)

		if(items_3.len)
			I = pick(items_3)
			I.loc = src.loc
			items_3.Remove(I)
			names.Add(I.name)

		for(var/amt = 0; amt <= 3; amt++)
			if(names.len)
				var/singlename = names[1]
				switch(names.len)
					if(3) message += " [singlename]"
					if(2) message += ", [singlename]"
					if(1) message += " and [singlename]"
				names.Remove(singlename)

		message += "."

		if(I) usr << message

	New() // Generating items
		..()
		var/obj/item/I

		for(var/amt = amount; amt > 0; amt--)
			if(item_1)
				I = new item_1(src)
				items_1.Add(I)
			if(item_2)
				I = new item_2(src)
				items_2.Add(I)
			if(item_3)
				I = new item_3(src)
				items_3.Add(I)

/obj/machinery/walllocker/emerglocker
	name = "emergency locker"
	desc = "It contains a set of three crowbars, oxygen tanks and masks"

	item_1 = /obj/item/weapon/crowbar
	item_2 = /obj/item/clothing/mask/breath
	item_3 = /obj/item/weapon/tank/emergency_oxygen

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
