/*
CONTAINS:

ORANGE SHOES
MUZZLE
CAKEHAT
SUNGLASSES
CIGARETTE
SWAT SUIT
CHAMELEON JUMPSUIT
DEATH COMMANDO GAS MASK
*/


/*
/obj/item/clothing/fire_burn(obj/fire/raging_fire, datum/air_group/environment)
	if(raging_fire.internal_temperature > src.s_fire)
		spawn( 0 )
			var/t = src.icon_state
			src.icon_state = ""
			src.icon = 'b_items.dmi'
			flick(text("[]", t), src)
			spawn(14)
				del(src)
				return
			return
		return 0
	return 1
*/ //TODO FIX

/obj/item/clothing/gloves/examine()
	set src in usr
	..()
	return

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	if (src.chained)
		src.chained = null
		new /obj/item/weapon/handcuffs( user.loc )
		src.icon_state = "orange"
	return

/obj/item/clothing/shoes/orange/attackby(H as obj, loc)
	if ((istype(H, /obj/item/weapon/handcuffs) && !( src.chained )))
		//H = null
		del(H)
		src.chained = 1
		src.icon_state = "orange1"
	return

/obj/item/clothing/mask/muzzle/attack_paw(mob/user as mob)
	if (src == user.wear_mask)
		return
	else
		..()
	return


/obj/item/clothing/under/chameleon/New()
	..()

	for(var/U in typesof(/obj/item/clothing/under/color)-(/obj/item/clothing/under/color))

		var/obj/item/clothing/under/V = new U
		src.clothing_choices += V


	return


/obj/item/clothing/under/chameleon/all/New()
	..()

	var/blocked = list(/obj/item/clothing/under/chameleon, /obj/item/clothing/under/chameleon/all)
	//to prevent an infinite loop

	for(var/U in typesof(/obj/item/clothing/under)-blocked)

		var/obj/item/clothing/under/V = new U
		src.clothing_choices += V



/obj/item/clothing/under/chameleon/attackby(obj/item/clothing/under/U as obj, mob/user as mob)

	if(istype(U, /obj/item/clothing/under/chameleon))
		user << "\red Nothing happens."
		return

	if(istype(U, /obj/item/clothing/under))

		if(src.clothing_choices.Find(U))
			user << "\red Pattern is already recognised by the suit."
			return

		src.clothing_choices += U

		user << "\red Pattern absorbed by the suit."

/obj/item/clothing/under/chameleon/verb/change()
	set name = "Change"
	set src in usr

	if(icon_state == "psyche")
		usr << "\red Your suit is malfunctioning"
		return

	var/obj/item/clothing/under/A

	A = input("Select Colour to change it to", "BOOYEA", A) in clothing_choices

	if(!A)
		return

	desc = null
	permeability_coefficient = 0.90

	desc = A.desc
	name = A.name
	icon_state = A.icon_state
	item_state = A.item_state
	item_color = A.item_color

/obj/item/clothing/suit/swat_suit/death_commando
	name = "Death Commando Suit"
	icon_state = "death_commando_suit"
	item_state = "death_commando_suit"
	flags = FPRINT | SUITSPACE

/obj/item/clothing/mask/gas/death_commando
	name = "Death Commando Mask"
	icon_state = "death_commando_mask"
	item_state = "death_commando_mask"
