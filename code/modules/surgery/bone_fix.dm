/datum/surgery/bone_fix
	name = "bone fix"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/fix_bone, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human)
	locations = list("chest", "head", "l_arm", "r_arm", "l_hand", "r_hand", "l_foot", "r_foot", "l_leg", "r_leg", "groin")

/datum/surgery_step/fix_bone
	implements = list(/obj/item/weapon/surgical/bonegel = 100, /obj/item/stack/rods = 80)
	time = 64

/datum/surgery_step/fix_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.current_organ.broken)
		user.visible_message("<span class='notice'>[user] begins to fix bone in [target]'s [parse_zone(target_zone)] with [tool].</span>")
	else
		user.visible_message("<span class='notice'>[user] begins to check bone in [target]'s [parse_zone(target_zone)] for damage.</span>")
	return 1

/datum/surgery_step/fix_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.current_organ.broken)
		surgery.current_organ.heal_damage(0, 0, 1)

		if(istype(tool, /obj/item/stack/rods))
			tool:use(1)
			surgery.current_organ.take_damage(rand(2, 12), 0, 0, 0)
			surgery.current_organ.min_broken_damage += 10
			surgery.current_organ.max_damage += 10
		user.visible_message("<span class='notice'>[user] successfully fixed bone in [target]'s [parse_zone(target_zone)]!</span>")
	else
		user.visible_message("<span class='notice'>[target]'s bone is not broken.</span>")
	return 1