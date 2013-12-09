/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "backpack"
	w_class = 4
	slot_flags = SLOT_BACK

/obj/item/weapon/storage/backpack/clown
	name = "Giggles Von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"

/obj/item/weapon/storage/backpack/captain
	name = "Captain's backpack"
	desc = "It's a special backpack made exclusively for Nanotrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"

/obj/item/weapon/storage/backpack/toy
	name = "toy backpack"
	icon = 'tank.dmi'
	desc = "You can look like a real spessman with it! Now with blinking lights!"
	icon_state = "jetpack1_s"
	item_state = "jetpack1_s"


/obj/item/weapon/storage/box
	name = "box"
	icon_state = "box"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap


/obj/item/weapon/storage/box/healthsensors
	name = "health sensors box"
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/healthsensors/New()
	new /obj/item/device/assembly/health(src)
	new /obj/item/device/assembly/health(src)
	new /obj/item/device/assembly/health(src)
	new /obj/item/device/assembly/health(src)
	new /obj/item/device/assembly/health(src)
	new /obj/item/device/assembly/health(src)
	new /obj/item/device/assembly/health(src)
	..()
	return

/obj/item/weapon/storage/box/glass
	name = "glassware box"
	icon_state = "beakerbox"

/obj/item/weapon/storage/box/glass/New()
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
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
	flags = FPRINT | CONDUCT
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0

/obj/item/weapon/storage/box/disk
	name = "data disks"
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/disk/disks

/obj/item/weapon/storage/box/disk/disks2

/obj/item/weapon/storage/box/fcard
	name = "fingerprint Cards"
	icon_state = "id"

/obj/item/weapon/storage/box/fcard/New()
	new /obj/item/weapon/f_card(src)
	new /obj/item/weapon/f_card(src)
	new /obj/item/weapon/f_card(src)
	new /obj/item/weapon/f_card(src)
	new /obj/item/weapon/f_card(src)
	new /obj/item/weapon/f_card(src)
	new /obj/item/weapon/f_card(src)
	..()
	return

/obj/item/weapon/storage/box/grenades
	icon_state = "flashbang"

/obj/item/weapon/storage/box/grenades/teargas
	name = "tear gas grenades (WARNING)"
	desc = "<FONT color=red><B>WARNING: Do not use without reading these preautions!</B></FONT>\n<B>WARNING: These devices are extremely dangerous and can cause blindness and skin irritation.</B>\nThe chemicals contained in these devices have been tuned for maximal effectiveness and due to extreme safety precuaiotn shave been incased in a tamper-proof pack. DO NOT ATTEMPT TO OPEN \n<B>DO NOT USE CONTINUALLY</B>\nOperating Directions:\n\t1. Pull detonnation pin. <B>ONCE THE PIN IS PULLED THE GRENADE CAN NOT BE DISARMED!</B>\n\t2. Throw grenade. <B>NEVER HOLD A LIVE GRENADE</B>\n\t3. The grenade will detonate 10 seconds after being primed. <B>EXCERCISE CAUTION</B>\n\t-<B>Never prime another grenade until after the first is detonated</B>"

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
	name = "flashbangs (WARNING)"

/obj/item/weapon/storage/box/grenades/flashbang/New()
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/grenade/flashbang(src)
	..()
	return

/obj/item/weapon/storage/box/grenades/emp
	desc = "A box with 5 emp grenades."
	name = "EMP grenades"

/obj/item/weapon/storage/box/grenades/emp/New()
	new /obj/item/weapon/grenade/emp(src)
	new /obj/item/weapon/grenade/emp(src)
	new /obj/item/weapon/grenade/emp(src)
	new /obj/item/weapon/grenade/emp(src)
	new /obj/item/weapon/grenade/emp(src)
	..()
	return

/obj/item/weapon/storage/box/grenades/metalfoam
	desc = "A box with 5 metal foam grenades."
	name = "metal foam grenades"

	New()
		..()
		new /obj/item/weapon/grenade/chem_grenade/metalfoam(src)
		new /obj/item/weapon/grenade/chem_grenade/metalfoam(src)
		new /obj/item/weapon/grenade/chem_grenade/metalfoam(src)
		new /obj/item/weapon/grenade/chem_grenade/metalfoam(src)
		new /obj/item/weapon/grenade/chem_grenade/metalfoam(src)

/obj/item/weapon/storage/box/grenades/cleaner
	desc = "A box with 5 cleaner grenades."
	name = "cleaner grenades"

/obj/item/weapon/storage/box/grenades/cleaner/New()
	new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
	new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
	new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
	new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
	new /obj/item/weapon/grenade/chem_grenade/cleaner(src)
	..()
	return

/obj/item/weapon/storage/box/gl
	name = "prescription glasses"
	icon_state = "id"

/obj/item/weapon/storage/box/gl/New()
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	..()
	return

/obj/item/weapon/storage/box/handcuffs
	name = "spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

/obj/item/weapon/storage/box/handcuffs/New()
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	..()
	return

/obj/item/weapon/storage/box/id
	name = "spare IDs"
	icon_state = "id"

/obj/item/weapon/storage/box/id/New()
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	new /obj/item/weapon/card/id(src)
	..()
	return

/obj/item/weapon/storage/box/lglo
	name = "latex gloves"
	icon_state = "latex"

/obj/item/weapon/storage/box/lglo/New()
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	..()
	return

/obj/item/weapon/storage/box/dna_inject
	name = "DNA-injectors"
	icon_state = "syringe"

/obj/item/weapon/storage/box/dna_inject/New()
	new /obj/item/weapon/dnainjector/h2m(src)
	new /obj/item/weapon/dnainjector/h2m(src)
	new /obj/item/weapon/dnainjector/h2m(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	new /obj/item/weapon/dnainjector/m2h(src)
	..()
	return

/obj/item/weapon/storage/box/stma
	name = "sterile masks"
	icon_state = "sterile"

/obj/item/weapon/storage/box/stma/New()
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	..()
	return

/obj/item/weapon/storage/box/imp_kit
	icon_state = "implant"

/obj/item/weapon/storage/box/imp_kit/track
	name = "Tracking Implant Kit"

/obj/item/weapon/storage/box/imp_kit/track/New()
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)
	new /obj/item/weapon/locator(src)
	..()

	return

/obj/item/weapon/storage/box/imp_kit/chem
	name = "Chemical Implant Kit"

/obj/item/weapon/storage/box/imp_kit/chem/New()
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)
	..()

	return


/obj/item/weapon/storage/box/imp_kit/da
	name = "Death Alarm Implant Kit"

/obj/item/weapon/storage/box/imp_kit/da/New()
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)
	..()
	return

/obj/item/weapon/storage/box/mousetraps
	name = "Pest-B-Gon mousetraps"
	desc = "WARNING: Keep out of reach of children."
	icon_state = "mousetraps"

/obj/item/weapon/storage/box/mousetraps/New()
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	new /obj/item/device/assembly/mousetrap(src)
	..()
	return

/obj/item/weapon/storage/box/donkpocket
	name = "Donk-Pockets"
	desc = "Remember to fully heat prior to serving.  Product will cool if not eaten within seven minutes."
	icon_state = "donk_kit"

/obj/item/weapon/storage/box/donkpocket/New()
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)
	..()
	return

/obj/item/weapon/storage/bible
	name = "bible"
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	var/mob/affecting = null