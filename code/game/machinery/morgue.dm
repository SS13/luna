/obj/structure/morgue
	name = "morgue"
	icon = 'stationobjs.dmi'
	icon_state = "morgue1"
	density = 1
	var/obj/structure/m_tray/connected = null
	anchored = 1.0

/obj/structure/morgue/proc/update()
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (src.contents.len)
			src.icon_state = "morgue2"
		else
			src.icon_state = "morgue1"
	return

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
	return

/obj/structure/morgue/alter_health()
	return src.loc

/obj/structure/morgue/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/morgue/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.loc = src
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		//src.connected = null
		del(src.connected)
	else
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/m_tray( src.loc )
		step(src.connected, EAST)
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, EAST)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "morgue0"
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.connected.loc
			src.connected.icon_state = "morguet"
		else
			//src.connected = null
			del(src.connected)
	src.add_fingerprint(user)
	update()
	return

/obj/structure/morgue/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.equipped() != P)
			return
		if ((!in_range(src, usr) && src.loc != user))
			return
		t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
		if (t)
			src.name = text("Morgue- '[]'", t)
		else
			src.name = "Morgue"
	src.add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.connected = new /obj/structure/m_tray( src.loc )
	step(src.connected, EAST)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.connected.loc
			//Foreach goto(106)
		src.connected.icon_state = "morguet"
	else
		//src.connected = null
		del(src.connected)
	return



/obj/structure/m_tray
	name = "morgue tray"
	icon = 'stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = 2.0
	var/obj/structure/morgue/connected = null
	anchored = 1.0

/obj/structure/m_tray/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/item/weapon/dummy))
		return 1
	else
		return ..()

/obj/structure/m_tray/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.loc = src.connected
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		del(src)
		return
	return

/obj/structure/m_tray/MouseDrop_T(mob/O, mob/user)
	if (!istype(O) || O.buckled || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
		return
	O.loc = src.loc
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				B << text("\red [] stuffs [] into []!", user, O, src)
	return




/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator."
	icon = 'stationobjs.dmi'
	icon_state = "crema1"
	density = 1
	var/obj/structure/c_tray/connected = null
	anchored = 1.0
	var/cremating = 0
	var/id = 1
	var/locked = 0


/obj/structure/crematorium/proc/update()
	if (src.connected)
		src.icon_state = "crema0"
	else
		if (src.contents.len)
			src.icon_state = "crema2"
		else
			src.icon_state = "crema1"
	return

/obj/structure/crematorium/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
	return

/obj/structure/crematorium/alter_health()
	return src.loc

/obj/structure/crematorium/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/crematorium/attack_hand(mob/user as mob)
	if (cremating)
		usr << "\red It's locked."
		return
	if ((src.connected) && (src.locked == 0))
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.loc = src
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		del(src.connected)
	else if (src.locked == 0)
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/c_tray( src.loc )
		step(src.connected, SOUTH)
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, SOUTH)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.connected.loc
			src.connected.icon_state = "cremat"
		else
			del(src.connected)
	src.add_fingerprint(user)
	update()

/obj/structure/crematorium/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.equipped() != P)
			return
		if ((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
		if (t)
			src.name = text("Crematorium- '[]'", t)
		else
			src.name = "Crematorium"
	src.add_fingerprint(user)
	return

/obj/structure/crematorium/relaymove(mob/user as mob)
	if (user.stat || locked)
		return
	src.connected = new /obj/structure/c_tray( src.loc )
	step(src.connected, SOUTH)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, SOUTH)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "crema0"
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.connected.loc
		src.connected.icon_state = "cremat"
	else
		del(src.connected)
	return

/obj/structure/crematorium/proc/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(length(contents) == 0)
		for (var/mob/M in viewers(user))
			M.show_message("\red You hear a hollow crackle.", 1)
			return
	else if(contents)
		cremating = 1
		locked = 1
		var/mob/dead/observer/newmob
		for (var/M in contents)
			if (istype(M,/mob/living) && M:client)
				var/i
				M:stunned = 100 //You really dont want to place this inside the loop.

				newmob = new/mob/dead/observer(M)
				M:client:mob = newmob

				for(i=0, i<10, i++)
					sleep(10)
					M:fireloss += 30
				var/obj/item/weapon/urn/U = new(M:loc)
				U.name += " - " + M:real_name
				U.desc = "This contains the ashes of " + M:real_name + "."

				if(M:mind)
					M:mind.transfer_to(newmob)
				for (var/obj/item/weapon/W in M)
					if (prob(10))
						W.loc = M:loc
				del(M)
			else if (istype(M,/mob/living))
				spawn(0)
					var/i
					M:stunned = 100
					for(i=0, i<10, i++)
						sleep(10)
						M:fireloss += 50
					var/obj/item/weapon/urn/U = new(M:loc)
					U.name += " - " + M:real_name
					U.desc = "This contains the ashes of " + M:real_name + "."
					for (var/obj/item/weapon/W in M)
						if (prob(10))
							W.loc = M:loc
					del(M)
		for (var/mob/M in viewers(user))
			M.show_message("\red You hear a roar as the crematorium activates.", 1)
		spawn(100)
			cremating = 0
			locked = 0
			playsound(src.loc, 'ding.ogg', 50, 1)
	return


/obj/structure/c_tray
	name = "crematorium tray"
	icon = 'stationobjs.dmi'
	icon_state = "cremat"
	density = 1
	layer = 2.0
	var/obj/structure/crematorium/connected = null
	anchored = 1.0

/obj/structure/c_tray/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover, /obj/item/weapon/dummy))
		return 1
	else
		return ..()

/obj/structure/c_tray/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/c_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.loc = src.connected
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		del(src)
		return
	return

/obj/structure/c_tray/MouseDrop_T(mob/O, mob/user)
	if (!istype(O) || O.buckled || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
		return
	O.loc = src.loc
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				B << text("\red [] stuffs [] into []!", user, O, src)
	return

/obj/machinery/crema_switch/attack_hand(mob/user as mob)
	if(src.allowed(usr))
		for (var/obj/structure/crematorium/C in world)
			if (C.id == id)
				if (!C.cremating)
					C.cremate(user)
	else
		usr << "\red Access denied."
	return

