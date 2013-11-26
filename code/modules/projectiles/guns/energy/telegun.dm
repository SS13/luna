/obj/item/weapon/gun/energy/teleport_gun
	name = "teleport gun"
	desc = "A hacked together combination of a taser and a handheld teleportation unit."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 250
	projectile_type = "/obj/item/projectile/energy/teleshot"
	origin_tech = "combat=3;magnets=3;bluespace=3"

	var/obj/item/target = null

/obj/item/weapon/gun/energy/teleport_gun/attack_self(mob/user as mob)
	var/list/L = list()
	for(var/obj/machinery/teleport/hub/R in world)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked)
			if(R.icon_state == "tele1")
				L["[com.id] (Active)"] = com.locked
			else
				L["[com.id] (Inactive)"] = com.locked
	L["None (Dangerous)"] = null
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Teleporter Gun") in L
	if (user.equipped() != src || user.stat || user.restrained())
		return
	var/T = L[t1]
	target = T
	usr << "\blue Teleportation hub selected!"
	src.add_fingerprint(user)
	return