#define FLASHLIGHT_LUM 4

/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon_state = "flight0"
	var/on = 0
	w_class = 2
	item_state = "flight"
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	m_amt = 50
	g_amt = 20

/obj/item/device/flashlight/attack_self(mob/user)
	on = !on
	icon_state = "flight[on]"

	if(on)
		user.ul_SetLuminosity(user.luminosity + FLASHLIGHT_LUM)
	else
		user.ul_SetLuminosity(user.luminosity - FLASHLIGHT_LUM)


/obj/item/device/flashlight/pickup(mob/user)
	if(on)
		src.ul_SetLuminosity(0)
		user.ul_SetLuminosity(user.luminosity + FLASHLIGHT_LUM)



/obj/item/device/flashlight/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.luminosity - FLASHLIGHT_LUM)
		src.ul_SetLuminosity(FLASHLIGHT_LUM)

/obj/item/clothing/head/helmet/hardhat/attack_self(mob/user)
	on = !on
	icon_state = "hardhat[on]_[color]"
	item_state = "hardhat[on]_[color]"

	if(on)
		user.ul_SetLuminosity(user.luminosity + FLASHLIGHT_LUM)
	else
		user.ul_SetLuminosity(user.luminosity - FLASHLIGHT_LUM)

/obj/item/clothing/head/helmet/hardhat/pickup(mob/user)
	if(on)
		src.ul_SetLuminosity(0)
		user.ul_SetLuminosity(user.luminosity + FLASHLIGHT_LUM)

/obj/item/clothing/head/helmet/hardhat/dropped(mob/user)
	if(on)
		user.ul_SetLuminosity(user.luminosity - FLASHLIGHT_LUM)
		src.ul_SetLuminosity(FLASHLIGHT_LUM)