/obj/structure/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'structures.dmi'
	icon_state = "lattice"
	density = 0
	anchored = 1.0
	layer = 2

/obj/structure/lattice/blob_act()
	if(prob(75))
		del(src)
		return

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/weapon/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/metal))
		C:build(get_turf(src))
		C:amount--
		playsound(src.loc, 'Genhit.ogg', 50, 1)
		C.add_fingerprint(user)

		if (C:amount < 1)
			user.u_equip(C)
			del(C)
		del(src)
		return
	if (istype(C, /obj/item/weapon/weldingtool) && C:welding)
		user << "\blue Slicing lattice joints ..."
		C:eyecheck(user)
		new /obj/item/stack/rods(src.loc)
		del(src)

	return
