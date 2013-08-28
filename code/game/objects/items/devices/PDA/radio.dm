/obj/item/device/radio/integrated
	name = "PDA radio module"
	desc = "An electronic radio system of NanoTrasen origin."
	icon = 'module.dmi'
	icon_state = "power_mod"
	var/obj/item/device/pda/hostpda = null

	var/on = 0 //Are we currently active??
	var/menu_message = ""

	New()
		..()
		if (istype(loc.loc, /obj/item/device/pda))
			hostpda = loc.loc

	proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)

		//world << "Post: [freq]: [key]=[value], [key2]=[value2]"
		var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

		if(!frequency) return

		var/datum/signal/signal = new()
		signal.source = src
		signal.transmission_method = 1
		signal.data[key] = value
		if(key2)
			signal.data[key2] = value2
		if(key3)
			signal.data[key3] = value3

		frequency.post_signal(src, signal, filter = s_filter)

	proc/print_to_host(var/text)
		if (isnull(src.hostpda))
			return
		src.hostpda.cart = text

		for (var/mob/M in viewers(1, src.hostpda.loc))
			if (M.client && M.machine == src.hostpda)
				src.hostpda.cartridge.unlock()

		return

	proc/generate_menu()

/obj/item/device/radio/integrated/beepsky
	var/list/botlist = null		// list of bots
	var/obj/machinery/bot/secbot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot

	var/control_freq = 1447

	// create a new QM cartridge, and register to receive bot control & beacon message
	New()
		..()
		spawn(5)
			if(radio_controller)
				radio_controller.add_object(src, control_freq, filter = RADIO_SECBOT)

	// receive radio signals
	// can detect bot status signals
	// create/populate list as they are recvd

	receive_signal(datum/signal/signal)
//		var/obj/item/device/pda/P = src.loc

		/*
		world << "recvd:[P] : [signal.source]"
		for(var/d in signal.data)
			world << "- [d] = [signal.data[d]]"
		*/
		if (signal.data["type"] == "secbot")
			if(!botlist)
				botlist = new()

			if(!(signal.source in botlist))
				botlist += signal.source

			if(active == signal.source)
				var/list/b = signal.data
				botstatus = b.Copy()

//		if (istype(P)) P.updateSelfDialog()

	Topic(href, href_list)
		..()
		var/obj/item/device/pda/PDA = src.hostpda

		switch(href_list["op"])

			if("control")
				active = locate(href_list["bot"])
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

			if("scanbots")		// find all bots
				botlist = null
				post_signal(control_freq, "command", "bot_status", s_filter = RADIO_SECBOT)

			if("botlist")
				active = null

			if("stop", "go")
				post_signal(control_freq, "command", href_list["op"], "active", active, s_filter = RADIO_SECBOT)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

			if("summon")
				post_signal(control_freq, "command", "summon", "active", active, "target", get_turf(PDA) , s_filter = RADIO_SECBOT)
				post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)
		PDA.cartridge.unlock()

/obj/item/device/radio/integrated/mule
	var/list/botlist = null		// list of bots
	var/obj/machinery/bot/mulebot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot
	var/list/beacons

	var/beacon_freq = 1400
	var/control_freq = 1447

	// create a new QM cartridge, and register to receive bot control & beacon message
	New()
		..()
		spawn(5)
			if(radio_controller)
				radio_controller.add_object(src, control_freq, filter = RADIO_MULEBOT)
				radio_controller.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)
				spawn(10)
					post_signal(beacon_freq, "findbeacon", "delivery", s_filter = RADIO_NAVBEACONS)

	// receive radio signals
	// can detect bot status signals
	// and beacon locations
	// create/populate lists as they are recvd

	receive_signal(datum/signal/signal)
//		var/obj/item/device/pda/P = src.loc

		/*
		world << "recvd:[P] : [signal.source]"
		for(var/d in signal.data)
			world << "- [d] = [signal.data[d]]"
		*/
		if(signal.data["type"] == "mulebot")
			if(!botlist)
				botlist = new()

			if(!(signal.source in botlist))
				botlist += signal.source

			if(active == signal.source)
				var/list/b = signal.data
				botstatus = b.Copy()

		else if(signal.data["beacon"])
			if(!beacons)
				beacons = new()

			beacons[signal.data["beacon"] ] = signal.source


//		if(istype(P)) P.updateSelfDialog()

	Topic(href, href_list)
		..()
		var/obj/item/device/pda/PDA = src.hostpda
		var/cmd = "command"
		if(active) cmd = "command [active.suffix]"

		switch(href_list["op"])

			if("control")
				active = locate(href_list["bot"])
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("scanbots")		// find all bots
				botlist = null
				post_signal(control_freq, "command", "bot_status", s_filter = RADIO_MULEBOT)

			if("botlist")
				active = null


			if("unload")
				post_signal(control_freq, cmd, "unload", s_filter = RADIO_MULEBOT)
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
			if("setdest")
				if(beacons)
					var/dest = input("Select Bot Destination", "Mulebot [active.suffix] Interlink", active.destination) as null|anything in beacons
					if(dest)
						post_signal(control_freq, cmd, "target", "destination", dest, s_filter = RADIO_MULEBOT)
						post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("retoff")
				post_signal(control_freq, cmd, "autoret", "value", 0, s_filter = RADIO_MULEBOT)
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
			if("reton")
				post_signal(control_freq, cmd, "autoret", "value", 1, s_filter = RADIO_MULEBOT)
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("pickoff")
				post_signal(control_freq, cmd, "autopick", "value", 0, s_filter = RADIO_MULEBOT)
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
			if("pickon")
				post_signal(control_freq, cmd, "autopick", "value", 1, s_filter = RADIO_MULEBOT)
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("stop", "go", "home")
				post_signal(control_freq, cmd, href_list["op"], s_filter = RADIO_MULEBOT)
				post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		PDA.cartridge.unlock()



/*
 *	Radio Cartridge, essentially a signaler.
 */


/obj/item/device/radio/integrated/signal
	frequency = 1457
	var/code = 30.0

	New()
		..()
		if(radio_controller)
			initialize()

	initialize()
		if (src.frequency < 1441 || src.frequency > 1489)
			src.frequency = sanitize_frequency(src.frequency)

		set_frequency(frequency)

	set_frequency(new_frequency)
		radio_controller.remove_object(src, frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency)

	proc/send_signal(message="ACTIVATE")

		if(last_transmission && world.time < (last_transmission + 5))
			return
		last_transmission = world.time

		var/time = time2text(world.realtime,"hh:mm:ss")
		var/turf/T = get_turf(src)
		lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

		var/datum/signal/signal = new
		signal.source = src
		signal.encryption = code
		signal.data["message"] = message

		radio_connection.post_signal(src, signal)

		return

/obj/item/device/radio/proc/autosay(var/from, message, channel) // Baystation stuff used to yell "CORE OVERLOAD"
	var/datum/radio_frequency/connection = null // Code shared by Mport2004 for Security Headsets -- TLE
	if(channel && channels && channels.len > 0)
		if (channel == "department")
			//world << "DEBUG: channel=\"[channel]\" switching to \"[channels[1]]\""
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if (!istype(connection))
		return
	var/display_freq = connection.frequency

	if (!(wires & WIRE_TRANSMIT))
		return

	var/list/receive = list()

	//for (var/obj/item/device/radio/R in radio_connection.devices)
	for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"]) // Modified for security headset code -- TLE
		//if(R.accept_rad(src, message))
		receive |= R.send_hear(display_freq)

	//world << "DEBUG: receive.len=[receive.len]"
	var/list/heard_normal = list() // normal message
	var/list/heard_garbled = list() // garbled message

	for (var/mob/R in receive)
		/*if (R.say_understands(M))
			if (!ishuman(M) || istype(M.wear_mask, /obj/item/clothing/mask/gas/voice))
				heard_masked += R
			else
				heard_normal += R
		else
			if (M.voice_message)
				heard_voice += R
			else
				heard_garbled += R*/
		heard_normal += R

	if (length(heard_normal) || length(heard_garbled))
		var/part_a = "<span class='radio'><span class='name'>"
		//var/part_b = "</span><b> \icon[src]\[[format_frequency(frequency)]\]</b> <span class='message'>"
		var/freq_text
		switch(display_freq)
			if(SYND_FREQ)
				freq_text = "#unkn"
			if(COMM_FREQ)
				freq_text = "Command"
			if(1351)
				freq_text = "Science"
			if(1355)
				freq_text = "Medical"
			if(1357)
				freq_text = "Engineering"
			if(1359)
				freq_text = "Security"
			if(1349)
				freq_text = "Mining"
			if(1347)
				freq_text = "Supply"
		//There's probably a way to use the list var of channels in code\game\communications.dm to make the dept channels non-hardcoded, but I wasn't in an experimentive mood. --NEO

		if(!freq_text)
			freq_text = format_frequency(display_freq)

		var/part_b = "</span><b> \icon[src]\[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "&quot;</span>[message]</span>&quot;"

		if (display_freq==SYND_FREQ)
			part_a = "<span class='syndradio'><span class='name'>"
		else if (display_freq==COMM_FREQ)
			part_a = "<span class='comradio'><span class='name'>"
		else if (display_freq in DEPT_FREQS)
			part_a = "<span class='deptradio'><span class='name'>"

		var/quotedmsg = "declares: " /*M.say_quote(message)*/


		//This following recording is intended for research and feedback in the use of department radio channels. It was added on 30.3.2011 by errorage.

		var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/blackbox_msg = "[part_a][from][part_blackbox_b][quotedmsg][part_c]"
		//var/blackbox_admin_msg = "[part_a][M.name] (Real name: [M.real_name])[part_blackbox_b][quotedmsg][part_c]"
		for (var/obj/machinery/blackbox_recorder/BR in world)
			//BR.messages_admin += blackbox_admin_msg
			switch(display_freq)
				if(1459)
					BR.msg_common += blackbox_msg
				if(1351)
					BR.msg_science += blackbox_msg
				if(1353)
					BR.msg_command += blackbox_msg
				if(1355)
					BR.msg_medical += blackbox_msg
				if(1357)
					BR.msg_engineering += blackbox_msg
				if(1359)
					BR.msg_security += blackbox_msg
				if(1441)
					BR.msg_deathsquad += blackbox_msg
				if(1213)
					BR.msg_syndicate += blackbox_msg
				if(1349)
					BR.msg_mining += blackbox_msg
				if(1347)
					BR.msg_cargo += blackbox_msg
				else
					BR.messages += blackbox_msg

		//End of research and feedback code.

		if (length(heard_normal))
			var/rendered = "[part_a][from][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_normal)
				R.show_message(rendered, 2)

		if (length(heard_garbled))
			quotedmsg = "" /*M.say_quote(stars(message))*/
			var/rendered = "[part_a][from][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_garbled)
				R.show_message(rendered, 2)