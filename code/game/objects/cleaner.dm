/obj/structure/mopbucket
	desc = "Fill it with water, but don't forget a mop!"
	name = "mop bucket"
	icon = 'janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	pressure_resistance = ONE_ATMOSPHERE
	flags = FPRINT | OPENCONTAINER

/obj/structure/mopbucket/New()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src


/obj/structure/mopbucket/examine()
	..()
	usr << text("\icon[src] [src.name] contains [src.reagents.total_volume] units of water left!")

/obj/structure/mopbucket/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/mop))
		if (src.reagents.total_volume >= 2)
			src.reagents.trans_to(W, 2)
			user << "\blue You wet the mop"
			playsound(src.loc, 'slosh.ogg', 25, 1)
		if (src.reagents.total_volume < 1)
			user << "\blue Out of water!"
	return

/obj/structure/mopbucket/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return

/obj/structure/mopbucket/tunderdome
	name = "lube mop bucket"
	anchored = 1
	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		reagents.add_reagent("lube", 100)