/obj/item/weapon/surgical
	icon = 'icons/obj/surgery.dmi'
	icon_state = "surgical_drapes"
	flags = FPRINT | CONDUCT
	w_class = 1
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/surgical/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon_state = "retractor"
	m_amt = 10000
	g_amt = 5000

/obj/item/weapon/surgical/bonegel
	name = "bone gel"
	desc = "For repairing broken bones."
	icon_state = "bone-gel"


/obj/item/weapon/surgical/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon_state = "hemostat"
	m_amt = 5000
	g_amt = 2500
	attack_verb = list("attacked", "pinched")


/obj/item/weapon/surgical/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon_state = "cautery"
	m_amt = 5000
	g_amt = 2500
	attack_verb = list("burnt")


/obj/item/weapon/surgical/drill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	m_amt = 15000
	g_amt = 10000
	force = 15
	w_class = 3
	attack_verb = list("drilled")


/obj/item/weapon/surgical/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
	force = 10
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	slash = 1
	m_amt = 10000
	g_amt = 5000
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")


/obj/item/weapon/surgical/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 15
	w_class = 3
	throwforce = 9
	throw_speed = 3
	throw_range = 5
	slash = 1
	m_amt = 20000
	g_amt = 10000
	attack_verb = list("attacked", "slashed", "sawed", "cut")


/obj/item/weapon/surgical/drapes
	name = "surgical drapes"
	desc = "Nanotrasen brand surgical drapes provide optimal safety and infection control."
	origin_tech = "biotech=1"
	attack_verb = list("slapped")

/obj/item/weapon/surgical/drapes/attack(mob/living/M, mob/user)
	if(user.a_intent == "help")
		if(attempt_initiate_surgery(src, M, user))
			return 1
	..()