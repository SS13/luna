/*
CONTAINS:
TABLE PARTS
REINFORCED TABLE PARTS
RACK PARTS
*/


// TABLE PARTS
/obj/item/weapon/table_parts
	name = "table parts"
	icon = 'items.dmi'
	icon_state = "table_parts"
	flags = FPRINT | CONDUCT


/obj/item/weapon/table_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( src.loc )
		del(src)

/obj/item/weapon/table_parts/attack_self(mob/user as mob)
	spawn()
		new /datum/construction_UI/table (user.loc, user, src)
		user.update_clothing()


// REINFORCED TABLE PARTS
/obj/item/weapon/table_parts/reinforced
	name = "reinforced table parts"
	icon_state = "reinf_tableparts"


/obj/item/weapon/table_parts/reinforced/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/plasteel( src.loc )
		del(src)

/obj/item/weapon/table_parts/reinforced/attack_self(mob/user as mob)
	spawn()
		new /datum/construction_UI/table/reinforced (user.loc, user, src)


// WOODEN TABLE PARTS
/obj/item/weapon/table_parts/wood
	name = "wooden table parts"
	desc = "Keep away from fire."
	icon_state = "wood_tableparts"
	flags = FPRINT

/obj/item/weapon/table_parts/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/wood( user.loc )
		del(src)

/obj/item/weapon/table_parts/wood/attack_self(mob/user as mob)
	spawn()
		new /datum/construction_UI/table/wood(user.loc, user, src)








// RACK PARTS
/obj/item/weapon/rack_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( src.loc )
		del(src)
		return
	return

/obj/item/weapon/rack_parts/attack_self(mob/user as mob)
	var/obj/structure/rack/R = new /obj/structure/rack( user.loc )
	R.add_fingerprint(user)
	del(src)
	return