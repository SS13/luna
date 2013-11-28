/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = 1
	density = 1
	directwired = 1
	var/glass_type = /obj/item/stack/sheet/glass
	var/health = 10
	var/id = 1
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH
	var/ndir = SOUTH
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control


/obj/machinery/power/solar/New()
	..()
	spawn(10)
		update_icon()
		update_solar_exposure()


		var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]

		if(Network)
			for(var/obj/machinery/power/solar_control/SC in Network.Nodes)
				control = SC

/obj/machinery/power/solar/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/crowbar))
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 50))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			new /obj/item/weapon/solar_assembly(src.loc)
			new glass_type(src.loc, 2)
			user.visible_message("<span class='notice'>[user] takes the glass off the solar panel.</span>")
			del(src)
		return
	else if (W)
		src.add_fingerprint(user)
		src.health -= W.force
		src.healthcheck()
	..()

/obj/machinery/power/solar/blob_act()
	src.health--
	src.healthcheck()
	return

/obj/machinery/power/solar/proc/healthcheck()
	if (src.health <= 0)
		if(!stat & BROKEN)
			broken()
		else
			new /obj/item/weapon/shard(src.loc)
			del(src)
			return
	return

/obj/machinery/power/solar/update_icon()
	overlays = null
	if(stat & BROKEN)
		overlays += image('power.dmi', icon_state = "solar_panel-b", layer = FLY_LAYER)
	else
		overlays += image('power.dmi', icon_state = "solar_panel", layer = FLY_LAYER)
		src.dir = angle2dir(adir)
	return

/obj/machinery/power/solar/proc/update_solar_exposure()
	if(obscured)
		sunfrac = 0
		return

	var/p_angle = abs((360+adir)%360 - (360+sun.angle)%360)
	if(p_angle > 90)			// if facing more than 90deg from sun, zero output
		sunfrac = 0
		return

	sunfrac = cos(p_angle) ** 2

#define SOLARGENRATE 1500

/obj/machinery/power/solar/process()
	if(stat & BROKEN) return

	var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
	//return //TODO: FIX

	if(Network && !control)
		for(var/obj/machinery/power/solar_control/SC in Network.Nodes)
			control = SC

	if(!obscured)
		var/sgen = SOLARGENRATE * sunfrac
		AddPower(sgen)
		if(Network && control)
			if(control in Network.Nodes) //this line right here...
				control.gen += sgen

	if(adir != ndir)
		spawn(10+rand(0,15))
			adir = (360+adir+dd_range(-10,10,ndir-adir))%360
			update_icon()
			update_solar_exposure()

/obj/machinery/power/solar/proc/broken()
	stat |= BROKEN
	new /obj/item/weapon/shard(src.loc)
	health = 0
	update_icon()
	return

/obj/machinery/power/solar/meteorhit()
	if(stat & !BROKEN)
		broken()
	else
		del(src)

/obj/machinery/power/solar/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			if(prob(15))
				new /obj/item/weapon/shard( src.loc )
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return





/obj/machinery/power/solar_control
	name = "solar panel controller"
	desc = "A controller for solar panel arrays."
	icon = 'computer.dmi'
	icon_state = "solar"
	anchored = 1
	density = 1
	directwired = 1
	var/id = 1
	var/cdir = 0
	var/gen = 0
	var/lastgen = 0
	var/track = 2			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/trackdir = 1		// 0 =CCW, 1=CW
	var/nexttime = 0


/obj/machinery/power/solar_control/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/frame/computer/A = new /obj/structure/frame/computer( src.loc )
				new /obj/item/weapon/shard(src.loc)
				var/obj/item/weapon/circuitboard/computer/solar_control/M = new /obj/item/weapon/circuitboard/computer/solar_control(A)
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/frame/computer/A = new /obj/structure/frame/computer( src.loc )
				var/obj/item/weapon/circuitboard/computer/solar_control/M = new /obj/item/weapon/circuitboard/computer/solar_control(A)
				for(var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/power/solar_control/New()
	..()
	spawn(15)
		var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
		if(!Network) return
		for(var/obj/machinery/power/solar/S in Network.Nodes)
			if(S.id != id) continue
			cdir = S.adir
			update_icon()

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		overlays = null
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		overlays = null
		return

	icon_state = "solar"
	overlays = null
	if(cdir > 0)
		overlays += image('computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir))
	return

/obj/machinery/power/solar_control/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN | NOPOWER)) return

	interact(user)

/obj/machinery/power/solar_control/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN | NOPOWER)) return

	interact(user)

/obj/machinery/power/solar_control/process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	use_power(250)
	if(track==1 && nexttime < world.timeofday && trackrate)
		nexttime = world.timeofday + 3600/abs(trackrate)
		cdir = (cdir+trackrate/abs(trackrate)+360)%360

		set_panels(cdir)
		update_icon()

	src.updateDialog()


// called by solar tracker when sun position changes
/obj/machinery/power/solar_control/proc/tracker_update(var/angle)
	if(track != 2 || stat & (NOPOWER | BROKEN))
		return
	cdir = angle
	set_panels(cdir)
	update_icon()

	src.updateDialog()

/obj/machinery/power/solar_control/interact(mob/user)
	if(stat & (BROKEN | NOPOWER)) return
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/living/silicon/ai))
			user.machine = null
			user << browse(null, "window=solcon")
			return

	add_fingerprint(user)
	user.machine = src

	var/t = "<TT><B>Solar Generator Control</B><HR><PRE>"
	t += "Generated power : [round(lastgen)] W<BR><BR>"
	t += "<B>Orientation</B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR><BR><BR>"

	t += "<BR><HR><BR><BR>"

	t += "Tracking: "
	switch(track)
		if(0)
			t += "<B>Off</B> <A href='?src=\ref[src];track=1'>Timed</A> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <B>Timed</B> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <A href='?src=\ref[src];track=1'>Timed</A> <B>Auto</B><BR>"


	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",5,30,180)]<BR><BR>"
	t += "<A href='?src=\ref[src];close=1'>Close</A></TT>"
	user << browse(t, "window=solcon")
	onclose(user, "solcon")
	return

/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.machine = null
		return
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.machine = null
		return

	if(href_list["dir"])
		cdir = text2num(href_list["dir"])
		spawn(1)
			set_panels(cdir)
			update_icon()

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list["cdir"]))%360)
			spawn(1)
				set_panels(cdir)
				update_icon()
		if(href_list["tdir"])
			src.trackrate = dd_range(-7200,7200,src.trackrate+text2num(href_list["tdir"]))
			if(src.trackrate) nexttime = world.timeofday + 3600/abs(trackrate)

	if(href_list["track"])
		if(src.trackrate) nexttime = world.timeofday + 3600/abs(trackrate)
		track = text2num(href_list["track"])
		if(track == 2)
			var/obj/machinery/power/tracker/T = locate() in world
			if(T)
				cdir = T.sun_angle

	src.updateUsrDialog()
	return

/obj/machinery/power/solar_control/proc/set_panels(var/cdir)
	var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
	if(!Network) return
	for(var/obj/machinery/power/solar/S in Network.Nodes)
		if(S.id != id) continue
		S.control = src
		S.ndir = cdir

/obj/machinery/power/solar_control/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()

/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/power/solar_control/meteorhit()
	broken()
	return

/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return

/obj/machinery/power/solar_control/blob_act()
	if (prob(50))
		broken()
		src.density = 0
