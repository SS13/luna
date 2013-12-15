/obj/item/device/flash
	name = "flash"
	icon_state = "flash"
	var/l_time = 1
	var/shots = 5
	throwforce = 5
	w_class = 1
	throw_speed = 4
	throw_range = 10
	flags = FPRINT | CONDUCT
	item_state = "electronic"
	var/status = 1
	origin_tech = "magnets=2;combat=1"

/obj/item/device/flash/light
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	slot_flags = SLOT_BELT
	status = -1


/obj/item/device/flash/attack(mob/living/carbon/M as mob, mob/user as mob)
	if ((CLUMSY in usr.mutations) && prob(50))
		usr << "\red The [src.name] slips out of your hand."
		usr.drop_item()
		return

	if ((world.time + 600) > src.l_time)
		shots = 5

	if(shots > 0 && !status)
		playsound(src.loc, 'flash.ogg', 100, 1)
		add_fingerprint(user)
		src.shots--
		l_time = world.time
		flick("[icon_state]2", src)

		var/safety = null
		if (istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if (istype(H.glasses, /obj/item/clothing/glasses/sunglasses) || (istype(H.head, /obj/item/clothing/head/helmet/welding) && !H.head:up))
				safety = 1
		if(isrobot(user))
			spawn(0)
				var/atom/movable/overlay/animation = new(user.loc)
				animation.layer = user.layer + 1
				animation.icon_state = "blank"
				animation.icon = 'mob.dmi'
				animation.master = user
				flick("blspell", animation)
				sleep(5)
				del(animation)
		if(!safety)
			M.Weaken(10)
			if(prob(10) && status == 1)
				status = 0
				icon_state = "flashburnt"
				user << "\red The bulb has burnt out!"
				return
			if(M.eye_stat > 15 && prob(M.eye_stat + 50))
				flick("e_flash", M.flash)
				M.eye_stat += rand(1, 2)
			else
				flick("flash", M.flash)
				M.eye_stat += rand(0, 2)
			if (M.eye_stat >= 20)
				M << "\red You eyes start to burn badly!"
				M.disabilities |= 1
				if(prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= 1
			if((user.mind in ticker.mode.head_revolutionaries) && ticker.mode.name != "rp-revolution")
				ticker.mode.add_revolutionary(M.mind)

		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [user] blinds [M] with [src]!"))

	else
		user.show_message("\red *click* *click*", 2)
		return

	return

/obj/item/device/flash/attack_self(mob/living/carbon/user as mob)
	if ((CLUMSY in usr.mutations) && prob(50))
		usr << "\red The [src.name] slips out of your hand."
		usr.drop_item()
		return

	if ((world.time + 600) > src.l_time)
		shots = 5
	if (shots < 1)
		user.show_message("\red *click* *click*", 2)
		return
	src.l_time = world.time
	add_fingerprint(user)
	src.shots--
	playsound(src.loc, 'flash.ogg', 100, 1)
	flick("[icon_state]2", src)
	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			del(animation)

	for(var/mob/living/carbon/M in oviewers(3, null))
		if(prob(50))
			if (locate(/obj/item/device/cloak, M))
				for(var/obj/item/device/cloak/S in M)
					S.active = 0
					S.icon_state = "shield0"
		if(M.client)
			var/safety = null
			if (istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if (istype(H.glasses, /obj/item/clothing/glasses/sunglasses) || (istype(H.head, /obj/item/clothing/head/helmet/welding) && !H.head:up ))
					safety = 1
			if (!safety)
				flick("flash", M.flash)