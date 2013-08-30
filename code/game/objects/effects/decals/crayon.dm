/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A rune drawn in crayon."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = 1


	examine()
		set src in view(2)
		..()
		return


	New(location,main = "#FFFFFF",shade = "#000000",var/type = "rune")
		..()
		loc = location

		name = type
		desc = "A [type] drawn in crayon."

		switch(type)
			if("rune")
				type = "rune[rand(1,6)]"
			if("graffiti")
				type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")

		var/icon/mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]",2.1)
		var/icon/shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]s",2.1)

		mainOverlay.Blend(main,ICON_ADD)
		shadeOverlay.Blend(shade,ICON_ADD)

		overlays += mainOverlay
		overlays += shadeOverlay

/obj/effect/decal/cleanable/crayon/explosive
	var/exploding = 0

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		if(istype(W, /obj/item/weapon/weldingtool) && W:isOn()) ingite(user)
		else if(istype(W, /obj/item/toy/minisingulo) && W:on) ingite(user)
		else if(istype(W, /obj/item/weapon/lighter) && W:lit) ingite(user)
		else if(istype(W, /obj/item/weapon/match) && W:lit) ingite(user)
		else if(istype(W, /obj/item/weapon/melee/energy/sword) && W:active) ingite(user)
		else if(istype(W, /obj/item/device/assembly/igniter)) ingite(user)
		else if(istype(W, /obj/item/clothing/mask/cigarette)  && W:lit)	ingite(user)
		else if(istype(W, /obj/item/device/flashlight/flare) && W:on) ingite(user)

	proc/ingite(mob/user)
		user << "You ingite the explosive [name]!"
		sleep(10)
		explode()

	ex_act(blah)
		explode()

	proc/explode()
		if(!exploding)
			exploding = 1
			sleep(2)
			explosion(src.loc,-1,-1,1)
