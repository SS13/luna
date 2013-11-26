/datum/surgery/limb_removal
	name = "limb removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/saw)
	species = list(/mob/living/carbon/human)
	locations = list("l_arm", "r_arm", "l_hand", "r_hand", "l_foot", "r_foot", "l_leg", "r_leg")

/datum/surgery/limb_removal/complete(mob/living/carbon/human/target)
	current_organ.status = ORGAN_DESTROYED
	current_organ.droplimb()
	..()