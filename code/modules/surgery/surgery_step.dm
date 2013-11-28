/datum/surgery_step
	var/list/implements = list()	//format is path = probability of success. alternatively
	var/implement_type = null		//the current type of implement used. This has to be stored, as the actual typepath of the tool may not match the list type.
	var/accept_hand = 0				//does the surgery step require an open hand? If true, ignores implements. Compatible with accept_any_item.
	var/accept_any_item = 0			//does the surgery step accept any item? If true, ignores implements. Compatible with require_hand.
	var/time = 10					//how long does the step take?


/datum/surgery_step/proc/try_op(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/success = 0
	//world << "try op"
	if(surgery.current_organ && surgery.current_organ.status != surgery.organ_status_must_be)
		//world << "organ status changed"
		surgery.complete(target)
		return 0

	if(accept_hand)
		//world << "accept_hand"
		if(!tool)
			//world << "and no tool"
			success = 1
	if(accept_any_item)
		//world << "accept_any_item"
		if(tool && tool_check(user, tool))
			//world << "and item is valid"
			success = 1
	else
		for(var/path in implements)
			//world << "[tool.type] [path]"
			if(istype(tool, path))
				//world << "success"
				implement_type = path
				if(tool_check(user, tool, target_zone))
					success = 1

	if(success)
		//world << "try op success [target_zone] [surgery.current_location]"
		if(target_zone == surgery.current_location || !surgery.current_location)
			if(get_location_accessible(target, target_zone))
				initiate(user, target, target_zone, tool, surgery)
				return 1
			else
				user << "<span class='notice'>You need to expose [target]'s [target_zone] to perform surgery on it!</span>"
				return 1	//returns 1 so we don't stab the guy in the dick or wherever.
	return 0


/datum/surgery_step/proc/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	surgery.step_in_progress = 1

	preop(user, target, target_zone, tool, surgery)
	if(do_after(user, time))

		var/advance = 0
		var/prob_chance = 100

		if(implement_type)	//this means it isn't a require hand or any item step.
			prob_chance = implements[implement_type]
		prob_chance *= get_location_modifier(target)

		if(prob(prob_chance))
			if(success(user, target, target_zone, tool, surgery))
				advance = 1
		else
			if(failure(user, target, target_zone, tool, surgery))
				advance = 1

		if(advance)
			surgery.status++
			if(surgery.status > surgery.steps.len)
				surgery.complete(target)

	surgery.step_in_progress = 0


/datum/surgery_step/proc/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to perform surgery on [target].</span>")


/datum/surgery_step/proc/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] succeeds!</span>")
	return 1


/datum/surgery_step/proc/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>[user] screws up!</span>")
	return 0


/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool, var/target_zone)
	return 1