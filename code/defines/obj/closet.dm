/*obj/structure/closet/portal
	desc = "It's a closet!"
	name = "Closet"
	icon = 'closet.dmi'
	icon_state = "closed"
	density = 1
	anchored = 1
	var/id
	var/t_id
	var/locked = 1
	var/turf/target = null
	var/obj/structure/closet/portal/link = null
	req_access = list(access_captain)
	flags = FPRINT*/


/obj/spresent
	desc = "It's a ... present?"
	name = "strange present"
	icon = 'items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

/obj/structure/closet/gmcloset
	desc = "A bulky (yet mobile) closet. Comes with formal clothes"
	name = "formal closet"

/obj/structure/closet/jcloset
	desc = "A bulky (yet mobile) closet. Comes with janitor's clothes and biohazard gear."
	name = "custodial closet"

/obj/structure/closet/jcloset/New()
	..()
	sleep(2)
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/storage/box/grenades/cleaner(src)
	new /obj/item/weapon/storage/box/grenades/cleaner(src)
	new /obj/item/weapon/reagent_containers/glass/bucket(src)


/obj/structure/closet/lawcloset
	desc = "A bulky (yet mobile) closet. Comes with lawyer apparel and items."
	name = "legal closet"

/obj/structure/closet/coffin
	desc = "A burial receptacle for the dearly departed."
	name = "coffin"
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"

/obj/structure/closet/syndicate
	desc = "Syndicate preparations closet."
	name = "weapons closet"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/toolcloset
	desc = "Tools closet."
	name = "tools closet"
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/toolcloset/New()
	..()
	if(prob(10)) new /obj/item/clothing/gloves/yellow(src)
	if(prob(20)) new /obj/item/weapon/storage/belt/utility(src)
	if(prob(30)) new /obj/item/device/multitool(src)

	if(prob(80)) new /obj/item/weapon/storage/toolbox/mechanical(src)
	else		 new /obj/item/weapon/storage/toolbox/electrical(src)

	if(prob(50)) new /obj/item/weapon/cable_coil(src,30)
	if(prob(30)) new /obj/item/clothing/head/helmet/hardhat(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/flashlight(src)
	return

/obj/structure/closet/thunderdome
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	name = "thunderdome closet"
	anchored = 1

/obj/structure/closet/thunderdome/tdgreen
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/malf/suits
	desc = "Gear preperations closet."
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"