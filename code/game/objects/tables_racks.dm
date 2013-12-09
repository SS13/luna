/obj/structure/table
	name = "table"
	icon = 'structures.dmi'
	icon_state = "table"
	density = 1
	layer = 2.8
	anchored = 1.0
	throwpass = 1

/obj/structure/table/reinforced
	name = "reinforced table"
	icon_state = "reinf_table"
	var/status = 2

/obj/structure/table/woodentable
	name = "wooden table"
	icon_state = "wood_table"

/obj/structure/table/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if(prob(50))
				del(src)
				return
		if(3.0)
			if(prob(25))
				new /obj/item/weapon/table_parts( src.loc )
				del(src)
	return

/obj/structure/table/blob_act()
	if(prob(50))
		new /obj/item/weapon/table_parts( src.loc )
		del(src)

/obj/structure/table/hand_p(mob/user as mob)

	return src.attack_paw(user)
	return

/obj/structure/table/attack_paw(mob/user as mob)
	if (HULK in usr.mutations)
		usr << text("\blue You destroy the table.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] destroys the table.", usr)
		if(istype(src, /obj/structure/table/reinforced))
			new /obj/item/weapon/table_parts/reinforced( src.loc )
		else
			new /obj/item/weapon/table_parts( src.loc )
		src.density = 0
		del(src)
	if (!( locate(/obj/structure/table, user.loc) ))
		step(user, get_dir(user, src))
		if (user.loc == src.loc)
			user.layer = TURF_LAYER
			for(var/mob/M in viewers(user, null))
				M.show_message("The monkey hides under the table!", 1)
	return

/obj/structure/table/attack_alien(mob/user as mob)
	if(istype(user, /mob/living/carbon/alien/larva))
		if (!( locate(/obj/structure/table, user.loc) ))
			step(user, get_dir(user, src))
			if (user.loc == src.loc)
				user.layer = TURF_LAYER
				for(var/mob/M in viewers(user, null))
					M.show_message("The alien larva hides under the table!", 1)
	return

/obj/structure/table/attack_hand(mob/user as mob)
	if (HULK in usr.mutations)
		usr << text("\blue You destroy the table.")
		for(var/mob/O in oviewers())
			if (O.client && !O.blinded)
				O << text("\red [] destroys the table.", usr)
		if(istype(src, /obj/structure/table/reinforced))
			new /obj/item/weapon/table_parts/reinforced( src.loc )
		else
			new /obj/item/weapon/table_parts( src.loc )
		src.density = 0
		del(src)
	if (mSmallsize in usr.mutations)
		step(user, get_dir(user, src))
		if (user.loc == src.loc)
			user.layer = TURF_LAYER
			for(var/mob/M in viewers(user, null))
				M.show_message("The person hides under the table!", 1)
	return



/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if (mover.pass_flags & PASSTABLE)
		return 1
	else
		return 0

/obj/structure/table/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item/weapon) ) || user.equipped() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/table/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		G.affecting.weakened = 5
		for(var/mob/O in viewers(world.view, src))
			if (O.client)
				O << text("\red [] puts [] on the table.", G.assailant, G.affecting)
		G.affecting.loc = src.loc
		del(W)
		return

	if (istype(W, /obj/item/weapon/wrench))
		user << "\blue Now disassembling table"
		playsound(src.loc, 'Ratchet.ogg', 50, 1)
		var/T = user.loc
		sleep(50)
		if(!(user.loc == T && user.equipped() == W)) //if they moved away or lost the wrench STOP
			return
		new /obj/item/weapon/table_parts( src.loc )
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		//SN src = null
		del(src)
		return
	user.drop_item()
	if(W && W.loc && !W.is_module)	W.loc = src.loc
	return

/obj/structure/table/reinforced/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		G.affecting.loc = src.loc
		G.affecting.weakened = 5
		for(var/mob/O in viewers(world.view, src))
			if (O.client)
				O << text("\red [] puts [] on the reinforced table.", G.assailant, G.affecting)
		del(W)
		return

	if (istype(W, /obj/item/weapon/weldingtool))
		if(src.status == 2)
			user << "\blue Now weakening the reinforced table"
			playsound(src.loc, 'Welder.ogg', 50, 1)
			sleep(50)
			user << "\blue Table weakened"
			src.status = 1
		else
			user << "\blue Now strengthening the reinforced table"
			playsound(src.loc, 'Welder.ogg', 50, 1)
			sleep(50)
			user << "\blue Table strengthened"
			src.status = 2
		return

	if (istype(W, /obj/item/weapon/wrench))
		if(src.status == 1)
			user << "\blue Now disassembling the reinforced table"
			playsound(src.loc, 'Ratchet.ogg', 50, 1)
			sleep(50)
			new /obj/item/weapon/table_parts/reinforced( src.loc )
			playsound(src.loc, 'Deconstruct.ogg', 50, 1)
			del(src)
			return
	user.drop_item()
	if(W && W.loc && !W.is_module)	W.loc = src.loc
	return

/obj/structure/table/woodentable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		G.affecting.loc = src.loc
		G.affecting.weakened = 5
		for(var/mob/O in viewers(world.view, src))
			if (O.client)
				O << text("\red [] puts [] on the table.", G.assailant, G.affecting)
		del(W)
		return

	if (istype(W, /obj/item/weapon/wrench))
		user << "\blue Now disassembling table"
		playsound(src.loc, 'Ratchet.ogg', 50, 1)
		var/T = user.loc
		sleep(50)
		if(!(user.loc == T && user.equipped() == W)) //if they moved away or lost the wrench STOP
			return
		new /obj/item/weapon/table_parts/wood( src.loc )
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		del(src)
		return
	user.drop_item()
	if(W && W.loc && !W.is_module)	W.loc = src.loc
	return






/obj/structure/rack
	name = "rack"
	icon = 'objects.dmi'
	icon_state = "rack"
	density = 1
	layer = 2.8
	flags = FPRINT
	anchored = 1.0

/obj/structure/rack/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.icon_state = "rackbroken"
				src.density = 0
		else
	return

/obj/structure/rack/blob_act()
	if(prob(50))
		del(src)
		return
	else if(prob(50))
		src.icon_state = "rackbroken"
		src.density = 0
		return

/obj/structure/rack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if (mover.pass_flags & PASSTABLE)
		return 1
	else
		return 0

/obj/structure/rack/MouseDrop_T(obj/O as obj, mob/user as mob)
	if ((!( istype(O, /obj/item/weapon) ) || user.equipped() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/rack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/weapon/rack_parts( src.loc )
		playsound(src.loc, 'Ratchet.ogg', 50, 1)
		//SN src = null
		del(src)
		return
	user.drop_item()
	if(W && W.loc && !W.is_module)	W.loc = src.loc
	return

/obj/structure/rack/meteorhit(obj/O as obj)
	if(prob(75))
		del(src)
		return
	else
		src.icon_state = "rackbroken"
		src.density = 0
	return