/*
 * Water Balloons
 */

/obj/item/weapon/reagent_containers/glass/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"
	icon = 'icons/obj/toy.dmi'
	volume = 10
	unacidable = 0 // if set to 1, no acid

/obj/item/weapon/reagent_containers/glass/balloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/reagent_containers/glass/balloon/on_reagent_change()
	update_icon()
	if(reagents.has_reagent("pacid", 1) && !unacidable)
		visible_message("The acid chews through [src]!","You hear a splash.")
		for(var/turf/splashturf in range(1,get_turf(src.loc)))
			reagents.reaction(splashturf)
			for(var/atom/A in splashturf)
				reagents.reaction(A)
		del(src)

/obj/item/weapon/reagent_containers/glass/balloon/throw_impact(atom/hit_atom)
	if(reagents.total_volume >= 1)
		visible_message("\red The [src.name] bursts!","You hear a pop and a splash.")
		for(var/turf/splashturf in range(1,get_turf(hit_atom)))
			reagents.reaction(splashturf)
			for(var/atom/A in splashturf)
				reagents.reaction(A)
				if(unacidable) reagents.reaction(A) // x2 fun!

		icon_state = "burst"
		sleep(5)
		del(src)
	return

/obj/item/weapon/reagent_containers/glass/balloon/update_icon()
	if(reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
		desc = "A translucent balloon with some form of liquid sloshing around in it."
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"
		desc = "A translucent balloon. There's nothing in it."