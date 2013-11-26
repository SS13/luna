/datum/game_mode/derelict
	name = "derelict"
	config_tag = "derelict"

/datum/game_mode/derelict/announce()
	world << "<B>The current game mode is - Derelict!</B>"

/datum/game_mode/derelict/pre_setup()
	world << "\red <B> Derelict takes time to load, please wait</B>"

	wreakstation()

	config.allow_ai = 0
	return 1


/datum/game_mode/derelict/post_setup()
	for(var/mob/living/carbon/human/player in world)
		equip_scavenger(player)

		var/list/L = list()
		for(var/area/shuttle/arrival/station/S in world)
			L += S
		var/A = pick(L)
		var/list/NL = list()
		for(var/turf/T in A)
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					NL += T
		player.loc = pick(NL)


/datum/game_mode/derelict/proc/equip_scavenger(var/mob/living/carbon/human/player)
	del player.wear_id
	del player.shoes
	del player.belt
	del player.gloves
	del player.glasses
	del player.head
	del player.wear_mask
	del player.ears
	del player.r_store
	del player.l_store
	del player.wear_suit
	del player.w_uniform

	player.equip_if_possible(new /obj/item/device/radio/headset(player), player.slot_ears)
	player.equip_if_possible(new /obj/item/clothing/suit/fire(player), player.slot_wear_suit)
	player.equip_if_possible(new /obj/item/clothing/under/color/black(player), player.slot_w_uniform)
	player.equip_if_possible(new /obj/item/clothing/mask/gas(player), player.slot_wear_mask)
	player.equip_if_possible(new /obj/item/weapon/tank/emergency_oxygen/engi(player), player.slot_l_store)
	player.equip_if_possible(new /obj/item/weapon/storage/belt/utility(player), player.slot_belt)
	player.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/red(player), player.slot_head)

	player.equip_if_possible(new /obj/item/weapon/storage/backpack(player), player.slot_back)
	player.equip_if_possible(new /obj/item/weapon/storage/box/circuity(player), player.slot_in_backpack)
	player.equip_if_possible(new /obj/item/weapon/cell/high(player), player.slot_in_backpack)
	player.equip_if_possible(new /obj/item/weapon/cell/high(player), player.slot_in_backpack)

	player.wear_id = new /obj/item/weapon/card/id(player)
	player.wear_id.registered = player.real_name
	player.wear_id.assignment = "Scavenger"
	player.wear_id.name = "[player.real_name]'s Scavenger ID"
	player.wear_id.layer = 40

	if(prob(55)) player.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(player), player.slot_l_hand)
	else		 player.equip_if_possible(new /obj/item/weapon/storage/toolbox/electrical(player), player.slot_l_hand)

	if(prob(50)) player.equip_if_possible(new /obj/item/clothing/shoes/magnetic(player), player.slot_shoes)
	else		 player.equip_if_possible(new /obj/item/clothing/shoes/black(player), player.slot_shoes)

	if(prob(45)) player.equip_if_possible(new /obj/item/device/multitool(player), player.slot_r_store)

	if(prob(40)) player.equip_if_possible(new /obj/item/clothing/gloves/yellow(player), player.slot_gloves)

	player.update_clothing()

/datum/game_mode/derelict/latespawn(var/mob/living/carbon/human/player)
	equip_scavenger(player)

	var/list/L = list()
	for(var/area/shuttle/arrival/station/S in world)
		L += S
	var/A = pick(L)
	var/list/NL = list()
	for(var/turf/T in A)
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				NL += T
	player.loc = pick(NL)


/obj/item/weapon/storage/box/circuity
	name = "circuit box"
	icon_state = "circuit"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/circuity/New()
	new /obj/item/weapon/circuitboard/circuitry(src)
	new /obj/item/weapon/circuitboard/circuitry(src)
	new /obj/item/weapon/circuitboard/circuitry(src)
	new /obj/item/weapon/circuitboard/circuitry(src)
	new /obj/item/weapon/circuitboard/circuitry(src)
	new /obj/item/weapon/circuitboard/circuitry(src)
	new /obj/item/weapon/circuitboard/circuitry(src)
	..()
	return