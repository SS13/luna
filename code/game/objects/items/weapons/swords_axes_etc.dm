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
	flags = FPRINT | NOSHIELD
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
	if ((CLUMSY in user.mutations) && prob(50))
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
	flags = FPRINT | CONDUCT | NOSHIELD

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
	flags = FPRINT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("beaten")
	var/stunforce = 10
	var/status = 0
	var/obj/item/weapon/cell/bcell = null
	var/hitcost = 1000


/obj/item/weapon/melee/baton/New()
	..()
	bcell = new /obj/item/weapon/cell/high(src)
	update_icon()
	return


/obj/item/weapon/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0

/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

/obj/item/weapon/melee/baton/examine()
	set src in view(1)
	..()
	if(bcell)
		usr <<"<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>"
	if(!bcell)
		usr <<"<span class='warning'>The baton does not have a power source installed.</span>"

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!bcell)
			user.drop_item()
			W.loc = src
			bcell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a cell.</span>"

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(bcell)
			bcell.update_icon()
			bcell.loc = get_turf(src.loc)
			bcell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		user << "<span class='notice'>[src] is now [status ? "on" : "off"].</span>"
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			user << "<span class='warning'>[src] does not have a power source!</span>"
		else
			user << "<span class='warning'>[src] is out of charge.</span>"
	add_fingerprint(user)

/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>You accidentally hit yourself with [src]!</span>"
		user.Weaken(stunforce*3)
		deductcharge(hitcost)
		return

	if(isrobot(M))
		..()
		return
	if(!isliving(M))
		return

	var/mob/living/L = M

	if(user.a_intent == "harm")
		..()
		playsound(loc, "swing_hit", 50, 1, -1)

	else if(!status)
		L.visible_message("<span class='warning'>[L] has been prodded with [src] by [user]. Luckily it was off.</span>")
		return

	if(status)
		user.lastattacked = L
		L.lastattacker = user

		L.Stun(stunforce)
		L.Weaken(stunforce)
		L.apply_effect(STUTTER, stunforce)

		L.visible_message("<span class='danger'>[L] has been stunned with [src] by [user]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

		if(isrobot(loc))
			var/mob/living/silicon/robot/R = loc
			if(R && R.cell)
				R.cell.use(hitcost)
		else
			deductcharge(hitcost)

		log_attack("[user.name] ([user.ckey]) stunned [L.name] ([L.ckey]) with [name]" )

/obj/item/weapon/melee/baton/emp_act(severity)
	if(bcell)
		deductcharge(1000 / severity)
		if(bcell.reliability != 100 && prob(50/severity))
			bcell.reliability -= 10 / severity
	..()

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 5
	hitcost = 2500
	slot_flags = null

/obj/item/weapon/melee/classic_baton/attack(mob/living/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red You club yourself over the head."
		user.Weaken(8)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.TakeDamage("head", force, 0)
		else
			user.adjustBruteLoss(force)
		return
	src.add_fingerprint(user)

	if (user.a_intent == "harm")
		playsound(src.loc, "swing_hit", 50, 1, -1)
		M.Stun(8)
		M.Weaken(8)
		M.apply_effect(STUTTER, 8)
		..()
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been beaten with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
	else
		playsound(src.loc, 'Genhit.ogg', 50, 1, -1)
		M.Stun(5)
		M.Weaken(5)
		M.apply_effect(STUTTER, 5)
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("\red <B>[M] has been stunned with the police baton by [user]!</B>", 1, "\red You hear someone fall", 2)
