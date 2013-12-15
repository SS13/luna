/obj/item/weapon/gun/energy/gun
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: stun and kill."
	icon_state = "energystun100"
	item_state = "gun"	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=3;magnets=2"
	modifystate = "energystun"

	var/mode = 0 //0 = stun, 1 = kill


	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 100
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "energykill"
			if(1)
				mode = 0
				charge_cost = 100
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "energystun"
		update_icon()
		user.update_clothing()


/obj/item/weapon/gun/energy/gun/mini
	desc = "A basic energy-based gun with two settings: stun and kill. This one is small enough to fit in pocket and has a built in flash."
	icon_state = "energy_ministun100"
	modifystate = "energy_ministun"
	charge_cost = 120
	w_class = 2

	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 150
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "energy_minikill"
			if(1)
				mode = 0
				charge_cost = 120
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "energy_ministun"
		update_icon()
		user.update_clothing()

	attack(mob/living/carbon/M as mob, mob/user as mob)
		if ((CLUMSY in usr.mutations) && prob(50))
			usr << "\red The [src.name] slips out of your hand."
			usr.drop_item()
			return

		if(power_supply.use(50))
			playsound(src.loc, 'flash.ogg', 100, 1)
			add_fingerprint(user)

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
				O.show_message(text("\red [user] blinds [M] with [src]'s flash!"))

		else
			user.show_message("\red *click*", 2)

		update_icon()

		return

/obj/item/weapon/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"
	item_state = "nucgun"
	origin_tech = "combat=3;materials=5;powerstorage=3"
	var/lightfail = 0
	var/charge_tick = 0

	New()
		..()
		processing_items.Add(src)


	Del()
		processing_items.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		if((power_supply.charge / power_supply.maxcharge) != 1)
			if(!failcheck())	return 0
			power_supply.give(100)
			update_icon()
		return 1


	proc
		failcheck()
			lightfail = 0
			if (prob(src.reliability))   return 1 //No failure
			if (prob(src.reliability + 14))
				for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
					if (src in M.contents)
						M << "\red Your gun feels pleasantly warm for a moment."
					else
						M << "\red You feel a warm sensation."
					M.apply_effect(rand(1,30), IRRADIATE)
				lightfail = 1
			else
				for (var/mob/living/M in range(rand(1,4),src)) //Big failure, TIME FOR RADIATION BITCHES
					if (src in M.contents)
						M << "\red Your gun's reactor overloads!"
					M << "\red You feel a wave of heat wash over you."
					M.apply_effect(140, IRRADIATE)
				crit_fail = 1 //break the gun so it stops recharging
				processing_items.Remove(src)
				update_icon()
			return 0


		update_charge()
			if (crit_fail)
				overlays += "nucgun-whee"
				return
			var/ratio = power_supply.charge / power_supply.maxcharge
			ratio = round(ratio, 0.25) * 100
			overlays += "nucgun-[ratio]"


		update_reactor()
			if(crit_fail)
				overlays += "nucgun-crit"
				return
			if(lightfail)
				overlays += "nucgun-medium"
			else if ((power_supply.charge/power_supply.maxcharge) <= 0.5)
				overlays += "nucgun-light"
			else
				overlays += "nucgun-clean"


		update_mode()
			if (mode == 0)
				overlays += "nucgun-stun"
			else if (mode == 1)
				overlays += "nucgun-kill"


	emp_act(severity)
		..()
		reliability -= round(15/severity)


	update_icon()
		overlays.Cut()
		update_charge()
		update_reactor()
		update_mode()

/obj/item/weapon/gun/energy/gun/newgun
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."
	icon_state = "energy_newstun100"
	item_state = "energystun100"	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	modifystate = "energy_newstun"

	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 100
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "energy_newkill"
			if(1)
				mode = 0
				charge_cost = 100
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "energy_newstun"
		update_icon()
		user.update_clothing()

	update_icon()
		..()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		if(mode)	item_state = "energykill[ratio]"
		else		item_state = "energystun[ratio]"