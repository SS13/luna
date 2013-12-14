/datum/game_mode/proc/equip_syndicate(mob/living/carbon/human/synd_mob)

	synd_mob.equip_if_possible(new /obj/item/device/radio/headset/syndicate(synd_mob), synd_mob.slot_ears)

	synd_mob.equip_if_possible(new /obj/item/clothing/under/syndicate(synd_mob), synd_mob.slot_w_uniform)
	synd_mob.equip_if_possible(new /obj/item/clothing/shoes/black(synd_mob), synd_mob.slot_shoes)
	synd_mob.equip_if_possible(new /obj/item/clothing/gloves/swat(synd_mob), synd_mob.slot_gloves)

	synd_mob.equip_if_possible(new /obj/item/weapon/storage/backpack(synd_mob), synd_mob.slot_back)
	synd_mob.equip_if_possible(new /obj/item/weapon/reagent_containers/pill/cyanide(synd_mob), synd_mob.slot_in_backpack)

	synd_mob.update_clothing()