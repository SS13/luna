/obj/structure/signpost
	icon = 'old_or_unused.dmi'
	icon_state = "signpost"
	anchored = 1
	density = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		switch(alert("Travel back to Luna?",,"Yes","No"))
			if("Yes")
				user.loc.loc.Exited(user)
				user.loc = pick(latejoin)
			if("No")
				return

/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	requires_power = 0
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'shore.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		process()

	Entered(atom/movable/Obj,atom/OldLoc)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		set background = 1

		var/sound/S = null
		var/sound_delay = 0
		if(prob(25))
			S = sound(file=pick('seag1.ogg','seag2.ogg','seag3.ogg'), volume=100)
			sound_delay = rand(0, 50)

		for(var/mob/living/carbon/human/H in src)
			if(H.s_tone > -55)
				H.s_tone--
				H.update_body()
			if(H.client)
				mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S

		spawn(60) .()

/obj/item/weapon/beach_ball
	icon = 'beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "clown"
	density = 0
	anchored = 0
	w_class = 1.0
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	flags = FPRINT | USEDELAY | CONDUCT
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed)


/obj/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = 0
	anchored = 1
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/weapon_name = null
	var/obj/item/weap = null
	var/image/stand_icon = null
	var/image/currentimage = null
	var/icon/base = null
	var/s_tone
	var/mob/living/clone = null
	var/image/left
	var/image/right
	var/image/up
	var/collapse
	var/image/down

	var/health = 100
/obj/fake_attacker/attackby(var/obj/item/weapon/P as obj, mob/user as mob)
	step_away(src,my_target,2)
	for(var/mob/M in oviewers(world.view,my_target))
		M << "\red <B>[my_target] flails around wildly.</B>"
	my_target.show_message("\red <B>[src] has been attacked by [my_target] </B>", 1) //Lazy.

	//src.health -= P.power


	return

/obj/fake_attacker/HasEntered(var/mob/M, somenumber)
	if(M == my_target)
		step_away(src,my_target,2)
		if(prob(30))
			for(var/mob/O in oviewers(world.view , my_target))
				O << "\red <B>[my_target] stumbles around.</B>"

/obj/fake_attacker/New()
	spawn(300)
		if(my_target)
			my_target.hallucinations -= src
		del(src)
	step_away(src,my_target,2)
	proccess()


/obj/fake_attacker/proc/updateimage()
//	del src.currentimage


	if(src.dir == NORTH)
		del src.currentimage
		src.currentimage = new /image(up,src)
	else if(src.dir == SOUTH)
		del src.currentimage
		src.currentimage = new /image(down,src)
	else if(src.dir == EAST)
		del src.currentimage
		src.currentimage = new /image(right,src)
	else if(src.dir == WEST)
		del src.currentimage
		src.currentimage = new /image(left,src)
	my_target << currentimage


/obj/fake_attacker/proc/proccess()
	if(!my_target) spawn(5) .()
	if(src.health < 0)
		collapse()
		return
	if(get_dist(src,my_target) > 1)
		src.dir = get_dir(src,my_target)
		step_towards_3d(src,my_target)
		updateimage()
	else
		if(prob(15))
			if(weapon_name)
				my_target << sound(pick('genhit1.ogg', 'genhit2.ogg', 'genhit3.ogg'))
				my_target.show_message("\red <B>[my_target] has been attacked with [weapon_name] by [src.name] </B>", 1)
				my_target.halloss += 8
				if(prob(20)) my_target.eye_blurry += 3
				if(prob(33))
					if(!locate(/obj/overlay) in my_target.loc)
						fake_blood(my_target)
			else
				my_target << sound(pick('punch1.ogg','punch2.ogg','punch3.ogg','punch4.ogg'))
				my_target.show_message("\red <B>[src.name] has punched [my_target]!</B>", 1)
				my_target.halloss += 4
				if(prob(33))
					if(!locate(/obj/overlay) in my_target.loc)
						fake_blood(my_target)

	if(prob(15))
		step_away(src,my_target,2)
	spawn(5) .()

/obj/fake_attacker/proc/collapse()
	collapse = 1
	updateimage()

/proc/fake_blood(var/mob/target)
	var/obj/overlay/O = new/obj/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	target << I
	spawn(300)
		del(O)
	return

/proc/fake_attack(var/mob/target)
	var/list/possible_clones = new/list()
	var/mob/living/carbon/human/clone = null
	var/clone_weapon = null

	for(var/mob/living/carbon/human/H in world)
		if(H.stat || H.lying) continue
		possible_clones += H

	if(!possible_clones.len) return
	clone = pick(possible_clones)
	//var/obj/fake_attacker/F = new/obj/fake_attacker(outside_range(target))
	var/obj/fake_attacker/F = new/obj/fake_attacker(target.loc)
	if(clone.l_hand)
		clone_weapon = clone.l_hand.name
		F.weap = clone.l_hand
	else if (clone.r_hand)
		clone_weapon = clone.r_hand.name
		F.weap = clone.l_hand

	F.name = clone.name
	F.my_target = target
	F.weapon_name = clone_weapon
	target.hallucinations += F


	F.left = image(clone,dir = WEST)
	F.right = image(clone,dir = EAST)
	F.up = image(clone,dir = NORTH)
	F.down = image(clone,dir = SOUTH)

//	F.base = new /icon(clone.stand_icon)
//	F.currentimage = new /image(clone)

/*



	F.left = new /icon(clone.stand_icon,dir=WEST)
	for(var/icon/i in clone.overlays)
		F.left.Blend(i)
	F.up = new /icon(clone.stand_icon,dir=NORTH)
	for(var/icon/i in clone.overlays)
		F.up.Blend(i)
	F.down = new /icon(clone.stand_icon,dir=SOUTH)
	for(var/icon/i in clone.overlays)
		F.down.Blend(i)
	F.right = new /icon(clone.stand_icon,dir=EAST)
	for(var/icon/i in clone.overlays)
		F.right.Blend(i)

	target << F.up
	*/

	F.updateimage()
//var/image/O = image(clone,F)
//	target << O


/mob/proc/get_all_possessed_items()
	var/list/items = new/list()

	if(hasvar(src,"back"))
		if(src:back)
			items += src:back
			for(var/obj/O in src:back.contents)
				items += O
				if(istype(O,/obj/item/weapon/storage/))
					items += O.contents
	if(hasvar(src,"belt"))
		if(src:belt)
			items += src:belt
			for(var/obj/O in src:belt.contents)
				items += O
				if(istype(O,/obj/item/weapon/storage/))
					items += O.contents
	if(hasvar(src,"ears"))
		if(src:ears)
			items += src:ears
	if(hasvar(src,"glasses"))
		if(src:glasses)
			items += src:glasses
	if(hasvar(src,"gloves"))
		if(src:gloves)
			items += src:gloves
	if(hasvar(src,"head")) if(src:head) items += src:head
	if(hasvar(src,"shoes")) if(src:shoes) items += src:shoes
	if(hasvar(src,"wear_id")) if(src:wear_id) items += src:wear_id
	if(hasvar(src,"wear_mask")) if(src:wear_mask) items += src:wear_mask
	if(hasvar(src,"wear_suit"))
		if(src:wear_suit)
			items += src:wear_suit
			for(var/obj/O in src:wear_suit.contents)
				items += O
				if(istype(O,/obj/item/weapon/storage/))
					items += O.contents
	if(hasvar(src,"w_uniform")) if(src:w_uniform) items += src:w_uniform
	if(hasvar(src,"l_hand"))
		if(src:l_hand)
			items += src:l_hand
			for(var/obj/O in src:l_hand.contents)
				items += O
				if(istype(O,/obj/item/weapon/storage/))
					items += O.contents
	if(hasvar(src,"r_hand"))
		if(src:r_hand)
			items += src:r_hand
			for(var/obj/O in src:r_hand.contents)
				items += O
				if(istype(O,/obj/item/weapon/storage/))
					items += O.contents

	return items

/proc/get_step_towards_3d2(var/atom/ref , var/atom/trg)
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/turf/temp = get_step_towards(ref,trg)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile = null
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = get_step(turf_last1,dir_alt1)
			turf_last2 = get_step(turf_last2,dir_alt2)
			breakpoint++

		if(!free_tile) return get_step(ref, base_dir)
		else return get_step_towards(ref,free_tile)

	else return get_step(ref, base_dir)
/proc/can_reach(var/atom/ref , var/atom/trg)
	var/turf/temp = trg
	if(temp.Enter(ref,null,1))
		return 1
	else
		return 0

/proc/get_step_towards_3d22(var/atom/ref , var/atom/trg)
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/turf/temp = get_step_towards(ref,trg)
	if(temp.Enter(ref))
		return temp
	else
		for(var/dirn in cardinal)
			var/turf/T = get_step(temp, dirn)
			if(T.Enter(ref))
				return T
	return get_step(ref, base_dir)

/proc/get_area_all_objects(var/areatype)
	//Takes: Area type as text string or as typepath OR an instance of the area.
	//Returns: A list of all objs in areas of that type of that type in the world.
	//Notes: Simple!

	if(!areatype) return null
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/objs = new/list()
	for(var/area/N in world)
		if(istype(N, areatype))
			for(var/obj/A in N.contents)
				objs += A
	return objs