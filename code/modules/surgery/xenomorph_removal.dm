/datum/surgery/xenomorph_removal
	name = "xenomorph removal"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/xenomorph_removal, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	locations = list("chest")


//remove xeno from premises
/datum/surgery_step/xenomorph_removal
	implements = list(/obj/item/weapon/surgical/hemostat = 100, /obj/item/weapon/shovel/spade = 75, /obj/item/weapon/minihoe = 70, /obj/item/weapon/crowbar = 65)
	time = 64
	var/datum/disease/alien_embryo/A

/datum/surgery_step/xenomorph_removal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to search in [target]'s chest for a xenomorph.</span>")
	A = locate() in target.viruses

/datum/surgery_step/xenomorph_removal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
//	var/obj/item/alien_embryo/A = locate() in target.contents
	if(A)
		user << "<span class='notice'>You found an unknown alien organism in [target]'s chest!</span>"
		if(A.stage < 3)
			user << "It's small and weak, barely the size of a foetus."
		else
			user << "It's grown quite large, and writhes slightly as you look at it."
/*			if(prob(10))
				A.AttemptGrow()*/
		user.visible_message("<span class='notice'>[user] successfully extracts the xenomorph from [target]!</span>")
		if(A.stage == 5 || (A.stage == 4 && prob(30)))
			new/mob/living/carbon/alien/larva(target.loc)
		else
			new/obj/item/weapon/alien_embryo(target.loc)
		A.cure()
	else
		user.visible_message("<span class='notice'>[user] can't find anything in [target]'s chest!</span>")
	return 1

/datum/surgery_step/xenomorph_removal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(A && prob(80))
		if(A.stage < 5 && prob(20*A.stage))
			A.stage++
		user.visible_message("<span class='warning'>[user] accidentally pokes the xenomorph in [target]!</span>")
	else
		target.adjustOxyLoss(50)
		user.visible_message("<span class='warning'>[user] accidentally pokes [target] in the lungs!</span>")
	return 0

/obj/item/weapon/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yuck."
	icon = 'icons/mob/alien.dmi'
	icon_state = "larva_l"