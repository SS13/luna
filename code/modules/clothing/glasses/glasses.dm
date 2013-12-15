/obj/item/clothing/glasses
	name = "Glasses"
	icon = 'glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES

	var/see_turfs = 0
	var/see_mobs = 0
	var/see_objs = 0

	var/see_in_dark = 2
	var/see_invisible = 0

/obj/item/clothing/glasses/blindfold
	name = "blindfold"
	icon_state = "blindfold"
	item_state = "blindfold"

/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	origin_tech = "magnets=2;engineering=2"
	icon_state = "meson"
	item_state = "meson"

	see_turfs = 1
	see_in_dark = 3
	see_invisible = 1

/obj/item/clothing/glasses/meson/night
	name = "Night Vision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = "magnets=3;engineering=2"
	see_in_dark = 6

/obj/item/clothing/glasses/science
	name = "Science Goggles"
//	desc = "nothing"
	icon_state = "purple"
	item_state = "glasses"

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/*obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	origin_tech = "magnets=3;engineering=3"
	vision_flags = SEE_OBJS*/

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"

/obj/item/clothing/glasses/regular/hipster
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/gglasses
	name = "green glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	protective_temperature = 1300
	var/already_worn = 0
	see_in_dark = 1

/*
/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Toggle Welding Goggles"
	var/up = 0

/obj/item/clothing/glasses/welding/attack_self()
	toggle()


/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			src.flags |= GLASSESCOVERSEYES
			flags_inv |= HIDEEYES
			icon_state = initial(icon_state)
			usr << "You flip the [src] down to protect your eyes."
		else
			src.up = !src.up
			src.flags &= ~HEADCOVERSEYES
			flags_inv &= ~HIDEEYES
			icon_state = "[initial(icon_state)]up"
			usr << "You push the [src] up out of your face."

		usr.update_inv_glasses(0)
*/
/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
//	vision_flags = BLIND

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	origin_tech = "magnets=3;materials=2;combat=2"
	var/obj/item/clothing/glasses/hud/security/hud = null

	New()
		..()
		src.hud = new/obj/item/clothing/glasses/hud/security(src)
		return

/obj/item/clothing/glasses/sunglasses/sechud/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	origin_tech = "materials=2;magnets=4;syndicate=4"
	see_mobs = 1
	see_in_dark = 4
	see_invisible = 2
	canremove = 0

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "thermal"
	origin_tech = "materials=2;magnets=4;syndicate=4"

	see_mobs = 1
	see_in_dark = 4
	see_invisible = 2

	emp_act(severity)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			if(M.glasses == src)
				M << "\red The Optical Thermal Scanner overloads and blinds you!"
				M.eye_blind = 8
				M.eye_blurry = 16
				M.disabilities |= NEARSIGHTED
				spawn(300)
					M.disabilities &= ~NEARSIGHTED
		..()

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"

/obj/item/clothing/glasses/thermal/monocle
	name = "thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/thermal/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"