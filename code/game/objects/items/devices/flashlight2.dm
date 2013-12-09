/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = 2
	flags = FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	m_amt = 50
	g_amt = 20
	var/on = 0
	var/brightness_on_r = 4 //luminosity when on, R
	var/brightness_on_g = 4 //luminosity when on, G
	var/brightness_on_b = 4 //luminosity when on, B

/obj/item/device/flashlight/initialize()
	..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		ul_SetLuminosity(brightness_on_r, brightness_on_g, brightness_on_b)
	else
		icon_state = initial(icon_state)
		ul_SetLuminosity(0)

/obj/item/device/flashlight/proc/update_brightness(var/mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(loc == user)
			user.ul_SetLuminosity(user.LuminosityRed + brightness_on_r, user.LuminosityGreen + brightness_on_g, user.LuminosityBlue + brightness_on_b)
		else if(isturf(loc))
			ul_SetLuminosity(brightness_on_r, brightness_on_g, brightness_on_b)
	else
		icon_state = initial(icon_state)
		if(loc == user)
			user.ul_SetLuminosity(user.LuminosityRed - brightness_on_r, user.LuminosityGreen - brightness_on_g, user.LuminosityBlue - brightness_on_b)
		else if(isturf(loc))
			ul_SetLuminosity(0)

/obj/item/device/flashlight/verb/toggle()
	set name = "Toggle Flashlight"
	set category = "Object"
	set src in oview(1)
	if(!usr.stat)
		attack_self(usr)


/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
		return 0
	on = !on
	update_brightness(user)
	return 1


/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == "eyes")

		if(((CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")	//don't have dexterity
			user << "<span class='notice'>You don't have the dexterity to do this!</span>"
			return

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.flags & HEADCOVERSEYES) || (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || (H.glasses && H.glasses.flags & GLASSESCOVERSEYES)))
			user << "<span class='notice'>You're going to need to remove that [(H.head && H.head.flags & HEADCOVERSEYES) ? "helmet" : (H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) ? "mask": "glasses"] first.</span>"
			return

		if(M == user)	//they're using it on themselves
			if(!M.blinded)
				flick("flash", M.flash)
				M.visible_message("<span class='notice'>[M] directs [src] to \his eyes.</span>", \
									 "<span class='notice'>You wave the light in front of your eyes! Trippy!</span>")
			else
				M.visible_message("<span class='notice'>[M] directs [src] to \his eyes.</span>", \
									 "<span class='notice'>You wave the light in front of your eyes.</span>")
			return

		user.visible_message("<span class='notice'>[user] directs [src] to [M]'s eyes.</span>", \
							 "<span class='notice'>You direct [src] to [M]'s eyes.</span>")

		if(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey))	//robots and aliens are unaffected
			if(M.stat == DEAD || M.sdisabilities & BLIND)	//mob is dead or fully blind
				user << "<span class='notice'>[M] pupils does not react to the light!</span>"
			else if(XRAY in M.mutations)	//mob has X-RAY vision
				user << "<span class='notice'>[M] pupils give an eerie glow!</span>"
			else	//they're okay!
				if(!M.blinded)
					flick("flash", M.flash)	//flash the affected mob
					user << "<span class='notice'>[M]'s pupils narrow.</span>"
	else
		return ..()


/obj/item/device/flashlight/lantern
	name = "lantern"
	desc = "Old, dusty mining lantern."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lantern"
	brightness_on_r = 6 //luminosity when on, R
	brightness_on_g = 6 //luminosity when on, G
	brightness_on_b = 5 //luminosity when on, B


/obj/item/device/flashlight/pickup(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed + brightness_on_r, user.LuminosityGreen + brightness_on_g, user.LuminosityBlue + brightness_on_b)
		ul_SetLuminosity(0)


/obj/item/device/flashlight/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.LuminosityRed - brightness_on_r, user.LuminosityGreen - brightness_on_g, user.LuminosityBlue - brightness_on_b)
		ul_SetLuminosity(brightness_on_r, brightness_on_g, brightness_on_b)


/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	brightness_on_r = 2 //luminosity when on, R
	brightness_on_g = 2 //luminosity when on, G
	brightness_on_b = 2 //luminosity when on, B


// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	brightness_on_r = 6 //luminosity when on, R
	brightness_on_g = 6 //luminosity when on, G
	brightness_on_b = 6 //luminosity when on, B
	w_class = 4
	m_amt = 0
	g_amt = 0
	on = 1


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	brightness_on_r = 6 //luminosity when on, R
	brightness_on_g = 6 //luminosity when on, G
	brightness_on_b = 6 //luminosity when on, B


/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red Nanotrasen issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	w_class = 2.0
	brightness_on_r = 7 //luminosity when on, R - pretty bright
	brightness_on_g = 1 //luminosity when on, G
	brightness_on_b = 1 //luminosity when on, B
	icon_state = "flare"
	item_state = "flare"
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500

/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		processing_others -= src

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/attack_self(mob/user)
	// Usual checks
	if(!fuel)
		user << "<span class='notice'>It's out of fuel.</span>"
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] activates the flare.</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")
		src.force = on_damage
		src.damtype = "fire"
		processing_others += src


/obj/item/device/flashlight/slime
	name = "glowing slime extract"
	desc = "Extract from a yellow slime. It emits a strong light when squeezed."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "slime"
	item_state = "slime"
	w_class = 2
	flags = FPRINT
	slot_flags = SLOT_BELT
	m_amt = 0
	g_amt = 0
	brightness_on_r = 6 //luminosity when on, R
	brightness_on_g = 6 //luminosity when on, G
	brightness_on_b = 5 //luminosity when on, B


/obj/item/clothing/head/helmet/hardhat/attack_self(mob/user)
	on = !on
	icon_state = "hardhat[on]_[item_color]"
	item_state = "hardhat[on]_[item_color]"

	if(on)
		user.ul_SetLuminosity(user.luminosity + 5)
	else
		user.ul_SetLuminosity(user.luminosity - 5)

/obj/item/clothing/head/helmet/hardhat/pickup(mob/user)
	if(on)
		src.ul_SetLuminosity(0)
		user.ul_SetLuminosity(user.luminosity + 5)

/obj/item/clothing/head/helmet/hardhat/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.luminosity - 5)
		src.ul_SetLuminosity(5)