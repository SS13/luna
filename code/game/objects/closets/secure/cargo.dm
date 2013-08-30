/obj/secure_closet/qm
	name = "Quartermaster's Closet"
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"
	req_access = list(access_cargo)

/obj/secure_closet/qm/New()
	..()
	sleep(2)
	new /obj/item/clothing/under/rank/qm( src )
	new /obj/item/device/pda/quartermaster(src)
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/weapon/hand_labeler ( src )
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/helmet/cargosoft(src)
	new /obj/item/clothing/shoes/brown(src)
	return


/obj/secure_closet/cargo
	name = "Cargo Technican's Closet"
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"
	req_access = list(access_cargo)

/obj/secure_closet/cargo/New()
	..()
	sleep(2)
	new /obj/item/clothing/under/rank/cargo( src )
	new /obj/item/device/pda/cargo(src)
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/weapon/hand_labeler ( src )
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/head/helmet/cargosoft(src)
	new /obj/item/clothing/shoes/brown(src)
	return


/obj/secure_closet/mining
	name = "Miner Closet"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(access_mining)

/obj/secure_closet/mining/New()
	..()
	sleep(2)
	new /obj/item/weapon/satchel/ore( src )
	new /obj/item/weapon/satchel/ore( src )
	if(prob(50))
		new /obj/item/weapon/pickaxe/drill( src )
	else
		new /obj/item/weapon/pickaxe( src )
		new /obj/item/weapon/shovel( src )
	new /obj/item/clothing/under/rank/miner( src )
	new /obj/item/device/pda/miner(src)
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/device/radio/headset/headset_mine(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/weapon/storage/backpack/industrial(src)
	new /obj/item/clothing/glasses/meson(src)
	return