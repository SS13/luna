
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass
	name = "glass"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50)
	volume = 50
	flags = FPRINT | OPENCONTAINER

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chem_dispenser/,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/weapon/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/item/weapon/grenade/chem_grenade,
		/obj/machinery/bot/medbot,
		/obj/machinery/computer/pandemic,
		/obj/item/weapon/secstorage/ssafe,
		/obj/machinery/disposal,
	)

	examine()
		set src in view()
		..()
		if(!(usr in view(2)) && usr != loc)
			return
		if(reagents && reagents.reagent_list.len)
			usr << "It contains:"
			if(istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = usr
				if(istype(H.glasses, /obj/item/clothing/glasses/science))
					for(var/datum/reagent/R in reagents.reagent_list)
						usr << "[R.volume] units of [R.name]"
				else
					usr << "[reagents.total_volume] units of something"

	attackby()
		return

	afterattack(obj/target, mob/user , flag)
		for(var/type in can_be_placed_into)
			if(istype(target, type))
				return

		if(ismob(target) && target.reagents && reagents.total_volume)
			var/R
			target.visible_message("<span class='danger'>[target] has been splashed with something by [user]!</span>", \
							"<span class='userdanger'>[target] has been splashed with something by [user]!</span>")
			if(reagents)
				for(var/datum/reagent/A in reagents.reagent_list)
					R += A.id + " ("
					R += num2text(A.volume) + "),"
			reagents.reaction(target, TOUCH)
			spawn(5) reagents.clear_reagents()
			return

		else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				user << "<span class='notice'>[target] is empty.</span>"
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "<span class='notice'>[src] is full.</span>"
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "<span class='notice'>You fill [src] with [trans] unit\s of the contents of [target].</span>"

		else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "<span class='notice'>[src] is empty.</span>"
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "<span class='notice'>[target] is full.</span>"
				return

			var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
			user << "<span class='notice'>You transfer [trans] unit\s of the solution to [target].</span>"

		else if(reagents.total_volume)
			user << "<span class='notice'>You splash the solution onto [target].</span>"
			reagents.reaction(target, TOUCH)
			spawn(5)
				reagents.clear_reagents()


/obj/item/weapon/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker. It can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	m_amt = 0
	g_amt = 500

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

/obj/item/weapon/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/weapon/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 100 units."
	icon_state = "beakerlarge"
	g_amt = 5000
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	flags = FPRINT | OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/large/cleaner
	New()
		..()
		reagents.add_reagent("cleaner", 100)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/large/antiviral
	New()
		..()
		reagents.add_reagent("spaceacillin", 100)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/large/sulphuric
	New()
		..()
		reagents.add_reagent("sacid", 100)
		update_icon()


/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	New()
		..()
		reagents.add_reagent("cryoxadone", 30)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric
	New()
		..()
		reagents.add_reagent("sacid", 50)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/slime
	New()
		..()
		reagents.add_reagent("slimejelly", 50)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/plasma
	New()
		..()
		reagents.add_reagent("plasma", 30)
		update_icon()

/obj/item/weapon/reagent_containers/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 70
	flags = FPRINT | OPENCONTAINER

	attackby(var/obj/D, mob/user as mob)
		if(istype(D, /obj/item/device/prox_sensor))
			var/obj/item/weapon/robot_assembly/bucket_sensor/B = new /obj/item/weapon/robot_assembly/bucket_sensor
			B.loc = user.loc

			user << "You add the sensor to the bucket"
			del(D)
			del(src)

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	icon_state = "beakernoreact"
	g_amt = 500
	volume = 50
	amount_per_transfer_from_this = 10
	flags = FPRINT | OPENCONTAINER | NOREACT

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	icon_state = "beakerbluespace"
	g_amt = 5000
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100,300)
	flags = FPRINT | OPENCONTAINER