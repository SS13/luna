obj/structure
	icon = 'structures.dmi'

	girder
		icon_state = "girder"
		anchored = 1
		density = 1
		var/state = 0

		displaced
			icon_state = "displaced"
			anchored = 0

		reinforced
			icon_state = "reinforced"
			state = 2

/obj/structure/girder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench) && state == 0 && anchored && !istype(src,/obj/structure/girder/displaced))
		playsound(src.loc, 'Ratchet.ogg', 100, 1)
		var/turf/T = get_turf(user)
		user << "\blue Now disassembling the girder"
		sleep(40)
		if(get_turf(user) == T)
			user << "\blue You dissasembled the girder!"
			new /obj/item/weapon/sheet/metal(get_turf(src))
			del(src)

	else if(istype(W, /obj/item/weapon/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
		playsound(src.loc, 'Screwdriver.ogg', 100, 1)
		var/turf/T = get_turf(user)
		user << "\blue Now unsecuring support struts"
		sleep(40)
		if(get_turf(user) == T)
			user << "\blue You unsecured the support struts!"
			state = 1

	else if(istype(W, /obj/item/weapon/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
		playsound(src.loc, 'Wirecutter.ogg', 100, 1)
		var/turf/T = get_turf(user)
		user << "\blue Now removing support struts"
		sleep(40)
		if(get_turf(user) == T)
			user << "\blue You removed the support struts!"
			new/obj/structure/girder( src.loc )
			del(src)

	else if(istype(W, /obj/item/weapon/crowbar) && state == 0 && anchored )
		playsound(src.loc, 'Crowbar.ogg', 100, 1)
		var/turf/T = get_turf(user)
		user << "\blue Now dislodging the girder"
		sleep(40)
		if(get_turf(user) == T)
			user << "\blue You dislodged the girder!"
			new/obj/structure/girder/displaced( src.loc )
			del(src)

	else if(istype(W, /obj/item/weapon/wrench) && state == 0 && !anchored )
		playsound(src.loc, 'Ratchet.ogg', 100, 1)
		var/turf/T = get_turf(user)
		user << "\blue Now securing the girder"
		sleep(40)
		if(get_turf(user) == T)
			user << "\blue You secured the girder!"
			new/obj/structure/girder( src.loc )
			del(src)

	else if((istype(W, /obj/item/weapon/sheet/metal)) && (W:amount >= 2))
		var/turf/T = get_turf(user)
		user << "\blue Now adding plating..."
		sleep(40)
		if (W && get_turf(user) == T)
			user << "\blue You added the plating!"
			var/turf/Tsrc = get_turf(src)
			Tsrc.ReplaceWithWall()
			W:amount -= 2
			if(W:amount <= 0)
				del(W)
			del(src)
		return

	else if (istype(W, /obj/item/weapon/sheet/r_metal))
		var/turf/T = get_turf(user)
		if (src.icon_state == "reinforced") //Time to finalize!
			user << "\blue Now finalising reinforced wall."
			sleep(50)
			if(W && get_turf(user) == T)
				user << "\blue Wall fully reinforced!"
				var/turf/Tsrc = get_turf(src)
				Tsrc.ReplaceWithRWall()
				W:amount--
				if (W:amount <= 0)
					del(W)
				del(src)
				return
		else
			user << "\blue Now reinforcing girders"
			sleep(60)
			user << "\blue Girders reinforced!"
			new/obj/structure/girder/reinforced( src.loc )
			del(src)
			return
	else
		..()

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
	var/mob/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/attack_hand(mob/user as mob)
	if(swirlie)
		usr.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie.name]'s head!</span>", "<span class='notice'>You slam the toilet seat onto [swirlie.name]'s head!</span>", "You hear reverberating porcelain.")
		swirlie.bruteloss += 8
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
		var/mob/GM = G.affecting
		if(ismob(G.affecting))
			if(G.state>1 && GM.loc == get_turf(src))
				if(open && !swirlie)
					user.visible_message("<span class='danger'>[user] starts to give [GM.name] a swirlie!</span>", "<span class='notice'>You start to give [GM.name] a swirlie!</span>")
					swirlie = GM
					if(do_after(user, 30, 5, 0))
						user.visible_message("<span class='danger'>[user] gives [GM.name] a swirlie!</span>", "<span class='notice'>You give [GM.name] a swirlie!</span>", "You hear a toilet flushing.")
						if(!GM.internal)
							GM.bruteloss += 8
					swirlie = null
				else
					user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
					GM.bruteloss += 8
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
