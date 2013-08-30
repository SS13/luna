/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"

obj/structure/stool/bed/chair/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob = null
	return

/obj/structure/stool/bed/chair/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled /*|| istype(user, /mob/living/silicon/pai) */)
		return
	unbuckle()
	if (M == usr)
		M.visible_message(\
			"\blue [M.name] buckles in!",\
			"You buckle yourself to [src].",\
			"You hear metal clanking")
	else
		M.visible_message(\
			"\blue [M.name] is buckled in to [src] by [user.name]!",\
			"You are buckled in to [src] by [user.name].",\
			"You hear metal clanking")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/obj/structure/stool/bed/chair/New()
	if(anchored)
		src.verbs -= /atom/movable/verb/pull
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_rotation()
	return

/obj/structure/stool/bed/chair/schair
	name = "pod chair"
	icon_state = "schair"
	anchored = 1

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
/*	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			user << "<span class='notice'>[SK] is not ready to be attached!</span>"
			return
		user.drop_item()
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		del(src)*/
	if(istype(W, /obj/item/weapon/wrench) && istype(src , /obj/structure/stool/bed/chair/schair))
		usr << "\blue Bolts, which hold this chair, are immovable."
		return
	..()

/obj/structure/stool/bed/chair/proc/handle_rotation()	//making this into a seperate proc so office chairs can call it on Move()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

	if(buckled_mob)
		if(buckled_mob.loc != src.loc)
			buckled_mob.loc = src.loc
		if(buckled_mob.dir != dir)
			buckled_mob.dir = dir

/obj/structure/stool/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	src.dir = turn(src.dir, 90)
	handle_rotation()
	return

/obj/structure/stool/bed/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

// Chair types
/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/wood(src.loc)
		del(src)
	else
		..()

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."

/obj/structure/stool/bed/chair/comfy/brown
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/stool/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/stool/bed/chair/office
	anchored = 0

/obj/structure/stool/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/stool/bed/chair/office/Move()
	..()
	handle_rotation()

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"