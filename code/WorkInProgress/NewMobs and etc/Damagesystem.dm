/mob/living/carbon/human
	name = "human"
	voice_name = "human"
	icon = 'mob.dmi'
	icon_state = "m-none"

	species = "Human"
	var/lastnutritioncomplaint = 0
	var/bloodloss = 0
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Short Hair"
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0
	var/s_tone = 0
	var/age = 30
	var/obj/overlay/hair

	var/obj/item/weapon/r_store = null	//Left pocket
	var/obj/item/weapon/l_store = null	//Right pocket
	var/obj/item/weapon/s_store = null 	//Suit Storage

	var/icon/stand_icon = null
	var/icon/lying_icon = null

	var/last_b_state = 1.0

	var/image/face_standing = null
	var/image/face_lying = null

	var/hair_icon_state = "hair_a"
	var/face_icon_state = "bald"

	var/list/body_standing = list()
	var/list/body_lying = list()

	var/bot = 0
	var/zombie = 0
	var/pale = 0
	var/zombietime = 0
	var/zombifying = 0
	var/zombi_infected = 0
	var/image/zombieimage = null
	var/datum/organ/external/DEBUG_lfoot
	var/datum/reagents/vessel

	var/special_voice = ""
	var/gender_ambiguous = 0 //if something goes wrong during gender reassignment this generates a line in examine

	var/list/hud_list = list()

	var/tdome_team = 0

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	nodamage = 1

/mob/living/carbon/human/New()
	..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	if (!dna)
		dna = new /datum/dna( null )

	var/datum/organ/external/chest/chest = new /datum/organ/external/chest( src )
	var/datum/organ/external/groin/groin = new /datum/organ/external/groin( src )
	var/datum/organ/external/head/head = new /datum/organ/external/head( src )
	var/datum/organ/external/l_arm/l_arm = new /datum/organ/external/l_arm( src )
	var/datum/organ/external/r_arm/r_arm = new /datum/organ/external/r_arm( src )
	var/datum/organ/external/l_hand/l_hand = new /datum/organ/external/l_hand( src )
	var/datum/organ/external/r_hand/r_hand = new /datum/organ/external/r_hand( src )
	var/datum/organ/external/l_leg/l_leg = new /datum/organ/external/l_leg( src )
	var/datum/organ/external/r_leg/r_leg = new /datum/organ/external/r_leg( src )
	var/datum/organ/external/l_foot/l_foot = new /datum/organ/external/l_foot( src )
	var/datum/organ/external/r_foot/r_foot = new /datum/organ/external/r_foot( src )

	l_hand.parent = l_arm
	r_hand.parent = r_arm
	l_foot.parent = l_leg
	r_foot.parent = r_leg

	organs["chest"] += chest
	organs["groin"] += groin
	organs["head"] += head
	organs["l_arm"] += l_arm
	organs["r_arm"] += r_arm
	organs["l_hand"] += l_hand
	organs["r_hand"] += r_hand
	organs["l_leg"] += l_leg
	organs["r_leg"] += r_leg
	organs["l_foot"] += l_foot
	organs["r_foot"] += r_foot

	organs += chest
	organs += groin
	organs += head
	organs += l_arm
	organs += r_arm
	organs += l_hand
	organs += r_hand
	organs += l_leg
	organs += r_leg
	organs += l_foot
	organs += r_foot

	for(var/datum/organ/external/O in GetOrgans())
		O.owner = src

	var/g = "m"
	if (gender == MALE)
		g = "m"
	else if (gender == FEMALE)
		g = "f"
	else
		gender = MALE
		g = "m"

	if(!stand_icon)
		stand_icon = new /icon('human.dmi', "body_[g]_s")
	if(!lying_icon)
		lying_icon = new /icon('human.dmi', "body_[g]_l")
	icon = stand_icon

//	src << "\blue Your icons have been generated!"

	vessel = new/datum/reagents(560)
	vessel.my_atom = src
	vessel.add_reagent("blood",560)

	internal_organs += new /obj/item/organ/appendix
	var/obj/item/organ/brain/brain = new /obj/item/organ/brain()
	internal_organs += brain
	brain.owner = src


	for(var/i=0;i<7;i++) // 2 for medHUDs and 5 for secHUDs
		hud_list += image('icons/mob/hud.dmi', src, "hudunknown")

	update_clothing()

	spawn(1) fixblood()

/mob/living/carbon/human/proc/fixblood()
	for(var/datum/reagent/blood/B in vessel.reagent_list)
		if(B.id == "blood" && B.data)
			B.data["blood_type"] = src.dna.blood_type
			B.data["blood_DNA"] = src.dna.unique_enzymes
			if(viruses)
				B.data["viruses"] = viruses

/mob/living/carbon/human/Bump(atom/movable/AM as mob|obj, yes)
	if (!yes  || now_pushing)
		return
	now_pushing = 1
	if (ismob(AM))
		var/mob/tmob = AM
		if(tmob.a_intent == "help" && a_intent == "help" && tmob.canmove && canmove) // mutual brohugs all around!
			var/turf/oldloc = loc
			loc = tmob.loc
			tmob.loc = oldloc
			now_pushing = 0
			return
		if(istype(equipped(), /obj/item/weapon/melee/baton)) // add any other item paths you think are necessary
			var/obj/item/weapon/melee/baton/W = equipped()
			if (world.time > lastDblClick+2)
				lastDblClick = world.time
				if((prob(40) || (prob(95) && (CLUMSY in mutations))) && W.status)
					src << "\red You accidentally stun yourself with the [W.name]."
					weakened = max(12, weakened)
					playsound(loc, 'Egloves.ogg', 50, 1, -1)
					W.deductcharge(1000)
				else if(W.status)
					for(var/mob/M in viewers(src, null))
						if(M.client)
							M << "\red <B>[src] accidentally bumps into [tmob] with the [W.name]."
					tmob.weakened = max(4, tmob.weakened)
					tmob.stunned = max(4, tmob.stunned)
					playsound(loc, 'Egloves.ogg', 50, 1, -1)
					W.deductcharge(1000)
				now_pushing = 0
				return
	now_pushing = 0
	spawn(0)
		..()
		if (!istype(AM, /atom/movable))
			return
		if (!now_pushing)
			now_pushing = 1
			if (!AM.anchored)
				var/t = get_dir(src, AM)
				step(AM, t)
			now_pushing = null
		return
	return

/mob/living/carbon/human/movement_delay()
	var/tally = 1.3

	if(zombie) return 6

	if(reagents.has_reagent("nuka_cola")) return 0
	if(reagents.has_reagent("hyperzine")) return 0
	if(istype(get_turf(src), /turf/space)) return 0

	var/health_deficiency = (health_full - health)
	if(health_deficiency >= 40)
		tally += (health_deficiency / 40)

	if(wear_suit) tally += wear_suit.slowdown

	if(shoes) tally += shoes.slowdown

	for(var/organ in list("l_leg","l_foot","r_leg","r_foot"))
		var/datum/organ/external/O = organs[organ]
		if(O.broken) // Be slower if our legs is broken
			tally += 2
		else if(!O.status) // Or destroyed
			tally += 3
		else if(O.status == ORGAN_ROBOTIC) // Be faster if our legs is robotic
			tally = max(tally - 1, 1.3)

	if(bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 20 * 1.25

	return tally

/mob/living/carbon/human/Stat()
	..()
	if(ticker && ticker.mode.name == "AI malfunction")
		if(ticker.mode:malf_mode_declared)
			stat(null, "Time left: [ticker.mode:AI_win_timeleft]")
//	if(main_shuttle.online && main_shuttle.location < 2)
//		var/timeleft = LaunchControl.timeleft()
//		if (timeleft)
//			stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

	if (client.statpanel == "Status")
		if (internal)
			if (!internal.air_contents)
				del(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", "[mind.changeling.chem_charges]/[mind.changeling.chem_storage]")
				stat("Absorbed DNA", mind.changeling.absorbedcount)

		var/obj/item/device/assembly/health/H = locate() in src
		if(H && H.scanning)
			stat("Health", health)


/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	if (stat == 2 && client)
		gib()
		return

	else if (stat == 2 && !client)
		gibs(loc, viruses)
		del(src)
		return

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 250
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				b_loss = b_loss/2
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			if (!shielded)
				b_loss += 60

			f_loss += 60

			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
				f_loss = f_loss/2

			if (!istype(ears, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/4
			if (!istype(ears, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50) && !shielded)
				Paralyse(10)

	for(var/organ in organs)
		var/datum/organ/external/temp = organs[text("[]", organ)]
		if (istype(temp, /datum/organ/external))
			switch(temp.name)
				if("head")
					temp.take_damage(b_loss * 0.2, f_loss * 0.2)
				if("chest")
					temp.take_damage(b_loss * 0.4, f_loss * 0.4)
				if("groin")
					temp.take_damage(b_loss * 0.1, f_loss * 0.1)
				if("l_arm")
					temp.take_damage(b_loss * 0.05, f_loss * 0.05)
				if("r_arm")
					temp.take_damage(b_loss * 0.05, f_loss * 0.05)
				if("l_hand")
					temp.take_damage(b_loss * 0.0225, f_loss * 0.0225)
				if("r_hand")
					temp.take_damage(b_loss * 0.0225, f_loss * 0.0225)
				if("l_leg")
					temp.take_damage(b_loss * 0.05, f_loss * 0.05)
				if("r_leg")
					temp.take_damage(b_loss * 0.05, f_loss * 0.05)
				if("l_foot")
					temp.take_damage(b_loss * 0.0225, f_loss * 0.0225)
				if("r_foot")
					temp.take_damage(b_loss * 0.0225, f_loss * 0.0225)

	UpdateDamageIcon()

/mob/living/carbon/human/blob_act()
	if (stat == 2)
		return
	var/shielded = 0
	for(var/obj/item/device/shield/S in src)
		if (S.active)
			shielded = 1
	var/damage = null
	if (stat != 2)
		damage = rand(1,20)

	if(shielded)
		damage /= 4

		//paralysis += 1

	show_message("\red The blob attacks you!")
	var/list/zones = list()
	for(var/datum/organ/external/part in organs)
		if(part.status)
			zones += part.name
	var/zone = pick(zones)
	if(!zone)
		return
	var/datum/organ/external/temp = organs["[zone]"]
	if(!temp.status)
		return
	switch(zone)
		if ("head")
			if ((((head && head.body_parts_covered & HEAD) || (wear_mask && wear_mask.body_parts_covered & HEAD)) && prob(99)))
				if (prob(20))
					temp.take_damage(damage, 0)
				else
					show_message("\red You have been protected from a hit to the head.")
				return
			if (damage > 4.9)
				if (weakened < 10)
					weakened = rand(10, 15)
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\red <B>The blob has weakened []!</B>", src), 1, "\red You hear someone fall.", 2)
			temp.take_damage(damage)
		if ("chest")
			if ((((wear_suit && wear_suit.body_parts_covered & CHEST) || (w_uniform && w_uniform.body_parts_covered & CHEST)) && prob(85)))
				show_message("\red You have been protected from a hit to the chest.")
				return
			if (damage > 4.9)
				if (prob(50))
					if (weakened < 5)
						weakened = 5
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>The blob has knocked down []!</B>", src), 1, "\red You hear someone fall.", 2)
				else
					if (stunned < 5)
						stunned = 5
					for(var/mob/O in viewers(src, null))
						if(O.client)	O.show_message(text("\red <B>The blob has stunned []!</B>", src), 1)
				if(stat != 2)	stat = 1
			temp.take_damage(damage)
		if ("groin")
			if ((((wear_suit && wear_suit.body_parts_covered & GROIN) || (w_uniform && w_uniform.body_parts_covered & GROIN)) && prob(75)))
				show_message("\red You have been protected from a hit to the lower chest.")
				return
			else
				temp.take_damage(damage, 0)


		if("l_arm")
			temp.take_damage(damage, 0)
		if("r_arm")
			temp.take_damage(damage, 0)
		if("l_hand")
			temp.take_damage(damage, 0)
		if("r_hand")
			temp.take_damage(damage, 0)
		if("l_leg")
			temp.take_damage(damage, 0)
		if("r_leg")
			temp.take_damage(damage, 0)
		if("l_foot")
			temp.take_damage(damage, 0)
		if("r_foot")
			temp.take_damage(damage, 0)

	UpdateDamageIcon()
	return

/mob/living/carbon/human/u_equip(obj/item/W as obj)
	if (W == wear_suit)
		wear_suit = null
		W = s_store
		if(W)
			u_equip(W)
			if (client)
				client.screen -= W
			if (W)
				W.loc = loc
				W.dropped(src)
				W.layer = initial(W.layer)
	else if (W == w_uniform)
		W = r_store
		if(W)
			u_equip(W)
			if (client)
				client.screen -= W
			if (W)
				W.loc = loc
				W.dropped(src)
				W.layer = initial(W.layer)
		W = l_store
		if (W)
			u_equip(W)
			if (client)
				client.screen -= W
			if (W)
				W.loc = loc
				W.dropped(src)
				W.layer = initial(W.layer)
		W = wear_id
		if (W)
			u_equip(W)
			if (client)
				client.screen -= W
			if (W)
				W.loc = loc
				W.dropped(src)
				W.layer = initial(W.layer)
		W = belt
		if (W)
			u_equip(W)
			if (client)
				client.screen -= W
			if (W)
				W.loc = loc
				W.dropped(src)
				W.layer = initial(W.layer)
		w_uniform = null
	else if (W == gloves)
		gloves = null
	else if (W == glasses)
		glasses = null
	else if (W == head)
		head = null
	else if (W == ears)
		ears = null
	else if (W == shoes)
		shoes = null
	else if (W == belt)
		belt = null
	else if (W == wear_mask)
		if(internal)
			if (internals)
				internals.icon_state = "internal0"
			internal = null
		wear_mask = null
	else if (W == wear_id)
		wear_id = null
	else if (W == r_store)
		r_store = null
	else if (W == l_store)
		l_store = null
	else if (W == s_store)
		s_store = null
	else if (W == back)
		back = null
	else if (W == handcuffed)
		handcuffed = null
	else if (W == r_hand)
		r_hand = null
	else if (W == l_hand)
		l_hand = null

	update_clothing()

/mob/living/carbon/human/db_click(text, t1)
	var/obj/item/W = equipped()
	var/emptyHand = (W == null)
	if (!emptyHand && !istype(W, /obj/item))
		return
	if (emptyHand)
		usr.next_move = usr.prev_move
		usr:lastDblClick -= 3	//permit the double-click redirection to proceed.

	switch(text)
		if("mask")
			if (wear_mask)
				if (emptyHand)
					wear_mask.DblClick()
				return
			if (!istype(W, /obj/item/clothing/mask))
				return
			u_equip(W)
			wear_mask = W
			W.equipped(src, text)
		if("back")
			if (back)
				if (emptyHand)
					back.DblClick()
				return
			if (!istype(W, /obj/item))
				return
			if (!(W.slot_flags & SLOT_BACK))
				return
			u_equip(W)
			back = W
			W.equipped(src, text)
		if("o_clothing")
			if(wear_suit)
				if(emptyHand)
					wear_suit.DblClick()
				return
			if(!istype(W, /obj/item/clothing/suit))
				return
			u_equip(W)
			wear_suit = W
			W.equipped(src, text)
		if("gloves")
			if(gloves)
				if(emptyHand)
					gloves.DblClick()
				return
			if (!istype(W, /obj/item/clothing/gloves))
				return
			u_equip(W)
			gloves = W
			W.equipped(src, text)
		if("shoes")
			if(shoes)
				if(emptyHand)
					shoes.DblClick()
				return
			if(!istype(W, /obj/item/clothing/shoes))
				return
			u_equip(W)
			shoes = W
			W.equipped(src, text)
		if("belt")
			if(belt)
				if(emptyHand)
					belt.DblClick()
				return
			if (!istype(W, /obj/item))
				return
			if(!(W.slot_flags & SLOT_BELT))
				return
			u_equip(W)
			belt = W
			W.equipped(src, text)
		if("eyes")
			if(glasses)
				if(emptyHand)
					glasses.DblClick()
				return
			if(!istype(W, /obj/item/clothing/glasses))
				return
			u_equip(W)
			glasses = W
			W.equipped(src, text)
		if("head")
			if(head)
				if(emptyHand)
					head.DblClick()
				return
			if(!istype(W, /obj/item/clothing/head) && !istype(W, /obj/item/weapon/paper))
				return
			u_equip(W)
			head = W
			W.equipped(src, text)
		if("ears")
			if(ears)
				if(emptyHand)
					ears.DblClick()
				return

			if(!W || (!istype(W, /obj/item/clothing/ears) && !istype(W, /obj/item/device/radio/headset) && !W.w_class == 1))
				return
			u_equip(W)
			ears = W
			W.equipped(src, text)
		if("i_clothing")
			if (w_uniform)
				if (emptyHand)
					w_uniform.DblClick()
				return
			if (!istype(W, /obj/item/clothing/under))
				return
			u_equip(W)
			w_uniform = W
			W.equipped(src, text)
		if("id")
			if (wear_id)
				if (emptyHand)
					wear_id.DblClick()
				return
			if(!w_uniform)
				return
			if(!istype(W, /obj/item/weapon/card/id) && !istype(W, /obj/item/device/pda) )
				return
			u_equip(W)
			wear_id = W
			W.equipped(src, text)
		if("storage1")
			if(l_store)
				if(emptyHand)
					l_store.DblClick()
				return
			if(!istype(W, /obj/item) || W.w_class > 2 || !w_uniform)
				return
			u_equip(W)
			l_store = W
		if("storage2")
			if(r_store)
				if(emptyHand)
					r_store.DblClick()
				return
			if(!istype(W, /obj/item) || W.w_class > 2 || !w_uniform)
				return
			u_equip(W)
			r_store = W
		if("suit storage")
			if(s_store)
				if(emptyHand)
					s_store.DblClick()
				return
			if(!istype(W, /obj/item) || !wear_suit || !wear_suit.allowed.len)
				return
			var/check = 0
			for(var/itype in wear_suit.allowed)
				if(istype(W, itype))
					check = 1
					break
			if(check)
				u_equip(W)
				s_store = W

	update_clothing()

	return

/mob/living/carbon/human/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if (M.client && !M.blinded)
			M.show_message(text("\red [] has been hit by []", src, O), 1)
	if (health > 0)
		var/dam_zone = pick("chest", "chest", "chest", "head", "groin")
		if (istype(organs[dam_zone], /datum/organ/external))
			var/datum/organ/external/temp = organs[dam_zone]
			if(!temp.status)
				return
			temp.take_damage((istype(O, /obj/effect/meteor/small) ? 10 : 25), 30)
			UpdateDamageIcon()
		updatehealth()
	return

/mob/living/carbon/human/hand_p(mob/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (M.a_intent == "harm")
		if (istype(M.wear_mask, /obj/item/clothing/mask/muzzle))
			return
		if (health > 0)
			if (istype(wear_suit, /obj/item/clothing/suit/space))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/space/santa))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/bio_suit))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/armor || /obj/item/clothing/suit/storage/armor))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/swat_suit))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[M.name] has bit []!</B>", src), 1)
				var/damage = rand(1, 3)
				var/zones = list()
				for(var/datum/organ/external/p in organs)
					if(p.status)
						zones += p.name
				if(!zones)
					return
				var/dam_zone = pick(zones)
				if (istype(organs[text("[]", dam_zone)], /datum/organ/external))
					var/datum/organ/external/temp = organs[text("[]", dam_zone)]
					if (temp.take_damage(damage, 0))
						UpdateDamageIcon()
					else
						UpdateDamage()
				updatehealth()
				if(istype(M.virus, /datum/disease/jungle_fever))
					monkeyize()
	return

/mob/living/carbon/human/attack_paw(mob/M as mob)
	if (M.a_intent == "help")
		sleeping = 0
		resting = 0
		if (paralysis >= 3) paralysis -= 3
		if (stunned >= 3) stunned -= 3
		if (weakened >= 3) weakened -= 3
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\blue The monkey shakes [] trying to wake him up!", src), 1)
	else
		if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
			return
		if (health > 0)
			if (istype(wear_suit, /obj/item/clothing/suit/space))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/space/santa))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/bio_suit))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/armor || /obj/item/clothing/suit/storage/armor))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else if (istype(wear_suit, /obj/item/clothing/suit/swat_suit))
				if (prob(25))
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M.name] has attempted to bite []!</B>", src), 1)
					return
			else
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\red <B>[M.name] has bit []!</B>", src), 1)
				var/damage = rand(1, 3)
				var/list/zones = list()
				for(var/datum/organ/external/p in organs)
					if(p.status)
						zones += p.name
				if(!zones)
					return
				var/dam_zone = pick(zones)
				if (istype(organs[text("[]", dam_zone)], /datum/organ/external))
					var/datum/organ/external/temp = organs[text("[]", dam_zone)]
					if (temp.take_damage(damage, 0))
						UpdateDamageIcon()
					else
						UpdateDamage()
				updatehealth()
				if(istype(M.virus, /datum/disease/jungle_fever))
					monkeyize()
	return

/mob/living/carbon/human/attack_slime(mob/living/carbon/slime/M as mob)
	if(M.Victim) return // can't attack while eating!

	if (health > -100)

		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>The [M.name] glomps []!</B>", src), 1)

		var/damage = rand(1, 3)

		if(istype(M, /mob/living/carbon/slime/adult))
			damage = rand(10, 25)
		else
			damage = rand(5, 15)


		var/dam_zone = pick("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg", "groin")

		var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
		var/armor_block = run_armor_check(affecting, "melee")
		apply_damage(damage, BRUTE, affecting, armor_block)


		if(M.powerlevel > 0)
			var/stunprob = 10
			var/power = M.powerlevel + rand(0,3)

			switch(M.powerlevel)
				if(1 to 2) stunprob = 20
				if(3 to 4) stunprob = 30
				if(5 to 6) stunprob = 40
				if(7 to 8) stunprob = 60
				if(9) 	   stunprob = 70
				if(10) 	   stunprob = 95

			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>The [M.name] has shocked []!</B>", src), 1)

				Weaken(power)
				if (stuttering < power)
					stuttering = power
				Stun(power)

				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()

				if (prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6,10))


		updatehealth()

	return

/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	if (M.a_intent == "help")
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\blue [M] caresses [src] with its sythe like arm."), 1)
	else
		//This will be changed to skin, where we can skin a dead human corpse
		if (M.a_intent == "grab")
			if (M == src)
				return
			if (w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M )
			G.assailant = M
			if (M.hand)
				M.l_hand = G
			else
				M.r_hand = G
			G.layer = 20
			G.affecting = src
			grabbed_by += G
			G.synch()
			playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red [] has grabbed [] passively!", M, src), 1)
		else
			if (M.a_intent == "harm")
				if (w_uniform)
					w_uniform.add_fingerprint(M)
				var/damage = rand(10, 20)
				var/datum/organ/external/affecting = organs["chest"]
				var/t = M.zone_sel.selecting
				if ((t in list( "eyes", "mouth" )))
					t = "head"
				var/def_zone = ran_zone(t)
				if (organs[def_zone])
					affecting = organs[def_zone]
				if ((istype(affecting, /datum/organ/external) && prob(90)))
					playsound(loc, "punch", 25, 1, -1)
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[] has slashed at []!</B>", M, src), 1)
					if (def_zone == "head")
						if ((((head && head.body_parts_covered & HEAD) || (wear_mask && wear_mask.body_parts_covered & HEAD)) && prob(99)))
							if (prob(20))
								affecting.take_damage(damage, 0)
							else
								show_message("\red You have been protected from a hit to the head.")
							return
						if (damage > 4.9)
							if (weakened < 10)
								weakened = rand(10, 15)
							for(var/mob/O in viewers(M, null))
								O.show_message(text("\red <B>[] has weakened []!</B>", M, src), 1, "\red You hear someone fall.", 2)
						affecting.take_damage(damage)
					else
						if (def_zone == "chest")
							if ((((wear_suit && wear_suit.body_parts_covered & CHEST) || (w_uniform && w_uniform.body_parts_covered & GROIN)) && prob(85)))
								show_message("\red You have been protected from a hit to the chest.")
								return
							if (damage > 4.9)
								if (prob(50))
									if (weakened < 5)
										weakened = 5
									playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
									for(var/mob/O in viewers(src, null))
										O.show_message(text("\red <B>[] has knocked down []!</B>", M, src), 1, "\red You hear someone fall.", 2)
								else
									if (stunned < 5)
										stunned = 5
									for(var/mob/O in viewers(src, null))
										O.show_message(text("\red <B>[] has stunned []!</B>", M, src), 1)
								if(stat != 2)	stat = 1
							affecting.take_damage(damage)
						else
							if (def_zone == "groin")
								if ((((wear_suit && wear_suit.body_parts_covered & GROIN) || (w_uniform && w_uniform.body_parts_covered & GROIN)) && prob(75)))
									show_message("\red You have been protected from a hit to the lower chest.")
									return
								if (damage > 4.9)
									if (prob(50))
										if (weakened < 3)
											weakened = 3
										for(var/mob/O in viewers(src, null))
											O.show_message(text("\red <B>[] has knocked down []!</B>", M, src), 1, "\red You hear someone fall.", 2)
									else
										if (stunned < 3)
											stunned = 3
										for(var/mob/O in viewers(src, null))
											O.show_message(text("\red <B>[] has stunned []!</B>", M, src), 1)
									if(stat != 2)	stat = 1
								affecting.take_damage(damage)
							else
								affecting.take_damage(damage)

					UpdateDamageIcon()

					updatehealth()
				else
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[M] has lunged at [src] but missed!</B>"), 1)
					return
			else
			//disarm
				if (!lying)
					if (w_uniform)
						w_uniform.add_fingerprint(M)
					var/randn = rand(1, 100)
					if (randn <= 25)
						weakened = 2
						for(var/mob/O in viewers(src, null))
							O.show_message(text("\red <B>[] has knocked over []!</B>", M, src), 1)
					else
						if (randn <= 60)
							drop_item()
							for(var/mob/O in viewers(src, null))
								O.show_message(text("\red <B>[] has knocked the item out of []'s hand!</B>", M, src), 1)
						else
							for(var/mob/O in viewers(src, null))
								O.show_message(text("\red <B>[] has tried to knock the item out of []'s hand!</B>", M, src), 1)
	return

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "harm")//Stungloves.
				if(G.cell.charge >= 2500)
					G.cell.charge -= 2500
					visible_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>")
					log_attack("[M.name] ([M.ckey]) stungloved [src.name] ([src.ckey])")

					Stun(10)
					Weaken(10)
					stuttering += 10

					return 1
				else
					M << "<span class='notice'>Not enough charge!</span>"
				return

	if (M.a_intent == "help")
		if(M.zombie)
			return
		if(lying || isslime(src))
			if(surgeries.len)
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(M, src))
						return 1
		if (health > 0)
			if (w_uniform)
				w_uniform.add_fingerprint(M)
		if (M.zombie)
			return
		if (health > 0)
			if (w_uniform)
				w_uniform.add_fingerprint(M)
			if(M == src)
				visible_message( \
					"<span class='notice'>[src] examines \himself.", \
					"<span class='notice'>You check yourself for injuries.</span>")

				for(var/datum/organ/external/org in M.organs)
					if(istype(org, /datum/organ/external/wound) || istype(org, /datum/organ/external/groin))
						continue
					var/status = ""
					var/brutedamage = org.brute_dam
					var/burndamage = org.burn_dam
					if(halloss > 0)
						if(prob(30))
							brutedamage += halloss
						if(prob(30))
							burndamage += halloss

					if(!org.status)
						src << "\t \red My [org.display_name] is <b>missing</b>!."
						continue

					else if(org.status == ORGAN_ROBOTIC)
						if(brutedamage > 0)
							status = "scratched"
						if(brutedamage > 30)
							status = "severely dented"
						if(brutedamage > 0 && burndamage > 0)
							status += " and "

						if(burndamage > 30)
							status += "burnt"
						else if(burndamage > 0)
							status += "charred"

						if(status == "")
							status = "OK"
						src << "\t [status == "OK" ? "\blue" : "\red"] My robotic [org.display_name] is [status]."
						continue

					if(brutedamage > 0)
						status = "bruised"
					if(brutedamage > 30)
						status = "mangled"

					for(var/datum/organ/external/wound/w in org.wounds)
						if(w.bleeding || org.bleeding)
							status = "<b>bleeding</b>"
							break

					if((brutedamage > 0 || org.bleeding) && burndamage > 0)
						status += " and "

					if(burndamage > 40)
						status += "peeling away"
					else if(burndamage > 20)
						status += "blistered"
					else if(burndamage > 0)
						status += "numb"
					if(status == "")
						status = "OK"
					src << "\t [status == "OK" ? "\blue" : "\red"] My [org.display_name] is [status]."
			else
				sleeping = 0
				resting = 0
				if (paralysis >= 3) paralysis -= 3
				if (stunned >= 3) stunned -= 3
				if (weakened >= 3) weakened -= 3
				playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\blue [] shakes [] trying to wake [] up!", M, src, src), 1)
		else
			if (M.health >= -99)
				if (((M.head && M.head.flags & 4) || ((M.wear_mask && !( M.wear_mask.flags & 32 )) || ((head && head.flags & 4) || (wear_mask && !( wear_mask.flags & 32 ))))))
					M << "\blue <B>Remove that mask!</B>"
					return
				var/obj/equip_e/human/O = new /obj/equip_e/human(  )
				O.source = M
				O.target = src
				O.s_loc = M.loc
				O.t_loc = loc
				O.place = "CPR"
				requests += O
				spawn( 0 )
					O.process()
					return
	else
		if (M.a_intent == "grab")
			if (M == src)
				return
			if (M.zombie)
				return
			if(buckled)
				M << "<span class='notice'>You cannot grab [src], \he is buckled in!</span>"
				return
			if (w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M )
			G.assailant = M
			if (M.hand)
				M.l_hand = G
			else
				M.r_hand = G
			G.layer = 20
			G.affecting = src
			grabbed_by += G
			G.synch()
			playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red [] has grabbed [] passively!", M, src), 1)
		else
			if (M.a_intent == "harm")
				if (w_uniform)
					w_uniform.add_fingerprint(M)
				var/damage = rand(1, 9)
				var/datum/organ/external/affecting = organs["chest"]
				var/t
				if(M.zombie)
					var/def_zone = ran_zone(t)
					if(organs["[def_zone]"])
						affecting = organs["[def_zone]"]
					if (affecting.status)
						//Attack with zombie
						if(!zombie && !virus2)
							// lower chance if wearing a suit
							var/pr = 0
							if(istype(wear_suit, /obj/item/clothing/suit/armor || /obj/item/clothing/suit/storage/armor))
								pr = 70
							else if(istype(wear_suit, /obj/item/clothing/suit/bio_suit))
								pr = 70
							else if(istype(wear_suit, /obj/item/clothing/suit))
								pr = 30
							if (prob(pr))
								for(var/mob/O in viewers(src, null))
									O.show_message(text("\red <B>[]'s suit protects [] from the bite!</B>", src, src), 1)
							else
								for(var/mob/O in viewers(src, null))
									O.show_message(text("\red <B>[] has bit []!</B>", M, src), 1)
								if (prob(75))
									zombi_infected = 1
									zombietime=rand(50,110)
									infect_mob_zombie(src)
						else
							affecting.take_damage(rand(1,7),0)
							var/mes = pick(list("clawed","scraped"))
							for(var/mob/O in viewers(src, null))
								O.show_message(text("\red <B>[M] has [mes] [src]!"),1)
					else
						for(var/mob/O in viewers(src, null))
							O.show_message(text("\red <B>[] has misses []!</B>", M, src), 1)
						return
					UpdateDamageIcon()
					updatehealth()
					return
				t = M.zone_sel.selecting
				if (t in list( "eyes", "mouth" ))
					t = "head"
				var/def_zone = ran_zone(t)
				if(organs[def_zone])
					affecting = organs[def_zone]

				var/cybermod = 0

				for(var/organ in list("l_arm","l_hand","r_arm","r_hand"))
					var/datum/organ/external/O = organs["[organ]"]
					if(O.broken) // Be weaker if our arms is broken
						damage -= 1
					else if(!O.status) // Or destroyed
						damage -= 2
					else if(O.status == ORGAN_ROBOTIC) // Be stronger if our arms is robotic
						damage += 2
						cybermod++

					damage = max(damage, 0)

				if(istype(affecting, /datum/organ/external) && prob(90) && affecting.status)
					if((HULK in M.mutations) || prob(10*cybermod))
						damage += 5
						spawn(0)
							Weaken(2)
							step_away(src,M,15)
							sleep(3)
							step_away(src,M,15)
					playsound(loc, "punch", 25, 1, -1)
					if(def_zone != "head")
						for(var/mob/O in viewers(src, null))
							O.show_message(text("\red <B>[] has punched []!</B>", M, src), 1)
					if(def_zone == "head")
						for(var/mob/O in viewers(src, null))
							O.show_message(text("\red <B>[] has punched [] in face!</B>", M, src), 1)
						if (((head && head.body_parts_covered & HEAD) || (wear_mask && wear_mask.body_parts_covered & HEAD)) && prob(99))
							if (istype(wear_mask, /obj/item/clothing/mask/gas/clown_hat))
								for(var/mob/O in viewers(src, null))
									O.show_message(text("[src]'s nose honks!"), 1)
								playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
							if (prob(20))
								affecting.take_damage(damage, 0)
							else
								show_message("\red You have been protected from a hit to the head.")
							return
						if (damage > 7)
							Weaken(8)
							for(var/mob/O in viewers(M, null))
								O.show_message(text("\red <B>[] has weakened []!</B>", M, src), 1, "\red You hear someone fall.", 2)
						affecting.take_damage(damage)
					else
						if (def_zone == "chest")
							if ((((wear_suit && wear_suit.body_parts_covered & CHEST) || (w_uniform && w_uniform.body_parts_covered & GROIN)) && prob(85)))
								show_message("\red You have been protected from a hit to the chest.")
								return
							if (damage > 7)
								if (prob(50))
									Weaken(5)
									playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
									for(var/mob/O in viewers(src, null))
										O.show_message(text("\red <B>[] has knocked down []!</B>", M, src), 1, "\red You hear someone fall.", 2)
								else
									Stun(5)
									for(var/mob/O in viewers(src, null))
										O.show_message(text("\red <B>[] has stunned []!</B>", M, src), 1)
								if(stat != 2)	stat = 1
							affecting.take_damage(damage)
						else
							if (def_zone == "groin")
								if ((((wear_suit && wear_suit.body_parts_covered & GROIN) || (w_uniform && w_uniform.body_parts_covered & GROIN)) && prob(75)))
									show_message("\red You have been protected from a hit to the lower chest.")
									return
								if (damage > 7)
									if (prob(50))
										Weaken(3)
										for(var/mob/O in viewers(src, null))
											O.show_message(text("\red <B>[] has knocked down []!</B>", M, src), 1, "\red You hear someone fall.", 2)
									else
										Stun(3)
										for(var/mob/O in viewers(src, null))
											O.show_message(text("\red <B>[] has stunned []!</B>", M, src), 1)
									if(stat != 2)	stat = 1
								affecting.take_damage(damage)
							else
								affecting.take_damage(damage)

					UpdateDamageIcon()

					updatehealth()
				else
					playsound(loc, 'punchmiss.ogg', 25, 1, -1)
					for(var/mob/O in viewers(src, null))
						O.show_message(text("\red <B>[] has attempted to punch []!</B>", M, src), 1)
					return
			else
				if (!lying && !(M.gloves && M.gloves.cell))
					if (w_uniform)
						w_uniform.add_fingerprint(M)
					var/randn = rand(1, 100)
					if (randn <= 25)
						weakened = 2
						playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
						for(var/mob/O in viewers(src, null))
							O.show_message(text("\red <B>[] has pushed down []!</B>", M, src), 1)
					else
						if (randn <= 60)
							drop_item()
							playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
							for(var/mob/O in viewers(src, null))
								O.show_message(text("\red <B>[] has disarmed []!</B>", M, src), 1)
						else
							playsound(loc, 'punchmiss.ogg', 25, 1, -1)
							for(var/mob/O in viewers(src, null))
								O.show_message(text("\red <B>[] has attempted to disarm []!</B>", M, src), 1)
	return

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0


/mob/living/carbon/human/proc/update_hair()
	switch(h_style)
		if("Short Hair")
			hair_icon_state = "hair_a"
		if("Long Hair")
			hair_icon_state = "hair_b"
		if("Long Fringe")
			hair_icon_state = "hair_longfringe"
		if("Very Long Fringe")
			hair_icon_state = "hair_vlongfringe"
		if("Longest Fringe")
			hair_icon_state = "hair_longest"
		if("Ladylike hair")
			hair_icon_state = "hair_test"
		if("Cut Hair")
			hair_icon_state = "hair_c"
		if("Mohawk")
			hair_icon_state = "hair_d"
		if("Balding")
			hair_icon_state = "hair_e"
		if("Wave")
			hair_icon_state = "hair_f"
		if("Bedhead")
			hair_icon_state = "hair_bedhead"
		if("Bedhead2")
			hair_icon_state = "hair_bedheadv2"
		if("Spikey")
			hair_icon_state = "hair_spikey"
		if("Dreadlocks")
			hair_icon_state = "hair_dreads"
		if("Afro")
			hair_icon_state = "hair_afro"
		if("Big Afro")
			hair_icon_state = "hair_bigafro"
		if("Braid")
			hair_icon_state = "hair_braid"
		if("Kagami")
			hair_icon_state = "hair_kagami"
		if("Ponytail")
			hair_icon_state = "hair_ponytail"
		else
			hair_icon_state = "bald"

	switch(f_style)
		if ("Watson")
			face_icon_state = "facial_watson"
		if ("Chaplin")
			face_icon_state = "facial_chaplin"
		if ("Selleck")
			face_icon_state = "facial_selleck"
		if ("Neckbeard")
			face_icon_state = "facial_neckbeard"
		if ("Full Beard")
			face_icon_state = "facial_fullbeard"
		if ("Long Beard")
			face_icon_state = "facial_longbeard"
		if ("Van Dyke")
			face_icon_state = "facial_vandyke"
		if ("Elvis")
			face_icon_state = "facial_elvis"
		if ("Abe")
			face_icon_state = "facial_abe"
		if ("Chinstrap")
			face_icon_state = "facial_chin"
		if ("Hipster")
			face_icon_state = "facial_hip"
		if ("Goatee")
			face_icon_state = "facial_gt"
		if ("Hogan")
			face_icon_state = "facial_hogan"
		else
			face_icon_state = "bald"

/obj/equip_e/human/process()
	if (item)
		item.add_fingerprint(source)
	if (!item)
		switch(place)
			if("mask")
				if (!( target.wear_mask ))
					//SN src = null
					del(src)
					return
/*			if("headset")
				if (!( target.w_radio ))
					//SN src = null
					del(src)
					return */
			if("l_hand")
				if (!( target.l_hand ))
					//SN src = null
					del(src)
					return
			if("r_hand")
				if (!( target.r_hand ))
					//SN src = null
					del(src)
					return
			if("suit")
				if (!( target.wear_suit ))
					//SN src = null
					del(src)
					return
			if("uniform")
				if (!( target.w_uniform ))
					//SN src = null
					del(src)
					return
			if("back")
				if (!( target.back ))
					//SN src = null
					del(src)
					return
			if("syringe")
				return
			if("pill")
				return
			if("fuel")
				return
			if("drink")
				return
			if("dnainjector")
				return
			if("handcuff")
				if (!( target.handcuffed ))
					//SN src = null
					del(src)
					return
			if("id")
				if ((!( target.wear_id ) || !( target.w_uniform )))
					//SN src = null
					del(src)
					return
			if("internal")
				if (!istype(target.wear_mask, /obj/item/clothing/mask) || !istype(target.back, /obj/item/weapon/tank) && !istype(target.belt, /obj/item/weapon/tank))
					//SN src = null
					del(src)
					return
	var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel")
	if ((item && !( L.Find(place) )))
		for(var/mob/O in viewers(target, null))
			O.show_message(text("\red <B>[] is trying to put \a [] on []</B>", source, item, target), 1)
	else
		if (place == "syringe")
			for(var/mob/O in viewers(target, null))
				O.show_message(text("\red <B>[] is trying to inject []!</B>", source, target), 1)
		else
			if (place == "pill")
				for(var/mob/O in viewers(target, null))
					O.show_message(text("\red <B>[] is trying to force [] to swallow []!</B>", source, target, item), 1)
			else
				if (place == "drink")
					for(var/mob/O in viewers(target, null))
						O.show_message(text("\red <B>[] is trying to force [] to swallow a gulp from the []!</B>", source, target, item), 1)
				else
					if (place == "dnainjector")
						for(var/mob/O in viewers(target, null))
							O.show_message(text("\red <B>[] is trying to inject [] with the []!</B>", source, target, item), 1)
					else
						var/message = null
						switch(place)
							if("mask")
								message = text("\red <B>[] is trying to take off \a [] from []'s head!</B>", source, target.wear_mask, target)
/*							if("headset")
								message = text("\red <B>[] is trying to take off \a [] from []'s face!</B>", source, target.w_radio, target) */
							if("l_hand")
								message = text("\red <B>[] is trying to take off \a [] from []'s left hand!</B>", source, target.l_hand, target)
							if("r_hand")
								message = text("\red <B>[] is trying to take off \a [] from []'s right hand!</B>", source, target.r_hand, target)
							if("gloves")
								message = text("\red <B>[] is trying to take off the [] from []'s hands!</B>", source, target.gloves, target)
							if("eyes")
								message = text("\red <B>[] is trying to take off the [] from []'s eyes!</B>", source, target.glasses, target)
							if("ears")
								message = text("\red <B>[] is trying to take off the [] from []'s ears!</B>", source, target.ears, target)
							if("head")
								message = text("\red <B>[] is trying to take off the [] from []'s head!</B>", source, target.head, target)
							if("shoes")
								message = text("\red <B>[] is trying to take off the [] from []'s feet!</B>", source, target.shoes, target)
							if("belt")
								message = text("\red <B>[] is trying to take off the [] from []'s belt!</B>", source, target.belt, target)
							if("suit")
								message = text("\red <B>[] is trying to take off \a [] from []'s body!</B>", source, target.wear_suit, target)
							if("back")
								message = text("\red <B>[] is trying to take off \a [] from []'s back!</B>", source, target.back, target)
							if("handcuff")
								message = text("\red <B>[] is trying to unhandcuff []!</B>", source, target)
							if("uniform")
								message = text("\red <B>[] is trying to take off \a [] from []'s body!</B>", source, target.w_uniform, target)
							if("pockets")
								for(var/obj/item/device/assembly/mousetrap/MT in list(target.l_store, target.r_store))
									if(MT.armed)
										for(var/mob/O in viewers(target, null))
											if(O == source)
												O.show_message(text("\red <B>You reach into the [target]'s pockets, but there was a live mousetrap in there!</B>"), 1)
											else
												O.show_message(text("\red <B>[source] reaches into [target]'s pockets and sets off a hidden mousetrap!</B>"), 1)
										target.u_equip(MT)
										if (target.client)
											target.client.screen -= MT
										MT.loc = source.loc
										MT.triggered(source, source.hand ? "l_hand" : "r_hand")
										MT.layer = OBJ_LAYER
										return
								for(var/obj/item/device/assembly_holder/AH in list(target.l_store, target.r_store))
									var/obj/item/device/assembly/mousetrap/MT
									if(istype(AH.a_left, /obj/item/device/assembly/mousetrap) && AH.a_left:armed)
										MT = AH.a_left
									else if(istype(AH.a_right, /obj/item/device/assembly/mousetrap) && AH.a_right:armed)
										MT = AH.a_right

									if(MT)
										for(var/mob/O in viewers(target, null))
											if(O == source)
												O.show_message(text("\red <B>You reach into the [target]'s pockets, but there was a live mousetrap in there!</B>"), 1)
											else
												O.show_message(text("\red <B>[source] reaches into [target]'s pockets and sets off a hidden mousetrap!</B>"), 1)
										target.u_equip(AH)
										if (target.client)
											target.client.screen -= AH
										AH.loc = source.loc
										MT.triggered(source, source.hand ? "l_hand" : "r_hand")
										AH.layer = OBJ_LAYER
										return
								message = text("\red <B>[] is trying to empty []'s pockets!!</B>", source, target)
							if("CPR")
								if (target.cpr_time >= world.time + 3)
									//SN src = null
									del(src)
									return
								message = text("\red <B>[] is trying to perform CPR on []!</B>", source, target)
							if("id")
								message = text("\red <B>[] is trying to take off [] from []'s uniform!</B>", source, target.wear_id, target)
							if("internal")
								if (target.internal)
									message = text("\red <B>[] is trying to remove []'s internals</B>", source, target)
								else
									message = text("\red <B>[] is trying to set on []'s internals.</B>", source, target)
							else
						for(var/mob/M in viewers(target, null))
							M.show_message(message, 1)
	spawn( 40 )
		done()
		return
	return

/obj/equip_e/human/done()
	var/mut = 0
	if(TK in source.mutations)
		mut = 1
	if(!source || !target)						return
	if(source.loc != s_loc && mut == 0)			return
	if(target.loc != t_loc && mut == 0)			return
	if(LinkBlocked(s_loc,t_loc) && mut == 0)	return
	if(item && source.equipped() != item)		return
	if(source.restrained() && mut == 0) 		return
	if(source.stat)								return

	switch(place)
		if("mask")
			if (target.wear_mask)
				var/obj/item/W = target.wear_mask
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/mask))
					source.drop_item()
					loc = target
					item.layer = 20
					target.wear_mask = item
					item.loc = target
		if("gloves")
			if (target.gloves)
				var/obj/item/W = target.gloves
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/gloves))
					source.drop_item()
					loc = target
					item.layer = 20
					target.gloves = item
					item.loc = target
		if("eyes")
			if (target.glasses)
				var/obj/item/W = target.glasses
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/glasses))
					source.drop_item()
					loc = target
					item.layer = 20
					target.glasses = item
					item.loc = target
		if("belt")
			if (target.belt)
				var/obj/item/W = target.belt
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if ((istype(item, /obj) && item.slot_flags & SLOT_BELT && target.w_uniform))
					source.drop_item()
					loc = target
					item.layer = 20
					target.belt = item
					item.loc = target
		if("suitstorage")
			if (target.s_store)
				var/obj/item/W = target.s_store
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj) && target.wear_suit && target.wear_suit.allowed.len)
					for(var/itype in target.wear_suit.allowed)
						if(istype(W, itype))
							source.drop_item()
							loc = target
							item.layer = 20
							target.belt = item
							item.loc = target
							break
		if("head")
			if (target.head)
				var/obj/item/W = target.head
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/head))
					source.drop_item()
					loc = target
					item.layer = 20
					target.head = item
					item.loc = target
		if("ears")
			if (target.ears)
				var/obj/item/W = target.ears
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/ears) || istype(item, /obj/item/device/radio/headset))
					source.drop_item()
					loc = target
					item.layer = 20
					target.ears = item
					item.loc = target
		if("shoes")
			if (target.shoes)
				var/obj/item/W = target.shoes
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/shoes))
					source.drop_item()
					loc = target
					item.layer = 20
					target.shoes = item
					item.loc = target
		if("l_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				//SN src = null
				del(src)
				return
			if (target.l_hand)
				var/obj/item/W = target.l_hand
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item))
					source.drop_item()
					loc = target
					item.layer = 20
					target.l_hand = item
					item.loc = target
					item.add_fingerprint(target)
		if("r_hand")
			if (istype(target, /obj/item/clothing/suit/straight_jacket))
				//SN src = null
				del(src)
				return
			if (target.r_hand)
				var/obj/item/W = target.r_hand
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item))
					source.drop_item()
					loc = target
					item.layer = 20
					target.r_hand = item
					item.loc = target
					item.add_fingerprint(target)
		if("uniform")
			if (target.w_uniform)
				var/obj/item/W = target.w_uniform
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
				W = target.l_store
				if (W)
					target.u_equip(W)
					if (target.client)
						target.client.screen -= W
					if (W)
						W.loc = target.loc
						W.dropped(target)
						W.layer = initial(W.layer)
				W = target.r_store
				if (W)
					target.u_equip(W)
					if (target.client)
						target.client.screen -= W
					if (W)
						W.loc = target.loc
						W.dropped(target)
						W.layer = initial(W.layer)
				W = target.wear_id
				if (W)
					target.u_equip(W)
					if (target.client)
						target.client.screen -= W
					if (W)
						W.loc = target.loc
						W.dropped(target)
						W.layer = initial(W.layer)
			else
				if (istype(item, /obj/item/clothing/under))
					source.drop_item()
					loc = target
					item.layer = 20
					target.w_uniform = item
					item.loc = target
		if("suit")
			if (target.wear_suit)
				var/obj/item/W = target.wear_suit
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/suit))
					source.drop_item()
					loc = target
					item.layer = 20
					target.wear_suit = item
					item.loc = target
		if("id")
			if (target.wear_id)
				var/obj/item/W = target.wear_id
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if (((istype(item, /obj/item/weapon/card/id)||istype(item, /obj/item/device/pda)) && target.w_uniform))
					source.drop_item()
					loc = target
					item.layer = 20
					target.wear_id = item
					item.loc = target
		if("back")
			if (target.back)
				var/obj/item/W = target.back
				if(!W.canremove) return

				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			else
				if ((istype(item, /obj/item) && item.slot_flags & SLOT_BACK))
					source.drop_item()
					loc = target
					item.layer = 20
					target.back = item
					item.loc = target
		if("handcuff")
			if (target.handcuffed)
				var/obj/item/W = target.handcuffed
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
				target.lasthandcuff = null
			else
				if (istype(item, /obj/item/weapon/handcuffs))
					target.drop_from_slot(target.r_hand)
					target.drop_from_slot(target.l_hand)
					source.drop_item()
					target.handcuffed = item
					item.loc = target
					target.lasthandcuff = world.timeofday
		if("CPR")
			if (target.cpr_time >= world.time + 30)
				//SN src = null
				del(src)
				return
			if ((target.health >= -75.0 && target.health < 0))
				target.cpr_time = world.time
				if (target.health >= -40.0)
					var/suff = min(target.oxyloss, 5)
					target.oxyloss -= suff
					target.updatehealth()
				if(target.reagents.get_reagent_amount("inaprovaline") < 10)
					target.reagents.add_reagent("inaprovaline", 10)
				for(var/mob/O in viewers(source, null))
					O.show_message(text("\red [] performs CPR on []!", source, target), 1)
				source << "\red Repeat every 7 seconds AT LEAST."
		if("dnainjector")
			if (item)
				var/obj/item/weapon/dnainjector/S = item
				item.add_fingerprint(source)
				item:inject(target, null)
				if (!( istype(S, /obj/item/weapon/dnainjector) ))
					//SN src = null
					del(src)
					return
				if (S.s_time >= world.time + 30)
					//SN src = null
					del(src)
					return
				S.s_time = world.time
				for(var/mob/O in viewers(source, null))
					O.show_message(text("\red [] injects [] with the DNA Injector!", source, target), 1)
		if("pockets")
			if (target.l_store)
				var/obj/item/W = target.l_store
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
			if (target.r_store)
				var/obj/item/W = target.r_store
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.layer = initial(W.layer)
				W.add_fingerprint(source)
		if("internal")
			if (target.internal)
				target.internal.add_fingerprint(source)
				target.internal = null
			else
				if (target.internal)
					target.internal = null
				if (!( istype(target.wear_mask, /obj/item/clothing/mask) ))
					return
				else
					if (istype(target.back, /obj/item/weapon/tank))
						target.internal = target.back
						for(var/mob/M in viewers(target, 1))
							M.show_message(text("[] is now running on internals.", target), 1)
						target.internal.add_fingerprint(source)
					else if(istype(target.belt, /obj/item/weapon/tank))
						target.internal = target.belt
						for(var/mob/M in viewers(target, 1))
							M.show_message(text("[] is now running on internals.", target), 1)
						target.internal.add_fingerprint(source)
		else
	if(source)
		source.update_clothing()
	if(target)
		target.update_clothing()
	//SN src = null
	del(src)
	return

// new damage icon system
// now constructs damage icon for each organ from mask * damage field

/mob/living/carbon/human/UpdateDamageIcon()
	var/list/L = list(  )
	for (var/t in organs)
		if (istype(organs[t], /datum/organ/external))
			L += organs[t]

	del(body_standing)
	body_standing = list()
	del(body_lying)
	body_lying = list()

	// FIXME: code that modifies gamelogic doesn't belong in a proc
	// called UpdateDamageIcon
	bruteloss = 0
	fireloss = 0

	updatehealth()

	for (var/datum/organ/external/O in L)
		if(O.status)
			O.update_icon()
			bruteloss += O.brute_dam
			fireloss += O.burn_dam

			if(zombie)
				O.damage_state = "30"

			var/icon/DI = new /icon('dam_human.dmi', O.damage_state)			// the damage icon for whole human
			DI.Blend(new /icon('dam_mask.dmi', O.icon_name), ICON_MULTIPLY)		// mask with this organ's pixels


			body_standing += DI

			DI = new /icon('dam_human.dmi', "[O.damage_state]-2")				// repeat for lying icons
			DI.Blend(new /icon('dam_mask.dmi', "[O.icon_name]2"), ICON_MULTIPLY)

			body_lying += DI

		//body_standing += new /icon( 'dam_zones.dmi', text("[]", O.d_i_state) )
		//body_lying += new /icon( 'dam_zones.dmi', text("[]2", O.d_i_state) )

/mob/living/carbon/human/show_inv(mob/user as mob)
	user.machine = src
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Gloves:</B> <A href='?src=\ref[src];item=gloves'>[(gloves ? gloves : "Nothing")]</A>
	<BR><B>Eyes:</B> <A href='?src=\ref[src];item=eyes'>[(glasses ? glasses : "Nothing")]</A>
	<BR><B>Ears:</B> <A href='?src=\ref[src];item=ears'>[(ears ? ears : "Nothing")]</A>
	<BR><B>Head:</B> <A href='?src=\ref[src];item=head'>[(head ? head : "Nothing")]</A>
	<BR><B>Shoes:</B> <A href='?src=\ref[src];item=shoes'>[(shoes ? shoes : "Nothing")]</A>
	<BR><B>Belt:</B> <A href='?src=\ref[src];item=belt'>[(belt ? belt : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(belt, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>Uniform:</B> <A href='?src=\ref[src];item=uniform'>[(w_uniform ? w_uniform : "Nothing")]</A>
	<BR><B>(Exo)Suit:</B> <A href='?src=\ref[src];item=suit'>[(wear_suit ? wear_suit : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR><B>ID:</B> <A href='?src=\ref[src];item=id'>[(wear_id ? wear_id : "Nothing")]</A>
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[name];size=340x480"))
	onclose(user, "mob[name]")
	return


// called when something steps onto a human
// this could be made more general, but for now just handle mulebot
/mob/living/carbon/human/HasEntered(var/atom/movable/AM)
	var/obj/machinery/bot/mulebot/MB = AM
	if(istype(MB))
		MB.RunOver(src)

/mob/living/carbon/human/proc/zombify()
	zombietime = 0
	zombifying = 0
	zombie = 1
	update_body()
	src << "\red You've become a zombie"
	if(l_hand)
		if (client)
			client.screen -= l_hand
		if (l_hand)
			l_hand.loc = loc
			l_hand.dropped(src)
			l_hand.layer = initial(r_hand.layer)
			l_hand = null
	if(r_hand)
		if (client)
			client.screen -= r_hand
		if (r_hand)
			r_hand.loc = loc
			r_hand.dropped(src)
			r_hand.layer = initial(r_hand.layer)
			r_hand = null
	sight |= SEE_MOBS
	see_in_dark = 4
	see_invisible = 2
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] seizes up and falls limp, \his eyes dead and lifeless...[src] is ZOMBIE! HARM CLAW! CLAW! CLAW!</B>"), 1)
	UpdateZombieIcons()
	UpdateDamageIcon()


/proc/UpdateZombieIcons()
	spawn(0)
		for(var/mob/living/carbon/human/H in world)
			del(H.zombieimage)
			if(H.zombie)
				H.zombieimage = image('mob.dmi', loc = H, icon_state = "rev")
			else if(H.zombifying)
				H.zombieimage = image('mob.dmi', loc = H, icon_state = "rev_head")
			else
				H.zombieimage = null
		for(var/mob/living/carbon/human/H in world)
			if(H.zombie)
				for(var/mob/living/carbon/human/N in world)
					H << N.zombieimage


/mob/living/carbon/human/relaymove(var/mob/user, direction)
	if(user in stomach_contents)
		if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(text("\red You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.equipped()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/organ = H.organs["chest"]
					if (istype(organ, /datum/organ/external))
						var/datum/organ/external/temp = organ
						temp.take_damage(d, 0)
					H.UpdateDamageIcon()
					H.updatehealth()
				else
					bruteloss += d
				for(var/mob/M in viewers(user, null))
					if(M.client)
						M.show_message(text("\red <B>[user] attacks [src]'s stomach wall with the [I.name]!"), 2)
				playsound(user.loc, 'attackblob.ogg', 50, 1)

				if(prob(bruteloss - 50))
					gib()

/mob/living/carbon/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()