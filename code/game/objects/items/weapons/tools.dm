/*
CONTAINS:

WRENCH
SCREWDRIVER
WELDINGTOOOL
*/


// WRENCH
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'items.dmi'
	icon_state = "wrench"
	flags = FPRINT | CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 150
	origin_tech = "materials=1;engineering=1"


// SCREWDRIVER
/obj/item/weapon/screwdriver/New()
	desc = "You can be totally screwy with this."
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if((CLUMSY in usr.mutations) && prob(30))
		M << "\red You stab yourself in the eye."
		M.eye_blurry += rand(3,4)
		M.eye_stat += rand(1,2)
		M.weakened += 4
		M.bruteloss += 10

	src.add_fingerprint(user)
	if(!(user.zone_sel.selecting == ("eyes" || "head")))
		return ..()
	var/mob/living/carbon/human/H = M
	if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
		// you can't stab someone in the eyes wearing a mask!
		user << "\blue You're going to need to remove that mask/helmet/glasses first."
		return
	for(var/mob/O in viewers(M, null))
		if(O == (user || M))	continue
		if(M == user)	O.show_message(text("\red [] has stabbed themself with []!", user, src), 1)
		else	O.show_message(text("\red [] has been stabbed in the eye with [] by [].", M, src, user), 1)
	if(M != user)
		M << "\red [user] stabs you in the eye with [src]!"
		user << "\red You stab [M] in the eye with [src]!"
	else
		user << "\red You stab yourself in the eyes with [src]!"
	if(istype(M, /mob/living/carbon/human))
		var/datum/organ/external/affecting = M.organs["head"]
		affecting.take_damage(7)
	else
		M.bruteloss += 7
	M.eye_blurry += rand(3,4)
	M.eye_stat += rand(2,4)
	if (M.eye_stat >= 10)
		M << "\red Your eyes start to bleed profusely!"
		M.eye_blurry += 15+(0.1*M.eye_blurry)
		M.disabilities |= BLIND
		if(M.stat == 2)	return
		if(prob(50))
			M << "\red You drop what you're holding and clutch at your eyes!"
			M.eye_blurry += 10
			M.paralysis += 1
			M.weakened += 4
			M.drop_item()
		if (prob(M.eye_stat - 10 + 1))
			M << "\red You go blind!"
			M.sdisabilities |= BLIND
	return


// WELDING TOOL

/obj/item/weapon/weldingtool
	name = "welding tool"
	icon = 'items.dmi'
	icon_state = "welder"
	origin_tech = "engineering=1"
	var/welding = 0.0
	var/status = 0	//flamethrower construction :shobon:
	flags = FPRINT | CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	m_amt = 30
	g_amt = 30

/obj/item/weapon/weldingtool/New()
	var/datum/reagents/R = new/datum/reagents(30)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", 30)
	return


/obj/item/weapon/weldingtool/examine()
	set src in usr
	usr << text("\icon[] [] contains [] units of fuel left!", src, src.name, get_fuel() )
	return

/obj/item/weapon/weldingtool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (status == 0 && istype(W,/obj/item/weapon/screwdriver))
		status = 1
		user << "\blue The welder can now be attached and modified."
	else if (status == 1 && istype(W,/obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		R.amount = R.amount - 1
		if (R.amount == 0)
			del(R)
		var/obj/item/assembly/weld_rod/F = new /obj/item/assembly/weld_rod( user )
		src.loc = F
		F.part1 = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.u_equip(src)
			user.r_hand = F
		else
			user.u_equip(src)
			user.l_hand = F
		R.master = F
		src.master = F
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		F.part2 = W
		F.layer = 20
		R.layer = 20
		F.loc = user
		src.add_fingerprint(user)
	else if (status == 1 && istype(W,/obj/item/weapon/screwdriver))
		status = 0
		user << "\blue You resecure the welder."
		return

// helper functions for weldingtool fuel use

// return fuel amount
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

// remove fuel amount
/obj/item/weapon/weldingtool/proc/use_fuel(var/amount)
	amount = min( get_fuel() , amount)
	reagents.remove_reagent("fuel", amount)
	return

/obj/item/weapon/weldingtool/proc/remove_fuel(amount = 1, mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "<span class='notice'>You need more welding fuel to complete this task.</span>"
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/weldingtool/proc/isOn()
	return welding

/obj/item/weapon/weldingtool/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		if(!welding)
			O.reagents.trans_to(src, 30)
			user << "\blue Welder refueled"
			playsound(src.loc, 'zzzt.ogg', 50, 1, -6)
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			user << "<span class='warning'>That was stupid of you.</span>"
			explosion(O.loc, -1, 0, 2)
			if(O)
				del(O)
			return

	else if(welding)
		use_fuel(1)
		if (get_fuel() <= 0)
			usr << "\blue Need more fuel!"
			src.welding = 0
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "welder"
		var/turf/location = user.loc
		if (istype(location, /turf))
			location.hotspot_expose(SPARK_TEMP, 50, 1)
	return


/obj/item/weapon/weldingtool/proc/eyecheck(mob/user as mob)
	//check eye protection
	var/safety = null

	if (istype(user,/mob/living/silicon/robot)) return

	if ((istype(user:head, /obj/item/clothing/head/helmet/welding) && !user:head:up) || istype(user:head, /obj/item/clothing/head/helmet/space))
		safety = 2
	else if (istype(user:glasses, /obj/item/clothing/glasses/sunglasses))
		safety = 1
	else if (istype(user:glasses, /obj/item/clothing/glasses/thermal))
		safety = -1
	else
		safety = 0
	switch(safety)
		if(1)
			usr << "\red Your eyes sting a little."
			user.eye_stat += rand(1, 2)
			if(user.eye_stat > 12)
				user.eye_blurry += rand(3,6)
		if(0)
			usr << "\red Your eyes burn."
			user.eye_stat += rand(2, 4)
			if(user.eye_stat > 10)
				user.eye_blurry += rand(4,10)
		if(-1)
			usr << "\red Your thermals intensify the welder's glow. Your eyes itch and burn severely."
			user.eye_blurry += rand(12,20)
			user.eye_stat += rand(12, 16)
	if(user.eye_stat > 10 && safety < 2)
		user << "\red Your eyes are really starting to hurt. This can't be good for you!"
	if (prob(user.eye_stat - 25 + 1))
		user << "\red You go blind!"
		user.sdisabilities |= 1
	else if (prob(user.eye_stat - 15 + 1))
		user << "\red You go blind!"
		user.eye_blind = 5
		user.eye_blurry = 5
		user.disabilities |= 1
		spawn(100)
			user.disabilities &= ~1

/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	if(status > 1)	return
	src.welding = !( src.welding )
	if (src.welding)
		if (get_fuel() <= 0)
			user << "\blue Need more fuel!"
			src.welding = 0
			return 0
		user << "\blue You will now weld when you attack."
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "welder1"
		processing_items.Add(src)
	else
		user << "\blue Not welding anymore."
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
	return

/obj/item/weapon/weldingtool/process()
	if(!welding)
		processing_items.Remove(src)
		return

	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc

	if (istype(location, /turf))
		location.hotspot_expose(SPARK_TEMP, 5)


/obj/item/weapon/weldingtool/industrial
	name = "industrial welding tool"
	icon_state = "indwelder"
	item_state = "welder"
	origin_tech = "engineering=2"
	m_amt = 600
	g_amt = 150

/obj/item/weapon/weldingtool/industrial/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/obj/item/weapon/weldingtool/industrial/New()
	var/datum/reagents/R = new/datum/reagents(60)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", 60)
	return

/obj/item/weapon/weldingtool/industrial/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		if(!welding)
			O.reagents.trans_to(src, 60)
			user << "\blue Welder refueled"
			playsound(src.loc, 'zzzt.ogg', 50, 1, -6)
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			user << "<span class='warning'>That was stupid of you.</span>"
			explosion(O.loc, -1, 0, 2)
			if(O)
				del(O)
			return

	else if(welding)
		use_fuel(1)
		if (get_fuel() <= 0)
			usr << "\blue Need more fuel!"
			src.welding = 0
			src.force = 3
			src.damtype = "brute"
			src.icon_state = "indwelder"
		var/turf/location = user.loc
		if (istype(location, /turf))
			location.hotspot_expose(SPARK_TEMP, 50, 1)
	return

/obj/item/weapon/weldingtool/industrial/attack_self(mob/user as mob)
	if(status > 1)	return
	src.welding = !( src.welding )
	if (src.welding)
		if (get_fuel() <= 0)
			user << "\blue Need more fuel!"
			src.welding = 0
			return 0
		user << "\blue You will now weld when you attack."
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "indwelder1"
		processing_items.Add(src)
	else
		user << "\blue Not welding anymore."
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "indwelder"
	return




/obj/item/weapon/weldingtool/mini
	name = "emergency welding tool"
	icon_state = "miniwelder"
	item_state = "welder"
	m_amt = 20
	g_amt = 5

/obj/item/weapon/weldingtool/mini/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/obj/item/weapon/weldingtool/mini/New()
	var/datum/reagents/R = new/datum/reagents(15)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", 15)
	return

/obj/item/weapon/weldingtool/mini/afterattack(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		if(!welding)
			O.reagents.trans_to(src, 15)
			user << "\blue Welder refueled"
			playsound(src.loc, 'zzzt.ogg', 50, 1, -6)
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			user << "<span class='warning'>That was stupid of you.</span>"
			explosion(O.loc, -1, 0, 2)
			if(O)
				del(O)
			return

	else if(welding)
		use_fuel(1)
		if (get_fuel() <= 0)
			usr << "\blue Need more fuel!"
			src.welding = 0
			src.force = 2
			src.damtype = "brute"
			src.icon_state = "miniwelder"
		var/turf/location = user.loc
		if (istype(location, /turf))
			location.hotspot_expose(SPARK_TEMP, 50, 1)
	return

/obj/item/weapon/weldingtool/mini/attack_self(mob/user as mob)
	if(status > 1)	return
	src.welding = !( src.welding )
	if (src.welding)
		if (get_fuel() <= 0)
			user << "\blue Need more fuel!"
			src.welding = 0
			return 0
		user << "\blue You will now weld when you attack."
		src.force = 15
		src.damtype = "fire"
		src.icon_state = "miniwelder1"
		processing_items.Add(src)
	else
		user << "\blue Not welding anymore."
		src.force = 32
		src.damtype = "brute"
		src.icon_state = "miniwelder"
	return



/obj/item/weapon/weldingtool/plasmacutter
	name = "plasma cutter"
	icon = 'items.dmi'
	icon_state = "plasmacutter"
	item_state = "gun"
	origin_tech = "materials=4;plasmatech=3;engineering=3"
	desc = "A rock cutter that uses bursts of hot plasma. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	flags = FPRINT | CONDUCT | OPENCONTAINER
	force = 7
	slash = 0
	m_amt = 4500
	g_amt = 300

/obj/item/weapon/weldingtool/plasmacutter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/obj/item/weapon/weldingtool/plasmacutter/New()
	var/datum/reagents/R = new/datum/reagents(15)
	reagents = R
	R.my_atom = src
	R.add_reagent("plasma", 15)
	return

/obj/item/weapon/weldingtool/plasmacutter/examine()
	set src in usr
	usr << text("\icon[src] Plasma cutter has [get_fuel()] units of plasma left!")
	return

/obj/item/weapon/weldingtool/plasmacutter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

// return fuel amount
/obj/item/weapon/weldingtool/plasmacutter/get_fuel()
	return reagents.get_reagent_amount("plasma")

// remove fuel amount
/obj/item/weapon/weldingtool/plasmacutter/use_fuel(var/amount)
	amount = min( get_fuel() , amount * 0.1)
	reagents.remove_reagent("plasma", amount)
	return

/obj/item/weapon/weldingtool/plasmacutter/remove_fuel(amount = 1, mob/living/M = null)
	if(!welding) return 0
	if(get_fuel() >= amount * 0.1)
		reagents.remove_reagent("plasma", amount * 0.1)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "<span class='notice'>You need more plasma to complete this task.</span>"
		return 0

/obj/item/weapon/weldingtool/plasmacutter/afterattack(obj/O as obj, mob/living/user as mob)
	if(welding)
		use_fuel(1)
		if (get_fuel() <= 0)
			usr << "\blue Need more plasma!"
			src.welding = 0
			src.force = 7
			src.damtype = "brute"
			slash = 0
		var/turf/location = user.loc
		if (istype(location, /turf))
			location.hotspot_expose(SPARK_TEMP, 50, 1)
	return

/obj/item/weapon/weldingtool/plasmacutter/eyecheck(mob/living/user as mob)
	if (istype(user,/mob/living/silicon/robot)) return
	//check eye protection
	var/safety = 1
	if ((istype(user:head, /obj/item/clothing/head/helmet/welding) && !user:head:up) || istype(user:head, /obj/item/clothing/head/helmet/space))
		safety += 2
	if (istype(user:glasses, /obj/item/clothing/glasses/sunglasses))
		safety += 1

	switch(safety)
		if(1)
			usr << "\red Your eyes sting a little."
			user.eye_stat += rand(1, 2)
			if(user.eye_stat > 12)
				user.eye_blurry += rand(3,6)
		if(0)
			usr << "\red Your eyes burn."
			user.eye_stat += rand(2, 4)
			if(user.eye_stat > 10)
				user.eye_blurry += rand(4,10)
	if(user.eye_stat > 10 && safety < 2)
		user << "\red Your eyes are really starting to hurt. This can't be good for you!"
	if (prob(user.eye_stat - 25 + 1))
		user << "\red You go blind!"
		user.sdisabilities |= 1
	else if (prob(user.eye_stat - 15 + 1))
		user << "\red You go blind!"
		user.eye_blind = 5
		user.eye_blurry = 5
		user.disabilities |= 1
		spawn(100)
			user.disabilities &= ~1

/obj/item/weapon/weldingtool/plasmacutter/attack_self(mob/user as mob)
	if(status > 1)	return
	src.welding = !( src.welding )
	if (src.welding)
		if (get_fuel() <= 0)
			user << "\blue Need more plasma!"
			src.welding = 0
			return 0
		user << "\blue You will now cut when you attack."
		src.force = 25
		slash = 1
		src.damtype = "fire"
		processing_items.Add(src)
	else
		user << "\blue Not cutting anymore."
		src.force = 7
		slash = 0
		src.damtype = "brute"
	return


/obj/item/weapon/weldingtool/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(!ishuman(M) || !ishuman(user) || user.a_intent != "help")
		return ..()

	var/mob/living/carbon/human/H = M
	var/mob/living/carbon/human/user2 = user

	var/t = user2.zone_sel.selecting
	var/datum/organ/external/affecting = H.organs[t]

	if(t in list("eyes", "mouth", "groin", "chest") || !affecting)
		return ..()

	if(affecting.status != ORGAN_ROBOTIC)
		return ..()

	if(remove_fuel(2, user))
		if(M != user)
			for(var/mob/O in viewers(M, null))
				O.show_message("\red [user] has fixed some dents on [M]'s robotic [affecting.display_name].", 1)
		else
			var/t_himself = "it's"
			if(user.gender == MALE)
				t_himself = "his"
			else if (user.gender == FEMALE)
				t_himself = "her's"

			for (var/mob/O in viewers(M, null))
				O.show_message("\red [M] has fixed some dents on [t_himself] robotic [affecting.display_name].", 1)

		if (affecting.heal_damage(10, 0))
			H.UpdateDamageIcon()
		else
			H.UpdateDamage()

		M.updatehealth()