/**********************Mineral stacking unit**************************/

/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon_state = "stacker"

	var/stk_types = list()
	var/stk_amt   = list()

	var/ore_gold = 0
	var/ore_silver = 0
	var/ore_diamond = 0
	var/ore_plasma = 0
	var/ore_iron = 0
	var/ore_uranium = 0
	var/ore_clown = 0
	var/ore_glass = 0
	var/ore_rglass = 0
	var/ore_r_metal = 0
	var/ore_wood = 0
	var/ore_cardboard = 0
	var/ore_cloth = 0
	var/ore_leather = 0

/obj/machinery/mineral/stacking_machine/New()
	..()
	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return

/obj/machinery/mineral/stacking_machine/process()
	if (src.output && src.input)
		var/obj/item/O
		while (locate(/obj/item, input.loc))
			O = locate(/obj/item, input.loc)
			if (istype(O,/obj/item/stack/sheet/metal))
				ore_iron+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/diamond))
				ore_diamond+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/plasma))
				ore_plasma+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/gold))
				ore_gold+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/silver))
				ore_silver+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/clown))
				ore_clown+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/mineral/uranium))
				ore_uranium+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/glass))
				ore_glass+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/rglass))
				ore_rglass+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/plasteel))
				ore_r_metal+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/cardboard))
				ore_cardboard+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/stack/sheet/wood))
				ore_wood+= O:amount
				del(O)
				continue
			if (istype(O,/obj/item/weapon/ore/slag))
				del(O)
				continue
			O.loc = src.output.loc
	if (ore_gold >= 15)
		var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold
		G.amount = 15
		G.loc = output.loc
		ore_gold -= 15
		return
	if (ore_silver >= 20)
		var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver
		G.amount = 20
		G.loc = output.loc
		ore_silver -= 20
		return
	if (ore_diamond >= 5)
		var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond
		G.amount = 5
		G.loc = output.loc
		ore_diamond -= 5
		return
	if (ore_plasma >= 50)
		var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma
		G.amount = 50
		G.loc = output.loc
		ore_plasma -= 50
		return
	if (ore_iron >= 50)
		var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal
		G.amount = 50
		G.loc = output.loc
		ore_iron -= 50
		return
	if (ore_clown >= 5)
		var/obj/item/stack/sheet/mineral/clown/G = new /obj/item/stack/sheet/mineral/clown
		G.amount = 5
		G.loc = output.loc
		ore_clown -= 5
		return
	if (ore_uranium >= 20)
		var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium
		G.amount = 20
		G.loc = output.loc
		ore_uranium -= 20
		return
	if (ore_glass >= 50)
		var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass
		G.amount = 50
		G.loc = output.loc
		ore_glass -= 50
		return
	if (ore_rglass >= 50)
		var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass
		G.amount = 50
		G.loc = output.loc
		ore_rglass -= 50
		return
	if (ore_r_metal >= 50)
		var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel
		G.amount = 50
		G.loc = output.loc
		ore_r_metal -= 50
		return
	if (ore_wood >= 20)
		var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood
		G.amount = 20
		G.loc = output.loc
		ore_wood -= 20
		return
	if (ore_cardboard >= 5)
		var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard
		G.amount = 5
		G.loc = output.loc
		ore_cardboard -= 5
		return
	return



/obj/machinery/mineral/stacking_machine/attack_hand(mob/user as mob)
	drop_stacks()

/obj/machinery/mineral/stacking_machine/proc/drop_stacks()
	if (ore_gold)
		var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold
		G.amount = ore_gold
		G.loc = output.loc
		ore_gold = 0
		return
	if (ore_silver)
		var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver
		G.amount = ore_silver
		G.loc = output.loc
		ore_silver = 0
		return
	if (ore_diamond)
		var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond
		G.amount = ore_diamond
		G.loc = output.loc
		ore_diamond = 0
		return
	if (ore_plasma)
		var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma
		G.amount = ore_plasma
		G.loc = output.loc
		ore_plasma = 0
		return
	if (ore_iron)
		var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal
		G.amount = ore_iron
		G.loc = output.loc
		ore_iron = 0
		return
	if (ore_clown)
		var/obj/item/stack/sheet/mineral/clown/G = new /obj/item/stack/sheet/mineral/clown
		G.amount = ore_clown
		G.loc = output.loc
		ore_clown = 0
		return
	if (ore_uranium)
		var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium
		G.amount = ore_uranium
		G.loc = output.loc
		ore_uranium = 0
		return
	if (ore_glass)
		var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass
		G.amount = ore_glass
		G.loc = output.loc
		ore_glass = 0
		return
	if (ore_rglass)
		var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass
		G.amount = ore_rglass
		G.loc = output.loc
		ore_rglass = 0
		return
	if (ore_r_metal)
		var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel
		G.amount = ore_r_metal
		G.loc = output.loc
		ore_r_metal = 0
		return
	if (ore_wood)
		var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood
		G.amount = ore_wood
		G.loc = output.loc
		ore_wood = 0
		return
	if (ore_cardboard)
		var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard
		G.amount = ore_cardboard
		G.loc = output.loc
		ore_cardboard = 0
		return