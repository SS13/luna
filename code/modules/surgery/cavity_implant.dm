/datum/surgery/cavity_implant
	name = "cavity implant"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/incise, /datum/surgery_step/handle_cavity, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	locations = list("chest", "head", "l_arm", "r_arm", "l_hand", "r_hand", "l_foot", "r_foot", "l_leg", "r_leg", "groin")


//handle cavity
/datum/surgery_step/handle_cavity
	accept_hand = 1
	accept_any_item = 1
	time = 32
	var/obj/item/IC = null

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	IC = surgery.current_organ.cavity

	if(tool)
		user.visible_message("<span class='notice'>[user] begins to insert [tool] into [target]'s [parse_zone(target_zone)].</span>")
	else
		user.visible_message("<span class='notice'>[user] checks for items in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(tool)
		var/max_w_class = 1 // head, hands, feet
		if(surgery.current_organ.name in list("r_arm", "l_arm", "r_leg", "l_leg"))
			max_w_class = 2 // arms, legs
		else
			max_w_class = 3 // chest

		if(IC || tool.w_class > max_w_class || (istype(tool, /obj/item/weapon/implant) && surgery.current_organ.implant) || istype(tool, /obj/item/organ))
			user.visible_message("<span class='notice'>[user] can't seem to fit [tool] in [target]'s [parse_zone(target_zone)].</span>")
			return 0
		else
			user.visible_message("<span class='notice'>[user] stuffs [tool] into [target]'s [parse_zone(target_zone)]!</span>")
			user.drop_item()
			if(istype(tool, /obj/item/weapon/implant))
				surgery.current_organ.implant = tool
				tool:implanted = target
			else
				surgery.current_organ.cavity = tool
			tool.loc = target
			return 1
	else
		if(IC)
			user.visible_message("<span class='notice'>[user] pulls [IC] out of [target]'s [parse_zone(target_zone)]!</span>")
			user.put_in_hands(IC)
			surgery.current_organ.cavity = null
			return 1
		else
			user.visible_message("<span class='notice'>[user] doesn't find anything in [target]'s [parse_zone(target_zone)].</span>")
			return 0