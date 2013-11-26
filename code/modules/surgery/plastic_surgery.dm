/datum/surgery/plastic_surgery
	name = "plastic surgery"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/reshape_face, /datum/surgery_step/close)
	species = list(/mob/living/carbon/human)
	locations = list("head")

//reshape_face
/datum/surgery_step/reshape_face
	implements = list(/obj/item/weapon/surgical/scalpel = 100, /obj/item/weapon/kitchen/utensil/knife = 50, /obj/item/weapon/wirecutters = 35)
	time = 64

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to alter [target]'s appearance.</span>")

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.face_dmg)
		target.face_dmg = 0
		user.visible_message("<span class='notice'>[user] successfully restores [target]'s appearance!</span>")
	else
		var/oldname = target.real_name
		target.real_name = random_name(target.gender)
		var/newname = target.real_name	//something about how the code handles names required that I use this instead of target.real_name
		user.visible_message("<span class='notice'>[user] alters [oldname]'s appearance completely, they are now [newname]!</span>")
	return 1

proc/random_name(gender, attempts_to_find_unique_name=10)
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		if(gender==FEMALE)	. = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else				. = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

		if(i != attempts_to_find_unique_name && !findname(.))
			break