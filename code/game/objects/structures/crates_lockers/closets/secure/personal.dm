/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personell. The first card swiped gains control."
	name = "personal closet"
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/New()
	..()
	spawn(2)
		new /obj/item/weapon/storage/backpack(src)
		new /obj/item/device/radio/headset( src )
	return


/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/New()
	..()
	spawn(4)
		contents = list()
		new /obj/item/clothing/under/color/white( src )
		new /obj/item/clothing/shoes/white( src )
	return



/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/personal/cabinet/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/personal/cabinet/New()
	..()
	spawn(4)
		contents = list()
//		new /obj/item/weapon/storage/backpack/satchel/withwallet( src )
		new /obj/item/device/radio/headset( src )
	return

/obj/structure/closet/secure_closet/personal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/weapon/grab))
			src.MouseDrop_T(W:affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W) W.loc = src.loc
	else if(istype(W, /obj/item/weapon/card/id))
		if(src.broken)
			user << "\red It appears to be broken."
			return
		var/obj/item/weapon/card/id/I = W
		if(!I || !I.registered)	return
		if(src.allowed(user) || !src.registered_name || (istype(I) && src.registered_name == I.registered))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !src.locked
			if(src.locked)	src.icon_state = src.icon_locked
			else	src.icon_state = src.icon_closed

			if(!src.registered_name)
				src.registered_name = I.registered
				src.desc = "Owned by [I.registered]."
		else
			user << "\red Access Denied"
	else if(istype(W, /obj/item/device/pda))
		if(src.broken)
			user << "\red It appears to be broken."
			return
		var/obj/item/device/pda/P = W
		if(!P || !P.owner) return

		if(src.allowed(user) || !src.registered_name || (istype(P) && src.registered_name == P.owner))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !src.locked
			if(src.locked)	src.icon_state = src.icon_locked
			else	src.icon_state = src.icon_closed

			if(!src.registered_name)
				src.registered_name = P.owner
				src.desc = "Owned by [P.owner]."
		else
			user << "\red Access Denied"

	else if(istype(W, /obj/item/weapon/card/emag) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
	else
		user << "\red Access Denied"
	return
