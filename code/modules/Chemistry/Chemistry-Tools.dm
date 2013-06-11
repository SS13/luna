// Bottles transfer 50 units
// Beakers transfer 30 units
// Syringes transfer 15 units
// Droppers transfer 5 units

//BUG!!!: reactions on splashing etc cause errors because stuff gets deleted before it executes.
//		  Bandaid fix using spawn - very ugly, need to fix this.

///////////////////////////////Grenades
/obj/item/weapon/grenade/chem_grenade
	name = "metal casing"
	icon_state = "chemg1"
	icon = 'chemical.dmi'
	item_state = "flashbang"
	w_class = 2.0
	force = 2.0
	var/stage = 0
	var/state = 0
	var/list/beakers = new/list()
	throw_speed = 4
	throw_range = 20
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
			icon_state = "chemg2"
			name = "unsecured grenade"
			stage = 1
		else if(istype(W,/obj/item/weapon/screwdriver) && stage == 1)
			if(beakers.len)
				user << "\blue You lock the assembly."
				playsound(src.loc, 'Screwdriver.ogg', 25, -3)
				name = "grenade"
				icon_state = "chemg3"
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
			src.icon_state = "chemg4"
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
			src.icon_state = "chemg4"
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
				var/datum/effects/system/steam_spread/steam = new /datum/effects/system/steam_spread()
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
	icon_state = "chemg3"
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

/obj/item/weapon/grenade/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	icon_state = "chemg3"
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
/*
/obj/item/weapon/grenade/chem_grenade/poo
	name = "poo grenade"
	desc = "A ShiTastic! brand biological warfare charge. Not very effective unless the target is squeamish."
	icon_state = "chemg3"
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
		var/datum/reagents/R = new/datum/reagents(15)
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
						D.reagents.trans_to(M, 15)
						M.bruteloss += 5

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

////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/dropper
	name = "Dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	volume = 5
	var/filled = 0

/*	New()
		var/datum/reagents/R = new/datum/reagents(5)
		reagents = R
		R.my_atom = src */

	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return

		if(filled)

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/weapon/reagent_containers/food)) //You can inject humans and food but you cant remove the shit.
				user << "\red You cannot directly fill this object."
				return

			if(ismob(target))
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red <B>[] drips something onto []!</B>", user, target), 1)
					message_admins("[user] drips something filled with [src.reagents.get_master_reagent_name()] onto [target]")
				src.reagents.reaction(target, TOUCH)

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution."
			if (src.reagents.total_volume<=0)
				filled = 0
				icon_state = "dropper[filled]"

		else

			if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
				user << "\red You cannot directly remove reagents from [target]."
				return

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			target.reagents.trans_to(src, 5)

			user << "\blue You fill the dropper with 5 units of the solution."

			filled = 1
			icon_state = "dropper[filled]"

		return






/obj/item/weapon/reagent_containers/glass/bloodpack/
	name = "Blood Pack"
	desc = "A plastic bag of blood."
	icon = 'chemical.dmi'
	icon_state = "bottle16"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER

	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		icon_state = "bottle[rand(1,20)]"

/obj/item/weapon/reagent_containers/glass/bloodpack/A
	name = "Blood Pack A"
	desc = "A plastic bag of blood with a sticker that says A."
	icon = 'chemical.dmi'
	icon_state = "bottle16"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10

	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		icon_state = "bottle[rand(1,20)]"
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = 50
		B.data["blood_type"] = "A"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		reagents.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/B
	name = "Blood Pack B"
	desc = "A plastic bag of blood with a sticker that says B."
	icon = 'chemical.dmi'
	icon_state = "bottle16"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10

	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		icon_state = "bottle[rand(1,20)]"
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = 50
		B.data["blood_type"] = "B"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		R.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/O
	name = "Blood Pack O"
	desc = "A plastic bag of blood with a sticker that says O."
	icon = 'chemical.dmi'
	icon_state = "bottle16"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		icon_state = "bottle[rand(1,20)]"
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = 50
		B.data["blood_type"] = "O"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		R.update_total()

/obj/item/weapon/reagent_containers/glass/bloodpack/AB
	name = "Blood Pack AB"
	desc = "A plastic bag of blood with a sticker that says AB."
	icon = 'chemical.dmi'
	icon_state = "bottle16"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10

	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		icon_state = "bottle[rand(1,20)]"
		var/datum/reagent/blood/B = new()
		reagents.reagent_list += B
		B.holder = src
		B.volume = 50
		B.data["blood_type"] = "AB"
		B.description = "Type: [B.data["blood_type"]]<br>DNA: DATA EXPUNGED"
		R.update_total()

//Syringes
/obj/item/weapon/reagent_containers/syringe/robot
	name = "Syringe (mixed)"
	desc = "Contains inaprovaline & anti-toxins."
	New()
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.maximum_volume = 15
		R.my_atom = src
		R.add_reagent("inaprovaline", 7)
		R.add_reagent("anti_toxin", 8)
		mode = "i"
		update_icon()

/obj/item/weapon/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	New()
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.maximum_volume = 15
		R.my_atom = src
		R.add_reagent("inaprovaline", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	New()
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.maximum_volume = 15
		R.my_atom = src
		R.add_reagent("anti_toxin", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."
	New()
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.maximum_volume = 15
		R.my_atom = src
		R.add_reagent("spaceacillin", 15)
		update_icon()