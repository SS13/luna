////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "A tablet or capsule."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	volume = 100

	New()
		..()
		if(!icon_state)
			icon_state = "pill[rand(1,20)]"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/storage/pill_bottle))
			var/obj/item/weapon/storage/pill_bottle/S = W
			for (var/obj/item/weapon/reagent_containers/pill/G in src.loc)
				if (S.contents.len <= 7) S.contents += G
				else
					user << "\blue The pill bottle is full."
					return
		return

	attack_self(mob/user)
		return

	attack(mob/M, mob/user, def_zone)
		if(M == user)
			M << "<span class='notice'>You swallow [src].</span>"
			M.drop_from_inventory(src) //icon update
			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, reagents.total_volume)
					del(src)
			else
				del(src)
			return 1

		else if(istype(M, /mob/living/carbon/human) )
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to force [M] to swallow [src].", 1)

			if(!do_mob(user, M)) return

			user.drop_from_inventory(src) //icon update
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] forces [M] to swallow [src].", 1)

			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, reagents.total_volume)
					del(src)
			else
				del(src)

			return 1

		return 0

	afterattack(obj/target, mob/user , flag)
		if(target.is_open_container() != 0 && target.reagents)
			if(!target.reagents.total_volume)
				user << "<span class='notice'>[target] is empty. There's nothing to dissolve [src] in.</span>"
				return
			user << "<span class='notice'>You dissolve [src] in [target].</span>"
			for(var/mob/O in viewers(2, user))	//viewers is necessary here because of the small radius
				O << "<span class='warning'>[user] slips something into [target].</span>"
			reagents.trans_to(target, reagents.total_volume)
			spawn(5)
				del(src)


//Pills
/obj/item/weapon/reagent_containers/pill/antitox
	name = "anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	New()
		..()
		reagents.add_reagent("anti_toxin", 50)

/obj/item/weapon/reagent_containers/pill/tox
	name = "toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	New()
		..()
		reagents.add_reagent("toxin", 50)

/obj/item/weapon/reagent_containers/pill/cyanide
	name = "cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	New()
		..()
		reagents.add_reagent("cyanide", 30)

/obj/item/weapon/reagent_containers/pill/stox
	name = "sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("stoxin", 30)

/obj/item/weapon/reagent_containers/pill/kelotane
	name = "kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	New()
		..()
		reagents.add_reagent("kelotane", 30)

/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	New()
		..()
		reagents.add_reagent("inaprovaline", 30)

/obj/item/weapon/reagent_containers/pill/dexalin
	name = "dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("inaprovaline", 5)
		reagents.add_reagent("dexalin", 35)

/obj/item/weapon/reagent_containers/pill/bicaridine
	name = "bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent("bicaridine", 30)

// FOR ADV MEDKIT
/obj/item/weapon/reagent_containers/pill/dexalinp
	name = "dexalin plus pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("inaprovaline", 5)
		reagents.add_reagent("dexalinp", 35)

/obj/item/weapon/reagent_containers/pill/dermaline
	name = "dermaline pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	New()
		..()
		reagents.add_reagent("dermaline", 40)

/obj/item/weapon/reagent_containers/pill/ryetalyn
	name = "ryetalyn pill"
	desc = "Used to treat genetic abnomalities."
	icon_state = "pill15"
	New()
		..()
		reagents.add_reagent("ryetalyn", 10)

/obj/item/weapon/reagent_containers/pill/hyronalin
	name = "hyronalin pill"
	desc = "Used to treat radiation poisoning."
	icon_state = "pill12"
	New()
		..()
		reagents.add_reagent("hyronalin", 50)

/obj/item/weapon/reagent_containers/pill/alkysine
	name = "alkysine pill"
	desc = "Used to treat brain damage."
	icon_state = "pill9"
	New()
		..()
		reagents.add_reagent("alkysine", 20)

/obj/item/weapon/reagent_containers/pill/imidazoline
	name = "imidazoline pill"
	desc = "Used to treat eye damage."
	icon_state = "pill19"
	New()
		..()
		reagents.add_reagent("imidazoline", 50)

// FOR VIROLOGY
/obj/item/weapon/reagent_containers/pill/silver
	name = "silver pill"
	desc = "Shiny!"
	icon_state = "pill9"
	New()
		..()
		reagents.add_reagent("silver", 20)

/obj/item/weapon/reagent_containers/pill/gold
	name = "gold pill"
	desc = "Shiny!"
	icon_state = "pill7"
	New()
		..()
		reagents.add_reagent("gold", 20)


// FOR BADMINERY
/obj/item/weapon/reagent_containers/pill/nanites
	name = "nanites pill"
	desc = "Beep-bop!"
	icon_state = "pill17"
	New()
		..()
		reagents.add_reagent("nanites", 5)

/obj/item/weapon/reagent_containers/pill/xenomicrobes
	name = "xenomicrobes pill"
	desc = "Hissss..."
	icon_state = "pill11"
	New()
		..()
		reagents.add_reagent("xenomicrobes", 5)

/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("adminordrazine", 50)