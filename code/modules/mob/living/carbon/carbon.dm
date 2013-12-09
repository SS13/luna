/mob/living/carbon/
	gender = MALE

	var/co2overloadtime = null
	var/temperature_resistance = T0C+75

	var/obj/item/weapon/card/id/wear_id = null

	var/list/stomach_contents 	= list()
	var/list/internal_organs	= list()	//List of /obj/item/organ in the mob. they don't go in the contents.

	var/oxygen_alert = 0
	var/toxins_alert = 0
	var/fire_alert = 0
	var/temperature_alert = 0
	var/list/random_events = list() //If handle_random_events() is run, it will choose from this list. Entries are defined per type (See Monkey and Human)
	var/oxylossparalysis = 50
	var/species = null

	var/datum/disease2/disease/virus2 = null
	var/list/datum/disease2/disease/immunevirus2 = list()
	var/list/datum/disease2/resistance/resistances2 = list()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(nutrition)
			nutrition--
	return .

/mob/living/carbon/relaymove(var/mob/user, direction)
	if(user in stomach_contents)
		if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(text("\red You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.equipped()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				adjustBruteLoss(d)
				for(var/mob/M in viewers(user, null))
					if(M.client)
						M.show_message(text("\red <B>[user] attacks [src]'s stomach wall with the [I.name]!"), 2)
				playsound(user.loc, 'attackblob.ogg', 50, 1)

				if(prob(bruteloss - 50))
					gib()

/mob/living/carbon/gib(give_medal)
	for(var/mob/M in src)
		if(M in stomach_contents)
			stomach_contents.Remove(M)
		M.loc = loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("\red <B>[M] bursts out of [src]!</B>"), 2)
	. = ..(give_medal)

/mob/living/carbon/proc/get_temperature(var/datum/gas_mixture/environment)
	var/loc_temp = T0C
	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		loc_temp =  M.return_temperature()

	else if(istype(get_turf(src), /turf/space))
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.temperature

	else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		var/obj/machinery/atmospherics/unary/cryo_cell/C = loc

		if(C.air_contents.total_moles() < 10)
			loc_temp = environment.temperature
		else
			loc_temp = C.air_contents.temperature

	else
		loc_temp = environment.temperature

	return loc_temp

/mob/living/carbon/Stat()
	..()
	statpanel("Status")
	stat("Intent", a_intent)
	stat("Move Mode", m_intent)

/mob/living/carbon/clean_blood()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.gloves)
			H.gloves.clean_blood()
		else
			H.bloody_hands = initial(bloody_hands)
			H.bloody_hands_mob = null
			H.blood_DNA = list()
	update_clothing()



/mob/living/carbon/Move()
	if (buckled)
		return

	if (restrained())
		pulling = null

	var/t7 = 1
	if (restrained())
		for(var/mob/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null

	if ((t7 && (pulling && ((get_dist_3d(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if (pulling && pulling.loc)
			if(!( isturf(pulling.loc) ))
				pulling = null
				return
			else
				if(Debug)
					check_diary()
					diary <<"pulling disappeared? at [__LINE__] in mob.dm - pulling = [pulling]"
					diary <<"REPORT THIS"

		/////
		if(pulling && pulling.anchored)
			pulling = null
			return

		if (!restrained())
			var/diag = get_dir(src, pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, pulling) > 1 || diag))
				if (ismob(pulling))
					var/mob/M = pulling
					var/ok = 1
					if (locate(/obj/item/weapon/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/weapon/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/weapon/grab))
								for(var/mob/O in viewers(M, null))
									O.show_message(text("\red [] has been pulled from []'s grip by []", G.affecting, G.assailant, src), 1)
								//G = null
								del(G)
						else
							ok = 0
						if (locate(/obj/item/weapon/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/t = M.pulling
						M.pulling = null

						pulling.Move(T)
						M.pulling = t
				else
					if (pulling)
						if(CanReachThrough(src.loc,pulling.loc,pulling))
							step(src.pulling, get_dir(src.pulling.loc, T))
	else
		pulling = null
		. = ..()
	if ((s_active && !( s_active in contents ) ))
		s_active.close(src)

	if(update_slimes)
		for(var/mob/living/carbon/slime/M in view(1,src))
			M.UpdateFeed(src)
	return .



/mob/living/carbon/proc/TakeDamage(zone, brute, burn)
	var/datum/organ/external/E = organs[text("[]", zone)]
	if (istype(E, /datum/organ/external))
		if (E.take_damage(brute, burn))
			UpdateDamageIcon()
		else
			UpdateDamage()
	else
		return 0
	return

/mob/living/carbon/proc/UpdateDamage()

	if (!(istype(src, /mob/living/carbon/human)))	//Added by Strumpetplaya - Invincible Monkey Fix
		return										//Possibly helps with other invincible mobs like Aliens?
	var/list/L = list(  )
	for(var/t in organs)
		if (istype(organs[text("[]", t)], /datum/organ/external))
			L += organs[text("[]", t)]
	bruteloss = 0
	fireloss = 0
	for(var/datum/organ/external/O in L)
		bruteloss += O.get_damage_brute()
		fireloss += O.get_damage_fire()
	return

/mob/living/carbon/proc/GetOrgans()
	var/list/L = list(  )
	for(var/t in organs)
		if (istype(organs[text("[]", t)], /datum/organ/external))
			L += organs[text("[]", t)]
	return uniquelist(L)

/mob/living/carbon/proc/UpdateDamageIcon()
	return


/mob/living/carbon/attack_hand(mob/living/user)
	if (!ticker)
		user << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		user << "No attacking people at spawn, you jackass."
		return

	if(!iscarbon(user)) return

	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			user.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in user.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

	if(lying || isslime(src))
		if(user.a_intent == "help")
			if(surgeries.len)
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	return 0


/mob/living/carbon/attack_paw(mob/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	if(!istype(M, /mob/living/carbon)) return


	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

	return

/mob/living/carbon/attackby(obj/item/I, mob/user)
	if(lying || isslime(src))
		if(surgeries.len)
			if(user.a_intent == "help")
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1

	..()