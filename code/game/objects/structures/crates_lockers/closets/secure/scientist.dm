/obj/structure/closet/secure_closet/scientist
	name = "Scientist's locker"
	req_access = list(access_tox_storage)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

	New()
		..()
		sleep(2)
		new /obj/item/weapon/tank/oxygen( src )
		new /obj/item/device/pda/toxins(src)
		new /obj/item/clothing/mask/gas( src )
		new /obj/item/clothing/under/rank/scientist( src )
		new /obj/item/clothing/shoes/white( src )
		new /obj/item/clothing/gloves/latex( src )
		new /obj/item/clothing/suit/storage/labcoat(src)
		new /obj/item/device/radio/headset/headset_sci(src)
		return



/obj/structure/closet/secure_closet/rd
	name = "Research Director's locker"
	req_access = list(access_heads)
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/under/rank/research_director(src)
		new /obj/item/clothing/suit/storage/labcoat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/gloves/latex(src)
		new /obj/item/device/radio/headset/heads/rd(src)
		new /obj/item/weapon/tank/oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/device/flash(src)
		new /obj/item/device/pda/heads/rd(src)
		new /obj/item/clothing/glasses/regular(src)
		new /obj/item/weapon/storage/backpack(src)
		return



/obj/structure/closet/secure_closet/animal
	name = "Animal Control"
	req_access = list(access_medical)

	New()
		..()
		sleep(2)
		new /obj/item/device/assembly/signaler(src)
		new /obj/item/device/radio/electropack(src)
		new /obj/item/device/radio/electropack(src)
		new /obj/item/device/radio/electropack(src)
		new /obj/item/device/radio/electropack(src)
		new /obj/item/device/radio/electropack(src)
		return

/obj/structure/closet/secure_closet/animal/toxins
	req_access = list(access_tox_storage)



/obj/structure/closet/secure_closet/chem
	name = "Chemist's locker"
	icon_state = "securechem1"
	icon_closed = "securechem"
	icon_locked = "securechem1"
	icon_opened = "secureresopen"
	icon_broken = "securechembroken"
	icon_off = "securechemoff"
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chem/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/device/pda/chem(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/shoes/brown(src)
//	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/weapon/storage/backpack(src)
	return



/obj/structure/closet/secure_closet/robot
	name = "Robotist's locker"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_robotics)

/obj/structure/closet/secure_closet/robot/New()
	..()
	sleep(2)
	new /obj/item/device/pda/robot(src)
	new /obj/item/clothing/under/rank/roboticist( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/weapon/storage/box/lglo( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_rob(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/weapon/storage/backpack(src)
	return



/obj/structure/closet/secure_closet/genetics
	name = "Genetic's Closet"
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"
	req_access = list(access_medlab)

/obj/structure/closet/secure_closet/genetics/New()
    ..()
    sleep(2)
    new /obj/item/device/pda/gene(src)
    new /obj/item/clothing/under/rank/geneticist( src )
    new /obj/item/clothing/shoes/white( src )
    new /obj/item/weapon/storage/box/stma( src )
    new /obj/item/clothing/suit/storage/labcoat(src)
    new /obj/item/device/radio/headset/headset_medsci(src)
    new /obj/item/clothing/gloves/latex(src)
    new /obj/item/weapon/storage/belt/medical(src)
    new /obj/item/weapon/storage/backpack/medic(src)
    return