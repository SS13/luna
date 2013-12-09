/**********************Satchel**************************/

/obj/item/weapon/satchel
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	name = "satchel"
	var/capacity = 50 //the number of items it can carry.
	flags = FPRINT
	slot_flags = SLOT_BELT
	w_class = 1

/obj/item/weapon/satchel/ore
	name = "mining satchel"

/obj/item/weapon/satchel/attack_self(mob/user as mob)
	for (var/obj/item/O in contents)
		contents -= O
		O.loc = user.loc
	user << "\blue You empty the satchel."
	return

/obj/item/weapon/satchel/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/ore))
		var/obj/item/weapon/ore/O = W
		if((src.contents.len + 1) <= capacity)
			src.contents += O
		return
	..()

/obj/item/weapon/satchel/ore/borg
	name = "cyborg mining satchel"
	capacity = 100 //the number of ore pieces it can carry.

/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = 1
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_glass = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_clown = 0
	var/amt_other = 0

	New()
		..()
		if(prob(50))
			icon_state = "orebox1"

/obj/structure/ore_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/ore))
		src.contents += W
		update_contents()
	else if (istype(W, /obj/item/weapon/satchel/ore))
		src.contents += W.contents
		update_contents()
		user << "\blue You empty the satchel into the box."
	return

/obj/structure/ore_box/proc/update_contents()
	amt_gold = 0
	amt_silver = 0
	amt_diamond = 0
	amt_glass = 0
	amt_iron = 0
	amt_plasma = 0
	amt_uranium = 0
	amt_clown = 0
	amt_other = 0

	for (var/obj/item/weapon/ore/C in contents)
		if (istype(C,/obj/item/weapon/ore/diamond))
			amt_diamond++
		else if (istype(C,/obj/item/weapon/ore/glass))
			amt_glass++
		else if (istype(C,/obj/item/weapon/ore/plasma))
			amt_plasma++
		else if (istype(C,/obj/item/weapon/ore/iron))
			amt_iron++
		else if (istype(C,/obj/item/weapon/ore/silver))
			amt_silver++
		else if (istype(C,/obj/item/weapon/ore/gold))
			amt_gold++
		else if (istype(C,/obj/item/weapon/ore/uranium))
			amt_uranium++
		else if (istype(C,/obj/item/weapon/ore/clown))
			amt_clown++
		else
			amt_other++

		src.updateUsrDialog()

/obj/structure/ore_box/attack_hand(obj, mob/user as mob)
	var/dat = text("<b>The contents of the ore box reveal...</b><br>")
	if(amt_gold)
		dat += text("Gold ore: [amt_gold]<br>")
	if(amt_silver)
		dat += text("Silver ore: [amt_silver]<br>")
	if(amt_iron)
		dat += text("Metal ore: [amt_iron]<br>")
	if(amt_glass)
		dat += text("Sand: [amt_glass]<br>")
	if(amt_diamond)
		dat += text("Diamond ore: [amt_diamond]<br>")
	if(amt_plasma)
		dat += text("Plasma ore: [amt_plasma]<br>")
	if(amt_uranium)
		dat += text("Uranium ore: [amt_uranium]<br>")
	if(amt_clown)
		dat += text("Bananium ore: [amt_clown]<br>")
	if(amt_other)
		dat += text("Other ore: [amt_other]<br>")

	dat += text("<br><br><A href='?src=\ref[src];removeall=1'>Empty box</A>")
	user << browse("[dat]", "window=orebox")
	return


/obj/structure/ore_box/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["removeall"])
		for (var/obj/item/weapon/ore/O in contents)
			contents -= O
			O.loc = src.loc
		usr << "\blue You empty the box."
	update_contents()
	return