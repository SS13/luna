/datum/surgery/limb_replacement
	name = "limb replacement"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/add_robolimb)
	species = list(/mob/living/carbon/human)
	locations = list("l_arm", "r_arm", "l_leg", "r_leg")
	organ_status_must_be = ORGAN_DESTROYED

/datum/surgery_step/add_robolimb
	implements = list(/obj/item/robot_parts/l_arm = 100, /obj/item/robot_parts/r_arm = 100, /obj/item/robot_parts/l_leg = 100, /obj/item/robot_parts/r_leg = 100)
	time = 54

/datum/surgery_step/add_robolimb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to replace [target]'s [parse_zone(target_zone)] with [tool].</span>")
	return 1

/datum/surgery_step/add_robolimb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] replaced [target]'s [parse_zone(target_zone)]!</span>")
	surgery.current_organ.robotize()
	del(tool)
	return 1

/datum/surgery_step/add_robolimb/tool_check(mob/user, obj/item/tool, target_zone)
	if(tool.icon_state == target_zone) // It's Hacky. It Works.
		return 1
	else
		return 0