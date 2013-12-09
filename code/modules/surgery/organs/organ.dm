/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'

/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	var/inflamed = 1

/obj/item/organ/appendix/update_icon()
	if(inflamed)
		icon_state = "appendixinflamed"
	else
		icon_state = "appendix"

/obj/item/organ/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	icon_state = "brain2"
	flags = 0
	force = 1
	w_class = 3
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "biotech=3"
	attack_verb = list("attacked", "slapped", "whacked")

	var/mob/living/carbon/owner = null

/obj/item/organ/brain/examine()
	set src in oview(12)
	if(!usr)	return

	..()
	if(owner && owner.client)
		usr << "You can feel the small spark of life still left in this one."
	else
		usr << "This one seems particularly lifeless. Perhaps it will regain some of it's luster later..."

/obj/item/organ/brain/New()
	..()
	spawn(5)
		if(owner)
			src.name = "[owner]'s brain"

/obj/item/organ/brain/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return

	src.add_fingerprint(user)

	if(!user.zone_sel.selecting == "head" || !istype(M, /mob/living/carbon))
		return ..()

	var/mob/living/carbon/human/H = M
	if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
		// you can't stab someone in the eyes wearing a mask!
		user << "\blue You're going to need to remove that mask/helmet/glasses first."
		return

	var/datum/organ/external/head = M.organs["head"]
	if(!getbrain(M) && head.status)
		for(var/mob/O in viewers(M, null))
			if(O == (user || M))
				continue
			if(M == user)
				O.show_message(text("\red [user] inserts [src] into his head!"), 1)
			else
				O.show_message(text("\red [M] has [src] inserted into his head by [user]."), 1)

		if(M != user)
			M << "\red [user] inserts [src] into your head!"
			user << "\red You insert [src] into [M]'s head!"
		else
			user << "\red You insert [src] into your head!"

		if(M.client)
			M.client.mob = new/mob/dead/observer(M) //a mob can't have two clients so get rid of one

		if(src.owner) 										//if the brain has an owner corpse
			if(src.owner.client) 							//if the player hasn't ghosted
				src.owner.client.mob = M 					//then put them in M

			else 											//if the player HAS ghosted
				for(var/mob/dead/observer/O in world)
					if(O.corpse == src.owner && O.client)	//find their ghost
						O.client.mob = M					//put their mob in M
						del(O) 								//delete thier ghost

		M.internal_organs += src
		loc = null
	else
		..()
	return

/obj/item/organ/brain/alien
	name = "alien brain"
	desc = "We barely understand the brains of terrestial animals. Who knows what we may find in the brain of such an advanced species?"
	icon_state = "brain-alien"
	origin_tech = "biotech=7"
	w_class = 2