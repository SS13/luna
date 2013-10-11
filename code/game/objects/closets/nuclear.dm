/obj/structure/closet/syndicate/nuclear
	desc = "Nuclear preparations closet."

/obj/structure/closet/syndicate/nuclear/New()
	..()
	sleep(2)
	new /obj/item/weapon/storage/box/handcuffs( src )
	new /obj/item/weapon/storage/box/grenades/flashbang( src )
	new /obj/item/weapon/gun/energy/gun( src )
	new /obj/item/weapon/gun/energy/gun( src )
	new /obj/item/weapon/gun/energy/gun( src )
	new /obj/item/weapon/gun/projectile/automatic/c20r( src )
	new /obj/item/weapon/gun/projectile/automatic/c20r( src )
	new /obj/item/weapon/plastique( src )
	new /obj/item/weapon/plastique( src )
	new /obj/item/weapon/pinpointer( src )
	new /obj/item/weapon/pinpointer( src )
	new /obj/item/weapon/pinpointer( src )
	new /obj/item/device/pda/syndicate( src )
	new /obj/item/device/uplink/radio( src )
	return
