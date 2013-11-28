/obj/structure/closet/secure_closet/medical
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical)


/obj/structure/closet/secure_closet/medical/regular
	name = "medicine closet"
	desc = "Filled with medical junk."


	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/box/syringes(src)
		new /obj/item/weapon/reagent_containers/dropper(src)
		new /obj/item/weapon/reagent_containers/dropper(src)
		new /obj/item/weapon/reagent_containers/glass/beaker(src)
		if (prob(20)) new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		else new /obj/item/weapon/reagent_containers/glass/beaker(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/toxin( src )
		new /obj/item/weapon/reagent_containers/glass/bottle/stoxin( src )
		new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
		new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
		return



/obj/structure/closet/secure_closet/medical/anesthetic
	name = "anesthetic closet"
	desc = "Used to knock people out."


	New()
		..()
		sleep(2)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/weapon/tank/anesthetic(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		new /obj/item/clothing/mask/breath/medical(src)
		return

/obj/structure/closet/secure_closet/medical/blood
	name = "Blood Freezer"

/obj/structure/closet/secure_closet/medical/blood/New()
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


/obj/structure/closet/secure_closet/medicalcloset
	name = "medical doctor's locker"
	req_access = list(access_medical)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/medic(src)
//		new /obj/item/clothing/under/rank/nursesuit (src)
//		new /obj/item/clothing/head/nursehat (src)
		new /obj/item/clothing/under/rank/medical(src)
		new /obj/item/clothing/suit/storage/labcoat(src)
		new /obj/item/device/pda/medical(src)
		new /obj/item/weapon/storage/box/stma(src)
		if(prob(15)) new /obj/item/clothing/glasses/hud/health(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/clothing/shoes/white(src)
//		new /obj/item/weapon/cartridge/medical(src)
		new /obj/item/device/radio/headset/headset_med(src)
		new /obj/item/weapon/storage/belt/medical(src)
		return


/*obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

	New()
		..()
		sleep(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/medic(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_med(src)
		new /obj/item/clothing/suit/bio_suit/cmo(src)
		new /obj/item/clothing/head/bio_hood/cmo(src)
		new /obj/item/clothing/under/rank/chief_medical_officer(src)
		new /obj/item/clothing/suit/labcoat/cmo(src)
		new /obj/item/weapon/cartridge/cmo(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/clothing/shoes/brown	(src)
		new /obj/item/device/radio/headset/heads/cmo(src)
		new /obj/item/weapon/storage/belt/medical(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/hypospray(src)
		return*/



/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_chemistry)


	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/box/pillbottle(src)
		new /obj/item/weapon/storage/box/pillbottle(src)
		return

/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/medical_wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened