/obj/item/weapon/storage/belt
	flags = FPRINT | TABLEPASS | ONBELT

/obj/item/weapon/storage/belt/utility
	name = "utility belt"
	desc = "Can hold various tools."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "burger"
	can_hold = list(
	"/obj/item/device/radio",
	"/obj/item/weapon/hand_labeler",
	"/obj/item/weapon/oreprospector",
	"/obj/item/device/pda",
	"/obj/item/device/analyzer",
	"/obj/item/weapon/crowbar",
	"/obj/item/weapon/screwdriver",
	"/obj/item/weapon/weldingtool",
	"/obj/item/weapon/wirecutters",
	"/obj/item/weapon/wrench",
	"/obj/item/device/multitool",
	"/obj/item/device/flashlight",
	"/obj/item/weapon/cable_coil",
	"/obj/item/device/t_scanner")

/obj/item/weapon/storage/belt/security
	name = "security belt"
	desc = "Can hold various security items."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "securitybelt"
	item_state = "burger"
	can_hold = list(
	"/obj/item/device/radio",
	"/obj/item/device/detective_scanner",
	"/obj/item/device/ammo",
	"/obj/item/device/pda",
	"/obj/item/weapon/gun/revolver",
	"/obj/item/weapon/gun/detectiverevolver/",
	"/obj/item/weapon/gun/energy/general",
	"/obj/item/weapon/handcuffs",
	"/obj/item/device/flash",
	"/obj/item/weapon/baton",
	"/obj/item/weapon/classic_baton",
	"/obj/item/weapon/gun/energy/taser_gun",
	"/obj/item/weapon/grenade/flashbang",
	"/obj/item/weapon/grenade/emp",
	"/obj/item/weapon/camera_test",
	"/obj/item/weapon/recorder")

/obj/item/weapon/storage/belt/security/reaper/New()
	..()
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/gun/energy/taser_gun(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/device/flash(src)

/obj/item/weapon/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical items."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "medicalbelt"
	item_state = "burger"
	can_hold = list(
	"/obj/item/device/radio",
	"/obj/item/device/pda",
	"/obj/item/device/healthanalyzer",
	"/obj/item/device/geneticsanalyzer",
	"/obj/item/weapon/reagent_containers/syringe",
	"/obj/item/weapon/medical",
	"/obj/item/weapon/storage/pill_bottle",
	"/obj/item/weapon/reagent_containers/glass/beaker",
	"/obj/item/weapon/reagent_containers/glass/bottle",
	"/obj/item/weapon/reagent_containers/glass/bloodpack",
	"/obj/item/weapon/reagent_containers/pill")

/obj/item/weapon/storage/belt/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if (!istype(over_object, /obj/screen))
		return ..()

	playsound(src.loc, "rustle", 50, 1, -5)
	if (!M.restrained() && !M.stat)
		if (over_object.name == "r_hand")
			if (!( M.r_hand ))
				M.u_equip(src)
				M.r_hand = src
		else
			if (over_object.name == "l_hand")
				if (!( M.l_hand ))
					M.u_equip(src)
					M.l_hand = src
		M.update_clothing()
		src.add_fingerprint(usr)
		return

/obj/item/weapon/storage/belt/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/storage/belt/attack_hand(mob/user as mob)
	if (src.loc == user)
		playsound(src.loc, "rustle", 50, 1, -5)
		if (user.s_active)
			user.s_active.close(user)
		src.show_to(user)

	else
		return ..()

	src.add_fingerprint(user)

/obj/item/weapon/storage/belt/attackby(obj/item/weapon/W as obj, mob/user as mob)
// Copy pasted from /storage, but removed the wclass check. In time, this could be made to define how many items of the same kind could go on a belt - Abi79

	if(can_hold.len)
		var/ok = 0
		for(var/A in can_hold)
			if(istype(W, text2path(A) )) ok = 1
		if(!ok)
			user << "\red This belt cannot hold [W]."
			return

	if (src.contents.len >= 7)
		return

	if (istype(W, /obj/item/weapon/storage) || src.loc == W)
		return

	user.u_equip(W)
	W.loc = src

	if ((user.client && user.s_active != src))
		user.client.screen -= W

	src.orient2hud(user)
	W.dropped(user)
	add_fingerprint(user)

	for(var/mob/O in viewers(user, null))
		O.show_message(text("\blue [] has added [] to []!", user, W, src), 1)

	return