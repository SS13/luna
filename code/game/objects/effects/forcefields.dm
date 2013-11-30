/obj/effect/forcefield
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield"
	anchored = 1.0
	opacity = 0
	density = 1
	unacidable = 1



///////////Mimewalls///////////

/obj/effect/forcefield/mime
	icon_state = "empty"
	name = "invisible wall"
	desc = "You have a bad feeling about this."

/obj/effect/forcefield/mime/Bumped(var/mob/living/M)
	if(istype(M))
		for(var/mob/V in viewers(M))
			if(V!=usr)
				V.show_message("[M] looks as if a wall is in front of them.", 3, "", 2)