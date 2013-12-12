////////////////INTERNAL MAGAZINES//////////////////////
/obj/item/ammo_magazine/internal
	desc = "Oh god, this shouldn't be here!"


/obj/item/ammo_magazine/internal/shot
	name = "pump shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	caliber = ".12"
	max_ammo = 4

/obj/item/ammo_magazine/internal/shotcom
	name = "combat shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = ".12"
	max_ammo = 8

/obj/item/ammo_magazine/internal/cylinder
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = ".357"
	var/cylinders = 7
	max_ammo = 7

	New()
		..()
		check_cylinders()

	give_round(var/obj/item/ammo_casing/r)
		if(istype(r))
			for(var/i = stored_ammo.len, i >= 1, i--)
				if(istype(stored_ammo[i], /obj/item/ammo_casing/none))
					stored_ammo[i] = r
					r.loc = src
					return 1
		return 0

	on_empty()
		check_cylinders()

	proc/check_cylinders()
		var/ecylinders = cylinders - stored_ammo.len
		if(ecylinders)
			for(var/i = 1, i <= ecylinders, i++)
				stored_ammo += new /obj/item/ammo_casing/none()

	ammo_count(var/countempties = 1)
		var/boolets = 0
		for(var/i = 1, i <= stored_ammo.len, i++)
			var/obj/item/ammo_casing/bullet = stored_ammo[i]
			if(!bullet.BB && !countempties)
				continue
			if(istype(bullet, /obj/item/ammo_casing/none))
				continue
			boolets++
		return boolets

	proc/spin()
		var/amt = rand(cylinders*2, cylinders*4)
		for(var/i = 1, i <= amt, i++)
			get_round(1)


/obj/item/ammo_magazine/internal/cylinder/rus357
	name = "russian revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = ".357"
	cylinders = 6
	max_ammo = 1

/obj/item/ammo_magazine/internal/cylinder/rev38
	name = "detective revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c38
	caliber = ".38"
	cylinders = 6
	max_ammo = 6

/obj/item/ammo_magazine/internal/dualshot
	name = "double-barrel shotgun internal magazine" // Yep, this is a cylinder.
	desc = "This doesn't even exist!"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	caliber = ".12"
	max_ammo = 2