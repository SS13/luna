var/list/department_radio_keys = list(
	  ":r" = "right hand",	"#r" = "right hand",	".r" = "right hand",
	  ":l" = "left hand",	"#l" = "left hand",		".l" = "left hand",
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":c" = "Command",		"#c" = "Command",		".c" = "Command",
	  ":n" = "Science",		"#n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		"#m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", "#e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",	"#s" = "Security",		".s" = "Security",
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":b" = "binary",		"#b" = "binary",		".b" = "binary",
	  ":a" = "alientalk",	"#a" = "alientalk",		".a" = "alientalk",
	  ":t" = "Syndicate",	"#t" = "Syndicate",		".t" = "Syndicate",
	  ":q" = "Supply",		"#q" = "Supply",		".q" = "Supply",
	  ":g" = "changeling",	"#g" = "changeling",	".g" = "changeling",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":ê" = "right hand",	"#ê" = "right hand",	".ê" = "right hand",
	  ":ä" = "left hand",	"#ä" = "left hand",		".ä" = "left hand",
	  ":ø" = "intercom",	"#ø" = "intercom",		".ø" = "intercom",
	  ":ð" = "department",	"#ð" = "department",	".ð" = "department",
	  ":ñ" = "Command",		"#ñ" = "Command",		".ñ" = "Command",
	  ":ò" = "Science",		"#ò" = "Science",		".ò" = "Science",
	  ":ü" = "Medical",		"#ü" = "Medical",		".ü" = "Medical",
	  ":ó" = "Engineering",	"#ó" = "Engineering",	".ó" = "Engineering",
	  ":û" = "Security",	"#û" = "Security",		".û" = "Security",
	  ":ö" = "whisper",		"#ö" = "whisper",		".ö" = "whisper",
	  ":è" = "binary",		"#è" = "binary",		".è" = "binary",
	  ":ô" = "alientalk",	"#ô" = "alientalk",		".ô" = "alientalk",
	  ":å" = "Syndicate",	"#å" = "Syndicate",		".å" = "Syndicate",
	  ":é" = "Supply",		"#é" = "Supply",		".é" = "Supply",
	  ":ï" = "changeling",	"#ï" = "changeling",	".ï" = "changeling"
)

/mob/living/proc/binarycheck() // /tg/ stuff, let it be  -- Nikie
	//if (istype(src, /mob/living/silicon/pai)) return
	if(issilicon(src)) return 1
	if(!ishuman(src)) return 0
	var/mob/living/carbon/human/H = src
	if (H.ears)
		var/obj/item/device/radio/headset/dongle = H.ears
		if(!istype(dongle)) return 0
		if(dongle.translate_binary) return 1

/mob/living/proc/hivecheck()
	if (isalien(src)) return 1
	if (!ishuman(src)) return 0
	var/mob/living/carbon/human/H = src
	if (H.ears)
		var/obj/item/device/radio/headset/dongle = H.ears
		if(!istype(dongle)) return 0
		if(dongle.translate_hive) return 1

/mob/living/say(var/message, var/presanitize = 1)
	if(presanitize)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	// sdisabilities & 2 is the mute disability
	if(!message || muted || stat == 1 || istype(wear_mask, /obj/item/clothing/mask/muzzle) || sdisabilities & 2)
		return

	if(stat == 2)
		return say_dead(message)

	// emotes
	if (copytext(message, 1, 2) == "*" && !stat)
		return emote(copytext(message, 2))

	if(silent)
		return

	// In case an object applies custom effects to the spoken message.
	// This offers more flexibility (overwrite brainloss effects, headset stunned check etc.) here than if it were inserted further below.

	// However, if you need to copy-paste a lot of the code below, consider whether it would be better to insert another hook underneath.
	if(isobj(src.loc))
		if(src.loc:overrideMobSay(message, src) != "not used") // if the obj has a custom effect
			return

	if(viruses.len)
		for(var/datum/disease/pierrot_throat/D in viruses)
			var/list/temp_message = text2list(message, " ") //List each word in the message
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++) //Create a second list for excluding words down the line
				pick_list += i
			for(var/i=1, ((i <= D.stage) && (i <= temp_message.len)), i++) //Loop for each stage of the disease or until we run out of words
				if(prob(3 * D.stage)) //Stage 1: 3% Stage 2: 6% Stage 3: 9% Stage 4: 12%
					var/H = pick(pick_list)
					if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
					temp_message[H] = "HONK"
					pick_list -= H //Make sure that you dont HONK the same word twice
				message = dd_list2text(temp_message, " ")

	//custom modes
	//if theres no space then theyre being a derpface
	var/custommode = ""
	var/firstspace = findtext(message, " ")
	if(copytext(message,1,6) == "&amp;" && firstspace > 7) //one character verbs?
		custommode = copytext(message,6,firstspace)
		message = copytext(message, firstspace+1)

	var/alt_name = "" // In case your face is burnt or you're wearing a mask
	if (istype(src, /mob/living/carbon/human) && name != GetVoice())
		if(istype(src:wear_id,/obj/item/weapon/card/id))
			if (src:wear_id:registered)
				alt_name = " (as [src:wear_id:registered])"
			else
				alt_name = " (as Unknown)"

		else if(istype(src:wear_id,/obj/item/device/pda))
			var/obj/item/device/pda/tempPda = src:wear_id
			if(tempPda.owner)
				alt_name = " (as [tempPda.owner])"
			else
				alt_name = " (as Unknown)"


	var/italics = 0
	var/message_range = null
	var/message_mode = null

	if (brainloss >= 60 && prob(50))
		if (ishuman(src))
			message_mode = "headset"
	// Special message handling
	else if (copytext(message, 1, 2) == ";")
		if (ishuman(src))
			message_mode = "headset"
		message = copytext(message, 2)

	else if (length(message) >= 2)
		var/channel_prefix = lowertext(copytext(message, 1, 3))

		message_mode = department_radio_keys[channel_prefix]
		//world << "channel_prefix=[channel_prefix]; message_mode=[message_mode]"
		if (message_mode)
			message = trim(copytext(message, 3))
			if (!ishuman(src) && !isrobot(src) && (message_mode=="department" || (message_mode in radiochannels)))
				message_mode = null //only humans can use headsets

	if(src.stunned > 0)
		message_mode = "" //Stunned people shouldn't be able to physically turn on their radio/hold down the button to speak into it

	message = trim(message)

	if (!message)
		return

	message = addtext(uppertext(copytext(message,1,2)), copytext(message, 2)) //capitalize the first letter of what they actually say

	if (stuttering)
		message = NewStutter(message,stunned)
	if (intoxicated)
		message = Intoxicated(message)

	// :downs:
	if (brainloss >= 60)
		message = dd_replacetext(message, " am ", " ")
		message = dd_replacetext(message, " is ", " ")
		message = dd_replacetext(message, " are ", " ")
		message = dd_replacetext(message, "you", "u")
		message = dd_replacetext(message, "help", "halp")
		message = dd_replacetext(message, "grief", "grife")
		if(prob(50))
			message = uppertext(message)
			message += "[stutter(pick("!", "!!", "!!!"))]"
		if(!stuttering && prob(15))
			message = NewStutter(message)

	if(istype(wear_mask, /obj/item/clothing/mask/gas/horsehead))
		var/obj/item/clothing/mask/gas/horsehead/hoers = wear_mask
		if(!hoers.canremove)
			message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")

	if (!istype(src, /mob/living/silicon))
		var/list/obj/item/used_radios = new
		switch (message_mode)
			if ("headset")
				if (src:ears)
					src:ears.talk_into(src, message)

				message_range = 1
				italics = 1

			if ("security_headset")
				if (src:ears)
					src:ears.security_talk_into(src, message)

				message_range = 1
				italics = 1

			if ("right hand")
				if (r_hand)
					r_hand.talk_into(src, message)

				message_range = 1
				italics = 1

			if ("left hand")
				if (l_hand)
					l_hand.talk_into(src, message)

				message_range = 1
				italics = 1

			if ("intercom")
				for (var/obj/item/device/radio/intercom/I in view(1, null))
					I.talk_into(src, message)

				message_range = 1
				italics = 1

			//I see no reason to restrict such way of whispering
			if ("whisper")
				whisper(message)
				return

			if ("binary")
				if(robot_talk_understand || binarycheck())
					robot_talk(message, 0)
				return

			/*if ("alientalk")
				if(alien_talk_understand || hivecheck())
				//message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN)) //seems redundant
					alien_talk(message)
				return*/

			if ("department")
				if (src:ears)
					src:ears.talk_into(src, message, message_mode)
					used_radios += src:ears
				message_range = 1
				italics = 1

			/*if ("pAI")
				if (src:radio)
					src:radio.talk_into(src, message)
					used_radios += src:radio
				message_range = 1
				italics = 1*/

			if("changeling")
				if(mind && mind.changeling)
					for(var/mob/living/carbon/Changeling in world)
						if(Changeling.mind && Changeling.mind.changeling)
							Changeling << "<i><font color=#800080><b>[mind.changeling.changelingID]:</b> [message]</font></i>"
					for(var/mob/dead/observer/ghost in world)
						ghost << "<i><font color=#800080><b>[mind.changeling.changelingID]:</b> [message]</font></i>"

					return

			else // Special headsets
				if (message_mode in radiochannels)
					if (src:ears)
						src:ears.talk_into(src, message, message_mode)
						used_radios += src:ears
					message_range = 1
					italics = 1

	else // For bots
		switch(message_mode)
			if("binary")
				if(robot_talk_understand || binarycheck())
					robot_talk(message, 0)
				return

			else
				if(isrobot(src))
					var/mob/living/silicon/robot/R = src
					if(R.radio)
						R.radio.talk_into(src, message, message_mode)
						italics = 1
						message_range = 0


	for (var/obj/O in view(message_range, src))
		spawn (0)
			if (O)
				O.hear_talk(src, message,italics,alt_name)

	var/list/listening
	if(isturf(src.loc))
		listening = hearers(message_range, src)
	else
		var/atom/object = src.loc
		listening = hearers(message_range, object)
	listening -= src
	listening += src

	var/list/heard_a = list() // understood us
	var/list/heard_b = list() // didn't understand us

	for (var/mob/M in listening)
		if (M.say_understands(src))
			heard_a += M
		else
			heard_b += M

	for(var/obj/O in view(3,src))
		O.catchMessage(message,src)

	var/rendered = null

	if(length(heard_a))
		var/message_a = say_quote(message, custommode)
		var/test = say_test(message)
		var/image/test2 = image('talk.dmi',src,"h[test]")
		if (italics)
			message_a = "<i>[message_a]</i>"

		rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] <span class='message'>[message_a]</span></span>"

		for(var/mob/M in heard_a) // Sending over the message to mobs who can understand
			M.show_message(rendered, 6)
			M << test2
		spawn(30) del(test2)

	var/renderedold = rendered // Used for the voice recorders below

	if(length(heard_b))
		var/message_b

		if(say_unknown())
			message_b = say_unknown()

		else if (voice_message)
			message_b = voice_message
		else
			message_b = Ellipsis(message)
			message_b = say_quote(message_b, custommode)

		if (italics)
			message_b = "<i>[message_b]</i>"

		rendered = "<span class='game say'><span class='name'>[voice_name]</span> <span class='message'>[message_b]</span></span>"

		for (var/mob/M in heard_b) // Sending over the message to mobs who can't understand
			M.show_message(rendered, 6)

	message = say_quote(message, custommode)
	if(italics)
		message = "<i>[message]</i>"

	rendered = "<span class='game say'><span class='name'>[GetVoice()]</span>[alt_name] <span class='message'>[message]</span></span>"
	for(var/client/C)
		if (C.mob)
			if (istype(C.mob, /mob/new_player))
				continue
			if (C.mob.stat >= 2 && !(C.mob in heard_a))
				C.mob.show_message(rendered, 2)

	for(var/obj/item/weapon/recorder/R in oview(message_range,src))
		if(R.recording)
			over
			var/id = rand(1,9999)
			var/test = R.disk.mobtype["[id]"]
			if(test)
				id = rand(1,9999)
				if(id == test)
					goto over
			if(istype(src, /mob/living/carbon/human))
				R.disk.memory["[id]"] += renderedold
				R.disk.mobtype["[id]"] += "human"

	for(var/mob/M in viewers(message_range,src))
		var/obj/item/weapon/implant/I = locate() in M.contents
		if(I)
			I.hear(message,src)
		var/obj/item/weapon/recorder/R = locate() in M.contents
		if(R)
			if(R.recording)
				over
				var/id = rand(1,9999)
				var/test = R.disk.mobtype["[id]"]
				if(test)
					id = rand(1,9999)
					if(id == test)
						goto over
				if(istype(src, /mob/living/carbon/human))
					R.disk.memory["[id]"] += renderedold
					R.disk.mobtype["[id]"] += "human"
				if(istype(src,/mob/living/carbon/monkey))
					R.disk.memory["[id]"] += renderedold
					R.disk.mobtype["[id]"] += "monkey"
				if(istype(src,/mob/living/silicon))
					R.disk.memory["[id]"] += renderedold
					R.disk.mobtype["[id]"] += "bot"
				if(istype(src,/mob/living/carbon/alien))
					R.disk.memory["[id]"] += renderedold
					R.disk.mobtype["[id]"] += "alien"

	log_say("[src.name]/[src.key] : [message]")

//headfindback
	log_m("Said [message]")


/mob/living/proc/robot_talk(var/message, var/presanitize = 1)
	log_say("[key_name(src)] : [message]")

	if(presanitize)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(!message)
		return

	var/message_a = say_quote(message)
	var/rendered = "<i><span class='game say'>Binary, <span class='name'>[name]</span> <span class='message'>[message_a]</span></span></i>"
	for(var/mob/living/M in world)
		if(!M.stat && M.client && M.binarycheck())
			M.show_message(rendered, 2)

	var/list/listening = hearers(1, src)
	listening -= src
	listening += src

	var/list/heard = list()
	for (var/mob/M in listening)
		if(!istype(M, /mob/living/silicon))
			heard += M


	if (length(heard))
		var/message_b

		message_b = "beep beep beep"
		message_b = say_quote(message_b)
		message_b = "<i>[message_b]</i>"

		rendered = "<i><span class='game say'><span class='name'>[voice_name]</span> <span class='message'>[message_b]</span></span></i>"

		for (var/mob/M in heard)
			M.show_message(rendered, 2)

	message = say_quote(message)

	rendered = "<i><span class='game say'>Binary, <span class='name'>[name]</span> <span class='message'>[message_a]</span></span></i>"

	for (var/client/C)
		if (istype(C.mob, /mob/new_player))
			continue
		if (C.mob.stat > 1)
			C.mob.show_message(rendered, 2)


/mob/living/proc/GetVoice()
	return name

/mob/living/carbon/human/GetVoice()
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange && V.voice != "Unknown")
			return V.voice
		else
			return name

	if(face_dmg)
		return "Unknown"

	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name


/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice