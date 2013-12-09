/obj/item/device/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	var/status = 1.0
	flags = FPRINT | CONDUCT
	item_state = "electronic"
	m_amt = 100
	throwforce = 5
	w_class = 1.0
	throw_speed = 3
	throw_range = 10

/obj/item/device/igniter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/device/radio/signaler) && !( src.status )))
		var/obj/item/device/radio/signaler/S = W
		if (!( S.b_stat ))
			return
		var/obj/item/assembly/rad_ignite/R = new /obj/item/assembly/rad_ignite( user )
		S.loc = R
		R.part1 = S
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/device/prox_sensor) && !( src.status )))

		var/obj/item/assembly/prox_ignite/R = new /obj/item/assembly/prox_ignite( user )
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/device/timer) && !( src.status )))

		var/obj/item/assembly/time_ignite/R = new /obj/item/assembly/time_ignite( user )
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)

	else if ((istype(W, /obj/item/device/healthanalyzer) && !( src.status )))
		var/obj/item/assembly/anal_ignite/R = new /obj/item/assembly/anal_ignite( user ) // Hehehe anal ingiter. Butthurter?
		W.loc = R
		R.part1 = W
		W.layer = initial(W.layer)
		if (user.client)
			user.client.screen -= W
		if (user.r_hand == W)
			user.u_equip(W)
			user.r_hand = R
		else
			user.u_equip(W)
			user.l_hand = R
		W.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.part2 = src
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)

	if (!( istype(W, /obj/item/weapon/screwdriver) ))
		return
	src.status = !( src.status )
	if (src.status)
		user.show_message("\blue The igniter is ready!")
	else
		user.show_message("\blue The igniter can now be attached!")
	src.add_fingerprint(user)
	return

/obj/item/device/igniter/attack_self(mob/user as mob)

	src.add_fingerprint(user)
	spawn( 5 )
		ignite()
		return
	return

/obj/item/device/igniter/proc/ignite()
	if (src.status)
		var/turf/location = src.loc

		if (src.master)
			location = src.master.loc

		location = get_turf(location)
		if(location)
			location.hotspot_expose(1000,1000)

	return

/obj/item/device/igniter/examine()
	set src in view()

	..()
	if ((in_range(src, usr) || src.loc == usr))
		if (src.status)
			usr.show_message("The igniter is ready!")
		else
			usr.show_message("The igniter can be attached!")
	return
