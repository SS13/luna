/obj/item/weapon/storage/firstaid
	name = "first aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap

/obj/item/weapon/storage/firstaid/regular

	New()
		..()
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bandaid(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
		return

/obj/item/weapon/storage/firstaid/fire
	name = "fire first aid"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	New()
		..()
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/pill/kelotane(src)
		new /obj/item/weapon/reagent_containers/pill/kelotane(src)
		new /obj/item/device/healthanalyzer(src)
		return


/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/antitox(src)
		new /obj/item/weapon/reagent_containers/pill/antitox(src)
		new /obj/item/weapon/reagent_containers/pill/antitox(src)
		new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
		new /obj/item/weapon/reagent_containers/syringe/antitoxin(src)
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
		new /obj/item/device/healthanalyzer(src)
		return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/dexalin(src)
		new /obj/item/weapon/reagent_containers/pill/dexalin(src)
		new /obj/item/weapon/reagent_containers/pill/dexalin(src)
		new /obj/item/weapon/reagent_containers/pill/dexalin(src)
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline(src)
		new /obj/item/device/healthanalyzer(src)
		return

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first aid kit"
	desc = "It's an evil looking medical kit for serious boo-boos."
	icon_state = "bezerk"

	New()
		..()
		new /obj/item/stack/medical/advanced/bruise_pack(src)
		new /obj/item/stack/medical/advanced/ointment(src)
		new /obj/item/weapon/storage/pill_bottle/dexalinp(src)
		new /obj/item/weapon/storage/pill_bottle/dermaline(src)
		new /obj/item/weapon/storage/pill_bottle/antitox(src)
		new /obj/item/weapon/storage/pill_bottle/other(src)
		new /obj/item/device/healthanalyzer(src)
		return

/obj/item/weapon/storage/firstaid/attackby(var/obj/item/robot_parts/S, mob/user as mob)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		if (src.contents.len >= 7)
			return
		if (S.w_class >= 2)
			return
		..()
		return

	if(src.contents.len >= 1)
		user << "\red You need to empty [src] out first!"
		return
	else
		var/obj/item/weapon/robot_assembly/firstaid_arm/A = new /obj/item/weapon/robot_assembly/firstaid_arm
		if(istype(src,/obj/item/weapon/storage/firstaid/fire))
			A.skin = "ointment"
		else if(istype(src, /obj/item/weapon/storage/firstaid/toxin))
			A.skin = "tox"
		else if(istype(src, /obj/item/weapon/storage/firstaid/o2))
			A.skin = "o2"
		else if(istype(src, /obj/item/weapon/storage/firstaid/adv))
			A.skin = "bezerk"

		A.loc = user
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = A
		else
			user.u_equip(S)
			user.l_hand = A
		A.layer = 20
		user << "You add the robot arm to the first aid kit"
		del(S)
		del(src)


/obj/item/weapon/storage/box/syringes
	name = "Syringes (Biohazard Alert)"
	icon_state = "syringe"

/obj/item/weapon/storage/box/syringes/New()
	..()
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	new /obj/item/weapon/reagent_containers/syringe(src)
	return

/obj/item/weapon/storage/pill_bottle
	name = "Pill bottle"
	icon_state = "pill_canister"
	icon = 'chemical.dmi'
	item_state = "contsolid"
	can_hold = list("/obj/item/weapon/reagent_containers/pill")
	w_class = 2

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "Pill bottle (kelotane)"
	desc = "Contains pills used to treat burns."

/obj/item/weapon/storage/pill_bottle/kelotane/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)


/obj/item/weapon/storage/pill_bottle/antitox
	name = "Pill bottle (anti-toxin)"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/antitox/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)


/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "Pill bottle (inaprovaline)"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/inaprovaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)


/obj/item/weapon/storage/pill_bottle/dexalin
	name = "Pill bottle (dexalin)"
	desc = "Contains pills used to treat oxygen deprivation."

/obj/item/weapon/storage/pill_bottle/dexalin/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin(src)


// OP pill bottles for Advanced First Aid Kit

/obj/item/weapon/storage/pill_bottle/dexalinp
	name = "Pill bottle (dexalin plus)"
	desc = "Contains pills used to treat oxygen deprivation."

/obj/item/weapon/storage/pill_bottle/dexalinp/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)
	new /obj/item/weapon/reagent_containers/pill/dexalinp(src)


/obj/item/weapon/storage/pill_bottle/dermaline
	name = "Pill bottle (dermaline)"
	desc = "Contains pills used to treat burns."

/obj/item/weapon/storage/pill_bottle/dermaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)


/obj/item/weapon/storage/pill_bottle/other/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/ryetalyn(src)
	new /obj/item/weapon/reagent_containers/pill/ryetalyn(src)
	new /obj/item/weapon/reagent_containers/pill/alkysine(src)
	new /obj/item/weapon/reagent_containers/pill/alkysine(src)
	new /obj/item/weapon/reagent_containers/pill/imidazoline(src)
	new /obj/item/weapon/reagent_containers/pill/imidazoline(src)
	new /obj/item/weapon/reagent_containers/pill/hyronalin(src)