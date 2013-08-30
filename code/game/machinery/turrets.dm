/*area/turret_protected
	name = "Turret Protected Area"
	var/list/turretTargets = list()

/area/turret_protected/proc/subjectDied(target)
	if (istype(target, /mob))
		if (!istype(target, /mob/living/silicon))
			if (target:stat==2)
				if (target in turretTargets)
					src.Exited(target)


/area/turret_protected/Entered(O)
	..()
	if (istype(O, /mob))
		if (!istype(O, /mob/living/silicon))
			if (!(O in turretTargets))
				turretTargets += O
	return 1

/area/turret_protected/Exited(O)
	if (istype(O, /mob))
		if (!istype(O, /mob/living/silicon))
			if (O in turretTargets)
				//O << "removing you from target list"
				turretTargets -= O
			//else
				//O << "You aren't in our target list!"
			if (turretTargets.len == 0)
				popDownTurrets()

	return 1

/area/turret_protected/proc/popDownTurrets()
	for (var/obj/machinery/turret/aTurret in src)
		aTurret.popDown()

/obj/machinery/turret
	name = "turret"
	icon = 'turrets.dmi'
	icon_state = "grey_target_prism"
	anchored = 1
	density = 1
	invisibility = 2
	layer = 3
	var/obj/machinery/turretcover/cover = null
	var/enabled = 1
	var/health = 80
	var/id = ""
	var/lasers = 0
	var/popping = 0
	var/raised = 0
	var/wasvalid = 0

	var/lastfired = 0
	var/shot_delay = 30 //3 seconds between shots

/obj/machinery/turretcover
	name = "pop-up turret cover"
	icon = 'turrets.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = 3.5
	density = 0

/obj/machinery/turret/proc/isPopping()
	return (popping!=0)

/obj/machinery/turret/power_change()
	if(stat & BROKEN)
		icon_state = "grey_target_prism"
	else
		if( powered() )
			if (src.enabled)
				if (src.lasers)
					icon_state = "orange_target_prism"
				else
					icon_state = "target_prism"
			else
				icon_state = "grey_target_prism"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "grey_target_prism"
				stat |= NOPOWER

/obj/machinery/turret/proc/setState(var/enabled, var/lethal)
	src.enabled = enabled
	src.lasers = lethal
	src.power_change()

/obj/machinery/turret/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(lastfired && world.time - lastfired < shot_delay)
		return
	lastfired = world.time
	if (src.cover==null)
		src.cover = new /obj/machinery/turretcover(src.loc)
	use_power(50)
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		world << text("Badly positioned turret - loc.loc is [].", loc)
		return
	var/area/area = loc
	if (istype(area, /area))
		if (istype(loc, /area/turret_protected))
			src.wasvalid = 1
			var/area/turret_protected/tarea = loc

			if (tarea.turretTargets.len>0)
				if (!isPopping())
					if (isDown())
						popUp()
					else
						var/mob/target = pick(tarea.turretTargets)
						src.dir = get_dir(src, target)
						if (src.enabled)
							if (istype(target, /mob/living))
								if (target.stat!=2)
									src.shootAt(target)
								else
									tarea.subjectDied(target)

		else
			if (src.wasvalid)
				src.die()
			/*else
				world << text("ERROR: Turret at [x], [y], [z] is NOT in a turret-protected area!")*/

/obj/machinery/turret/proc/isDown()
	return (invisibility!=0)

/obj/machinery/turret/proc/popUp()
	if ((!isPopping()) || src.popping==-1)
		invisibility = 0
		popping = 1
		if (src.cover!=null)
			flick("popup", src.cover)
			src.cover.icon_state = "openTurretCover"
		spawn(10)
			if (popping==1) popping = 0

/obj/machinery/turret/proc/popDown()
	if ((!isPopping()) || src.popping==1)
		popping = -1
		if (src.cover!=null)
			flick("popdown", src.cover)
			src.cover.icon_state = "turretCover"
		spawn(10)
			if (popping==-1)
				invisibility = 2
				popping = 0

/obj/machinery/turret/proc/shootAt(var/mob/target)
	var/turf/T = loc
	var/atom/U = (istype(target, /atom/movable) ? target.loc : target)
	if ((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if (!( istype(T, /turf) ))
		return

	var/obj/beam/a_laser/A
	if (src.lasers)
		A = new /obj/beam/a_laser( loc )
		use_power(50)
	else
		A = new /obj/bullet/electrode( loc )
		use_power(100)

	if (!( istype(U, /turf) ))
		//A = null
		del(A)
		return
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.process()
		return
	return

/obj/machinery/turret/bullet_act(var/obj/item/projectile/Proj)
	src.health -= Proj.damage
	..()
	if(prob(45) && Proj.damage > 0) src.spark_system.start()
	del (Proj)
	if (src.health <= 0)
		src.die()
	return


/obj/machinery/turret/ex_act(severity)
	if(severity < 3)
		src.die()

/obj/machinery/turret/proc/die()
	src.health = 0
	src.density = 0
	src.stat |= BROKEN
	src.icon_state = "destroyed_target_prism"
	if (cover!=null)
		del(cover)
	sleep(3)
	flick("explosion", src)
	spawn(13)
		del(src)

/obj/machinery/turretid
	name = "Turret deactivation control"
	icon = 'device.dmi'
	icon_state = "motion3"
	anchored = 1
	density = 0
	req_access = list(access_ai_upload)
	var/enabled = 1
	var/id = ""
	var/lethal = 0
	var/locked = 1
	var/similar_controls
	var/turrets

/obj/machinery/turretid/east
	pixel_x = 28

/obj/machinery/turretid/south
	pixel_y = -28

/obj/machinery/turretid/west
	pixel_x = -28

/obj/machinery/turretid/north
	pixel_y = 28

/obj/machinery/turretid/New()
	..()
	spawn(10)		// allow map load
		turrets = list()
		for(var/obj/machinery/turret/T in world)
			if(T.id == id)
				turrets += T

		similar_controls = list() // On modifying a control, all the similar controls should change their icon_state as well
		for(var/obj/machinery/turretid/TC in world)
			if(TC.id == id && TC != src)
				similar_controls += TC

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)
	else // trying to unlock the interface
		if (src.allowed(usr))
			locked = !locked
			user << "You [ locked ? "lock" : "unlock"] the panel."
			if (locked)
				if (user.machine==src)
					user.machine = null
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(usr)
		else
			user << "\red Access denied."

/obj/machinery/turretid/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/living/silicon))
			user << text("Too far away.")
			user.machine = null
			user << browse(null, "window=turretid")
			return

	user.machine = src
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = "<TT><B>Turret Control Panel</B> ([area.name])<HR>"

	if(src.locked && (!istype(user, /mob/living/silicon)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	user << browse(t, "window=turretid")
	onclose(user, "turretid")

/obj/machinery/turretid/Topic(href, href_list)
	..()
	if (src.locked)
		if (!istype(usr, /mob/living/silicon))
			usr << "Control panel is locked!"
			return
	if (href_list["toggleOn"])
		src.enabled = !src.enabled
		src.updateTurrets()
	else if (href_list["toggleLethal"])
		src.lethal = !src.lethal
		src.updateTurrets()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if (src.enabled)
		if (src.lethal)
			src.icon_state = "motion1"
			for(var/obj/machinery/turretid/TC in src.similar_controls) //Change every similar control's icon as well
				TC.icon_state = "motion1"
		else
			src.icon_state = "motion3"
			for(var/obj/machinery/turretid/TC in src.similar_controls)
				TC.icon_state = "motion3"
	else
		src.icon_state = "motion0"
		for(var/obj/machinery/turretid/TC in src.similar_controls)
			TC.icon_state = "motion0"

	for (var/obj/machinery/turret/aTurret in turrets)
		aTurret.setState(enabled, lethal)*/


/area/turret_protected
	name = "Turret Protected Area"
	var/list/turretTargets = list()

/area/turret_protected/proc/subjectDied(target)
	if( isliving(target) )
		if( !issilicon(target) )
			var/mob/living/L = target
			if( L.stat )
				if( L in turretTargets )
					src.Exited(L)


/area/turret_protected/Entered(O)
	..()
	if( master && master != src )
		return master.Entered(O)

	if( iscarbon(O) )
		turretTargets |= O
	else if( istype(O, /obj/mecha) )
		var/obj/mecha/Mech = O
		if( Mech.occupant )
			turretTargets |= Mech
//	else if(istype(O,/mob/living/simple_animal))
//		turretTargets |= O
	return 1

/area/turret_protected/Exited(O)
	if( master && master != src )
		return master.Exited(O)

	if( ismob(O) && !issilicon(O) )
		turretTargets -= O
	else if( istype(O, /obj/mecha) )
		turretTargets -= O
	..()
	return 1


/obj/machinery/turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "grey_target_prism"
	var/raised = 0
	var/enabled = 1
	var/id = 0
	anchored = 1
	layer = 3
	invisibility = INVISIBILITY_LEVEL_TWO
	density = 1
	var/lasers = 0
	var/lasertype = 1
		// 1 = lasers
		// 2 = cannons
		// 3 = pulse
		// 4 = change (HONK)
	var/health = 80
	var/obj/machinery/turretcover/cover = null
	var/popping = 0
	var/wasvalid = 0
	var/lastfired = 0
	var/shot_delay = 30 //3 seconds between shots
	var/datum/effect/effect/system/spark_spread/spark_system
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300
//	var/list/targets
	var/atom/movable/cur_target
	var/targeting_active = 0
	var/area/turret_protected/protected_area


/obj/machinery/turret/New()
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
//	targets = new
	..()
	return

/obj/machinery/turretcover
	name = "pop-up turret cover"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = 3.5
	density = 0
	var/obj/machinery/turret/host = null

/obj/machinery/turret/proc/isPopping()
	return (popping!=0)

/obj/machinery/turret/power_change()
	if(stat & BROKEN)
		icon_state = "grey_target_prism"
	else
		if( powered() )
			if (src.enabled)
				if (src.lasers)
					icon_state = "orange_target_prism"
				else
					icon_state = "target_prism"
			else
				icon_state = "grey_target_prism"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "grey_target_prism"
				stat |= NOPOWER

/obj/machinery/turret/proc/setState(var/enabled, var/lethal)
	src.enabled = enabled
	src.lasers = lethal
	src.power_change()


/obj/machinery/turret/proc/get_protected_area()
	var/area/turret_protected/TP = get_area(src)
	if(istype(TP))
		if(TP.master && TP.master != TP)
			TP = TP.master
		return TP
	return

/obj/machinery/turret/proc/check_target(var/atom/movable/T as mob|obj)
	if( T && T in protected_area.turretTargets )
		var/area/area_T = get_area(T)
		if( !area_T || (area_T.type != protected_area.type) )
			protected_area.Exited(T)
			return 0 //If the guy is somehow not in the turret's area (teleportation), get them out the damn list. --NEO

		var/turf/turf_T = get_turf(T)
		if(turf_T.density) return 0 //Not shooting people in walls

		if( iscarbon(T) )
			var/mob/living/carbon/MC = T
			if(!MC.stat)
				if(!MC.lying || lasers)
					return 1
		else if( istype(T, /obj/mecha) )
			var/obj/mecha/ME = T
			if( ME.occupant )
				return 1
//		else if(istype(T,/mob/living/simple_animal))
//			var/mob/living/simple_animal/A = T
//			if( !A.stat )
//				if(lasers)
//					return 1
	return 0

/obj/machinery/turret/proc/get_new_target()
	var/list/new_targets = new
	var/new_target
	for(var/mob/living/carbon/M in protected_area.turretTargets)
		if(!M.stat)
			if(!M.lying || lasers)
				new_targets += M
	for(var/obj/mecha/M in protected_area.turretTargets)
		if(M.occupant)
			new_targets += M
//	for(var/mob/living/simple_animal/M in protected_area.turretTargets)
//		if(!M.stat)
//			new_targets += M
	if(new_targets.len)
		new_target = pick(new_targets)
	return new_target


/obj/machinery/turret/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(src.cover==null)
		src.cover = new /obj/machinery/turretcover(src.loc)
		src.cover.host = src
	protected_area = get_protected_area()
	if(!enabled || !protected_area || protected_area.turretTargets.len<=0)
		if(!isDown() && !isPopping())
			popDown()
		return
	if(!check_target(cur_target)) //if current target fails target check
		cur_target = get_new_target() //get new target

	if(cur_target) //if it's found, proceed
//		world << "[cur_target]"
		if(!isPopping())
			if(isDown())
				popUp()
				use_power = 2
			else
				spawn()
					if(!targeting_active)
						targeting_active = 1
						target()
						targeting_active = 0
	else if(!isPopping())//else, pop down
		if(!isDown())
			popDown()
			use_power = 1
	return


/obj/machinery/turret/proc/target()
	while(src && enabled && !stat && check_target(cur_target))
		src.dir = get_dir(src, cur_target)
		shootAt(cur_target)
		sleep(shot_delay)
	return

/obj/machinery/turret/proc/shootAt(var/atom/movable/target)
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if (!T || !U)
		return
	var/obj/item/projectile/A
	if (src.lasers)
		switch(lasertype)
			if(1)
				A = new /obj/item/projectile/beam( loc )
			if(2)
				A = new /obj/item/projectile/beam/heavylaser( loc )
			if(3)
				A = new /obj/item/projectile/beam/pulse( loc )
//			if(4)
//				A = new /obj/item/projectile/change( loc )
//			if(5)
//				A = new /obj/item/projectile/bluetag( loc )
//			if(6)
//				A = new /obj/item/projectile/redtag( loc )
		A.original = target
		use_power(500)
	else
		A = new /obj/item/projectile/energy/electrode( loc )
		use_power(200)
	A.current = T
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.process()
	return


/obj/machinery/turret/proc/isDown()
	return (invisibility!=0)

/obj/machinery/turret/proc/popUp()
	if ((!isPopping()) || src.popping==-1)
		invisibility = 0
		popping = 1
		if (src.cover!=null)
			flick("popup", src.cover)
			src.cover.icon_state = "openTurretCover"
		spawn(10)
			if (popping==1) popping = 0

/obj/machinery/turret/proc/popDown()
	if ((!isPopping()) || src.popping==1)
		popping = -1
		if (src.cover!=null)
			flick("popdown", src.cover)
			src.cover.icon_state = "turretCover"
		spawn(10)
			if (popping==-1)
				invisibility = INVISIBILITY_LEVEL_TWO
				popping = 0

/obj/machinery/turret/bullet_act(var/obj/item/projectile/Proj)
	src.health -= Proj.damage
	..()
	if(prob(45) && Proj.damage > 0) src.spark_system.start()
	del (Proj)
	if (src.health <= 0)
		src.die()
	return

/obj/machinery/turret/attackby(obj/item/weapon/W, mob/user)//I can't believe no one added this before/N
	..()
	playsound(src.loc, 'sound/weapons/smash.ogg', 60, 1)
	src.spark_system.start()
	src.health -= W.force * 0.5
	if (src.health <= 0)
		src.die()
	return

/obj/machinery/turret/emp_act(severity)
	switch(severity)
		if(1)
			enabled = 0
			lasers = 0
			power_change()
	..()

/obj/machinery/turret/ex_act(severity)
	if(severity < 3)
		src.die()

/obj/machinery/turret/proc/die()
	src.health = 0
	src.density = 0
	src.stat |= BROKEN
	src.icon_state = "destroyed_target_prism"
	if (cover!=null)
		del(cover)
	sleep(3)
	flick("explosion", src)
	spawn(13)
		del(src)

/obj/machinery/turretid
	name = "Turret deactivation control"
	icon = 'icons/obj/device.dmi'
	icon_state = "motion3"
	anchored = 1
	density = 0
	var/id = 0
	var/enabled = 1
	var/lethal = 0
	var/locked = 1
	var/control_area //can be area name, path or nothing.
	var/ailock = 0 // AI cannot use this
	req_access = list(access_ai_upload)

/obj/machinery/turretid/New()
	..()
	if(!control_area)
		var/area/CA = get_area(src)
		if(CA.master && CA.master != CA)
			control_area = CA.master
		else
			control_area = CA
	else if(istext(control_area))
		for(var/area/A in world)
			if(A.name && A.name==control_area)
				control_area = A
				break
	//don't have to check if control_area is path, since get_area_all_atoms can take path.
	return

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)

	if (istype(W, /obj/item/weapon/card/emag) && !emagged)
		user << "\red You short out the turret controls' access analysis module."
		emagged = 1
		locked = 0
		if(user.machine==src)
			src.attack_hand(user)

		return

	else if( get_dist(src, user) == 1 )		// trying to unlock the interface
		if (src.allowed(usr))
			if(emagged)
				user << "<span class='notice'>The turret control is unresponsive.</span>"
				return

			locked = !locked
			user << "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>"
			if (locked)
				if (user.machine==src)
					user.unset_machine()
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(user)
		else
			user << "<span class='warning'>Access denied.</span>"

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(!ailock)
		return attack_hand(user)
	else
		user << "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>"

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if ( get_dist(src, user) > 1 )
		if ( !issilicon(user) )
			user << "<span class='notice'>You are too far away.</span>"
			user.unset_machine()
			user << browse(null, "window=turretid")
			return

	user.set_machine(src)
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = ""

	if(src.locked && (!istype(user, /mob/living/silicon)))
		t += "<div class='notice icon'>Swipe ID card to unlock interface</div>"
	else
		if (!istype(user, /mob/living/silicon))
			t += "<div class='notice icon'>Swipe ID card to lock interface</div>"
		t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	//user << browse(t, "window=turretid")
	//onclose(user, "turretid")
	var/datum/browser/popup = new(user, "turretid", "Turret Control Panel ([area.name])")
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()


/*obj/machinery/turret/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)	return
	if(!(stat & BROKEN))
		visible_message("\red <B>[M] [M.attacktext] [src]!</B>")
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
		//src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		src.health -= M.melee_damage_upper
		if (src.health <= 0)
			src.die()
	else
		M << "\red That object is useless to you."
	return*/




/obj/machinery/turret/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(!(stat & BROKEN))
		playsound(src.loc, 'sound/weapons/slash.ogg', 25, 1, -1)
		visible_message("\red <B>[] has slashed at []!</B>", M, src)
		src.health -= 15
		if (src.health <= 0)
			src.die()
	else
		M << "\green That object is useless to you."
	return



/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return
	if (src.locked)
		if (!istype(usr, /mob/living/silicon))
			usr << "Control panel is locked!"
			return
	if (href_list["toggleOn"])
		src.enabled = !src.enabled
		src.updateTurrets()
	else if (href_list["toggleLethal"])
		src.lethal = !src.lethal
		src.updateTurrets()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if(control_area)
		for (var/obj/machinery/turret/aTurret in get_area_all_atoms(control_area))
			aTurret.setState(enabled, lethal)
	src.update_icons()

/obj/machinery/turretid/proc/update_icons()
	if (src.enabled)
		if (src.lethal)
			icon_state = "motion1"
		else
			icon_state = "motion3"
	else
		icon_state = "motion0"
																				//CODE FIXED BUT REMOVED
//	if(control_area)															//USE: updates other controls in the area
//		for (var/obj/machinery/turretid/Turret_Control in world)				//I'm not sure if this is what it was
//			if( Turret_Control.control_area != src.control_area )	continue	//supposed to do. Or whether the person
//			Turret_Control.icon_state = icon_state								//who coded it originally was just tired
//			Turret_Control.enabled = enabled									//or something. I don't see  any situation
//			Turret_Control.lethal = lethal										//in which this would be used on the current map.
																				//If he wants it back he can uncomment it

/obj/machinery/turretid/west