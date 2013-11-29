/obj/effect/proc_holder/spell/targeted/horsemask
	name = "Curse of the Horseman"
	desc = "This spell triggers a curse on a target, causing them to wield an unremovable horse head mask. They will speak like a horse! Any masks they are wearing will be disintegrated. This spell does not require robes."
	school = "transmutation"
	charge_type = "recharge"
	charge_max = 150
	charge_counter = 0
	clothes_req = 0
	stat_allowed = 0
	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = "shout"
	range = 7
	selection_type = "range"
	var/list/compatible_mobs = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

/obj/effect/proc_holder/spell/targeted/horsemask/cast(list/targets, mob/user = usr)
	if(!targets.len)
		user << "<span class='notice'>No target found in range.</span>"
		return

	var/mob/living/carbon/human/target = targets[1]

	if(!target)
		return

	var/isvalid = 0
	for(var/ttype in compatible_mobs)
		if(istype(target, ttype))
			isvalid = 1
			break


	if(!isvalid)
		user << "<span class='notice'>It'd be stupid to curse [target] with a horse's head!</span>"
		return

	if(!(target in oview(range)))//If they are not in overview after selection.
		user << "<span class='notice'>They are too far away!</span>"
		return

	var/obj/item/clothing/mask/gas/horsehead/magichead = new /obj/item/clothing/mask/gas/horsehead
	magichead.canremove = 0		//curses!
	magichead.unacidable = 1	//curses!
	magichead.flags_inv = null	//so you can still see their face
	magichead.voicechange = 1	//NEEEEIIGHH
	target.visible_message(	"<span class='danger'>[target]'s face lights up in fire, and after the event a horse's head takes its place!</span>", \
							"<span class='danger'>Your face burns up, and shortly after the fire you realise you have the face of a horse!</span>")
	del target.wear_mask
	target.equip_if_possible(magichead, target.slot_wear_mask)
	target.update_clothing()

	flick("e_flash", target.flash)