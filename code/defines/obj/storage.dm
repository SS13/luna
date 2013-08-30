/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "backpack"
	w_class = 4.0
	flags = 259.0

/obj/item/weapon/storage/backpack/clown
	name = "Giggles Von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/weapon/storage/backpack/medic
	name = "Medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/security
	name = "Security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/industrial
	name = "Industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"

/obj/item/weapon/storage/backpack/captain
	name = "Captain's backpack"
	desc = "It's a special backpack made exclusively for Nanotrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"

/obj/item/weapon/storage/box
	name = "Box"
	icon_state = "box"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap

/obj/item/weapon/storage/box/glass
	name = "Glassware Box"
	icon_state = "beakerbox"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/glass/New()
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	..()
	return

/obj/item/weapon/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	can_hold = list("/obj/item/weapon/reagent_containers/food/snacks/monkeycube")
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)

/obj/item/weapon/storage/briefcase
	name = "briefcase"
	icon_state = "briefcase"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0

/obj/item/weapon/storage/box/disk
	name = "Data Disks"
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/disk/disks

/obj/item/weapon/storage/box/disk/disks2

/obj/item/weapon/storage/box/fcard
	name = "Fingerprint Cards"
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/fcard/New()
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	new /obj/item/weapon/f_card( src )
	..()
	return

/obj/item/weapon/storage/box/grenades
	icon_state = "flashbang"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/grenades/teargas
	name = "Tear gas grenades (WARNING)"
	desc = "<FONT color=red><B>WARNING: Do not use without reading these preautions!</B></FONT>\n<B>WARNING: These devices are extremely dangerous and can cause blindness and skin irritation.</B>\nThe chemicals contained in these devices have been tuned for maximal effectiveness and due to extreme safety precuaiotn shave been incased in a tamper-proof pack. DO NOT ATTEMPT TO OPEN \n<B>DO NOT USE CONTINUALLY</B>\nOperating Directions:\n\t1. Pull detonnation pin. <B>ONCE THE PIN IS PULLED THE GRENADE CAN NOT BE DISARMED!</B>\n\t2. Throw grenade. <B>NEVER HOLD A LIVE FLASHBANG</B>\n\t3. The grenade will detonste 10 seconds hafter being primed. <B>EXCERCISE CAUTION</B>\n\t-<B>Never prime another grenade until after the first is detonated</B>"

	New()
		..()
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)

/obj/item/weapon/storage/box/grenades/flashbang
	desc = "<FONT color=red><B>WARNING: Do not use without reading these preautions!</B></FONT>\n<B>These devices are extremely dangerous and can cause blindness or deafness if used incorrectly.</B>\nThe chemicals contained in these devices have been tuned for maximal effectiveness and due to extreme safety precuaiotn shave been incased in a tamper-proof pack. DO NOT ATTEMPT TO OPEN\nFLASH WARNING: Do not use continually. Excercise extreme care when detonating in closed spaces.\n\tMake attemtps not to detonate withing range of 2 meters of the intended target. It is imperative\n\tthat the targets visit a medical professional after usage. Damage to eyes increases extremely per\n\tuse and according to range. Glasses with flash resistant filters DO NOT always work on high powered\n\tflash devices such as this. <B>EXERCISE CAUTION REGARDLESS OF CIRCUMSTANCES</B>\nSOUND WARNING: Do not use continually. Visit a medical professional if hearing is lost.\n\tThere is a slight chance per use of complete deafness. Exercise caution and restraint.\nSTUN WARNING: If the intended or unintended target is too close to detonation the resulting sound\n\tand flash have been known to cause extreme sensory overload resulting in temporary\n\tincapacitation.\n<B>DO NOT USE CONTINUALLY</B>\nOperating Directions:\n\t1. Pull detonnation pin. <B>ONCE THE PIN IS PULLED THE GRENADE CAN NOT BE DISARMED!</B>\n\t2. Throw grenade. <B>NEVER HOLD A LIVE FLASHBANG</B>\n\t3. The grenade will detonste 10 seconds hafter being primed. <B>EXCERCISE CAUTION</B>\n\t-<B>Never prime another grenade until after the first is detonated</B>\nNote: Usage of this pyrotechnic device without authorization is an extreme offense and can\nresult in severe punishment upwards of <B>10 years in prison per use</B>.\n\nDefault 3 second wait till from prime to detonation. This can be switched with a screwdriver\nto 10 seconds.\n\nCopyright of NanoTrasen Industries- Military Armnaments Division\nThis device was created by NanoTrasen Labs a member of the Expert Advisor Corporation"
	name = "Flashbangs (WARNING)"

/obj/item/weapon/storage/box/grenades/flashbang/New()
	new /obj/item/weapon/grenade/flashbang( src )
	new /obj/item/weapon/grenade/flashbang( src )
	new /obj/item/weapon/grenade/flashbang( src )
	new /obj/item/weapon/grenade/flashbang( src )
	new /obj/item/weapon/grenade/flashbang( src )
	new /obj/item/weapon/grenade/flashbang( src )
	new /obj/item/weapon/grenade/flashbang( src )
	..()
	return

/obj/item/weapon/storage/box/grenades/emp
	desc = "A box with 5 emp grenades."
	name = "EMP grenades"

/obj/item/weapon/storage/box/grenades/emp/New()
	new /obj/item/weapon/grenade/emp( src )
	new /obj/item/weapon/grenade/emp( src )
	new /obj/item/weapon/grenade/emp( src )
	new /obj/item/weapon/grenade/emp( src )
	new /obj/item/weapon/grenade/emp( src )
	..()
	return

/obj/item/weapon/storage/box/grenades/metalfoam
	desc = "A box with 5 metal foam grenades."
	name = "Metal foam grenades"

	New()
		..()
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)

/obj/item/weapon/storage/box/grenades/cleaner
	desc = "A box with 5 cleaner grenades."
	name = "Cleaner grenades"

/obj/item/weapon/storage/box/grenades/cleaner/New()
	new /obj/item/weapon/grenade/chem_grenade/cleaner( src )
	new /obj/item/weapon/grenade/chem_grenade/cleaner( src )
	new /obj/item/weapon/grenade/chem_grenade/cleaner( src )
	new /obj/item/weapon/grenade/chem_grenade/cleaner( src )
	new /obj/item/weapon/grenade/chem_grenade/cleaner( src )
	..()
	return

/obj/item/weapon/storage/box/gl
	name = "Prescription Glasses"
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/gl/New()
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/glasses/regular( src )
	..()
	return

/obj/item/weapon/storage/box/handcuff
	name = "Spare Handcuffs"
	icon_state = "handcuff"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/handcuff/New()
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	new /obj/item/weapon/handcuffs( src )
	..()
	return

/obj/item/weapon/storage/box/id
	name = "Spare IDs"
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/id/New()
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	new /obj/item/weapon/card/id( src )
	..()
	return

/obj/item/weapon/storage/box/lglo
	name = "Latex Gloves"
	icon_state = "latex"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/lglo/New()
	new /obj/item/clothing/gloves/latex( src )
	new /obj/item/clothing/gloves/latex( src )
	new /obj/item/clothing/gloves/latex( src )
	new /obj/item/clothing/gloves/latex( src )
	new /obj/item/clothing/gloves/latex( src )
	new /obj/item/clothing/gloves/latex( src )
	new /obj/item/clothing/gloves/latex( src )
	..()
	return

/obj/item/weapon/storage/box/dna_inject
	name = "DNA-Injectors"
	icon_state = "syringe"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/dna_inject/New()
	new /obj/item/weapon/dnainjector/h2m( src )
	new /obj/item/weapon/dnainjector/h2m( src )
	new /obj/item/weapon/dnainjector/h2m( src )
	new /obj/item/weapon/dnainjector/m2h( src )
	new /obj/item/weapon/dnainjector/m2h( src )
	new /obj/item/weapon/dnainjector/m2h( src )
	..()
	return

/obj/item/weapon/storage/box/stma
	name = "Sterile Masks"
	icon_state = "sterile"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/stma/New()
	new /obj/item/clothing/mask/surgical( src )
	new /obj/item/clothing/mask/surgical( src )
	new /obj/item/clothing/mask/surgical( src )
	new /obj/item/clothing/mask/surgical( src )
	new /obj/item/clothing/mask/surgical( src )
	new /obj/item/clothing/mask/surgical( src )
	new /obj/item/clothing/mask/surgical( src )
	..()
	return

/obj/item/weapon/storage/box/trackimp_kit
	name = "Tracking Implant Kit"
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/trackimp_kit/New()
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implantcase/tracking( src )
	new /obj/item/weapon/implanter( src )
	new /obj/item/weapon/implantpad( src )
	new /obj/item/weapon/locator( src )
	..()

	return

/obj/item/weapon/storage/box/chemimp_kit
	name = "Chemical Implant Kit"
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/chemimp_kit/New()
	new /obj/item/weapon/implantcase/chem( src )
	new /obj/item/weapon/implantcase/chem( src )
	new /obj/item/weapon/implantcase/chem( src )
	new /obj/item/weapon/implantcase/chem( src )
	new /obj/item/weapon/implantcase/chem( src )
	new /obj/item/weapon/implanter( src )
	new /obj/item/weapon/implantpad( src )
	..()

	return


/obj/item/weapon/storage/box/daimp_kit
	name = "Death Alarm Implant Kit"
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/daimp_kit/New()
	new /obj/item/weapon/implantcase/death_alarm( src )
	new /obj/item/weapon/implantcase/death_alarm( src )
	new /obj/item/weapon/implantcase/death_alarm( src )
	new /obj/item/weapon/implantcase/death_alarm( src )
	new /obj/item/weapon/implantcase/death_alarm( src )
	new /obj/item/weapon/implanter( src )
	new /obj/item/weapon/implantpad( src )
	..()
	return

/obj/item/weapon/storage/box/mousetraps
	name = "Pest-B-Gon Mousetraps"
	desc = "WARNING: Keep out of reach of children."
	icon_state = "mousetraps"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/mousetraps/New()
	new /obj/item/weapon/mousetrap( src )
	new /obj/item/weapon/mousetrap( src )
	new /obj/item/weapon/mousetrap( src )
	new /obj/item/weapon/mousetrap( src )
	new /obj/item/weapon/mousetrap( src )
	new /obj/item/weapon/mousetrap( src )
	..()
	return

/obj/item/weapon/storage/box/donkpocket
	name = "Donk-Pockets"
	desc = "Remember to fully heat prior to serving.  Product will cool if not eaten within seven minutes."
	icon_state = "donk_kit"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/donkpocket/New()
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket( src )
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket( src )
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket( src )
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket( src )
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket( src )
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket( src )
	..()
	return

/obj/item/weapon/storage/bible
	name = "bible"
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	var/mob/affecting = null