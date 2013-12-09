/obj/item/weapon/storage
	icon = 'storage.dmi'
	name = "storage"
	var/list/can_hold = new/list()
	var/obj/effect/screen/storage/boxes = null
	var/obj/effect/screen/close/closer = null
	w_class = 3.0
	flags = FPRINT
	var/foldable = null	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard

/obj/effect/screen/storage/attackby(W, mob/user as mob)
	src.master.attackby(W, user)
	return

/obj/item/weapon/storage/New()
	src.boxes = new /obj/effect/screen/storage(  )
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "block"
	src.boxes.screen_loc = "7,7 to 10,8"
	src.boxes.layer = 19

	src.closer = new /obj/effect/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "x"
	src.closer.layer = 20

	spawn(5)
		src.orient_objs(4, 10, 4, 3)
		//src.orient_objs(7, 8, 10, 7)
		return

	return

// BubbleWrap - A box can be folded up to make card
/obj/item/weapon/storage/attack_self(mob/user as mob)
	if(contents.len) return
	if(!ispath(src.foldable)) return

	var/found = 0
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			src.close(M)
		if (M == user)
			found = 1
	if(!found) return	// User is too far away

	// Now make the cardboard
	user << "\blue You fold \the [src] flat."
	new src.foldable(get_turf(src))
	del(src)
//BubbleWrap END

/obj/item/weapon/storage/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(can_hold.len)
		var/ok = 0
		for(var/A in can_hold)
			if(istype(W, text2path(A) )) ok = 1
		if(!ok)
			user << "\red This container cannot hold [W]."
			return

	if (src.contents.len >= 7) return

	if ((W.w_class >= w_class && !istype(src, /obj/item/weapon/storage/backpack/holding)) || w_class == 1 && W.w_class == 1 || src.loc == W)
		return

//	if(W.w_class >= src.w_class && (istype(W, /obj/item/weapon/storage)))
//		if(!istype(src, /obj/item/weapon/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
//			return //To prevent the stacking of the same sized items.

	user.u_equip(W)
	W.loc = src

	if ((user.client && user.s_active != src))
		user.client.screen -= W

	src.orient2hud(user)
	W.dropped(user)
	add_fingerprint(user)

	if (istype(W, /obj/item/weapon/gun/energy/crossbow)) return //STEALTHY

	for(var/mob/O in viewers(user, null))
		O.show_message(text("\blue [] has added [] to []!", user, W, src), 1)
	return



/*obj/item/weapon/storage/dropped(mob/living/user as mob)
	src.orient_objs(7, 8, 10, 7)
	return*/

/obj/item/weapon/storage/MouseDrop(over_object, src_location, over_location)
	..()
	if (over_object == usr && (in_range(src, usr) || usr.contents.Find(src) ))
		if (usr.s_active)
			usr.s_active.close(usr)
		src.show_to(usr)
	return

/obj/item/weapon/storage/attack_paw(mob/living/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	return src.attack_hand(user)
	return

/obj/item/weapon/storage/attack_hand(mob/living/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	if (src.loc == user && (ismonkey(user) || (user:r_store != src && user:l_store != src)))
		if (user.s_active)
			user.s_active.close(user)
		src.show_to(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
		src.orient2hud(user)
	src.add_fingerprint(user)
	return

/obj/item/weapon/storage/proc/return_inv()

	var/list/L = list()

	L += src.contents

	for(var/obj/item/weapon/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/weapon/gift/G in src)
		L += G.gift
		if (istype(G.gift, /obj/item/weapon/storage))
			L += G.gift:return_inv()
	return L

/obj/item/weapon/storage/proc/show_to(mob/living/user as mob)
	if(!user.client) return

	for(var/obj/item/device/assembly/mousetrap/MT in src)
		if(MT.armed)
			for(var/mob/O in viewers(user, null))
				if(O == user)
					user.show_message(text("\red <B>You reach into the [src.name], but there was a live mousetrap in there!</B>"), 1)
				else
					user.show_message(text("\red <B>[user] reaches into the [src.name] and sets off a hidden mousetrap!</B>"), 1)
			MT.loc = user.loc
			MT.triggered(user, user.hand ? "l_hand" : "r_hand")
			MT.layer = OBJ_LAYER
			return


	if(ishuman(user))
		for(var/obj/item/device/assembly_holder/AH in list(user:l_store, user:r_store))
			var/obj/item/device/assembly/mousetrap/MT
			if(istype(AH.a_left, /obj/item/device/assembly/mousetrap) && AH.a_left:armed)
				MT = AH.a_left
			else if(istype(AH.a_right, /obj/item/device/assembly/mousetrap) && AH.a_right:armed)
				MT = AH.a_right

			if(MT)
				for(var/mob/O in viewers(user, null))
					if(O == user)
						user.show_message(text("\red <B>You reach into the [src.name], but there was a live mousetrap in there!</B>"), 1)
					else
						user.show_message(text("\red <B>[user] reaches into the [src.name] and sets off a hidden mousetrap!</B>"), 1)
				AH.loc = user.loc
				MT.triggered(user, user.hand ? "l_hand" : "r_hand")
				AH.layer = OBJ_LAYER
				return

	hide_from(user)

	user.client.screen += src.boxes
	user.client.screen += src.closer
	user.client.screen += src.contents
	user.s_active = src
	return

/obj/item/weapon/storage/proc/hide_from(mob/user as mob)
	if(!user.client) return

	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	return

/obj/item/weapon/storage/proc/close(mob/user as mob)

	src.hide_from(user)
	user.s_active = null
	return

/obj/item/weapon/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty

	src.boxes.screen_loc = text("[],[] to [],[]", tx, ty, mx, my)
	for(var/obj/O in src.contents)
		O.screen_loc = text("[],[]", cx, cy)
		O.layer = 20
		cx++
		if (cx > mx)
			cx = tx
			cy--
	src.closer.screen_loc = text("[mx],[my]")
	return

/obj/item/weapon/storage/proc/orient2hud(mob/user as mob)
	if (src == user.l_hand)
		src.orient_objs(3, 11, 3, 4)

	else if (src == user.r_hand)
		src.orient_objs(1, 11, 1, 4)

	else if (src == user.back)
		src.orient_objs(4, 10, 4, 3)
	else
		src.orient_objs(4, 10, 4, 3)
	return