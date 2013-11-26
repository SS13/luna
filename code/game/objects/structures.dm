/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if(prob(50))
				del(src)
				return
		if(3.0)
			return

/obj/structure/meteorhit(obj/O as obj)
	del(src)

/obj/structure/girder
	icon = 'icons/obj/structures.dmi'
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = 2
	var/state = 0

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench) && state == 0)
			if(anchored)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "\blue Now disassembling the girder"
				if(do_after(user,40))
					if(!src) return
					user << "\blue You dissasembled the girder!"
					new /obj/item/stack/sheet/metal(get_turf(src))
					del(src)
			else
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "\blue Now securing the girder"
				if(get_turf(user, 40))
					user << "\blue You secured the girder!"
					new/obj/structure/girder( src.loc )
					del(src)

		else if(istype(W, /obj/item/weapon/weldingtool/plasmacutter))
			user << "\blue Now slicing apart the girder"
			if(do_after(user,30))
				if(!src) return
				user << "\blue You slice apart the girder!"
				new /obj/item/stack/sheet/metal(get_turf(src))
				del(src)

		else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
			user << "\blue You drill through the girder!"
			new /obj/item/stack/sheet/metal(get_turf(src))
			del(src)

		else if(istype(W, /obj/item/weapon/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user << "\blue Now unsecuring support struts"
			if(do_after(user,40))
				if(!src) return
				user << "\blue You unsecured the support struts!"
				state = 1

		else if(istype(W, /obj/item/weapon/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user << "\blue Now removing support struts"
			if(do_after(user,40))
				if(!src) return
				user << "\blue You removed the support struts!"
				new/obj/structure/girder( src.loc )
				del(src)

		else if(istype(W, /obj/item/weapon/crowbar) && state == 0 && anchored )
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user << "\blue Now dislodging the girder"
			if(do_after(user, 40))
				if(!src) return
				user << "\blue You dislodged the girder!"
				new/obj/structure/girder/displaced( src.loc )
				del(src)

		else if(istype(W, /obj/item/stack/sheet))

			var/obj/item/stack/sheet/S = W
			switch(S.type)

				if(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal/cyborg)
					if(!anchored)
						if(S.amount < 2) return
						S.use(2)
						user << "\blue You create a false wall! Push on it to open or close the passage."
						new /obj/structure/falsewall (src.loc)
						del(src)
					else
						if(S.amount < 2) return ..()
						user << "\blue Now adding plating..."
						if (do_after(user,40))
							if(!src || !S || S.amount < 2) return
							S.use(2)
							user << "\blue You added the plating!"
							var/turf/Tsrc = get_turf(src)
							Tsrc.ChangeTurf(/turf/simulated/wall)
							del(src)
						return

				if(/obj/item/stack/sheet/plasteel)
					if(!anchored)
						if(S.amount < 2) return
						S.use(2)
						user << "\blue You create a false wall! Push on it to open or close the passage."
						new /obj/structure/falserwall (src.loc)
						del(src)
					else
						if (src.icon_state == "reinforced") //I cant believe someone would actually write this line of code...
							if(S.amount < 1) return ..()
							user << "\blue Now finalising reinforced wall."
							if(do_after(user, 50))
								if(!src || !S || S.amount < 1) return
								S.use(1)
								user << "\blue Wall fully reinforced!"
								var/turf/Tsrc = get_turf(src)
								Tsrc.ChangeTurf(/turf/simulated/wall/r_wall)
								del(src)
							return
						else
							if(S.amount < 1) return ..()
							user << "\blue Now reinforcing girders"
							if (do_after(user,60))
								if(!src || !S || S.amount < 1) return
								S.use(1)
								user << "\blue Girders reinforced!"
								new/obj/structure/girder/reinforced( src.loc )
								del(src)
							return

			if(S.sheettype)
				var/M = S.sheettype
				if(!anchored)
					if(S.amount < 2) return
					S.use(2)
					user << "\blue You create a false wall! Push on it to open or close the passage."
					var/F = text2path("/obj/structure/falsewall/[M]")
					new F (src.loc)
					del(src)
				else
					if(S.amount < 2) return ..()
					user << "\blue Now adding plating..."
					if (do_after(user,40))
						if(!src || !S || S.amount < 2) return
						S.use(2)
						user << "\blue You added the plating!"
						var/turf/Tsrc = get_turf(src)
						Tsrc.ChangeTurf(text2path("/turf/simulated/wall/mineral/[M]"))
						del(src)
					return

//		else if(istype(W, /obj/item/pipe))
//			var/obj/item/pipe/P = W
//			if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
//				user.drop_item()
//				P.loc = src.loc
//				user << "\blue You fit the pipe into the [src]!"
		else
			..()


	blob_act()
		if(prob(40))
			del(src)


	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(30))
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					del(src)
				return
			if(3.0)
				if (prob(5))
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					del(src)
				return
			else
		return

/obj/structure/girder/displaced
	name = "displaced girder"
	icon_state = "displaced"
	anchored = 0

/obj/structure/girder/reinforced
	name = "reinforced girder"
	icon_state = "reinforced"
	state = 2

/obj/structure/cultgirder
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	anchored = 1
	density = 1
	layer = 2

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "\blue Now disassembling the girder"
			if(do_after(user,40))
				user << "\blue You dissasembled the girder!"
				del(src)

		else if(istype(W, /obj/item/weapon/weldingtool/plasmacutter))
			user << "\blue Now slicing apart the girder"
			if(do_after(user,30))
				user << "\blue You slice apart the girder!"
			del(src)

		else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
			user << "\blue You drill through the girder!"
			del(src)

	blob_act()
		if(prob(40))
			del(src)


	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(30))
					del(src)
				return
			if(3.0)
				if (prob(5))
					del(src)
				return
			else
		return

/obj/structure/sink
	name = "sink"
	icon = 'watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/sink/attack_hand(mob/M as mob)
	if(isrobot(M) || isAI(M))
		return

	if(busy)
		M << "\red Someone's already washing here."
		return

	var/turf/location = M.loc
	if(!isturf(location)) return
	usr << "\blue You start washing your hands."

	busy = 1
	sleep(40)
	busy = 0

	if(M.loc != location) return		//Person has moved away from the sink

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/washer = C
			if(washer.gloves)					//if they have gloves
				washer.gloves.clean_blood()		//clean the gloves
			else								//and if they don't,
				washer.clean_blood()			//wash their hands (a mob being bloody means they are 'red handed')
		else
			C.clean_blood()						//other things that can't wear gloves should just wash the mob.
	for(var/mob/V in viewers(src, null))
		V.show_message("\blue [M] washes their hands using \the [src].")

/obj/structure/sink/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		user << "\red Someone's already washing here."
		return

	if (istype(O, /obj/item/weapon/reagent_containers/glass/bucket))
		O:reagents.add_reagent("water", 70)
		user.visible_message( \
			"\blue [user] fills the [O] using \the [src].", \
			"\blue You fill the [O] using \the [src].")
		return

	if (istype(O, /obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks))
		O:reagents.add_reagent("water", 10)
		user.visible_message( \
			"\blue [user] fills the [O] using \the [src].", \
			"\blue You fill the [O] using \the [src].")
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	usr << "\blue You start washing \the [I]."

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		"\blue [user] washes \a [I] using \the [src].", \
		"\blue You wash \a [I] using \the [src].")


/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'watercloset.dmi'
	icon_state = "toilet10"
	density = 0
	anchored = 1
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/attack_hand(mob/user as mob)
	if(swirlie)
		usr.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie.name]'s head!</span>", "<span class='notice'>You slam the toilet seat onto [swirlie.name]'s head!</span>", "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(8)
		return

	if(cistern && !open)
		if(!contents.len)
			user << "<span class='notice'>The cistern is empty.</span>"
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				if(!user.get_active_hand())
					I.loc = user.loc
					user.put_in_hand(I)
			else
				I.loc = get_turf(src)
			user << "<span class='notice'>You find \an [I] in the cistern.</span>"
			w_items -= I.w_class
			return


/obj/structure/toilet/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		var/mob/living/GM = G.affecting
		if(ismob(G.affecting))
			if(G.state>1 && GM.loc == get_turf(src))
				if(open && !swirlie)
					user.visible_message("<span class='danger'>[user] starts to give [GM.name] a swirlie!</span>", "<span class='notice'>You start to give [GM.name] a swirlie!</span>")
					swirlie = GM
					if(do_after(user, 30, 5, 0))
						user.visible_message("<span class='danger'>[user] gives [GM.name] a swirlie!</span>", "<span class='notice'>You give [GM.name] a swirlie!</span>", "You hear a toilet flushing.")
						if(!GM.internal)
							GM.oxyloss += 28
					swirlie = null
				else
					user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
					GM.adjustBruteLoss(8)
			else
				user << "<span class='notice'>You need a tighter grip.</span>"

	if(cistern)
		if(I.w_class > 3)
			user << "<span class='notice'>\The [I] does not fit.</span>"
			return
		if(w_items + I.w_class > 5)
			user << "<span class='notice'>The cistern is full.</span>"
			return
		user.drop_item()
		I.loc = src
		w_items += I.w_class
		user << "You carefully place \the [I] into the cistern."
		return

/*
 * False Walls
 */
/obj/structure/falsewall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	anchored = 1
	icon = 'icons/turf/walls.dmi'
	var/mineral = "metal"
	var/opening = 0

/obj/structure/falsewall/New()
	relativewall_neighbours()
	..()

/obj/structure/falsewall/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			W.relativewall()

		for(var/obj/structure/falsewall/W in range(temploc,1))
			W.relativewall()

		for(var/obj/structure/falserwall/W in range(temploc,1))
			W.relativewall()
	..()


/obj/structure/falsewall/relativewall()

	if(!density)
		icon_state = "[mineral]fwall_open"
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	for(var/obj/structure/falserwall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	icon_state = "[mineral][junction]"
	return

/obj/structure/falsewall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		icon_state = "[mineral]fwall_open"
		flick("[mineral]fwall_opening", src)
		sleep(15)
		src.density = 0
		opacity = 0
		opening = 0
	else
		opening = 1
		flick("[mineral]fwall_closing", src)
		icon_state = "[mineral]0"
		density = 1
		sleep(15)
		opacity = 1
		src.relativewall()
		opening = 0

/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	if(density)
		icon_state = "[mineral]0"
		src.relativewall()
	else
		icon_state = "[mineral]fwall_open"

/obj/structure/falsewall/proc/ChangeToWall(var/delete = 1)
	var/turf/T = get_turf(src)
	if(!mineral || mineral == "metal")
		T.ChangeTurf(/turf/simulated/wall)
	else
		T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[mineral]"))
	if(delete)
		del(src)
	return T

/obj/structure/falsewall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opening)
		user << "\red You must wait until the door has stopped moving."
		return

	if(density)
		var/turf/T = get_turf(src)
		if(T.density)
			user << "\red The wall is blocked!"
			return
		if(istype(W, /obj/item/weapon/screwdriver))
			user.visible_message("[user] tightens some bolts on the wall.", "You tighten the bolts on the wall.")
			ChangeToWall()

		if( istype(W, /obj/item/weapon/weldingtool) )
			var/obj/item/weapon/weldingtool/WT = W
			if( WT:welding )
				ChangeToWall(0)
				if(mineral != "plasma")//Stupid shit keeps me from pushing the attackby() to plasma walls -Sieve
					T = get_turf(src)
					T.attackby(W,user)
				del(src)
	else
		user << "\blue You can't reach, close it first!"

	if( istype(W, /obj/item/weapon/weldingtool/plasmacutter) || istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		ChangeToWall(0)
		if(mineral != "plasma")
			var/turf/T = get_turf(src)
			T.attackby(W,user)
		del(src)


/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	if(density)
		icon_state = "[mineral]0"
		src.relativewall()
	else
		icon_state = "[mineral]fwall_open"

/*
 * False R-Walls
 */

/obj/structure/falserwall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon = 'icons/turf/walls.dmi'
	icon_state = "r_wall"
	density = 1
	opacity = 1
	anchored = 1
	var/mineral = "metal"
	var/opening = 0

/obj/structure/falserwall/New()
	relativewall_neighbours()
	..()


/obj/structure/falserwall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		// Open wall
		icon_state = "frwall_open"
		flick("frwall_opening", src)
		sleep(15)
		density = 0
		opacity = 0
		opening = 0
	else
		opening = 1
		icon_state = "r_wall"
		flick("frwall_closing", src)
		density = 1
		sleep(15)
		opacity = 1
		relativewall()
		opening = 0

/obj/structure/falserwall/relativewall()

	if(!density)
		icon_state = "frwall_open"
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	for(var/obj/structure/falserwall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	icon_state = "rwall[junction]"
	return



/obj/structure/falserwall/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opening)
		user << "\red You must wait until the door has stopped moving."
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		var/turf/T = get_turf(src)
		user.visible_message("[user] tightens some bolts on the r wall.", "You tighten the bolts on the wall.")
		T.ChangeTurf(/turf/simulated/wall) //Intentionally makes a regular wall instead of an r-wall (no cheap r-walls for you).
		del(src)

	if( istype(W, /obj/item/weapon/weldingtool) )
		var/obj/item/weapon/weldingtool/WT = W
		if( WT.remove_fuel(0,user) )
			var/turf/T = get_turf(src)
			T.ChangeTurf(/turf/simulated/wall)
			T = get_turf(src)
			T.attackby(W,user)
			del(src)

	//DRILLING
	else if (istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		var/turf/T = get_turf(src)
		T.ChangeTurf(/turf/simulated/wall)
		T = get_turf(src)
		T.attackby(W,user)
		del(src)


/*
 * Falsewalls
 */

/obj/structure/falsewall/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon_state = ""
	mineral = "uranium"

/obj/structure/falsewall/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon_state = ""
	mineral = "gold"

/obj/structure/falsewall/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny."
	icon_state = ""
	mineral = "silver"

/obj/structure/falsewall/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon_state = ""
	mineral = "diamond"

/obj/structure/falsewall/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon_state = ""
	mineral = "plasma"

/obj/structure/falsewall/clown
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon_state = ""
	mineral = "clown"

/obj/structure/falsewall/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon_state = ""
	mineral = "sandstone"