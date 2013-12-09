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
	flags = FPRINT
	slot_flags = SLOT_BELT
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
 * Sleepy Pen
 */

/obj/item/weapon/pen/sleepypen
	desc = "It's a normal black ink pen with a sharp point."
	origin_tech = "materials=2;syndicate=5"
	flags = FPRINT | OPENCONTAINER
	slot_flags = SLOT_BELT

/obj/item/weapon/pen/sleepypen/New()
	var/datum/reagents/R = new/datum/reagents(120)
	reagents = R
	R.my_atom = src
	R.add_reagent("penstoxin", 90)
	R.add_reagent("cryptobiolin", 30)
	..()
	return

/obj/item/weapon/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	if (reagents.total_volume)
		user << "\red You stab [M] with the pen."
		spawn(20)
			if(M.reagents) reagents.trans_to(M, 30)
	return

/*
 * Death Pen
 *
 * (Sleepy Pen Nuclear Edition)
 */

/obj/item/weapon/pen/deathpen
	desc = "It's a normal black ink pen with a sharp point."
	origin_tech = "materials=2;syndicate=5"
	flags = FPRINT | OPENCONTAINER
	slot_flags = SLOT_BELT

/obj/item/weapon/pen/sleepypen/New()
	var/datum/reagents/R = new/datum/reagents(80)
	reagents = R
	R.my_atom = src
	R.add_reagent("cyanide", 80)
	..()
	return

/obj/item/weapon/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	if (reagents.total_volume)
		user << "\red You stab [M] with the pen."
		spawn(20)
			if(M.reagents) reagents.trans_to(M, 20)
	return