/obj/structure/closet/syndicate/personal
	desc = "gear closet"

/obj/structure/closet/syndicate/personal/New()
	..()
	sleep(2)
	new /obj/item/weapon/storage/belt/syndie(src)
	new /obj/item/weapon/tank/jetpack/syndie(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/under/syndicate(src)
	new /obj/item/clothing/head/helmet/space/syndicate/terror(src)
	new /obj/item/clothing/suit/space/syndicate/terror(src)
	new /obj/item/weapon/cell(src)
	new /obj/item/weapon/card/id/syndicate(src)