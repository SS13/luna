/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/device/pda/heads/captain(src)
		new /obj/item/weapon/storage/backpack/captain(src)
		new /obj/item/weapon/gun/energy/gun/newgun(src)
		new /obj/item/weapon/storage/box/id(src)
//		new /obj/item/clothing/suit/captunic(src)
//		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/under/rank/captain/suit(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet/swat(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/gloves/green(src)
		//new /obj/item/clothing/gloves/captain(src)
		return



/obj/structure/closet/secure_closet/hop
	name = "Head of Personnel's locker"
	req_access = list(access_heads)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/device/pda/heads/hop(src)
		new /obj/item/clothing/under/rank/head_of_personnel(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/device/radio/headset/heads/hop(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/storage/box/id(src)
		new /obj/item/weapon/storage/box/id(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/device/flash(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		return



/obj/structure/closet/secure_closet/hos
	name = "Head of Security's locker"
	req_access = list(access_heads)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/security(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/weapon/shield/riot(src)
//		new /obj/item/weapon/storage/lockbox/loyalty(src)
		new /obj/item/weapon/storage/box/grenades/flashbang(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/gun/energy/gun(src)

		new /obj/item/device/pda/heads/hos(src)
		new /obj/item/clothing/under/rank/head_of_security(src)
		new /obj/item/clothing/shoes/jackboots(src)
		new /obj/item/clothing/suit/storage/armor/hos(src)
		new /obj/item/clothing/head/helmet/HoS(src)
		new /obj/item/weapon/storage/box/id(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/clothing/gloves/black(src)
		return



/obj/structure/closet/secure_closet/warden
	name = "Warden's locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"


	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/security(src)
		new /obj/item/clothing/under/rank/warden(src)
		new /obj/item/weapon/clipboard(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/weapon/storage/box/grenades/flashbang(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/device/pda/warden(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/device/flash(src)
		new /obj/item/clothing/shoes/jackboots(src)
		new /obj/item/clothing/suit/warden_jacket(src)
		new /obj/item/clothing/head/helmet/wardencap(src)
		new /obj/item/weapon/storage/box/handcuffs(src)
		new /obj/item/clothing/gloves/black(src)
		return



/obj/structure/closet/secure_closet/security
	name = "Security Officer's locker"
	req_access = list(access_security)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		..()
		sleep(2)
		new /obj/item/device/pda/security(src)
		new /obj/item/weapon/storage/backpack/security(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/suit/storage/gearharness(src)
		new /obj/item/clothing/under/color/red(src)
		new /obj/item/clothing/gloves/red(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/clothing/head/helmet/secsoft(src)
		new /obj/item/clothing/shoes/jackboots(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/spray/pepper(src)
		if(prob(70)) new /obj/item/weapon/grenade/flashbang(src)
		else		 new /obj/item/weapon/storage/box/grenades/flashbang(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		if(prob(60)) new /obj/item/clothing/glasses/sunglasses(src)
		else		 new /obj/item/clothing/glasses/hud/security(src)
		return

/obj/structure/closet/secure_closet/security/cargo

	New()
		..()
		new /obj/item/device/encryptionkey/headset_cargo(src)
		return

/obj/structure/closet/secure_closet/security/engine

	New()
		..()
		new /obj/item/device/encryptionkey/headset_eng(src)
		return

/obj/structure/closet/secure_closet/security/science

	New()
		..()
		new /obj/item/device/encryptionkey/headset_sci(src)
		return

/obj/structure/closet/secure_closet/security/med

	New()
		..()
		new /obj/item/device/encryptionkey/headset_med(src)
		return

/obj/structure/closet/secure_closet/forensics
	name = "forensics locker"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	req_access = list(access_forensics_lockers)

/obj/structure/closet/secure_closet/forensics/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/device/pda/security(src)
	new /obj/item/clothing/under/rank/forensic_technician(src)
	new /obj/item/clothing/suit/storage/gearharness(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/weapon/storage/box/fcard(src)
	new /obj/item/weapon/storage/box/lglo(src)
	new /obj/item/weapon/fcardholder(src)
	new /obj/item/device/detective_scanner(src)
	new /obj/item/weapon/storage/box/evidence(src)
	return

/obj/structure/closet/secure_closet/detective
	name = "Detective's Cabinet"
	req_access = list(access_forensics_lockers)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/det(src)
		new /obj/item/clothing/suit/storage/det_suit(src)
		new /obj/item/device/pda/det(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/det_hat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/storage/box/evidence(src)
		new /obj/item/weapon/clipboard(src)
		new /obj/item/weapon/storage/box/fcard(src)
		new /obj/item/weapon/storage/box/evidence(src)
		new /obj/item/weapon/fcardholder(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/device/detective_scanner(src)
		new /obj/item/ammo_magazine/box/c38(src)
		new /obj/item/ammo_magazine/box/c38(src)
		//new /obj/item/weapon/gun/projectile/detective(src)
		return

/obj/structure/closet/secure_closet/detective/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)	icon_state = icon_locked
			else		icon_state = icon_closed
		else icon_state = icon_opened

/obj/structure/closet/secure_closet/injection
	name = "lethal injections"
	req_access = list(access_captain)

	New()
		..()
		sleep(2)
		new /obj/item/weapon/reagent_containers/syringe/lethal/choral(src)
		new /obj/item/weapon/reagent_containers/syringe/lethal/choral(src)
		new /obj/item/weapon/reagent_containers/syringe/lethal/choral(src)
		new /obj/item/weapon/reagent_containers/syringe/lethal/choral(src)
		new /obj/item/weapon/reagent_containers/syringe/lethal/choral(src)


/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_security)
	anchored = 1
	var/id = null

	New()
		new /obj/item/clothing/under/color/orange(src)
		new /obj/item/clothing/shoes/orange(src)
		return



/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_heads)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/paper/Court(src)
		new /obj/item/weapon/paper/Court(src)
		new /obj/item/weapon/paper/Court(src)
		new /obj/item/weapon/pen(src)
		new /obj/item/clothing/suit/judgerobe(src)
		new /obj/item/clothing/head/powdered_wig(src)
		new /obj/item/clothing/under/lawyer/red(src)
		new /obj/item/clothing/under/lawyer/blue(src)
		new /obj/item/clothing/under/lawyer/black(src)
		new /obj/item/weapon/storage/briefcase(src)
		return

/*obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/wall/update_icon()
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
*/