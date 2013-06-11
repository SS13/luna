/*
CONTAINS:
RODS
METAL
REINFORCED METAL
LATTICE

*/
/*

// RODS
/obj/item/stack/rods
	name = "rods"
	icon = 'items.dmi'
	icon_state = "rods"
	var/amount = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 3.0
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	m_amt = 1875

/obj/item/stack/rods/examine()
	set src in view(1)

	..()
	usr << text("There are [] rod\s left on the stack.", src.amount)
	return

/obj/item/stack/rods/attack_hand(mob/user as mob)
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/stack/rods/F = new /obj/item/stack/rods( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 20
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return

/obj/item/stack/rods/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
		if(amount < 2)
			user << "\blue You need at least two rods to do this."
			return
		if (W:get_fuel() < 2)
			user << "\blue You need more welding fuel to complete this task."
			return
		W:eyecheck(user)
		W:use_fuel(2)
		new /obj/item/stack/sheet/metal(usr.loc)
		for (var/mob/M in viewers(src))
			M.show_message("\red [src] is shaped into metal by [user.name] with the weldingtool.", 3, "\red You hear welding.", 2)

		amount -= 2
		if(amount == 0)
			del(src)
		return
	if (istype(W, /obj/item/stack/rods))
		if (W:amount == 6)
			return
		if (W:amount + src:amount > 6)
			src.amount = W:amount + src:amount - 6
			W:amount = 6
		else
			W:amount += src:amount
			//SN src = null
			del(src)
			return
	return

/obj/item/stack/rods/attack_self(mob/user as mob)
	if (locate(/obj/structure/grille, usr.loc))
		for(var/obj/structure/grille/G in usr.loc)
			if (G.destroyed)
				G.health = 10
				G.density = 1
				G.destroyed = 0
				G.icon_state = "grille"
				src.amount--
			else
	else
		if (src.amount < 2)
			return
		src.amount -= 2
		new /obj/structure/grille( usr.loc )
	if (src.amount < 1)
		del(src)
		return
	src.add_fingerprint(user)
	return

*/