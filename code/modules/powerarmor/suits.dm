/obj/item/clothing/suit/powered/spawnable
	New()
		servos = new /obj/item/weapon/powerarmorcomponent/servos(src)
		servos.parent = src
		reactive = new /obj/item/weapon/powerarmorcomponent/reactive/centcomm(src)
		reactive.parent = src
		atmoseal = new /obj/item/weapon/powerarmorcomponent/atmoseal/optional/adminbus(src)
		atmoseal.parent = src
		power = new /obj/item/weapon/powerarmorcomponent/power(src)
		power.parent = src

		verbs += /obj/item/clothing/suit/powered/proc/poweron

/obj/item/clothing/suit/powered/spawnable/badmin
	New()
		servos = new /obj/item/weapon/powerarmorcomponent/servos(src)
		servos.parent = src
		reactive = new /obj/item/weapon/powerarmorcomponent/reactive(src)
		reactive.parent = src
		atmoseal = new /obj/item/weapon/powerarmorcomponent/atmoseal/optional/adminbus(src)
		atmoseal.parent = src
		power = new /obj/item/weapon/powerarmorcomponent/power(src)
		power.parent = src

		verbs += /obj/item/clothing/suit/powered/proc/poweron


/obj/item/clothing/head/powered/spawnable
	name = "Powered armor"
	icon_state = "swat"
	desc = "Not for rookies."
	item_state = "swat"

	New()
		verbs += /obj/item/clothing/head/powered/proc/atmotoggle
		verbs += /obj/item/clothing/head/powered/proc/lightstoggle


//SYNDIE
/obj/item/clothing/head/powered/spawnable/syndie
	name = "Powered armor"
	icon_state = "powered0-syndie"
	desc = "Not for rookies."
	item_color = "syndie"

/obj/item/clothing/suit/powered/spawnable/syndie
	name = "Powered armor"
	icon_state = "powered-syndie"
	desc = "Not for rookies."


//DEATHSQUAD
/obj/item/clothing/head/powered/spawnable/deathsquad
	name = "Powered armor"
	icon_state = "powered0-deathsquad"
	desc = "Not for rookies."
	item_color = "deathsquad"

/obj/item/clothing/suit/powered/spawnable/deathsquad
	name = "Powered armor"
	icon_state = "powered-deathsquad"
	desc = "Not for rookies."