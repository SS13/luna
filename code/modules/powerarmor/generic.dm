/obj/item/clothing/suit/powered
	name = "Powered armor"
	desc = "Not for rookies."
	icon_state = "swat"
	item_state = "swat"
	w_class = 4//bulky item

	flags = FPRINT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 9
	var/fuel = 0

	var/list/togglearmor = list(melee = 90, bullet = 70, laser = 60,energy = 40, bomb = 75, bio = 75, rad = 75)
	var/active = 0

	var/helmrequired = 1
	var/obj/item/clothing/head/powered/helm

	var/glovesrequired = 0
	var/obj/item/clothing/gloves/powered/gloves

	var/shoesrequired = 0
	var/obj/item/clothing/shoes/powered/shoes
	//Adding gloves and shoes as possible armor components. --NEO

	var/obj/item/weapon/powerarmorcomponent/servos/servos
	var/obj/item/weapon/powerarmorcomponent/reactive/reactive
	var/obj/item/weapon/powerarmorcomponent/atmoseal/atmoseal
	var/obj/item/weapon/powerarmorcomponent/power/power

	New()
		verbs += /obj/item/clothing/suit/powered/proc/poweron

	proc/poweron()
		set category = "Powersuit"
		set name = "Activate armor systems"

		var/mob/living/carbon/human/user = usr

		if(user.stat)
			return //if you're unconscious or dead, no dicking with your armor. --NEO

		if(!istype(user))
			user << "\red This suit was engineered for human use only."
			return

		if(user.wear_suit!=src)
			user << "\red The suit functions best if you are inside of it."
			return

		if(helmrequired && !istype(user.head, /obj/item/clothing/head/powered))
			user << "\red Helmet missing, unable to initiate power-on procedure."
			return

		if(glovesrequired && !istype(user.gloves, /obj/item/clothing/gloves/powered))
			user << "\red Gloves missing, unable to initiate power-on procedure."
			return

		if(shoesrequired && !istype(user.shoes, /obj/item/clothing/shoes/powered))
			user << "\red Shoes missing, unable to initiate power-on procedure."
			return

		if(active)
			user << "\red The suit is already on, you can't turn it on twice."
			return

		if(!power || !power.checkpower())
			user << "\red Powersource missing or depleted."
			return

		verbs -= /obj/item/clothing/suit/powered/proc/poweron

		user << "\blue Suit interlocks engaged."
		if(helmrequired)
			helm = user.head
			helm.canremove = 0
		if(glovesrequired)
			gloves = user.gloves
			gloves.canremove = 0
		if(shoesrequired)
			shoes = user.shoes
			shoes.canremove = 0
		canremove = 0
		sleep(20)

		if(atmoseal)
			atmoseal.toggle()
			sleep(20)

		if(reactive)
			reactive.toggle()
			sleep(20)

		if(servos)
			servos.toggle()
			sleep(20)

		user << "\blue All systems online."
		active = 1
		power.process()

		verbs += /obj/item/clothing/suit/powered/proc/poweroff


	proc/poweroff()
		set category = "Powersuit"
		set name = "Deactivate armor systems"
		powerdown() //BYOND doesn't seem to like it if you try using a proc with vars in it as a verb, hence this. --NEO

	proc/powerdown(sudden = 0)

		var/delay = sudden?0:20

		var/mob/living/carbon/human/user = usr

		if(user.stat && !sudden)
			return //if you're unconscious or dead, no dicking with your armor. --NEO

		if(!active)
			return

		verbs -= /obj/item/clothing/suit/powered/proc/poweroff

		if(sudden)
			user << "\red Your armor loses power!"

		if(servos)
			servos.toggle(sudden)
			sleep(delay)

		if(reactive)
			reactive.toggle(sudden)
			sleep(delay)

		if(atmoseal)
			if(istype(atmoseal, /obj/item/weapon/powerarmorcomponent/atmoseal/optional) && helm)
				atmoseal:helmtoggle(sudden)
			atmoseal.toggle(sudden)

			sleep(delay)

		if(helm && helm.on)
			helm.on = 0
			helm.icon_state = "powered0-[item_color]"
//			item_state = "powered[on]-[color]"

			user.ul_SetLuminosity(user.luminosity - helm:brightness_on)

			user.update_clothing()


		if(!sudden)
			usr << "\blue Suit interlocks disengaged."
			if(helm)
				helm.canremove = 1
				helm = null
			if(gloves)
				gloves.canremove = 1
				gloves = null
			if(shoes)
				shoes.canremove = 1
				gloves = null
			canremove = 1
			//Not a tabbing error, the thing only unlocks if you intentionally power-down the armor. --NEO
		sleep(delay)

		if(!sudden)
			usr << "\blue All systems disengaged."

		active = 0
		verbs += /obj/item/clothing/suit/powered/proc/poweron



	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(power && istype(power,/obj/item/weapon/powerarmorcomponent/power/plasma))
			switch(W.type)
				if(/obj/item/stack/sheet/mineral/plasma)
					if(fuel < 50)
						user << "\blue You feed some refined plasma into the armor's generator."
						power:fuel += 25
						W:amount--
						if (W:amount <= 0)
							del(W)
						return
					else
						user << "\red The generator already has plenty of plasma."
						return

				if(/obj/item/weapon/ore/plasma) //raw plasma has impurities, so it doesn't provide as much fuel. --NEO
					if(fuel < 50)
						user << "\blue You feed some plasma ore into the armor's generator."
						power:fuel += 15
						del(W)
						return
					else
						user << "\red The generator already has plenty of plasma."
						return

		..()

/obj/item/clothing/head/powered
	name = "Powered armor"
	icon_state = "swat"
	desc = "Not for rookies."
	flags = FPRINT | HEADCOVERSEYES | HEADCOVERSMOUTH
	see_face = 0
	var/brightness_on = 5 //luminosity when on
	var/on = 0
	item_state = "swat"
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)
	var/obj/item/clothing/suit/powered/parent
	item_color = "syndie"

	pickup(mob/user)
		if(on)
			user.ul_SetLuminosity(user.luminosity + brightness_on)
			ul_SetLuminosity(0)

	dropped(mob/user)
		if(on)
			on = 0
			icon_state = "powered0-[item_color]"
//			item_state = "powered[on]-[color]"

			user.ul_SetLuminosity(user.luminosity - brightness_on)

			user.update_clothing()

	proc/atmotoggle()
		set category = "Powersuit"
		set name = "Toggle helmet seals"

		var/mob/living/carbon/human/user = usr

		if(!istype(user))
			user << "\red This helmet is not rated for nonhuman use."
			return

		if(user.head != src)
			user << "\red Can't engage the seals without wearing the helmet."
			return

		if(!user.wear_suit || !istype(user.wear_suit,/obj/item/clothing/suit/powered))
			user << "\red This helmet can only couple with powered armor."
			return

		var/obj/item/clothing/suit/powered/armor = user.wear_suit

		if(!armor.atmoseal || !istype(armor.atmoseal, /obj/item/weapon/powerarmorcomponent/atmoseal/optional))
			user << "\red This armor's atmospheric seals are missing or incompatible."
			return

		armor.atmoseal:helmtoggle(0,1)

	proc/lightstoggle()
		set category = "Powersuit"
		set name = "Toggle helmet lights"

		var/mob/living/carbon/human/user = usr

		if(!istype(user))
			user << "\red This helmet is not rated for nonhuman use."
			return

		if(user.head != src)
			user << "\red Can't engage the seals without wearing the helmet."
			return

		if(!user.wear_suit || !istype(user.wear_suit,/obj/item/clothing/suit/powered))
			user << "\red This helmet can only couple with powered armor."
			return

		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return

		if(!user.wear_suit:active)
			user << "The suit must be powered!"
			return

		on = !on
		icon_state = "powered[on]-[item_color]"
//		item_state = "powered[on]-[color]"

		if(on)	user.ul_SetLuminosity(user.luminosity + brightness_on)
		else	user.ul_SetLuminosity(user.luminosity - brightness_on)

		user.update_clothing()

	pickup(mob/user)
		if(on)
			user.ul_SetLuminosity(user.luminosity + brightness_on)
			ul_SetLuminosity(0)

	dropped(mob/user)
		if(on)
			user.ul_SetLuminosity(user.luminosity - brightness_on)
			ul_SetLuminosity(brightness_on)



/obj/item/clothing/gloves/powered
	name = "Powered armor"
	icon_state = "swat"
	desc = "Not for rookies."
	flags = FPRINT
	item_state = "swat"
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)

/obj/item/clothing/shoes/powered
	name = "Powered armor"
	icon_state = "swat"
	desc = "Not for rookies."
	flags = FPRINT
	item_state = "swat"
	armor = list(melee = 40, bullet = 30, laser = 20,energy = 15, bomb = 25, bio = 10, rad = 10)