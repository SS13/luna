/*
CONTAINS:
PAPER
WRAPPING PAPER
GIFTS
BEDSHEET BIN
PHOTOGRAPHS
*/


// PAPER

/obj/item/weapon/paper/New()

	..()
	src.pixel_y = rand(-8, 8)
	src.pixel_x = rand(-9, 9)
	return


/obj/item/weapon/paper/examine()
	set src in view()

	..()
	if (!( istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead) || istype(usr, /mob/living/silicon) ))
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, Ellipsis(src.info)), text("window=[]", src.name))
		onclose(usr, "[src.name]")
	else
		var/t = dd_replacetext(src.info, "\n", "<BR>")
		t = dd_replacetext(t, "\[b\]", "<B>")
		t = dd_replacetext(t, "\[/b\]", "</B>")
		t = dd_replacetext(t, "\[i\]", "<I>")
		t = dd_replacetext(t, "\[/i\]", "</I>")
		t = dd_replacetext(t, "\[u\]", "<U>")
		t = dd_replacetext(t, "\[/u\]", "</U>")
		t = text("<font face=calligrapher>[]</font>", t)
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, t), text("window=[]", src.name))
		onclose(usr, "[src.name]")
	return

/obj/item/weapon/paper/attack_self(mob/user as mob)
	if ((usr.mutations & CLUMSY) && prob(50))
		usr << text("\red You cut yourself on the paper.")
		usr:adjustBruteLoss(1)
		return
	var/n_name = input(user, "What would you like to label the paper?", "Paper Labelling", null)  as text
	n_name = copytext(n_name, 1, 32)
	if ((src.loc == user && user.stat == 0))
		src.name = text("paper[]", (n_name ? text("- '[]'", n_name) : null))
	src.add_fingerprint(user)
	return

/obj/item/weapon/paper/attack_ai(var/mob/living/silicon/ai/user as mob)
	if (get_dist(src, user.current) < 2)
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, src.info), text("window=[]", src.name))
		onclose(usr, "[src.name]")
	else
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", src.name, Ellipsis(src.info)), text("window=[]", src.name))
		onclose(usr, "[src.name]")
	return

/obj/item/weapon/paper/attackby(obj/item/weapon/P as obj, mob/user as mob)

	if (istype(P, /obj/item/weapon/pen))
		if(src.stamped == 1)
			user << "\blue This paper has been stamped and can no longer be edited."
			return

		var/t = "[src.info]"
		do
			t = input(user, "What text do you wish to add?", text("[]", src.name), t)  as message
			if ((!in_range(src, usr) && src.loc != user && !( istype(src.loc, /obj/item/weapon/clipboard) ) && src.loc.loc != user && user.equipped() != P))
				return

			if(lentext(t) >= MAX_PAPER_MESSAGE_LEN)
				var/cont = input(user, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
				if(cont == "no")
					break
		while(lentext(t) > MAX_PAPER_MESSAGE_LEN)


		t = copytext(t,1,MAX_PAPER_MESSAGE_LEN)			//Allow line breaks on paper

		src.info = t
	else
		if(istype(P, /obj/item/weapon/stamp))
			if ((!in_range(src, usr) && src.loc != user && !( istype(src.loc, /obj/item/weapon/clipboard) ) && src.loc.loc != user && user.equipped() != P))
				return
			src.info += text("<BR><i>This paper has been stamped with the [].</i><BR>", P.name)
			src.icon_state = "paper_stamped"
			src.stamped = 1
			user << "\blue You stamp the paper with your rubber stamp."

	src.add_fingerprint(user)
	return






// WRAPPING PAPER

/obj/item/weapon/wrapping_paper/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!( locate(/obj/structure/table, src.loc) ))
		user << "\blue You MUST put the paper on a table!"
	if (W.w_class < 4)
		if ((istype(user.l_hand, /obj/item/weapon/wirecutters) || istype(user.r_hand, /obj/item/weapon/wirecutters)))
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				user << "\blue You need more paper!"
				return
			else
				src.amount -= a_used
				user.drop_item()
				var/obj/item/weapon/gift/G = new /obj/item/weapon/gift( src.loc )
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = text("gift[]", G.size)
				G.gift = W
				W.loc = G
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
			if (src.amount <= 0)
				new /obj/item/weapon/c_tube( src.loc )
				//SN src = null
				del(src)
				return
		else
			user << "\blue You need scissors!"
	else
		user << "\blue The object is FAR too large!"
	return


/obj/item/weapon/wrapping_paper/examine()
	set src in oview(1)

	..()
	usr << text("There is about [] square units of paper left!", src.amount)
	return

/obj/item/weapon/wrapping_paper/attack(target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	if (istype(target:wear_suit, /obj/item/clothing/suit/straight_jacket) || target:stat)
		if (src.amount > 2)
			var/obj/spresent/present = new /obj/spresent (target:loc)
			src.amount -= 2

			if (target:client)
				target:client:perspective = EYE_PERSPECTIVE
				target:client:eye = present

			target:loc = present
		else
			user << "/blue You need more paper."
	else
		user << "Theyre moving around too much. a Straitjacket would help."





// GIFTS

/obj/item/weapon/gift/attack_self(mob/user as mob)
	if(!src.gift)
		user << "\blue The gift was empty!"
		del(src)
	src.gift.loc = user
	if (user.hand)
		user.l_hand = src.gift
	else
		user.r_hand = src.gift
	src.gift.layer = 20
	src.gift.add_fingerprint(user)
	del(src)
	return

/obj/item/weapon/a_gift/ex_act()
	del(src)
	return


/obj/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	user << "\blue You can't move."

/obj/spresent/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!istype(W, /obj/item/weapon/wirecutters))
		user << "\blue I need wirecutters for that."
		return

	user << "\blue You cut open the present."

	for(var/mob/M in src) //Should only be one but whatever.
		M.loc = src.loc
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	del(src)


/obj/item/weapon/a_gift/attack_self(mob/M as mob)
	switch(pick("flash", "t_gun", "l_gun", "shield", "sword", "axe"))
		if("flash")
			var/obj/item/device/flash/W = new /obj/item/device/flash( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 20
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("l_gun")
			var/obj/item/weapon/gun/energy/laser/W = new /obj/item/weapon/gun/energy/laser( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 20
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("t_gun")
			var/obj/item/weapon/gun/energy/taser/W = new /obj/item/weapon/gun/energy/taser( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 20
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("shield")
			var/obj/item/device/shield/W = new /obj/item/device/shield( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 20
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("sword")
			var/obj/item/weapon/melee/energy/sword/W = new /obj/item/weapon/melee/energy/sword( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 20
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		if("axe")
			var/obj/item/weapon/melee/energy/axe/W = new /obj/item/weapon/melee/energy/axe( M )
			if (M.hand)
				M.l_hand = W
			else
				M.r_hand = W
			W.layer = 20
			W.add_fingerprint(M)
			//SN src = null
			del(src)
			return
		else
	return


// PHOTOGRAPH

/obj/item/weapon/paper/photograph/New()

	..()
	src.pixel_y = 0
	src.pixel_x = 0
	return

/obj/item/weapon/paper/photograph/attack_self(mob/user as mob)

	var/n_name = input(user, "What would you like to label the photo?", "Paper Labelling", null)  as text
	n_name = copytext(n_name, 1, 32)
	if ((src.loc == user && user.stat == 0))
		src.name = text("photo[]", (n_name ? text("- '[]'", n_name) : null))
	src.add_fingerprint(user)
	return
