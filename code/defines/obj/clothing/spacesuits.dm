/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments."
	icon_state = "space"
	gas_transfer_coefficient = 0.01
	item_state = "s_suit"
	flags = FPRINT | SUITSPACE | PLASMAGUARD
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02
	slowdown = 3

/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "space"
	flags = FPRINT | HEADSPACE | HEADCOVERSEYES | HEADCOVERSMOUTH | PLASMAGUARD
	see_face = 0.0
	item_state = "space"


obj/item/clothing/suit/space/ntsco
	name = "NT Special Combat Operations Suit"
	icon_state = "ntsco"
	item_state = "ntsco"


/* SYNDIE */
/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	desc = "Has a tag on it: Totally not property of an enemy corporation, honest."
	icon_state = "syndicate"
	item_state = "syndicate"

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	desc = "Has a tag on it: Totally not property of a hostile corporation, honest!"
	icon_state = "syndicate"
	item_state = "syndicate"
	slowdown = 0


/obj/item/clothing/head/helmet/space/syndicate/green
	name = "green space helmet"
	icon_state = "syndicate-helm-green"
	item_state = "syndicate-helm-green"

obj/item/clothing/suit/space/syndicate/green
	name = "green space suit"
	icon_state = "syndicate-green"
	item_state = "syndicate-green"


/obj/item/clothing/head/helmet/space/syndicate/blue
	name = "blue space helmet"
	icon_state = "syndicate-helm-blue"
	item_state = "syndicate-helm-blue"

obj/item/clothing/suit/space/syndicate/blue
	name = "blue space suit"
	icon_state = "syndicate-blue"
	item_state = "syndicate-blue"


/obj/item/clothing/head/helmet/space/syndicate/green
	name = "dark green space helmet"
	icon_state = "syndicate-helm-green-dark"
	item_state = "syndicate-helm-green-dark"

obj/item/clothing/suit/space/syndicate/green
	name = "dark green space suit"
	icon_state = "syndicate-green-dark"
	item_state = "syndicate-green-dark"


/obj/item/clothing/head/helmet/space/syndicate/black
	name = "black space helmet"
	icon_state = "syndicate-helm-black"
	item_state = "syndicate-helm-black"

obj/item/clothing/suit/space/syndicate/black
	name = "black space suit"
	icon_state = "syndicate-black"
	item_state = "syndicate-black"

/* NUKE */

/obj/item/clothing/head/helmet/space/syndicate/terror
	name = "black space helmet"
	icon_state = "syndicate-helm-black-red"
	item_state = "syndicate-helm-black-red"

obj/item/clothing/suit/space/syndicate/terror
	name = "black space suit"
	icon_state = "syndicate-black-red"
	item_state = "syndicate-black-red"


/obj/item/clothing/head/helmet/space/syndicate/tech
	name = "black space helmet"
	icon_state = "syndicate-helm-black-engie"
	item_state = "syndicate-helm-black-engie"
	var/brightness_on = 5 //luminosity when on
	var/on = 0
	attack_self(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return
		on = !on
		if(on)
			user.ul_SetLuminosity(user.luminosity + brightness_on)
			icon_state = "syndicate-helm-black-engie1"
			item_state = "syndicate-helm-black-engie1"
		else
			user.ul_SetLuminosity(user.luminosity - brightness_on)
			icon_state = "syndicate-helm-black-engie"
			item_state = "syndicate-helm-black-engie"

	pickup(mob/user)
		if(on)
			user.ul_SetLuminosity(user.luminosity + brightness_on)
			ul_SetLuminosity(0)

	dropped(mob/user)
		if(on)
			user.ul_SetLuminosity(user.luminosity - brightness_on)
			ul_SetLuminosity(brightness_on)

obj/item/clothing/suit/space/syndicate/tech
	name = "black space suit"
	icon_state = "syndicate-black-engie"
	item_state = "syndicate-black-engie"


/obj/item/clothing/head/helmet/space/syndicate/medic
	name = "black space helmet"
	icon_state = "syndicate-helm-black-med"
	item_state = "syndicate-helm-black-med"

obj/item/clothing/suit/space/syndicate/medic
	name = "black space suit"
	icon_state = "syndicate-black-med"
	item_state = "syndicate-black-med"