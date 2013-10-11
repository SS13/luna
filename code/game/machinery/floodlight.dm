/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/weapon/cell/cell = null
	var/use = 1
	var/unlocked = 0
	var/open = 0

/obj/machinery/floodlight/update_icon()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if (!on)
		if (luminosity)
			update_icon()
			ul_SetLuminosity(0)
		return

	if(!luminosity && cell && cell.charge > 0)
		ul_SetLuminosity(10)
		update_icon()

	if(!cell && luminosity)
		on = 0
		update_icon()
		ul_SetLuminosity(0)
		return

	cell.charge -= use

	if(cell.charge <= 0 && luminosity)
		on = 0
		update_icon()
		ul_SetLuminosity(0)
		return

/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		cell.loc = usr
		cell.layer = 20
		if (user.hand )
			user.l_hand = cell
		else
			user.r_hand = cell

		cell.add_fingerprint(user)
		src.cell = null
		update_icon()
		user.update_clothing()

		user << "You remove the power cell"
		return

	if(on)
		on = 0
		user << "You turn off the light"
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = 1
		user << "You turn on the light"

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (!open)
			if(unlocked)
				unlocked = 0
				user << "You screw the battery panel in place."
			else
				unlocked = 1
				user << "You unscrew the battery panel."

	if (istype(W, /obj/item/weapon/crowbar))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				user << "You crowbar the battery panel in place."
			else
				if(unlocked)
					open = 1
					user << "You remove the battery panel."

	if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				user << "There is a power cell already installed."
			else
				user.drop_item()
				W.loc = src
				cell = W
				user << "You insert the power cell."
	update_icon()

/obj/machinery/floodlight/New()
	src.cell = new/obj/item/weapon/cell(src)
	cell.maxcharge = 2500
	cell.charge = 2500
	..()

