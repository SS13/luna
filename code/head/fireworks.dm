/obj/item/toy/fire
	icon = 'fireworks.dmi'
	var/lit = 0

/obj/item/toy/fire/attackby(obj/item/weapon/W,mob/user)
	if(lit)	return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) lit(user, W)

	else if(istype(W, /obj/item/toy/minisingulo))
		var/obj/item/toy/minisingulo/S = W
		if(S.on) lit(user, W)

	else if(istype(W, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/L = W
		if(L.lit) lit(user, W)

	else if(istype(W, /obj/item/weapon/match))
		var/obj/item/weapon/match/M = W
		if(M.lit) lit(user, W)

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active) lit(user, W)

	else if(istype(W, /obj/item/toy/fire))
		var/obj/item/toy/fire/F = W
		if(F.lit) lit(user, W)

	else if(istype(W, /obj/item/device/assembly/igniter))
		lit(user, W)

	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/M = W
		if(M.lit) lit(user, W)
	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/C = W
		if(C.on) lit(user, W)

/obj/item/toy/fire/proc/lit(var/mob/user, var/obj/item/I)
	for(var/mob/M in viewers(user))
		M << "[user] lits \the [src] with their [I]."
	lit = 1
	on_lit(user)

/obj/item/toy/fire/proc/on_lit(var/mob/user)
	return

/obj/item/toy/fire/firework
	name = "firework"
	icon_state = "rocket_0"
	var/datum/effect/system/sparkel_spread/S

/obj/item/toy/fire/firework/on_lit()
	icon_state = "rocket_1"
	S = new()
	S.set_up(5,0,src.loc)
	sleep(30)
	if(ismob(src.loc) || isobj(src.loc))
		S.attach(src.loc)
	S.start()
	del(src)


/obj/item/toy/fire/sparkler
	name = "sparkler"
	icon_state = "sparkler_0"
	var/datum/effect/effect/system/spark_spread/S

/obj/item/toy/fire/sparkler/on_lit()
	icon_state = "sparkler_1"
	var/b = rand(5,9)
	for(var/xy, xy<=b, xy++)
		S = new()
		S.set_up(1,0,src.loc)
		if(ismob(src.loc) || isobj(src.loc))
			S.attach(src.loc)
		S.start()
		sleep(10)
	del(src)