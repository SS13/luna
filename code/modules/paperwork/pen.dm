/*	Pens!
 *	Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 */


/*
 * Pens
 */
/obj/item/weapon/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	flags = FPRINT | ONBELT | TABLEPASS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	m_amt = 10

/obj/item/weapon/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"

/obj/item/weapon/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"

/obj/item/weapon/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"


/*
 * Sleepy Pens
 */

/obj/item/weapon/pen/sleepypen
	desc = "It's a normal black ink pen with a sharp point."
	flags = FPRINT | ONBELT | TABLEPASS | OPENCONTAINER

/obj/item/weapon/pen/sleepypen/New()
	var/datum/reagents/R = new/datum/reagents(150)
	reagents = R
	R.my_atom = src
	R.add_reagent("stoxin", 150)
	..()
	return

/obj/item/weapon/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	if (reagents.total_volume)
		user << "\red You stab [M] with the pen."
		spawn(500)
			if(M.reagents) reagents.trans_to(M, 50)
	return


/*

/*
 * Sleepy Pens
 */
/obj/item/weapon/pen/sleepypen
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	origin_tech = "materials=2;syndicate=5"


/obj/item/weapon/pen/sleepypen/New()
	var/datum/reagents/R = new /datum/reagents(30) //Used to be 300
	reagents = R
	R.my_atom = src
	R.add_reagent("chloralhydrate", 22)	//Used to be 100 sleep toxin	//30 Chloral seems to be fatal, reducing it to 22.
	..()


/obj/item/weapon/pen/sleepypen/attack(mob/M, mob/user)
	if(!istype(M))	return

	..()
	if(reagents.total_volume)
		if(M.reagents)
			reagents.trans_to(M, 30) //used to be 150


/*
 * Parapens
 */
 /obj/item/weapon/pen/paralysis
	origin_tech = "materials=2;syndicate=5"


/obj/item/weapon/pen/paralysis/attack(mob/M, mob/user)
	if(!istype(M))	return

	..()
	if(reagents.total_volume)
		if(M.reagents)
			reagents.trans_to(M, 50)


/obj/item/weapon/pen/paralysis/New()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src
	R.add_reagent("zombiepowder", 10)
	R.add_reagent("impedrezene", 25)
	R.add_reagent("cryptobiolin", 15)
	..()

 */