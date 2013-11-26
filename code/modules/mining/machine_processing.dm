/**********************Mineral processing unit**************************/

/obj/machinery/mineral/processing_unit
	name = "furnace"
	icon_state = "furnace"

	var/ore_gold = 0
	var/ore_silver = 0
	var/ore_diamond = 0
	var/ore_glass = 0
	var/ore_plasma = 0
	var/ore_uranium = 0
	var/ore_iron = 0
	var/ore_clown = 0
	var/ore_adamantine = 0

/obj/machinery/mineral/processing_unit/New()
	..()
	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
//		processing_items.Add(src)
		return
	return

/obj/machinery/mineral/processing_unit/process()
	if (src.output && src.input)
		var/i
		for (i = 0; i < 10; i++)
			if (ore_glass > 0)
				ore_glass--;
				new /obj/item/stack/sheet/glass(output.loc)
				continue
			if (ore_gold > 0)
				ore_gold--;
				new /obj/item/stack/sheet/mineral/gold(output.loc)
				continue
			if (ore_silver > 0)
				ore_silver--;
				new /obj/item/stack/sheet/mineral/silver(output.loc)
				continue
			if (ore_diamond > 0)
				ore_diamond--;
				new /obj/item/stack/sheet/mineral/diamond(output.loc)
				continue
			if (ore_plasma > 0)
				ore_plasma--;
				new /obj/item/stack/sheet/mineral/plasma(output.loc)
				continue
			if (ore_uranium > 0)
				ore_uranium--;
				new /obj/item/stack/sheet/mineral/uranium(output.loc)
				continue
			if (ore_iron > 0)
				ore_iron--;
				new /obj/item/stack/sheet/metal(output.loc)
				continue
			if (ore_clown > 0)
				ore_clown--;
				new /obj/item/stack/sheet/mineral/clown(output.loc)
				continue
		for (i = 0; i < 10; i++)
			var/obj/item/O
			O = locate(/obj/item, input.loc)
			if (O)
				if (istype(O,/obj/item/weapon/ore/iron))
					ore_iron++;
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/glass))
					ore_glass++;
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/diamond))
					ore_diamond++;
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/plasma))
					ore_plasma++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/gold))
					ore_gold++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/silver))
					ore_silver++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/uranium))
					ore_uranium++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/clown))
					ore_clown++
					del(O)
					continue
				O.loc = src.output.loc
			else
				break
	return