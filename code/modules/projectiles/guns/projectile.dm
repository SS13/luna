/obj/item/weapon/gun/projectile
	desc = "A gun."
	name = "gun"
	icon_state = "revolver"
	caliber = ".357"
	origin_tech = "combat=2;materials=2"
	w_class = 3.0
	m_amt = 1000

	var/obj/item/ammo_magazine/magazine
	var/obj/item/ammo_casing/chambered
	var/mag_type = /obj/item/ammo_magazine/internal/cylinder


/obj/item/weapon/gun/projectile/New()
	..()
	magazine = new mag_type(src)
	chamber_round()
	update_icon()
	return

/obj/item/weapon/gun/projectile/proc/chamber_round()
	if(chambered || !magazine)
		return 0
	else
		var/obj/item/ammo_casing/round = magazine.get_round()
		if(istype(round))
			chambered = round
			chambered.loc = src
			return 1
	return 0


/obj/item/weapon/gun/projectile/process_chambered()
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(isnull(AC) || !istype(AC))
		return 0
	AC.loc = get_turf(src) //Eject casing onto ground.
	chambered = null
	chamber_round()

	AC.on_fired()

	if(AC.BB)
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		AC.BB = null
		AC.update_icon()
		return 1
	AC.update_icon()
	return 0


/obj/item/weapon/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob, var/show_msg = 1)
	if(istype(A, mag_type) && !magazine)
		user.drop_item()
		magazine = A
		magazine.loc = src
		user << "<span class='notice'>You load a new magazine into \the [src]!</span>"
		chamber_round()
		A.update_icon()
		update_icon()
		return 1

	else if(istype(magazine, /obj/item/ammo_magazine/internal))
		var/num_loaded = 0
		if(istype(A, /obj/item/ammo_magazine))
			var/obj/item/ammo_magazine/AM = A
			for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
				if(magazine.give_round(AC))
					AM.stored_ammo -= AC
					num_loaded++
				else
					AM.update_icon()
					break
		if(istype(A, /obj/item/ammo_casing))
			var/obj/item/ammo_casing/AC = A
			if(magazine.give_round(AC))
				user.drop_item()
				AC.loc = magazine
				num_loaded++
				AC.update_icon()

		if(num_loaded)
			if(show_msg)
				if(num_loaded > 1)
					user << "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>"
				else
					user << "<span class='notice'>You load a shell into \the [src]!</span>"
			update_icon()
			chamber_round()
		return num_loaded


	return 0

/obj/item/weapon/gun/projectile/attack_self(mob/living/user as mob)
	if(istype(magazine, /obj/item/ammo_magazine/external))
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine.update_icon()
		magazine = null
		user << "<span class='notice'>You pull the magazine out of \the [src]!</span>"
	else if(istype(magazine, /obj/item/ammo_magazine/internal))
		var/num_unloaded = 0

		while(get_ammo() > 0)
			var/obj/item/ammo_casing/CB
			CB = magazine.get_round()
			chambered = null
			if(CB && !istype(CB, /obj/item/ammo_casing/none))
				CB.loc = get_turf(src.loc)
				CB.update_icon()
				num_unloaded++

		magazine.on_empty()

		if (num_unloaded > 1)
			user << "<span class = 'notice'>You unload [num_unloaded] shell\s from [src]!</span>"
		else if(num_unloaded == 1)
			user << "<span class = 'notice'>You unload a shell from [src]!</span>"
	update_icon()
	return

/obj/item/weapon/gun/projectile/examine()
	..()
	usr << "Has [get_ammo()] round\s remaining."
	return

/obj/item/weapon/gun/projectile/proc/get_ammo(var/countchambered = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets