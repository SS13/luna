//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	density = 1
	icon_opened = "crateopen"
	icon_closed = "crate"
	req_access = null
	opened = 0
	flags = FPRINT
//	mouse_drag_pointer = MOUSE_ACTIVE_POINTER	//???

/obj/structure/closet/crate/open()
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)

	for(var/obj/O in src)
		O.loc = get_turf(src)

	icon_state = icon_opened
	src.opened = 1
	return 1

/obj/structure/closet/crate/close()
	playsound(src.loc, 'sound/machines/click.ogg', 15, 1, -3)

	var/itemcount = 0

	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break

		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue

		if(istype(O, /obj/structure/stool/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/stool/bed/B = O
			if(B.buckled_mob)
				continue

		O.loc = src
		itemcount++

	icon_state = icon_closed
	src.opened = 0
	return 1


/obj/structure/closet/crate/fireworks
	name = "Fireworks crate"
/obj/structure/closet/crate/fireworks/New()
	new /obj/item/toy/fire/sparkler(src)
	new /obj/item/toy/fire/sparkler(src)
	new /obj/item/toy/fire/sparkler(src)
	new /obj/item/toy/fire/sparkler(src)
	new /obj/item/toy/fire/sparkler(src)
	new /obj/item/toy/fire/sparkler(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)
	new /obj/item/toy/fire/firework(src)

/obj/structure/closet/crate/internals
	desc = "A internals crate."
	name = "internals crate"
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/internals/New()
	new /obj/item/clothing/mask/gas(src)
	if(prob(50)) new /obj/item/weapon/tank/oxygen(src)
	else new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/air(src)

/obj/structure/closet/crate/internalsoxy
	desc = "A internals crate."
	name = "internals crate"
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/internalsoxy/New()
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/tank/oxygen(src)

/obj/structure/closet/crate/trashcart
	desc = "A heavy, metal trashcart with wheels."
	name = "Trash Cart"
	icon_state = "trashcart"
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "Hat Crate"
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under Nanotrasen's whitelist."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/obj/structure/closet/crate/medical
	desc = "A medical crate."
	name = "medical crate"
	icon_state = "medicalcrate"
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/structure/closet/crate/rcd
	desc = "A crate for the storage of the RCD."
	name = "RCD crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/rcd/New()
	..()
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd(src)

/obj/structure/closet/crate/freezer
	desc = "A freezer."
	name = "freezer"
	icon_state = "freezer"
	icon_opened = "freezeropen"
	icon_closed = "freezer"
	var/target_temp = T0C - 40
	var/cooling_power = 40

	return_air()
		var/datum/gas_mixture/gas = (..())
		if(!gas)	return null
		var/datum/gas_mixture/newgas = new/datum/gas_mixture()
		newgas.oxygen = gas.oxygen
		newgas.carbon_dioxide = gas.carbon_dioxide
		newgas.nitrogen = gas.nitrogen
		newgas.toxins = gas.toxins
		newgas.volume = gas.volume
		newgas.temperature = gas.temperature
		if(newgas.temperature <= target_temp)	return

		if((newgas.temperature - cooling_power) > target_temp)
			newgas.temperature -= cooling_power
		else
			newgas.temperature = target_temp
		return newgas

/obj/structure/closet/crate/freezer/ice/New()
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


/obj/structure/closet/crate/bin
	desc = "A large bin."
	name = "large bin"
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/structure/closet/crate/radiation
	desc = "A crate with a radiation sign on it."
	name = "radioactive gear crate"
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1

/obj/structure/closet/crate/secure/weapon
	desc = "A secure weapons crate."
	name = "weapons crate"
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"

/obj/structure/closet/crate/secure/engineering
	desc = "A crate for the storage of engineering equipment."
	name = "engineering crate"
	icon_state = "engi_secure_crate"
	icon_opened = "engi_secure_crate_open"
	icon_closed = "engi_secure_crate"

/obj/structure/closet/crate/secure/plasma
	desc = "A secure plasma crate."
	name = "plasma crate"
	icon_state = "plasmacrate"
	icon_opened = "plasmacrateopen"
	icon_closed = "plasmacrate"

/obj/structure/closet/crate/secure/gear
	desc = "A secure gear crate."
	name = "Gear crate"
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/secure/hydrosec
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	name = "secure hydroponics crate"
	icon_state = "hydrosecurecrate"
	icon_opened = "hydrosecurecrateopen"
	icon_closed = "hydrosecurecrate"

/obj/structure/closet/crate/secure/bin
	desc = "A secure bin."
	name = "secure bin"
	icon_state = "largebins"
	icon_opened = "largebinsopen"
	icon_closed = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon = 'icons/obj/storage.dmi'
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"

/obj/structure/closet/crate/engineering
	desc = "A crate for the storage of engineering equipment."
	name = "engineering crate"
	icon_state = "engi_crate"
	icon_opened = "engi_crate_open"
	icon_closed = "engi_crate"

/obj/structure/closet/crate/electrical
	desc = "A crate for the storage of electical equipment."
	name = "electrical crate"
	icon_state = "engi_e_crate"
	icon_opened = "engi_e_crate_open"
	icon_closed = "engi_e_crate"

//obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.
/*	name = "Hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon = 'icons/obj/storage.dmi'
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"
	density = 1*/
//	New()
//		..()
//		new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
//		new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
//		new /obj/item/weapon/minihoe(src)
//		new /obj/item/weapon/weedspray(src)
//		new /obj/item/weapon/weedspray(src)
//		new /obj/item/weapon/pestspray(src)
//		new /obj/item/weapon/pestspray(src)
//		new /obj/item/weapon/pestspray(src)


/obj/structure/closet/crate/secure/New()
	..()
	if(locked)
		overlays.Cut()
		overlays += redlight
	else
		overlays.Cut()
		overlays += greenlight


/obj/structure/closet/crate/radiation/New()
	..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)


/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	if(locked && !broken)
		if (allowed(user))
			user << "<span class='notice'>You unlock [src].</span>"
			src.locked = 0
			overlays.Cut()
			overlays += greenlight
			return
		else
			user << "<span class='notice'>[src] is locked.</span>"
			return
	else
		..()

/obj/structure/closet/crate/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card) && src.allowed(user) && !locked && !opened && !broken)
		user << "<span class='notice'>You lock \the [src].</span>"
		src.locked = 1
		overlays.Cut()
		overlays += redlight
		return
	else if(istype(W, /obj/item/device/hacktool) && src.req_access)
		src.req_access = 0
		user << "You reset [src]'s lock."
	else if(istype(W, /obj/item/weapon/card/emag) && !broken)
		overlays.Cut()
		overlays += emag
		overlays += sparks
		spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
		playsound(src.loc, "sparks", 60, 1)
		src.locked = 0
		src.broken = 1
		user << "<span class='notice'>You unlock \the [src].</span>"
		return

	return ..()

/obj/structure/closet/crate/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/structure/closet/crate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opened)
		if(isrobot(user))
			return
		user.drop_item()
		if(W)
			W.loc = src.loc
	/*else if(istype(W, /obj/item/weapon/packageWrap))
		return*/
	else if(istype(W, /obj/item/weapon/cable_coil))
		if(rigged)
			user << "<span class='notice'>[src] is already rigged!</span>"
			return
		user  << "<span class='notice'>You rig [src].</span>"
		user.drop_item()
		del(W)
		rigged = 1
		return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			user  << "<span class='notice'>You attach [W] to [src].</span>"
			user.drop_item()
			W.loc = src
			return
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(rigged)
			user  << "<span class='notice'>You cut away the wiring.</span>"
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else return attack_hand(user)

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(90/severity))
		if(!locked)
			src.locked = 1
			overlays.Cut()
			overlays += redlight
		else
			overlays.Cut()
			overlays += emag
			overlays += sparks
			spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
			src.locked = 0
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access += pick(get_all_accesses())
	..()


/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/O in src.contents)
				del(O)
			del(src)
			return
		if(2.0)
			for(var/obj/O in src.contents)
				if(prob(50))
					del(O)
			del(src)
			return
		if(3.0)
			if (prob(50))
				del(src)
			return
		else
	return
