/*
CONTAINS:
SPACE CLEANER
MOP
*/
/obj/item/weapon/cleaner
	desc = "Space Cleaner!"
	icon = 'janitor.dmi'
	name = "space cleaner"
	icon_state = "cleaner"
	item_state = "cleaner"
	var/saftey = 1
	flags = ONBELT|TABLEPASS|OPENCONTAINER|FPRINT|USEDELAY
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10

/obj/item/weapon/cleaner/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	R.add_reagent("cleaner", 50)

/obj/item/weapon/cleaner/attack_self(mob/user as mob)
	if(saftey == 1)
		saftey = 0
		user << "\blue You flick the catch to off"
	else
		saftey = 1
		user << "\blue You flick the catch back on"

/obj/item/weapon/cleaner/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/cleaner/afterattack(atom/A as mob|obj, mob/user as mob)
	if (saftey == 1)
		user << "\blue The catch is still on!"
		return
	if (src.reagents.total_volume < 1)
		user << "\blue Its empty!"
		return

	var/obj/effect/decal/D = new/obj/effect/decal(get_turf(src))
	D.name = "chemicals"
	D.icon = 'chemical.dmi'
	D.icon_state = "chempuff"
	D.create_reagents(10)
	src.reagents.trans_to(D, 10)
	playsound(src.loc, 'zzzt.ogg', 50, 1, -6)

	spawn(0)
		for(var/i=0, i<3, i++)
			step_towards_3d(D,A)
			D.reagents.reaction(get_turf(D))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)
			sleep(3)
		del(D)

	return

/obj/item/weapon/cleaner/examine()
	set src in usr
	usr << text("\icon[] [] units of cleaner left!", src, src.reagents.total_volume)
	..()
	return

// MOP
/obj/item/weapon/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'janitor.dmi'
	icon_state = "mop"
	var/mopping = 0
	var/mopcount = 0
	force = 3.0
	throwforce = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = 3.0
	flags = FPRINT | TABLEPASS

/obj/item/weapon/mop/New()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/weapon/mop/afterattack(atom/A, mob/user as mob)
	if (src.reagents.total_volume < 1 || mopcount >= 5)
		user << "\blue Your mop is dry!"
		return

	if (istype(A, /turf/simulated))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		sleep(40)
		user << "\blue You have finished mopping!"
		src.reagents.reaction(A,1,10)
		A.clean_blood()
		for(var/obj/effect/decal/cleanable/C in A)
			del(C)
		mopcount++
	else if (istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/overlay))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[user] begins to clean [A]</B>"), 1)
		sleep(20)
		user << "\blue You have finished mopping!"
		var/turf/U = A.loc
		src.reagents.reaction(U)
		if(A) del(A)
		mopcount++

	if(mopcount >= 5) //Okay this stuff is an ugly hack and i feel bad about it.
		spawn(5)
			src.reagents.clear_reagents()
			mopcount = 0

	return