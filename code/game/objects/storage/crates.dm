/obj/structure/crate
	desc = "A crate."
	name = "Crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	density = 1
	var/openicon = "crateopen"
	var/closedicon = "crate"
	req_access = null
	var/opened = 0
	var/locked = 0
	flags = FPRINT
	m_amt = 7500
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/structure/crate/New()
	..()
	spawn(1)
		if(!opened)		// if closed, any item at the crate's loc is put in the contents
			for(var/obj/item/I in src.loc)
				if(I.density || I.anchored || I == src) continue
				I.loc = src

/obj/structure/crate/proc/open()
	playsound(src.loc, 'click.ogg', 15, 1, -3)

	for(var/obj/O in src)
		O.loc = get_turf(src)
	for(var/mob/M in src)
		M.loc = get_turf(src)

	icon_state = openicon
	src.opened = 1

/obj/structure/crate/proc/close()
	playsound(src.loc, 'click.ogg', 15, 1, -3)
	for(var/obj/O in get_turf(src))
		if(O.density || O.anchored || O == src) continue
		O.loc = src
	icon_state = closedicon
	src.opened = 0

/obj/structure/crate/attack_hand(mob/user as mob)
	if(!locked)
		if(opened) close()
		else open()
	else
		user << "\red It's locked."
	return

/obj/structure/crate/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/structure/crate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return attack_hand(user)
	if(opened)
		user.drop_item()
		W.loc = src.loc
	else return attack_hand(user)

/*
CRATES
*/

/obj/structure/crate/internals
	desc = "A internals crate."
	name = "Internals crate"
	icon_state = "o2crate"
	openicon = "o2crateopen"
	closedicon = "o2crate"

/obj/structure/crate/internals/New()
	..()
	new /obj/item/clothing/mask/gas(src)
	if(prob(50)) new /obj/item/weapon/tank/oxygen(src)
	else new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/air(src)


/obj/structure/crate/medical
	desc = "A medical crate."
	name = "Medical crate"
	icon_state = "medicalcrate"
	openicon = "medicalcrateopen"
	closedicon = "medicalcrate"


/obj/structure/crate/rcd
	desc = "A crate for the storage of the RCD."
	name = "RCD crate"
	icon_state = "crate"
	openicon = "crateopen"
	closedicon = "crate"

/obj/structure/crate/rcd/New()
	..()
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd(src)


/obj/structure/crate/hydro
	desc = "A hydroponical crate."
	name = "Hydroponical crate"
	icon_state = "hydrocrate"
	openicon = "hydrocrateopen"
	closedicon = "hydrocrate"


/obj/structure/crate/engineering
	desc = "A crate for the storage of engineering equipment."
	name = "Engineering crate"
	icon_state = "engi_crate"
	openicon = "engi_crate_open"
	closedicon = "engi_crate"

/obj/structure/crate/engineering/New()
	..()
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/clothing/head/helmet/welding(src)
	new /obj/item/clothing/head/helmet/welding(src)

/obj/structure/crate/freezer
	desc = "A freezer."
	name = "Freezer"
	icon_state = "freezer"
	openicon = "freezeropen"
	closedicon = "freezer"

/obj/structure/crate/freezer/ice/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ice(src)

/obj/structure/crate/bin
	desc = "A large bin."
	name = "Large bin"
	icon_state = "largebin"
	openicon = "largebinopen"
	closedicon = "largebin"



/obj/structure/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	openicon = "securecrateopen"
	closedicon = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	locked = 1
	req_access = list(access_security)

/obj/structure/crate/secure/New()
	..()
	if(locked)
		overlays = null
		overlays += redlight
	else
		overlays = null
		overlays += greenlight

/obj/structure/crate/secure/attack_hand(mob/user as mob)
	if(locked && allowed(user) && !broken)
		user << "\blue You unlock the [src]."
		src.locked = 0
		overlays = null
		overlays += greenlight
	return ..()

/obj/structure/crate/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return attack_hand(user)
	if(istype(W, /obj/item/weapon/card) && src.allowed(user) && !locked && !opened && !broken)
		user << "\red You lock the [src]."
		src.locked = 1
		overlays = null
		overlays += redlight
		return
	else if (istype(W, /obj/item/weapon/card/emag) && locked &&!broken)
		overlays = null
		overlays += emag
		overlays += sparks
		spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
		playsound(src.loc, 'sparks4.ogg', 75, 1)
		src.locked = 0
		src.broken = 1
		user << "\blue You unlock the [src]."
		return

	return ..()



/obj/structure/crate/secure/weapon
	desc = "A secure weapons crate."
	name = "Weapons crate"
	icon_state = "weaponcrate"
	openicon = "weaponcrateopen"
	closedicon = "weaponcrate"

/obj/structure/crate/secure/plasma
	desc = "A secure plasma crate."
	name = "Plasma crate"
	icon_state = "plasmacrate"
	openicon = "plasmacrateopen"
	closedicon = "plasmacrate"
	req_access = list(access_tox)

/obj/structure/crate/secure/gear
	desc = "A secure gear crate."
	name = "Gear crate"
	icon_state = "secgearcrate"
	openicon = "secgearcrateopen"
	closedicon = "secgearcrate"

/obj/structure/crate/secure/bin
	desc = "A secure bin."
	name = "Secure bin"
	icon_state = "largebins"
	openicon = "largebinsopen"
	closedicon = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"