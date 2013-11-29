/client/proc/cmd_admin_deghostize(var/mob/dead/M in world)
	set category = "Debug"
	set name = "Deghostize"

	if(!ticker)
		alert("Wait until the game starts")
		return

	var/rank = input("What rank would you like to give to new char?") in list(
	"Unassigned",
	"Engineer",
	"Security Officer",
	"Forensic Technician",
	"Geneticist",
	"Scientist",
	"Atmospheric Technician",
	"Medical Doctor",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Counselor",
	"Roboticist",
	"Hydroponicist",
	"Barman",
	"Chef",
	"Janitor",
	"Chemist",
	"Warden",
	"Clown",
	"Mime",
	"Quartermaster",
	"Shaft Miner",
	"Cargo Technician")

	if(!rank) return

	if(istype(M, /mob/dead/observer))
		log_admin("[key_name(src)] has deghostized [M.key] into [rank].")
		spawn(10)
			M:Deghostize(rank)
	else
		alert("Ghostbusters Error")

/mob/dead/observer/proc/Deghostize(var/rank = "Unassigned")
	var/name = input("You has been respawned by admin. What name would you like to give to your new char?")
	if(!name) return 0

	var/mob/living/carbon/human/new_character = new /mob/living/carbon/human(loc)
	new_character.real_name = name
	new_character.name = name

	switch(rank)
		if ("Counselor")
			new_character.equip_if_possible(new /obj/item/device/pda/chaplain(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/chaplain(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/chaplain_hoodie(new_character), new_character.slot_wear_suit)

		if ("Geneticist")
			new_character.equip_if_possible(new /obj/item/device/pda/gene(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/geneticist(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/white(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_medsci, new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/medic(new_character), new_character.slot_back)

		if ("Chemist")
			new_character.equip_if_possible(new /obj/item/device/pda/chem(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/chemist(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/white(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_medsci(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/medic(new_character), new_character.slot_back)

		if ("Janitor")
			new_character.equip_if_possible(new /obj/item/device/pda/janitor(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/janitor(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/galoshes(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Clown")
			new_character.equip_if_possible(new /obj/item/device/pda/clown(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/clown(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/mask/gas/clown_hat(new_character), new_character.slot_wear_mask)
			new_character.equip_if_possible(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/bikehorn(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/clown(new_character), new_character.slot_back)
			src.mutations += CLUMSY

		if ("Mime")
			new_character.equip_if_possible(new /obj/item/device/pda/mime(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/mime(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/mask/gas/mime(new_character), new_character.slot_wear_mask)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/latex(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/clothing/head/beret(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Engineer")
			new_character.equip_if_possible(new /obj/item/device/pda/engineering(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/engineer(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/orange(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(new_character), new_character.slot_l_hand)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/yellow(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/crowbar(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/device/t_scanner(new_character), new_character.slot_r_store)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_eng(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/hazard(new_character), new_character.slot_wear_suit)

		if ("Unassigned")
			new_character.equip_if_possible(new /obj/item/clothing/under/color/grey(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Forensic Technician")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_sec(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/device/pda/det(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/forensic_technician(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/brown(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/storage/box/fcard(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/fcardholder(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/gearharness(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/device/detective_scanner(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/lighter/zippo(new_character), new_character.slot_l_store)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/security(new_character), new_character.slot_back)

		if ("Medical Doctor")
			new_character.equip_if_possible(new /obj/item/device/pda/medical(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/medical(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/white(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(new_character), new_character.slot_l_hand)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_med(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/medic(new_character), new_character.slot_back)

		if ("Captain")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/heads/captain(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/device/pda/heads/captain(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/captain(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/brown(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(new_character), new_character.slot_glasses)
			new_character.equip_if_possible(new /obj/item/weapon/gun/energy/taser(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/storage/box/id(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/green(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/captain(new_character), new_character.slot_back)

		if ("Security Officer")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_sec(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/device/pda/security(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/color/red(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/jackboots(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/weapon/handcuffs(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/handcuffs(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/clothing/head/helmet/secsoft(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/red(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/security(new_character), new_character.slot_back)

		if ("Scientist")
			new_character.equip_if_possible(new /obj/item/device/pda/toxins(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/scientist(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/white(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/clothing/mask/gas(new_character), new_character.slot_wear_mask)
			new_character.equip_if_possible(new /obj/item/weapon/tank/air(new_character), new_character.slot_l_hand)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_sci(new_character),new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Head of Security")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/heads/hos(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/device/pda/heads/hos(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/head_of_security(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/armor/hos(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/jackboots(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/head/helmet/HoS(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/security(new_character), new_character.slot_back)

		if ("Head of Personnel")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/heads/hop(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/device/pda/heads/hop(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/head_of_personnel(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/suit/armor/vest(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/brown(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/head/helmet(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/weapon/gun/energy/taser(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/storage/box/id(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Warden")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_sec(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/device/pda/warden(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/warden(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/suit/warden_jacket(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/jackboots(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/security(new_character), new_character.slot_back)

		if ("Atmospheric Technician")
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_eng(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/atmospheric_technician(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(new_character), new_character.slot_l_hand)
			new_character.equip_if_possible(new /obj/item/weapon/crowbar(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/hazard(new_character), new_character.slot_wear_suit)

		if ("Barman")
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/bartender(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/device/pda/bar(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/suit/armor/vest(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/device/radio/headset(new_character),new_character.slot_ears)

		if ("Chef")
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/chef(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/device/pda/chef(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/head/chefhat(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/weapon/kitchen/rollingpin(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/device/radio/headset(new_character),new_character.slot_ears)

		if ("Roboticist")
			new_character.equip_if_possible(new /obj/item/device/pda/robot(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/roboticist(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/weapon/crowbar(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(new_character), new_character.slot_l_hand)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_rob,new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Hydroponicist")
			new_character.equip_if_possible(new /obj/item/device/pda/hydro(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/hydroponics(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/device/radio/headset(new_character),new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/clothing/head/greenbandana(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/apron(new_character), new_character.slot_wear_suit)

		if ("Quartermaster")
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/cargo(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/device/pda/quartermaster(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_cargo(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Cargo Technician")
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/cargotech(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/device/pda/cargo(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_cargo(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Chief Engineer")
			new_character.equip_if_possible(new /obj/item/device/pda/heads/ce(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/gloves/yellow(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/brown(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(new_character), new_character.slot_head)
			new_character.equip_if_possible(new /obj/item/clothing/glasses/meson(new_character), new_character.slot_glasses)
			new_character.equip_if_possible(new /obj/item/weapon/gun/energy/taser(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/chief_engineer(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/heads/ce(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/hazard(new_character), new_character.slot_wear_suit)

		if ("Research Director")
			new_character.equip_if_possible(new /obj/item/device/pda/heads/rd(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/brown(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/research_director(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(new_character), new_character.slot_wear_suit)
			new_character.equip_if_possible(new /obj/item/weapon/clipboard(new_character), new_character.slot_r_hand)
			new_character.equip_if_possible(new /obj/item/weapon/gun/energy/taser(new_character), new_character.slot_in_backpack)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/heads/rd(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack(new_character), new_character.slot_back)

		if ("Shaft Miner")
			new_character.equip_if_possible(new /obj/item/clothing/gloves/black(new_character), new_character.slot_gloves)
			new_character.equip_if_possible(new /obj/item/clothing/shoes/black(new_character), new_character.slot_shoes)
			new_character.equip_if_possible(new /obj/item/clothing/under/rank/miner(new_character), new_character.slot_w_uniform)
			new_character.equip_if_possible(new /obj/item/device/pda/miner(new_character), new_character.slot_belt)
			new_character.equip_if_possible(new /obj/item/device/radio/headset/headset_mine(new_character), new_character.slot_ears)
			new_character.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial(new_character), new_character.slot_back)
			new_character.equip_if_possible(new /obj/item/clothing/glasses/meson(new_character), new_character.slot_glasses)

	new_character.equip_if_possible(new /obj/item/device/radio/headset(new_character), new_character.slot_ears)

	var/obj/item/weapon/card/id/id = new /obj/item/weapon/card/id(new_character)
	id.registered = new_character.real_name
	id.assignment = rank
	id.access = get_access(rank)
	id.name = "[new_character.real_name]'s ID Card ([rank])"

	new_character.equip_if_possible(id,new_character.slot_wear_id)

	new_character.equip_if_possible(new /obj/item/device/pda(new_character), new_character.slot_belt)
	if (istype(new_character.belt, /obj/item/device/pda))
		new_character.belt:owner = new_character.real_name
		new_character.belt.name = "PDA-[new_character.real_name]"

	new_character.update_clothing()

	if(client)
		if(client.mob.mind)
			client.mob.mind.transfer_to(new_character)
		else
			client.mob = new_character
	spawn(10)
		del(src)
		return