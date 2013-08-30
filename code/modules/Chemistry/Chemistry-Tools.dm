// Bottles transfer 50 units
// Beakers transfer 30 units
// Syringes transfer 15 units
// Droppers transfer 5 units

//BUG!!!: reactions on splashing etc cause errors because stuff gets deleted before it executes.
//		  Bandaid fix using spawn - very ugly, need to fix this.

///////////////////////////////Grenades
/obj/item/weapon/grenade/chem_grenade
	name = "metal casing"
	icon_state = "chemg"
	force = 2.0
	var/stage = 0
	var/state = 0
	var/list/beakers = new/list()
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/assembly/time_ignite) && !stage)
			user << "\blue You add [W] to the metal casing."
			playsound(src.loc, 'Screwdriver2.ogg', 25, -3)
			del(W) //Okay so we're not really adding anything here. cheating.
			icon_state = "chemg_ass"
			name = "unsecured grenade"
			stage = 1
		else if(istype(W,/obj/item/weapon/screwdriver) && stage == 1)
			if(beakers.len)
				user << "\blue You lock the assembly."
				playsound(src.loc, 'Screwdriver.ogg', 25, -3)
				name = "grenade"
				icon_state = "chemg_locked"
				stage = 2
			else
				user << "\red You need to add at least one beaker before locking the assembly."
		else if (istype(W,/obj/item/weapon/reagent_containers/glass) && stage == 1)
			if(beakers.len == 2)
				user << "\red The grenade can not hold more containers."
				return
			else
				if(W.reagents.total_volume)
					user << "\blue You add \the [W] to the assembly."
					user.drop_item()
					W.loc = src
					beakers += W
				else
					user << "\red \the [W] is empty."

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (istype(target, /obj/item/weapon/storage)) return ..()
		if (!src.state && stage == 2)
			user << "\red You prime the grenade! 3 seconds!"
			src.state = 1
			src.icon_state = "chemg_active"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn(30)
				explode()
			user.drop_item()
			var/t = (isturf(target) ? target : target.loc)
			walk_towards(src, t, 3)

	attack_self(mob/user as mob)
		if (!src.state && stage == 2)
			user << "\red You prime the grenade! 3 seconds!"
			src.state = 1
			src.icon_state = "chemg_active"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn(30)
				explode()

	attack_hand()
		walk(src,0)
		return ..()
	attack_paw()
		return attack_hand()

	proc
		explode()
			var/has_reagents = 0
			for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
				if(G.reagents.total_volume) has_reagents = 1

			if(!has_reagents)
				playsound(src.loc, 'Screwdriver2.ogg', 50, 1)
				state = 0
				return

			playsound(src.loc, 'bamf.ogg', 50, 1)

			for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
				G.reagents.trans_to(src, G.reagents.total_volume)

			if(src.reagents.total_volume) //The possible reactions didnt use up all reagents.
				var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread()
				steam.set_up(10, 0, get_turf(src))
				steam.attach(src)
				steam.start()

				for(var/atom/A in view(3, src.loc))
					if( A == src ) continue
					src.reagents.reaction(A, 1, 10)


			invisibility = 100 //Why am i doing this?
			spawn(50)		   //To make sure all reagents can work
				del(src)	   //correctly before deleting the grenade.


/obj/item/weapon/grenade/chem_grenade/metalfoam
	name = "metal foam grenade"
	desc = "Used for emergency sealing of air breaches."
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("aluminium", 30)
		B2.reagents.add_reagent("foaming_agent", 10)
		B2.reagents.add_reagent("pacid", 10)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"


/obj/item/weapon/grenade/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 30)
		B2.reagents.add_reagent("water", 10)
		B2.reagents.add_reagent("cleaner", 10)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"


/obj/item/weapon/grenade/chem_grenade/teargas
	name = "teargas grenade"
	desc = "Used for nonlethal riot control. Contents under pressure. Do not directly inhale contents."
//	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("condensedcapsaicin", 25)
		B1.reagents.add_reagent("potassium", 25)
		B2.reagents.add_reagent("phosphorus", 25)
		B2.reagents.add_reagent("sugar", 25)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"

		//CreateDefaultTrigger(/obj/item/device/assembly/timer)

/*
/obj/item/weapon/grenade/chem_grenade/poo
	name = "poo grenade"
	desc = "A ShiTastic! brand biological warfare charge. Not very effective unless the target is squeamish."
	icon_state = "chemg_locked"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("poo", 30)
		B2.reagents.add_reagent("poo", 30)

		beakers += B1
		beakers += B2
*/
///////////////////////////////Grenades

/obj/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'chemical.dmi'
	icon_state = "null"
	anchored = 1
	density = 0

	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src

/obj/item/weapon/gun/syringe
	name = "syringe gun"
	icon = 'gun.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 4.0
	var/list/syringes = new/list()
	var/max_syringes = 1
	m_amt = 2000

	examine()
		set src in view(2)
		..()
		usr << "\icon [src] Syringe gun:"
		usr << "\blue [syringes.len] / [max_syringes] Syringes."

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/weapon/reagent_containers/syringe))
			if(syringes.len < max_syringes)
				user.drop_item()
				I.loc = src
				syringes += I
				user << "\blue You put the syringe in the syringe gun."
				user << "\blue [syringes.len] / [max_syringes] Syringes."
			else
				usr << "\red The syringe gun cannot hold more syringes."

	attack()
		return 1

	afterattack(obj/target, mob/user , flag)
		if(!isturf(target.loc)) return

		if(syringes.len)
			if(target != user)
				spawn(0) fire_syringe(target,user)
			else
				var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]
				S.reagents.trans_to(user, S.reagents.total_volume)
				syringes -= S
				del(S)
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red [] shot \himself with a syringe gun!", user), 1)
		else
			usr << "\red The syringe gun is empty."

	proc
		fire_syringe(atom/target, mob/user)
			var/turf/trg = get_turf(target)
			var/obj/syringe_gun_dummy/D = new/obj/syringe_gun_dummy(get_turf(src))
			var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]
			S.reagents.trans_to(D, S.reagents.total_volume)
			syringes -= S
			del(S)
			D.icon_state = "syringeproj"
			D.name = "syringe"
			playsound(user.loc, 'syringeproj.ogg', 50, 1)
			shoot:
				for(var/i=0, i<6, i++)
					if(D.loc == trg) break
					step_towards_3d(D,trg)

					for(var/mob/living/carbon/M in D.loc)
						if(!istype(M,/mob/living/carbon)) continue
						if(M == user) continue
						D.reagents.trans_to(M, D.reagents.total_volume)
						M.adjustBruteLoss(5)

						for(var/mob/O in viewers(world.view, D))
							O.show_message(text("\red [] was hit by the syringe!", M), 1)

						del(D)
						break shoot

					for(var/atom/A in D.loc)
						if(A == user) continue
						if(A.density)
							del(D)
							break shoot

					sleep(1)

			spawn(10)
				del(D)

			return

/obj/item/weapon/gun/syringe/rapid
	name = "rapid syringe gun"
	icon_state = "rapidsyringegun"
	max_syringes = 6
	m_amt = 20000




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