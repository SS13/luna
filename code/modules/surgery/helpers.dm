/proc/attempt_initiate_surgery(obj/item/I, mob/living/carbon/M, mob/living/user)
	if(istype(M))
		var/target_zone = user:zone_sel.selecting
		var/datum/organ/external/target_organ = M.organs[target_zone]

		if(M.lying || isslime(M))	//if they're prone or a slime
			var/list/all_surgeries = surgeries_list.Copy()
			var/list/available_surgeries = list()
			for(var/i in all_surgeries)
				var/datum/surgery/S = all_surgeries[i]

				if(!(target_zone in S.locations))
					continue

				if(target_organ && target_organ.status != S.organ_status_must_be)
					continue

				if(locate(S.type) in M.surgeries)
					continue

				if(S.target_must_be_dead && M.stat != DEAD)
					continue

				for(var/path in S.species)
					if(istype(M, path))
						available_surgeries[S.name] = S
						break

			var/P = input("Begin which procedure?", "Surgery", null, null) as null|anything in available_surgeries
			if(P)
				var/datum/surgery/S = available_surgeries[P]
				var/datum/surgery/procedure = new S.type
				if(procedure)
					if(get_location_accessible(M, target_zone))
						M.surgeries += procedure
						procedure.current_location = target_zone
						if(target_organ)
							procedure.current_organ = target_organ
						user.visible_message("<span class='notice'>[user] drapes [I] over [M]'s [parse_zone(target_zone)] to prepare for \an [procedure.name].</span>")
						return 1
					else
						user << "<span class='notice'>You need to expose [M]'s [target_zone] first.</span>"
						return 1	//return 1 so we don't slap the guy in the dick with the drapes.
			else
				return 1	//once the input menu comes up, cancelling it shouldn't hit the guy with the drapes either.
	return 0


proc/get_location_modifier(mob/M)
	var/turf/T = get_turf(M)
	if(locate(/obj/machinery/optable, T))
		return 1
	else if(locate(/obj/structure/table, T))
		return 0.8
	else if(locate(/obj/structure/stool/bed/roller, T))
		return 0.9
	else if(locate(/obj/structure/stool/bed, T))
		return 0.6
	else
		return 0.4


/proc/get_location_accessible(mob/M, location)
	var/covered_locations	= 0	//based on body_parts_covered
	var/face_covered		= 0	//based on flags_inv
	var/eyesmouth_covered	= 0	//based on flags
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		for(var/obj/item/clothing/I in list(C.back, C.wear_mask))
			covered_locations |= I.body_parts_covered
			face_covered |= I.flags_inv
			eyesmouth_covered |= I.flags
		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			for(var/obj/item/clothing/I in list(H.wear_suit, H.w_uniform, H.shoes, H.belt, H.gloves, H.glasses, H.head, H.ears))
				covered_locations |= I.body_parts_covered
				face_covered |= I.flags_inv
				eyesmouth_covered |= I.flags

	switch(location)
		if("head")
			if(covered_locations & HEAD)
				return 0
		if("eyes")
			if(covered_locations & HEAD || face_covered & HIDEEYES || eyesmouth_covered & GLASSESCOVERSEYES)
				return 0
		if("mouth")
			if(covered_locations & HEAD || face_covered & HIDEFACE || eyesmouth_covered & MASKCOVERSMOUTH)
				return 0
		if("chest")
			if(covered_locations & CHEST)
				return 0
		if("groin")
			if(covered_locations & GROIN)
				return 0
		if("l_arm")
			if(covered_locations & ARM_LEFT)
				return 0
		if("r_arm")
			if(covered_locations & ARM_RIGHT)
				return 0
		if("l_leg")
			if(covered_locations & LEG_LEFT)
				return 0
		if("r_leg")
			if(covered_locations & LEG_RIGHT)
				return 0
		if("l_hand")
			if(covered_locations & HAND_LEFT)
				return 0
		if("r_hand")
			if(covered_locations & HAND_RIGHT)
				return 0
		if("l_foot")
			if(covered_locations & FOOT_LEFT)
				return 0
		if("r_foot")
			if(covered_locations & FOOT_RIGHT)
				return 0

	return 1