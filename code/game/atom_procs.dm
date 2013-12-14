
/atom/proc/MouseDrop_T()
	return

/atom/proc/attack_hand(mob/user as mob)
	return

/atom/proc/attack_paw(mob/user as mob)
	return

/atom/proc/attack_ai(mob/user as mob)
	return

//for aliens, it works the same as monkeys except for alien -> mob interactions which will be defined in the
//appropiate mob files
/atom/proc/attack_alien(mob/user as mob)
	src.attack_paw(user)
	return

/atom/proc/hand_h(mob/user as mob)
	return

/atom/proc/hand_p(mob/user as mob)
	return

/atom/proc/hand_a(mob/user as mob)
	return

/atom/proc/hand_al(mob/user as mob)
	src.hand_p(user)
	return

/*
	if(hascall(src,"pull"))
		call(src,/atom/movable/verb/pull)()
*/
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	return

/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!(W.flags & NOHIT))
		for(var/mob/O in viewers(src, null))
			if (O.client && !O.blinded)
				O << "\red <B>[src] has been hit by [user] with [W]</B>"
	return

/atom/proc/add_fingerprint(mob/living/carbon/human/M as mob)
	if (!istype(M, /mob/living/carbon/human) || !istype(M.dna, /datum/dna))
		return 0
	add_fibers(M)
	if (!(src.flags & FPRINT))
		return
	if (M.gloves)
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += "(Wearing gloves). Real name: [M.real_name], Key: [M.key]"
			src.fingerprintslast = M.key
		return 0
	if (mFingerprints in M.mutations)
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += "(Has no fingerprints) Real name: [M.real_name], Key: [M.key]"
			src.fingerprintslast = M.key
		return 0
	if (!src.fingerprints)
		src.fingerprints = text("[]", md5(M.dna.uni_identity))
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += "Real name: [M.real_name], Key: [M.key]"
			src.fingerprintslast = M.key
		return 1
	else
		var/list/L = params2list(src.fingerprints)
		L -= md5(M.dna.uni_identity)
		while(L.len >= 3)
			L -= L[1]
		L += md5(M.dna.uni_identity)
		src.fingerprints = list2params(L)

		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += "Real name: [M.real_name], Key: [M.key]"
			src.fingerprintslast = M.key
	return


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)
	if (!istype(M, /mob/living/carbon/human))
		return 0

	if (!(src.flags & FPRINT))
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	//adding blood to items
	if (istype(src, /obj/item)&&!istype(src, /obj/item/weapon/melee/energy))//Only regular items. Energy melee weapon are not affected.
		var/obj/item/O = src

		//if we haven't made our blood_overlay already
		if(!O.blood_overlay)
			var/icon/I = new /icon(O.icon, O.icon_state)
			I.Blend(new /icon('icons/effects/blood.dmi', "thisisfuckingstupid"), ICON_ADD) //fills the icon_state with white (except where it's transparent)
			I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant

			//not sure if this is worth it. It attaches the blood_overlay to every item of the same type if they don't have one already made.
			for(var/obj/item/A in world)
				if(A.type == O.type && !A.blood_overlay)
					A.blood_overlay = I

		//apply the blood-splatter overlay if it isn't already in there
		if(!blood_DNA.len)
			O.overlays += O.blood_overlay

		//if this blood isn't already in the list, add it

		if(blood_DNA[M.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
		return 1 //we applied blood to the item

	//adding blood to turfs
	else if (istype(src, /turf/simulated))
		var/turf/simulated/T = src

		//get one blood decal and infect it with virus from M.viruses
		for(var/obj/effect/decal/cleanable/blood/B in T.contents)
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
			for(var/datum/disease/D in M.viruses)
				var/datum/disease/newDisease = D.Copy(1)
				B.viruses += newDisease
				newDisease.holder = B
			return 1 //we bloodied the floor

		//if there isn't a blood decal already, make one.
		var/obj/effect/decal/cleanable/blood/newblood = new /obj/effect/decal/cleanable/blood(T)
		newblood.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
		for(var/datum/disease/D in M.viruses)
			var/datum/disease/newDisease = D.Copy(1)
			newblood.viruses += newDisease
			newDisease.holder = newblood
		return 1 //we bloodied the floor

	//adding blood to humans
	else if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		//if this blood isn't already in the list, add it
		if(blood_DNA[H.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[H.dna.unique_enzymes] = H.dna.blood_type
		H.update_clothing()	//handles bloody hands overlays and updating
		return 1 //we applied blood to the item
	return

/atom/proc/clean_blood()
	if(istype(src, /obj))
		src:contaminated = 0
	if (!(src.flags & FPRINT))
		return
	if(blood_DNA.len)
		if(istype(src, /obj/item))
			var/obj/item/source2 = src
			source2.overlays -= source2.blood_overlay
			src.blood_DNA = list()
	return

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/Click(location,control,params)
	//world << "atom.Click() on [src] by [usr] : src.type is [src.type]"

	if(usr.client.buildmode)
		build_click(usr, usr.client.buildmode, location, control, params, src)
		return

	return DblClick(location, control, params)

/atom/DblClick(location, control, params) //TODO: DEFERRED: REWRITE
	if (world.time <= usr:lastDblClick+2)
		//world << "BLOCKED atom.DblClick() on [src] by [usr] : src.type is [src.type]"
		return
	else
		//world << "atom.DblClick() on [src] by [usr] : src.type is [src.type]"
		usr:lastDblClick = world.time
	..()
	var/parameters = params2list(params)

	// ------ SHIFT-CLICK -----

	if(parameters["shift"])
		if(!isAI(usr))
			ShiftClick(usr)
		return

	//Putting it here for now. It diverts stuff to the mech clicking procs. Putting it here stops us drilling items in our inventory Carn
	if(istype(usr.loc,/obj/mecha))
		if(usr.client && (src in usr.client.screen))
			return
		var/obj/mecha/Mech = usr.loc
		Mech.click_action(src,usr)
		return


	// ------- ALT-CLICK -------

	if(parameters["alt"])
		if(!isAI(usr))
			AltClick(usr)
		return


	// ------- CTRL-CLICK -------

	if(parameters["ctrl"])
		if(!isAI(usr))
			CtrlClick(usr)
		return

	usr.log_m("Clicked on [src]")

	if(usr.in_throw_mode)
		return usr:throw_item(src)

	var/obj/item/W = null
	if(ismob(src) && istype(usr,/mob/living/silicon/ai))
		usr:ai_actual_track(src)
	if(istype(usr, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = usr
		W = R.selected_module()
		if(!W)
			var/count
			var/list/objects = list()
			if(usr:module_state_1)
				objects += usr:module_state_1
				count++
			if(usr:module_state_2)
				objects += usr:module_state_2
				count++
			if(usr:module_state_3)
				objects += usr:module_state_3
				count++
			if(count > 1)
				var/input = input("Please, select an item!", "Item", null, null) as obj in objects
				W = input
			else if(count != 0)
				for(var/obj in objects)
					W = obj
			else if(count == 0)
				W = null
	else
		W = usr.equipped()

	if (W == src && usr.stat == 0)
		spawn (0)
			W.attack_self(usr)
		return

	if (((usr.paralysis || usr.stunned || usr.weakened) && !istype(usr, /mob/living/silicon/ai)) || usr.stat != 0)
		return

	if ((!( src in usr.contents ) && (((!isturf(src) && (!isturf(src.loc) && (src.loc && !isturf(src.loc.loc)))) || !isturf(usr.loc)) && (src.loc != usr.loc && (!istype(src, /obj/effect/screen) && !( usr.contents.Find(src.loc) ))))))
		return

	var/t5 = in_range(src, usr) || src.loc == usr

	if (istype(usr, /mob/living/silicon/ai))
		t5 = 1

	if (istype(usr, /mob/living/silicon/robot) && W == null)
		t5 = 1

	if (istype(src, /datum/organ) && src in usr.contents)
		return

	if (((t5 || (W && (W.flags & 16))) && !( istype(src, /obj/effect/screen) )))
		if (usr.next_move < world.time)
			usr.prev_move = usr.next_move
			usr.next_move = world.time + 10
		else
			return

		if ((src.loc && (get_dist(src, usr) < 2 || src.loc == usr.loc)))
			var/direct = get_dir(usr, src)
			var/ok = 0
			if ( (direct - 1) & direct)
				var/turf/Step_1
				var/turf/Step_2
				switch(direct)
					if(EAST|NORTH)
						Step_1 = get_step(usr, NORTH)
						Step_2 = get_step(usr, EAST)

					if(EAST|SOUTH)
						Step_1 = get_step(usr, SOUTH)
						Step_2 = get_step(usr, EAST)

					if(NORTH|WEST)
						Step_1 = get_step(usr, NORTH)
						Step_2 = get_step(usr, WEST)

					if(SOUTH|WEST)
						Step_1 = get_step(usr, SOUTH)
						Step_2 = get_step(usr, WEST)

					else

				if(Step_1 && Step_2)
					var/check_1 = 1
					var/check_2 = 1

					check_1 = CanReachThrough(get_turf(usr), Step_1, src) && CanReachThrough(Step_1, get_turf(src), src)

					check_2 = CanReachThrough(get_turf(usr), Step_2, src) && CanReachThrough(Step_2, get_turf(src), src)

					ok = (check_1 || check_2)
			else

				ok = CanReachThrough(get_turf(usr), get_turf(src), src)

			if (!( ok ))
				return 0

		if ( !(usr.restrained()) )
			if (W)
				if (t5)
					src.alog(W,usr)
					src.attackby(W, usr)
				if (W)
					W.afterattack(src, usr, (t5 ? 1 : 0))
			else
				if (istype(usr, /mob/living/carbon/human))
					src.attack_hand(usr, usr.hand)
				else
					if (istype(usr, /mob/living/carbon/monkey))
						src.attack_paw(usr, usr.hand)
					else
						if (istype(usr, /mob/living/carbon/alien/humanoid))
							src.attack_alien(usr, usr.hand)
						else
							if (istype(usr, /mob/living/silicon))
								src.attack_ai(usr, usr.hand)
		else
			if (istype(usr, /mob/living/carbon/human))
				src.hand_h(usr, usr.hand)
			else
				if (istype(usr, /mob/living/carbon/monkey))
					src.hand_p(usr, usr.hand)
				else
					if (istype(usr, /mob/living/carbon/alien/humanoid))
						src.hand_al(usr, usr.hand)
					else
						if (istype(usr, /mob/living/silicon))
							src.hand_a(usr, usr.hand)

	else
		if (istype(src, /obj/effect/screen))
			usr.prev_move = usr.next_move
			if (usr.next_move < world.time)
				usr.next_move = world.time + 10
			else
				return
			if (!( usr.restrained() ))
				if ((W && !( istype(src, /obj/effect/screen) )))
					src.alog(W,usr)
					src.attackby(W, usr)

					if (W)
						W.afterattack(src, usr)
				else
					if (istype(usr, /mob/living/carbon/human))
						src.attack_hand(usr, usr.hand)
					else
						if (istype(usr, /mob/living/carbon/monkey))
							src.attack_paw(usr, usr.hand)
						else
							if (istype(usr, /mob/living/carbon/alien/humanoid))
								src.attack_alien(usr, usr.hand)
			else
				if (istype(usr, /mob/living/carbon/human))
					src.hand_h(usr, usr.hand)
				else
					if (istype(usr, /mob/living/carbon/monkey))
						src.hand_p(usr, usr.hand)
					else
						if (istype(usr, /mob/living/carbon/alien/humanoid))
							src.hand_al(usr, usr.hand)
	return


	if( iscarbon(usr) && !usr.buckled )
		if( src.x && src.y && usr.x && usr.y )
			var/dx = src.x - usr.x
			var/dy = src.y - usr.y

			if(dy || dx)
				if(abs(dx) < abs(dy))
					if(dy > 0)	usr.dir = NORTH
					else		usr.dir = SOUTH
				else
					if(dx > 0)	usr.dir = EAST
					else		usr.dir = WEST
			else
				if(pixel_y > 16)		usr.dir = NORTH
				else if(pixel_y < -16)	usr.dir = SOUTH
				else if(pixel_x > 16)	usr.dir = EAST
				else if(pixel_x < -16)	usr.dir = WEST

/atom/proc/AltClick()
	if(hascall(src,"pull"))
		src:pull()
	return

/atom/proc/CtrlClick()
	if(hascall(src,"pull"))
		src:pull()
	return

/atom/proc/ShiftClick(var/mob/M as mob)

	if(istype(M.machine, /obj/machinery/computer/security)) //No examining by looking through cameras
		return

	//I dont think this was ever really a problem and it's only creating more bugs...
//	if(( abs(src.x-M.x)<8 || abs(src.y-M.y)<8 ) && src.z == M.z ) //This should prevent non-observers to examine stuff from outside their view.
	examine()

	return

/atom/proc/CanReachThrough(turf/srcturf, turf/targetturf, atom/target)
	var/obj/item/weapon/dummy/D = new /obj/item/weapon/dummy( srcturf )

	if(targetturf.density && targetturf != get_turf(target))
		return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in srcturf)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CheckExit(D, targetturf))
				del D
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in targetturf)
		if((border_obstacle.flags & ON_BORDER) && (src != border_obstacle))
			if(!border_obstacle.CanPass(D, srcturf, 1, 0))
				del D
				return 0

	del D
	return 1
/atom/proc/CanReachTrough2(turf/srcturf, turf/targetturf, atom/target)
// HORRIBLE
/*
	var/direct = get_dir(target, src)
	var/canpass1 = 0
	var/canpass2 = 0
	world << "[direct]"
	switch(direct)
		if(1)
			world << "NORTH || SOUTH || WEST || EAST"
			if(CanReachThrough(srcturf,targetturf,target))
				return 1
			else
				return 0
		if(2)
			world << "NORTH || SOUTH || WEST || EAST"
			if(CanReachThrough(srcturf,targetturf,target))
				return 1
			else
				return 0
		if(4)
			world << "NORTH || SOUTH || WEST || EAST"
			if(CanReachThrough(srcturf,targetturf,target))
				return 1
			else
				return 0
		if(8)
			world << "NORTH || SOUTH || WEST || EAST"
			if(CanReachThrough(srcturf,targetturf,target))
				return 1
			else
				return 0
		if(NORTHWEST)
			world << "NORTHWEST"
			var/turf/north = get_step(src,1)
			var/turf/west = get_step(north,8)
			canpass1 = north.TestEnter(target)
			canpass2 = west.TestEnter(target)
			if(canpass1 && canpass2)
				return 1
			else
				return 0
		if(NORTHEAST)
			world << "NORTHEAST"
			var/turf/north = get_step(src,1)
			var/turf/west = get_step(north,4)
			canpass1 = north.TestEnter(target)
			canpass2 = west.TestEnter(target)
			if(canpass1 && canpass2)
				return 1
			else
				return 0
		if(SOUTHEAST)
			world << "SOUTHEAST"
			var/turf/north = get_step(src,2)
			var/turf/west = get_step(north,4)
			canpass1 = north.TestEnter(target)
			canpass2 = west.TestEnter(target)
			if(canpass1 && canpass2)
				return 1
			else
				return 0
		if(SOUTHWEST)
			world << "SOUTHWEST"
			var/turf/north = get_step(src,2)
			var/turf/west = get_step(north,8)
			canpass1 = north.TestEnter(target)
			canpass2 = west.TestEnter(target)
			if(canpass1 && canpass2)
				return 1
			else
				return 0
			//HEADBACK

	var/direct = get_dir(usr, src)
	var/ok = 0
	if ( (direct - 1) & direct)
		var/turf/Step_1
		var/turf/Step_2
		switch(direct)
			if(EAST|NORTH)
				Step_1 = get_step(target, NORTH)
				Step_2 = get_step(target, EAST)
			if(EAST|SOUTH)
				Step_1 = get_step(target, SOUTH)
				Step_2 = get_step(target, EAST)
			if(NORTH|WEST)
				Step_1 = get_step(target, NORTH)
				Step_2 = get_step(target, WEST)
			if(SOUTH|WEST)
				Step_1 = get_step(target, SOUTH)
				Step_2 = get_step(target, WEST)
			else
		if(Step_1 && Step_2)
			var/check_1 = 1
			var/check_2 = 1
			check_1 = CanReachThrough(get_turf(target), Step_1, src) && CanReachThrough(Step_1, get_turf(src), src)
			check_2 = CanReachThrough(get_turf(target), Step_2, src) && CanReachThrough(Step_2, get_turf(src), src)
			if(check_1 && check_2)
				return 1
	else
		if(CanReachThrough(get_turf(target), get_turf(src), src))
			return 1


/turf/proc/TestEnter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover || !isturf(mover.loc))
		return 1


	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if((obstacle.flags & ~ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(obstacle.flags & ~ON_BORDER)
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				return 0
	return 1 //Nothing found to block so return success!
*/
/atom/proc/alog(var/atom/device,var/mob/mb)
	src.logs += "[src.name] used by a [device.name] by [mb.real_name]([mb.key])"
	mb.log_m("[src.name] used by a [device.name]")



/atom/proc/addoverlay(var/overlays)
	src.overlayslist += overlays
	src.overlays += overlays

/atom/proc/removeoverlay(var/overlays)
	if (istype(overlays, /image)) // This is needed due to the way overlayss work. The overlays being passed to this proc is in most instances not the same object, so we need to compare their attributes
		var/image/I = overlays
		for (var/image/L in src.overlayslist)
			if (L.icon == I.icon && L.icon_state == I.icon_state && L.dir == I.dir && L.layer == I.layer)
				src.overlayslist -= L
				break
	else
		src.overlayslist -= overlays
	src.overlays -= overlays // Seems that the overlayss list is special and is able to remove them. Suspect it does similar to the if block above.

/atom/proc/clearoverlays()
	src.overlayslist = new/list()
	src.overlays = null

/atom/proc/addalloverlays(var/list/overlayss)
	src.overlayslist = overlayss
	src.overlays = overlayss

/atom/movable/proc/forceMove(atom/destination)
	if(destination)
		if(loc)
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		return 1
	return 0

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

		for(var/datum/disease/D in M.viruses)
			var/datum/disease/newDisease = D.Copy(1)
			this.viruses += newDisease
			newDisease.holder = this

// Only adds blood on the floor -- Skie
/atom/proc/add_blood_floor(mob/living/carbon/M as mob)
	if(istype(src, /turf/simulated))
		if(M.dna)	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/blood/B = locate() in contents
			if(!B)	B = new(src)
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type

			for(var/datum/disease/D in M.viruses)
				var/datum/disease/newDisease = D.Copy(1)
				B.viruses += newDisease
				newDisease.holder = B

		else if(istype(M, /mob/living/carbon/alien))
			var/obj/effect/decal/cleanable/xenoblood/B = locate() in contents
			if(!B)	B = new(src)
			B.blood_DNA["UNKNOWN BLOOD"] = "X*"
		else if(istype(M, /mob/living/silicon/robot))
			var/obj/effect/decal/cleanable/oil/B = locate() in contents
			if(!B)	B = new(src)