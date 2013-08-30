/obj/item/weapon/reagent_containers/glass/bloodpack/
	name = "Blood Pack"
	desc = "A plastic bag of blood."
	icon = 'bloodpack.dmi'
	icon_state = "bloodpack_100"
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	volume = 100


	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_hand()
		..()
		update_icon()

/obj/item/weapon/reagent_containers/glass/bloodpack/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 9)			icon_state = "bloodpack_0"
		if(10 to 30)		icon_state = "bloodpack_20"
		if(31 to 50) 		icon_state = "bloodpack_40"
		if(51 to 70) 		icon_state = "bloodpack_60"
		if(71 to 90) 		icon_state = "bloodpack_90"
		if(91 to INFINITY)	icon_state = "bloodpack_100"


/obj/item/weapon/reagent_containers/glass/bloodpack/A
	name = "Blood Pack A"
	desc = "A plastic bag of blood with a sticker that says A."

	New()
		..()
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = volume
		B.data["blood_type"] = "A"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		reagents.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/B
	name = "Blood Pack B"
	desc = "A plastic bag of blood with a sticker that says B."

	New()
		..()
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = volume
		B.data["blood_type"] = "B"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		reagents.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/O
	name = "Blood Pack O"
	desc = "A plastic bag of blood with a sticker that says O."

	New()
		..()
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = volume
		B.data["blood_type"] = "O"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		reagents.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/AB
	name = "Blood Pack AB"
	desc = "A plastic bag of blood with a sticker that says AB."

	New()
		..()
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = volume
		B.data["blood_type"] = "AB"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		reagents.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/empty
	name = "Blood Pack"
	desc = "A plastic bag for blood. This one is empty"
	icon_state = "bloodpack_0"