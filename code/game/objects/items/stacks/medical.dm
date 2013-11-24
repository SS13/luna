/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 10
	max_amount = 10
	w_class = 1
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0
	var/check_health = 1
	var/stop_bleeding = 0

/obj/item/stack/medical/proc/AddReagents(mob/living/carbon/human/M as mob)
	return

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if (check_health && M.health < 0)
		return

	if (!istype(M))
		user << "\red \The [src] cannot be applied to [M]!"
		return 1

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.organs["chest"]

		if (ishuman(user))
			var/mob/living/carbon/human/user2 = user
			var/t = user2.zone_sel.selecting

			if (t in list("eyes", "mouth"))
				t = "head"

			if (H.organs[t])
				affecting = H.organs[t]

			if (stop_bleeding)
				if(affecting.bleeding)
					affecting.bleeding = 0

				for(var/datum/organ/external/wound/W in affecting.wounds)
					if(W.bleeding) W.stopbleeding()
		else
			if (!istype(affecting, /datum/organ/external) || affecting:burn_dam <= 0)
				affecting = H.organs["head"]
				if (!istype(affecting, /datum/organ/external) || affecting:burn_dam <= 0)
					affecting = H.organs["groin"]

		if(affecting.status != ORGAN_INTACT)
			return

		if (affecting.heal_damage(src.heal_brute, src.heal_burn))
			H.UpdateDamageIcon()
		else
			H.UpdateDamage()
		AddReagents(M)
	else
		M:adjustBruteLoss(-src.heal_brute/2)
		M:adjustFireLoss(-src.heal_burn/2)
	M.updatehealth()

	if(user)
		if (M != user)
			for (var/mob/O in viewers(M, null))
				O.show_message("\red [M] has been applied with [src] by [user]", 1)
		else
			var/t_himself = "itself"
			if (user.gender == MALE)
				t_himself = "himself"
			else if (user.gender == FEMALE)
				t_himself = "herself"

			for (var/mob/O in viewers(M, null))
				O.show_message("\red [M] applied [src] on [t_himself]", 1)

	use(1)

/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A pack designed to treat blunt-force trauma."
	icon_state = "brutepack"
	heal_brute = 30
	origin_tech = "biotech=1"

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 20
	origin_tech = "biotech=1"


/obj/item/stack/medical/advanced
	check_health = 0

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 60
	origin_tech = "biotech=3"
	stop_bleeding = 1

	AddReagents(mob/living/carbon/human/M as mob)
		M.reagents.add_reagent("bicaridine", 5)
		M.reagents.add_reagent("inaprovaline", 5)

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 40
	origin_tech = "biotech=2"

	AddReagents(mob/living/carbon/human/M as mob)
		M.reagents.add_reagent("kelotane", 5)
		M.reagents.add_reagent("inaprovaline", 5)


/obj/item/stack/medical/bandaid
	name = "Band-aid"
	desc = "A roll of bandaid"
	icon_state = "bandaid"
	origin_tech = "biotech=1"

/obj/item/stack/medical/bandaid/attack(mob/M as mob, mob/user as mob)
	if(!ishuman(M))
		user << "You can only do that on humans"
		return

	var/mob/living/carbon/human/MS = M
	if(MS.bloodloss > 0)
		var/t = user.zone_sel.selecting
		var/datum/organ/external/temp = MS.organs["[t]"]
		if(!temp)
			return

		var/stoped = 0
		if(temp.bleeding)
			temp.bleeding = 0
			stoped = 1

		for(var/datum/organ/external/wound/W in temp.wounds)
			if(W.bleeding)
				W.stopbleeding()
				stoped = 1

		if(!stoped)
			user << "There is no bleeding wound at [t]"
			return

		if (user)
			if (M != user)
				for (var/mob/O in viewers(MS, null))
					O.show_message("\red [MS] has been bandaged with [src] by [user]", 1)
			else
				var/t_himself = "itself"
				if (user.gender == MALE)
					t_himself = "himself"
				else if (user.gender == FEMALE)
					t_himself = "herself"
				for (var/mob/O in viewers(MS, null))
					O.show_message("\red [MS] bandaged [t_himself] with [src]", 1)
		use(1)
		return