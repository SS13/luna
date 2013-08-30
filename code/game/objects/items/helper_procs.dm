/obj/proc/hear_talk(mob/M as mob, message,italics,alt_name)
	var/mob/mo = locate(/mob) in src
	var/list/understood = list()
	var/list/didnot = list()
	if(mo)
		for(var/mob/mos in src)
			if(mos.say_understands(M))
				understood += mos
				continue
			else
				didnot += mos
	var/rendered
	if (length(understood))
		var/message_a = M.say_quote(message)
		if (italics)
			message_a = "<i>[message_a]</i>"

		if (!istype(M, /mob/living/carbon/human) || istype(M.wear_mask, /obj/item/clothing/mask/gas/voice))
			rendered = "<span class='game say'><span class='name'>[M.name]</span> <span class='message'>[message_a]</span></span>"
		else if(M.face_dmg)
			rendered = "<span class='game say'><span class='name'>Unknown</span> <span class='message'>[message_a]</span></span>"
		else
			rendered = "<span class='game say'><span class='name'>[M.real_name]</span>[alt_name] <span class='message'>[message_a]</span></span>"

		for (var/mob/MS in understood)
			MS.show_message(rendered, 6)

	if (length(didnot))
		var/message_b

		if(M.say_unknown())
			message_b = M.say_unknown()

		else if (M.voice_message)
			message_b = M.voice_message
		else
			message_b = Ellipsis(message)
			message_b = M.say_quote(message_b)

		if (italics)
			message_b = "<i>[message_b]</i>"

		rendered = "<span class='game say'><span class='name'>[M.voice_name]</span> <span class='message'>[message_b]</span></span>"

		for (var/mob/MS in didnot)
			MS.show_message(rendered, 6)

	// I HATE YOU FOR THIS