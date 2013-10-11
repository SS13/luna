/*
CONTAINS:
SWORD
AXE
STUN BATON
CLASSIC BATON
*/

/*
 * Sword
 */

/obj/item/weapon/melee/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	var/active = 0.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	origin_tech = "magnets=3;syndicate=4"


/obj/item/weapon/melee/energy/sword/New()
	item_color = pick("red", "blue", "green", "purple")

/obj/item/weapon/melee/energy/sword/IsShield()
	return active

//obj/item/weapon/melee/energy/sword/attack(target as mob, mob/user as mob)
//	if(istype(target, /mob/living))
//		target:AdjustFireLoss(10)
//	..()

/obj/item/weapon/melee/energy/sword/attack_self(mob/living/user as mob)
	if ((user.mutations & CLUMSY) && prob(50))
		user << "\red You accidentally cut yourself with the Sword."
		user.adjustBruteLoss(5)
		user.adjustFireLoss(5)
	active = !active
	if (active)
		if(istype(src,/obj/item/weapon/melee/energy/sword/pirate))
			icon_state = "cutlass1"
		else
			icon_state = "sword[item_color]"
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		user << "\blue The sword is now active."
		src.force = 30
		throwforce = 20
		if(src.blood_DNA)
			var/icon/I = new /icon(initial(src.icon), src.icon_state)
			I.Blend(new /icon('blood.dmi', "thisisfuckingstupid"),ICON_ADD)
			I.Blend(new /icon('blood.dmi', "itemblood"),ICON_MULTIPLY)
			I.Blend(new /icon(initial(src.icon), src.icon_state),ICON_UNDERLAY) //motherfucker
			src.icon = I
		src.w_class = 4
		src.slash = 1
	else
		user << "\blue The sword can now be concealed."
		src.force = 3
		if(istype(src,/obj/item/weapon/melee/energy/sword/pirate))
			icon_state = "cutlass0"
		else
			icon_state = "sword0"
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		if(src.blood_DNA)
			var/icon/I = new /icon(initial(src.icon), src.icon_state)
			I.Blend(new /icon('blood.dmi', "thisisfuckingstupid"),ICON_ADD)
			I.Blend(new /icon('blood.dmi', "itemblood"),ICON_MULTIPLY)
			I.Blend(new /icon(initial(src.icon), src.icon_state),ICON_UNDERLAY) //motherfucker
			src.icon = I
		src.w_class = 1
		src.slash = 0
	src.add_fingerprint(user)
	user.update_clothing()
	return


/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/sword/green/New()
	item_color = "green"

/obj/item/weapon/melee/energy/sword/red/New()
	item_color = "red"

// AXE

/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	var/active = 0.0
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	slash = 1
	w_class = 3.0
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS

/obj/item/weapon/melee/energy/axe/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The axe is now energised."
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 5
	else
		user << "\blue The axe can now be concealed."
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 3
	src.add_fingerprint(user)
	user.update_clothing()
	return


// STUN BATON
/obj/item/weapon/melee/baton
	name = "stunbaton"
	desc = "A stun baton for hitting people with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10
	throwforce = 7
	w_class = 3
	var/charges = 10.0
	origin_tech = "combat=2"
	var/maximum_charges = 10.0
	var/status = 0


/obj/item/weapon/melee/baton/update_icon()
	if(src.status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"
	if(src.blood_DNA)
		var/icon/I = new /icon(initial(src.icon), src.icon_state)
		I.Blend(new /icon('blood.dmi', "thisisfuckingstupid"),ICON_ADD)
		I.Blend(new /icon('blood.dmi', "itemblood"),ICON_MULTIPLY)
		I.Blend(new /icon(initial(src.icon), src.icon_state),ICON_UNDERLAY) //motherfucker
		src.icon = I
/obj/item/weapon/melee/baton/attack_self(mob/user as mob)
	src.status = !( src.status )
	if ((usr.mutations & CLUMSY) && prob(50))
		usr << "\red You grab the stunbaton on the wrong side!"
		usr.Stun(10)
		return
	if (src.status)
		user << "\blue The baton is now on."
		playsound(src.loc, "sparks", 75, 1, -1)
	else
		user << "\blue The baton is now off."
		playsound(src.loc, "sparks", 75, 1, -1)
	user.update_clothing()
	update_icon()
	src.add_fingerprint(user)
	return

/obj/item/weapon/melee/baton/attack(mob/M as mob, mob/user as mob)
	if ((usr.mutations & CLUMSY) && prob(50))
		usr << "\red You grab the stunbaton on the wrong side."
		usr.Stun(10)
		return
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = M

	if(H.zombie) return
	if ((istype(H, /mob/living/carbon/human) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
		M << "\red The helmet protects you from being hit hard in the head!"
		return
	if (status == 0 || (status == 1 && charges == 0))
		if(user.a_intent == "hurt")
			if (M.weakened < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 5
				..()
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been beaten with the stun baton by [user]!</B>", 1)
			if(status == 1 && charges == 0)
				user << "\red Not enough charge"
			return
		else
			for(var/mob/O in viewers(M))
				if (O.client)	O.show_message("\red <B>[M] has been prodded with the stun baton by [user]! Luckily it was off.</B>", 1)
			if(status == 1 && charges == 0)
				user << "\red Not enough charge"
			return
	if((charges > 0 && status == 1) && (istype(H, /mob/living/carbon/human)))
		flick("baton_active", src)
		if (user.a_intent == "hurt")
			playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				charges--
			if (M.weakened < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 1
			if (M.stuttering < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering = 1
			..()
			if (M.stunned < 1 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stunned = 1
		else
			playsound(src.loc, 'Egloves.ogg', 50, 1, -1)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				charges--
			if (M.weakened < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.weakened = 10
			if (M.stuttering < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stuttering = 10
			if (M.stunned < 10 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
				M.stunned = 10
			user.lastattacked = M
			M.lastattacker = user
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the stun baton by [user]!</B>", 1, "\red You hear someone fall", 2)
	else if((charges > 0 && status == 1) && (istype(M, /mob/living/carbon/monkey)))
		flick("baton_active", src)
		if (user.a_intent == "hurt")
			playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 400
			else
				charges--
			if (M.weakened < 1 && (!(M.mutations & HULK)) )
				M.weakened = 1
			if (M.stuttering < 1 && (!(M.mutations & HULK)) )
				M.stuttering = 1
			..()
			if (M.stunned < 1 && (!(M.mutations & HULK)) )
				M.stunned = 1
		else
			playsound(src.loc, 'Egloves.ogg', 50, 1, -1)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 400
			else
				charges--
			if (M.weakened < 10 && (!(M.mutations & HULK)) )
				M.weakened = 10
			if (M.stuttering < 10 && (!(M.mutations & HULK)) )
				M.stuttering = 10
			if (M.stunned < 10 && (!(M.mutations & HULK)) )
				M.stunned = 10
			user.lastattacked = M
			M.lastattacker = user
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the stun baton by [user]!</B>", 1, "\red You hear someone fall", 2)

/obj/item/weapon/melee/classic_baton/attack(mob/living/M as mob, mob/living/user as mob)
	if ((usr.mutations & CLUMSY) && prob(50))
		usr << "\red You club yourself over the head."
		usr.weakened = max(3 * force, usr.weakened)
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.TakeDamage("head", 2 * force, 0)
		else
			user.adjustBruteLoss(2 * force)
		return
	src.add_fingerprint(user)

	if (user.a_intent == "hurt")
		playsound(src.loc, "swing_hit", 50, 1, -1)
		if (M.weakened < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.weakened = 8
		if (M.stuttering < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stuttering = 8
		..()
		if (M.stunned < 8 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stunned = 8
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been beaten with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
	else
		playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
		if (M.weakened < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.weakened = 5
		if (M.stunned < 5 && (!(M.mutations & HULK))  /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stunned = 5
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
