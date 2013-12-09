/*
CONTAINS:
MOP
*/
/obj/item/weapon/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'janitor.dmi'
	icon_state = "mop"
	var/mopping = 0
	var/mopcount = 0
	force = 9
	throwforce = 10
	throw_speed = 5
	throw_range = 10
	w_class = 3

/obj/item/weapon/mop/New()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/weapon/mop/afterattack(atom/A, mob/user as mob)
	if (src.reagents.total_volume < 1 || mopcount >= 15)
		user << "\blue Your mop is dry!"
		return

	if (istype(A, /turf/simulated))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		if(do_after(user, 40))
			user << "\blue You have finished mopping!"
			if(A)
				src.reagents.reaction(A,1,10)
				A.clean_blood()
				for(var/obj/effect/decal/cleanable/C in A)
					del(C)
				mopcount++
	else if (istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/overlay))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[user] begins to clean [A]</B>"), 1)
		if(do_after(user, 20))
			user << "\blue You have finished mopping!"
			if(A)
				var/turf/U = A.loc
				src.reagents.reaction(U)
				del(A)
				mopcount++

	if(mopcount >= 15) //Okay this stuff is an ugly hack and i feel bad about it.
		spawn(5)
			src.reagents.clear_reagents()
			mopcount = 0

	return