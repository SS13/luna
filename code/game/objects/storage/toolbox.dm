/obj/item/weapon/storage/toolbox
	name = "toolbox"
	icon = 'storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	origin_tech = "combat=1"
	flags = FPRINT | CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	origin_tech = "combat=1"

/obj/item/weapon/storage/toolbox/attackby(var/obj/item/stack/tile/metal/T, mob/user as mob)
	if(!istype(T))
		..()
		return
	if(istype(src, /obj/item/weapon/storage/toolbox/syndicate)) return

	if(src.contents.len >= 1)
		user << "They wont fit in as there is already stuff inside!"
		return
	if (user.s_active)
		user.s_active.close(user)
	var/obj/item/weapon/robot_assembly/toolbox_tiles/B = new /obj/item/weapon/robot_assembly/toolbox_tiles
	B.loc = user
	if (user.r_hand == T)
		user.u_equip(T)
		user.r_hand = B
	else
		user.u_equip(T)
		user.l_hand = B
	B.layer = 20
	user << "You add the tiles into the empty toolbox. They stick oddly out the top."

	if(istype(src, /obj/item/weapon/storage/toolbox/empty) || istype(src, /obj/item/weapon/storage/toolbox/emergency)) B.item_color = "r"
	else if (istype(src, /obj/item/weapon/storage/toolbox/electrical)) B.item_color = "y"
	user.update_clothing()
	del(T)
	del(src)


/obj/item/weapon/storage/toolbox/New()
	..()
	if (src.type == /obj/item/weapon/storage/toolbox)
		world << "BAD: [src] ([src.type]) spawned at [src.x] [src.y] [src.z]"
		del(src)

/obj/item/weapon/storage/toolbox/empty

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/weapon/storage/toolbox/emergency/New()
	..()
	new /obj/item/weapon/crowbar/red(src)
	new /obj/item/weapon/weldingtool/mini(src)
	new /obj/item/weapon/extinguisher/mini(src)
	if(prob(50)) new /obj/item/device/flashlight(src)
	else 		 new /obj/item/device/flashlight/flare(src)
	new /obj/item/device/radio(src)


/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/weapon/storage/toolbox/mechanical/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/weapon/wirecutters(src)


/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/weapon/storage/toolbox/electrical/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/t_scanner(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/cable_coil(src,30)
	new /obj/item/weapon/cable_coil(src,30)
	if(prob(10))new /obj/item/clothing/gloves/yellow(src)
	else		new /obj/item/weapon/cable_coil(src,30)

/obj/item/weapon/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = "combat=1;syndicate=1"
	force = 14

/obj/item/weapon/storage/toolbox/syndicate/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool/industrial(src)
	new /obj/item/weapon/crowbar/red(src)
	new /obj/item/weapon/cable_coil(src,30)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/multitool(src)