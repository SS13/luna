/datum/surgery/implant_removal
	name = "implant removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/extract_implant, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	locations = list("chest", "head", "l_arm", "r_arm", "l_hand", "r_hand", "l_foot", "r_foot", "l_leg", "r_leg", "groin")


//extract implant
/datum/surgery_step/extract_implant
	implements = list(/obj/item/weapon/surgical/hemostat = 100, /obj/item/weapon/wirecutters = 85, /obj/item/weapon/crowbar = 65)
	time = 64
	var/obj/item/weapon/implant/I = null

/datum/surgery_step/extract_implant/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	I = surgery.current_organ.implant

	if(I)
		user.visible_message("<span class='notice'>[user] begins to extract [I] implant from [target]'s [parse_zone(target_zone)].</span>")
	else
		user.visible_message("<span class='notice'>[user] looks for an implant in [target]'s [parse_zone(target_zone)].</span>")

/datum/surgery_step/extract_implant/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(I)
		user.visible_message("<span class='notice'>[user] successfully removes [I] implant from [target]'s [parse_zone(target_zone)]!</span>")
		//if(istype(I, /obj/item/weapon/implant/loyalty))
		//	target << "<span class='notice'>You feel a sense of liberation as Nanotrasen's grip on your mind fades away.</span>"
		I.loc = target.loc
		I.implanted = null
		surgery.current_organ.implant = null
	else
		user.visible_message("<span class='notice'>[user] can't find anything in [target]'s [parse_zone(target_zone)].</span>")
	return 1