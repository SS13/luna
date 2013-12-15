/proc/get_all_thefts(var/job, var/datum/mind/traitor, var/reagents = 1)
	var/list/datum/objective/objectives = list()
	var/list/possible_reagents = list(
		"polytrinic acid", "space lube",
		"unstable mutagen", "leporazine",
		"cryptobiolin", "lexorin",
	)

	var/list/possible_items = list(
		"the captain's antique laser gun", "a hand teleporter",
		"a rapid construction device", "a jetpack",
		"a pair of magboots", "28 moles of plasma (full tank)",
		"the hypospray", "a bone gel bottle",
		"an ablative armor vest", "the captain's pinpointer",
		"a small singularity engine", "a completed cyborg shell (no brain)",
		"a finished (but not booted up) AI construct with brain",
	)

	if(reagents)
		for(var/r in possible_reagents)
			var/datum/objective/stealreagent/O = new /datum/objective/stealreagent(null,job)
			O.set_target(r)
			objectives += O

	for(var/i in possible_items)
		var/datum/objective/steal/O = new /datum/objective/steal(null,job)
		O.set_target(i)
		objectives += O

	return objectives

/proc/GetObjectives(var/job,var/datum/mind/traitor)
	return get_all_thefts(job, traitor)


/proc/GetCObjectives(var/job,var/datum/mind/changeling)
	return get_all_thefts(job, changeling)

/proc/GenerateAssassinate(var/job,var/datum/mind/traitor)
	var/list/datum/objective/assassinate/missions = list()

	for(var/datum/mind/target in ticker.minds)
		if((target != traitor) && istype(target.current, /mob/living/carbon/human))
			if(target && target.current)
				missions +=	new /datum/objective/assassinate(null,job,target)
	return missions

/proc/GenerateProtection(var/job,var/datum/mind/traitor)
	var/list/datum/objective/frame/missions = list()

	for(var/datum/mind/target in ticker.minds)
		if((target != traitor) && istype(target.current, /mob/living/carbon/human))
			if(target && target.current)
				missions +=	new /datum/objective/protection(null,job,target)
	return missions

/proc/GenerateCProtection(var/job,var/datum/mind/changeling)
	return GenerateProtection(job, changeling)

/proc/GenerateCAssassinate(var/job,var/datum/mind/changeling)
	return GenerateAssassinate(job, changeling)



/proc/SelectObjectives(var/job,var/datum/mind/traitor)
	var/list/datum/objective/chosenobjectives = list()
	var/list/datum/objective/theftobjectives = get_all_thefts(job, traitor)	//Separated all the objective types so they can be picked independantly of each other.
	var/list/datum/objective/killobjectives = GenerateAssassinate(job,traitor)
	var/list/datum/objective/protectobjectives = GenerateProtection(job,traitor)

	var/totalweight
	var/selectobj
	var/conflict

	while(totalweight < 100)
		selectobj = rand(1,100)	//Randomly determine the type of objective to be given.
		if(!length(killobjectives) || !length(protectobjectives))	//If any of these lists are empty, just give them theft objectives.
			var/datum/objective/objective = pick(theftobjectives)
			chosenobjectives += objective
			totalweight += objective.weight
			theftobjectives -= objective
		else switch(selectobj)
			if(1 to 45)		//Theft Objectives (45% chance)
				var/datum/objective/objective = pick(theftobjectives)
				chosenobjectives += objective
				totalweight += objective.weight
				theftobjectives -= objective
			if(46 to 85)	//Assassination Objectives (40% chance)
				var/datum/objective/assassinate/objective = pick(killobjectives)
				for(var/datum/objective/protection/conflicttest in chosenobjectives)	//Check to make sure we aren't telling them to Assassinate somebody they need to Protect.
					if(conflicttest.target == objective.target)
						conflict = 1
				if(!conflict)
					chosenobjectives += objective
					totalweight += objective.weight
					killobjectives -= objective
				conflict = 0
			if(86 to 100)	//Protection Objectives (15% chance)
				var/datum/objective/protection/objective = pick(protectobjectives)
				for(var/datum/objective/assassinate/conflicttest in chosenobjectives)	//Check to make sure we aren't telling them to Protect somebody they need to Assassinate.
					if(conflicttest.target == objective.target)
						conflict = 1
				if(!conflict)
					chosenobjectives += objective
					totalweight += objective.weight
					protectobjectives -= objective
				conflict = 0

	if(prob(90))
		chosenobjectives += new /datum/objective/escape(null,job)
	else
		chosenobjectives += new /datum/objective/hijack(null,job)
	return chosenobjectives

/proc/SelectChangelingObjectives(var/job,/var/datum/mind/changeling)
	var/list/datum/objective/chosenobjectives = list()
	var/list/datum/objective/theftobjectives = get_all_thefts(job, changeling)		//Separated all the objective types so they can be picked independantly of each other.
	var/list/datum/objective/killobjectives = GenerateCAssassinate(job,changeling)
	var/totalweight
	var/selectobj
	var/conflict

	totalweight += 20 // absorb has weight too

	while(totalweight < 100)
		selectobj = rand(1,100)	//Randomly determine the type of objective to be given.
		if(!length(killobjectives))	//If any of these lists are empty, just give them theft objectives.
			var/datum/objective/objective = pick(theftobjectives)
			chosenobjectives += objective
			totalweight += objective.weight
			theftobjectives -= objective
		else switch(selectobj)
			if(1 to 50)		//Theft Objectives (50% chance)
				var/datum/objective/objective = pick(theftobjectives)
				chosenobjectives += objective
				totalweight += objective.weight
				theftobjectives -= objective
			if(51 to 100)	//Assassination Objectives (50% chance)
				var/datum/objective/assassinate/objective = pick(killobjectives)
				for(var/datum/objective/protection/conflicttest in chosenobjectives)	//Check to make sure we aren't telling them to Assassinate somebody they need to Protect.
					if(conflicttest.target == objective.target)
						conflict = 1
				if(!conflict)
					chosenobjectives += objective
					totalweight += objective.weight
					killobjectives -= objective
				conflict = 0

	chosenobjectives += new /datum/objective/absorb(null,job)

	if(prob(70))
		chosenobjectives += new /datum/objective/escape(null,job)
	else
		chosenobjectives += new /datum/objective/survive(null,job)
	return chosenobjectives







/datum/objective
	var/datum/mind/owner
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0 				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.

	var/job
	var/weight

	New(var/text,var/joba)
		if(text)
			src.explanation_text = text
		job = joba

	proc/check_completion()
		return 1

	proc/find_target()
		return null



/datum/objective/frame
	New(var/text,var/joba,var/datum/mind/targeta)
		target = targeta
		job = joba
		weight = 60
		explanation_text = "Frame [target.current.real_name], the [target.assigned_role] for a crime and make sure they are arrested and brought back to the Centcom station alive.  We'll handle the rest from there."

	check_completion()
		if(main_shuttle.location<2)
			return 0

		if(target.current.stat == 2)
			return 0

		var/turf/location = get_turf(target.current.loc)
		if(!location)
			return 0

		if(!target.current:handcuffed)
			return 0


		for(var/datum/shuttle/s in shuttles)
			if(location in locate(s.centcom))
				return 1

		return 0

/datum/objective/protection
	New(var/text,var/joba,var/datum/mind/targeta)
		target = targeta
		job = joba
		weight = 30
		explanation_text = "[target.current.real_name], the [target.assigned_role] is a relative of a high ranking Syndicate Leader.  Make sure they get off the ship safely."

	check_completion()
		if(main_shuttle.location < 2)
			return 0

		if(target.current.stat == 2)
			return 0

		var/turf/location = get_turf(target.current.loc)
		if(!location)
			return 0

		for(var/datum/shuttle/s in shuttles)
			if(location in locate(s.centcom))
				return 1

		return 0

/datum/objective/assassinate
	New(var/text,var/joba,var/datum/mind/targeta)
		target = targeta
		job = joba
		weight = 60
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."

	check_completion()
		if(target && target.current)
			if(target.current.stat == 2 || issilicon(target.current))
				return 1
			else
				return 0
		else
			return 1

	proc/find_target_by_role(var/role)
		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && ishuman(possible_target.current) && (possible_target.assigned_role == role))
				target = possible_target
				break

		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"

		return target


	find_target()
		var/list/possible_targets = list()

		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && istype(possible_target.current, /mob/living/carbon/human))
				possible_targets += possible_target

		if(possible_targets.len > 0)
			target = pick(possible_targets)

		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"

		return target

/datum/objective/capture
	var/separation_time = 0
	var/almost_complete = 0

	New(var/text,var/joba,var/datum/mind/targeta)
		target = targeta
		job = joba
		explanation_text = "Capture [target.current.real_name], the [target.assigned_role]."

	check_completion()
		if(target && target.current)
			if(target.current.stat == DEAD)
				if(vsc.RPREV_REQUIRE_HEADS_ALIVE) return 0
			else
				if(!target.current.handcuffed && !target.current.stat) // N2O is fine too
					return 0
		else if(vsc.RPREV_REQUIRE_HEADS_ALIVE) return 0
		return 1

	proc/find_target_by_role(var/role)
		for(var/datum/mind/possible_target in ticker.minds)
			if((possible_target != owner) && istype(possible_target.current, /mob/living/carbon/human) && (possible_target.assigned_role == role))
				target = possible_target
				break

		if(target && target.current)
			explanation_text = "Capture [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"

		return target


/datum/objective/hijack
	explanation_text = "Hijack the emergency shuttle by escaping alone."

	check_completion()
		if(main_shuttle.location<2)
			return 0

		if(!owner.current || owner.current.stat == DEAD)
			return 0
		var/turf/location = get_turf(owner.current.loc)

		for(var/datum/shuttle/s in shuttles)
			if(location in locate(s.centcom))
				for(var/mob/living/carbon/player in locate(s.centcom))
					if (player.mind && player.mind != owner && player.stat != DEAD)
						return 0

				return 1

		return 0

/datum/objective/escape
	explanation_text = "Escape on the shuttle alive, without being arrested."

	check_completion()
		if(main_shuttle.location<2)
			return 0

		if(!owner.current || owner.current.stat == DEAD || issilicon(owner.current))
			return 0

		var/turf/location = get_turf(owner.current)
		if(!location)
			return 0

		if(owner.current:handcuffed)
			return 0

		for(var/datum/shuttle/s in shuttles)
			if(location in locate(s.centcom))
				return 1

		return 0

/datum/objective/survive
	explanation_text = "Stay alive until the end."

	check_completion()
		if(!owner.current || owner.current.stat == DEAD || issilicon(owner.current))
			return 0

		return 1


/*
 NUCLEAR
 */
/datum/objective/nuclear
	explanation_text = "Destroy the station with a nuclear device."

/*
 CHANGELING
 */

/datum/objective/absorb
	New()
		..()
		gen_amount_goal()


	proc/gen_amount_goal(var/lowbound = 4, var/highbound = 6)
		target_amount = rand (lowbound,highbound)
		if (ticker)
			var/n_p = 1 //autowin
			if (ticker.current_state == GAME_STATE_SETTING_UP)
				for(var/mob/new_player/P in player_list)
					if(P.client && P.ready && P.mind!=owner)
						n_p ++
			else if (ticker.current_state == GAME_STATE_PLAYING)
				for(var/mob/living/carbon/human/P in player_list)
					if(P.client && !(P.mind in ticker.mode.changelings) && P.mind!=owner)
						n_p ++
			target_amount = min(target_amount, n_p)

		explanation_text = "Extract [target_amount] compatible genome\s."
		return target_amount

	check_completion()
		if(owner && owner.changeling && owner.changeling.absorbed_dna && (owner.changeling.absorbedcount >= target_amount))
			return 1
		else
			return 0

/datum/objective/steal
	var/obj/item/steal_target
	var/target_name
	weight = 20

	var/global/possible_items[] = list(
		"the captain's antique laser gun" = /obj/item/weapon/gun/energy/laser/captain,
		"a hand teleporter" = /obj/item/device/hand_tele,
		"a rapid construction device" = /obj/item/weapon/rcd,
		"a jetpack" = /obj/item/weapon/tank/jetpack,
		"a pair of magboots" = /obj/item/clothing/shoes/magnetic,
		"28 moles of plasma (full tank)" = /obj/item/weapon/tank,
		"the hypospray" = /obj/item/weapon/reagent_containers/hypospray,
		"a bone gel bottle" = /obj/item/weapon/surgical/bonegel,
		"an ablative armor vest" = /obj/item/clothing/suit/armor/laserproof,
		"the captain's pinpointer" = /obj/item/weapon/pinpointer,
		"a small singularity engine" = /obj/item/toy/minisingulo,
		"a completed cyborg shell (no brain)" = /obj/item/robot_parts/robot_suit,
		"a finished (but not booted up) AI construct with brain" = /obj/structure/AIcore,
	)

	var/global/possible_items_special[] = list(
		"an advanced energy gun" = /obj/item/weapon/gun/energy/gun/nuclear,
		"a diamond drill" = /obj/item/weapon/pickaxe/diamonddrill,
		"a bag of holding" = /obj/item/weapon/storage/backpack/holding,
		"a hyper-capacity cell" = /obj/item/weapon/cell/hyper,
		"10 diamonds" = /obj/item/stack/sheet/mineral/diamond,
		"50 gold bars" = /obj/item/stack/sheet/mineral/gold,
		"25 refined uranium bars" = /obj/item/stack/sheet/mineral/uranium,
	)


	proc/set_target(item_name)
		target_name = item_name
		steal_target = possible_items[target_name]
		if (!steal_target)
			steal_target = possible_items_special[target_name]
		explanation_text = "Steal [target_name]."
		return steal_target


	find_target()
		return set_target(pick(possible_items))


	proc/select_target()
		var/list/possible_items_all = possible_items+possible_items_special+"custom"
		var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
		if (!new_target) return
		if (new_target == "custom")
			var/obj/item/custom_target = input("Select type:","Type") as null|anything in typesof(/obj/item)
			if (!custom_target) return
			var/tmp_obj = new custom_target
			var/custom_name = tmp_obj:name
			del(tmp_obj)
			custom_name = copytext(sanitize(input("Enter target name:", "Objective target", custom_name) as text|null),1,MAX_MESSAGE_LEN)
			if (!custom_name) return
			target_name = custom_name
			steal_target = custom_target
			explanation_text = "Steal [target_name]."
		else
			set_target(new_target)
		return steal_target

	check_completion()
		if(!steal_target || !owner.current)	return 0
		if(!isliving(owner.current))	return 0
		var/list/all_items = owner.current.GetAllContents()	//this should get things in cheesewheels, books, etc.
		switch(target_name)
			if("28 moles of plasma (full tank)","10 diamonds","50 gold bars","25 refined uranium bars")
				var/target_amount = text2num(target_name)//Non-numbers are ignored.
				var/found_amount = 0.0//Always starts as zero.

				for(var/obj/item/I in all_items) //Check for plasma tanks
					if(istype(I, steal_target))
						found_amount += (target_name=="28 moles of plasma (full tank)" ? (I:air_contents:toxins) : (I:amount))
				return found_amount>=target_amount

			if("an unused sample of slime extract")
				for(var/obj/item/weapon/slime_extract/E in all_items)
					if(E.Uses > 0)
						return 1

			if("a completed cyborg shell (no brain)")
				for(var/obj/item/robot_parts/robot_suit/R in all_items)
					if(R.check_completion())
						return 1

			if("a finished (but not booted up) AI construct with brain")
				for(var/datum/shuttle/s in shuttles)
					for(var/obj/structure/AIcore/objective in locate(s.centcom))
						if (objective.buildstate == 5)
							return 1

			else
				for(var/obj/I in all_items) //Check for items
					if(istype(I, steal_target))
						return 1
		return 0



/datum/objective/stealreagent
	var/datum/reagent/steal_reagent
	var/target_name
	weight = 35

	var/global/possible_reagents[] = list(
		"polytrinic acid" = /datum/reagent/pacid,
		"space lube" = /datum/reagent/lube,
		"unstable mutagen" = /datum/reagent/mutagen,
	 	"leporazine" = /datum/reagent/leporazine,
	 	"cryptobiolin" =/datum/reagent/cryptobiolin,
	 	"lexorin" = /datum/reagent/lexorin,
	)

	find_target()
		target_name = pick(possible_reagents)
		steal_reagent = possible_reagents[target_name]
		explanation_text = "Steal a container filled with [target_name]."

		return steal_reagent

	proc/set_target(item_name)
		target_name = item_name
		steal_reagent = possible_reagents[target_name]
		explanation_text = "Steal a container filled with [target_name]."
		return steal_reagent

	proc/select_target()
		var/new_target = input("Select target:", "Objective target", steal_reagent) as null|anything in possible_reagents+"custom"
		if (!new_target) return
		if (new_target == "custom")
			var/obj/item/custom_target = input("Select type:","Type") as null|anything in typesof(/datum/reagent)
			if (!custom_target) return
			var/tmp_obj = new custom_target
			var/custom_name = tmp_obj:name
			del(tmp_obj)
			custom_name = copytext(sanitize(input("Enter target name:", "Objective target", custom_name) as text|null),1,MAX_MESSAGE_LEN)
			if (!custom_name) return
			target_name = custom_name
			steal_reagent = custom_target
		else
			set_target(target_name)

		explanation_text = "Steal a container filled with [target_name]."
		return steal_reagent

	check_completion()
		if(steal_reagent)
			if(owner.current.check_contents_for_reagent(steal_reagent))
				return 1
			else
				return 0