/obj/secure_closet/medical	//Empty medical closet
	name = "Medical Closet"
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medical1"
	req_access = list(access_medical)


/obj/secure_closet/medicalcloset
	name = "Medical Closet"
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"
	req_access = list(access_medical)

/obj/secure_closet/medicalcloset/New()
	..()
	sleep(2)
	new /obj/item/device/pda/medical(src)
	new /obj/item/clothing/under/rank/medical( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/weapon/storage/box/stma( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/weapon/storage/belt/medical(src)
	new /obj/item/weapon/storage/backpack/medic(src)
	return


/obj/secure_closet/medical1
	name = "Medicine Closet"
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medical1"
	req_access = list(access_medical)

/obj/secure_closet/medical1/New()
	..()
	sleep(2)
	new /obj/item/weapon/storage/box/gl( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/stoxin( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/stoxin( src )
	new /obj/item/weapon/reagent_containers/glass/bottle/toxin( src )
	new /obj/item/weapon/storage/box/syringes( src )
	new /obj/item/weapon/reagent_containers/dropper( src )
	new /obj/item/weapon/reagent_containers/dropper( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	new /obj/item/weapon/reagent_containers/glass/beaker( src )
	return


/obj/secure_closet/medical3
	name = "Blood Freezer"
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medical1"
	req_access = list(access_medical)

/obj/secure_closet/medical3/New()
	..()
	sleep(2)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/A(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/B(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/O(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/AB(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/A(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/B(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/O(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/AB(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/A(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/B(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/O(src)
	new/obj/item/weapon/reagent_containers/glass/bloodpack/AB(src)
	return


/obj/secure_closet/medical2/New()
	..()
	sleep(2)
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/weapon/tank/anesthetic( src )
	new /obj/item/clothing/mask/medical( src )
	new /obj/item/clothing/mask/medical( src )
	new /obj/item/clothing/mask/medical( src )
	new /obj/item/clothing/mask/medical( src )
	return


/obj/secure_closet/hydro/New()
	..()
	sleep(2)
	new /obj/item/device/pda/hydro(src)
	new /obj/item/clothing/under/rank/hydroponics(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/weapon/storage/backpack(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/clothing/head/green_band(src)
	new /obj/item/clothing/suit/storage/apron(src)
	return
