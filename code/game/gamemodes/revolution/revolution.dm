// To add a rev to the list of revolutionaries,
// call ticker.mode.add_revolutionary(_THE_PLAYERS_MIND_)
// nothing else needs to be done, as that proc will check if they are a valid target.
// Just make sure the converter is a head before you call it!
// To remove a rev (from brainwashing or w/e), call ticker.mode.remove_revolutionary(_THE_PLAYERS_MIND_),
// this will also check they're not a head, so it can just be called freely
// If the rev icons start going wrong for some reason, ticker.mode.update_all_rev_icons() can be called to correct them.
// If the game somtimes isn't registering a win properly, then ticker.mode.check_win() isn't being called somewhere.


/datum/game_mode/revolution
	name = "revolution"
	config_tag = "revolution"

	uplink_items = {"
/obj/item/weapon/storage/box/syndie_kit/imp_freedom:3:Freedom Implant, with injector;
/obj/item/weapon/storage/box/syndie_kit/imp_compress:5:Compressed matter implant, with injector;
/obj/item/device/hacktool:4:Hacktool;
/obj/item/weapon/storage/toolbox/syndicate:1:Fully Loaded Toolbox;
/obj/item/weapon/soap/syndie:1:Syndicate Soap;
/obj/item/clothing/shoes/syndigaloshes:2:No-Slip Syndicate Shoes;
/obj/item/device/encryptionkey/syndicate:1:Binary Encryption Key;
/obj/item/clothing/under/chameleon:2:Chameleon Jumpsuit;
/obj/item/weapon/card/emag:3:Cryptographic Sequencer;
/obj/item/weapon/card/id/syndicate:4:Fake ID;
/obj/item/clothing/glasses/thermal:4:Thermal Glasses;
/obj/item/weapon/storage/box/grenades/emp:4:Box of EMP grenades;
/obj/item/weapon/cartridge/syndicate:3:Detomatix PDA cart;
/obj/item/device/chameleon:4:Chameleon projector;
/obj/item/weapon/pen/sleepypen:4:Sleepy pen;
/obj/item/clothing/mask/gas/voice:3:Voice changer;
/obj/item/weapon/aiModule/freeform:3:Freeform AI module;
/obj/item/weapon/reagent_containers/pill/cyanide:4:Cyanide Pill
	"}

	var/finished = 0
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/revolution/announce()
	world << "<B>The current game mode is - Revolution!</B>"
//	world << "<B>Some crewmembers are attempting to start a revolution!<BR>\nRevolutionaries - Kill the Captain, HoP, and HoS. Convert other crewmembers (excluding the Captain, HoP, HoS, and security officers) to your cause by flashing them. Protect your leaders.<BR>\nPersonnel - Protect the Captain, HoP, and HoR. Kill the leaders of the revolution, and brainwash the other revolutionaries (by beating them in the head).</B>"

/datum/game_mode/revolution/send_intercept()
	var/intercepttext = "<FONT size = 3><B>Cent. Com. Update</B> Requested staus information:</FONT><HR>"
	intercepttext += "<B> Cent. Com has recently been contacted by the following syndicate affiliated organisations in your area, please investigate any information you may have:</B>"

	var/list/possible_modes = list()
	possible_modes.Add("revolution", "wizard", "nuke", "traitor", "malf")
	possible_modes -= "nuke"
	var/number = pick(2, 3)
	var/i = 0
	for(i = 0, i < number, i++)
		possible_modes.Remove(pick(possible_modes))
	possible_modes.Insert(rand(possible_modes.len), "nuke")

	var/datum/intercept_text/i_text = new /datum/intercept_text
	for(var/A in possible_modes)
		intercepttext += i_text.build(A, pick(head_revolutionaries))

	for (var/obj/machinery/computer/communications/comm in world)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "paper- 'Cent. Com. Status Summary'"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. Status Summary")
			comm.messagetext.Add(intercepttext)

	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")

/datum/game_mode/revolution/post_setup()
	var/list/revs_possible = get_possible_revolutionaries()
	var/list/heads = get_living_heads()
	var/rev_number = 0

	if(!revs_possible || !heads)
		world << "<B> \red Not enough players for revolution game mode. Restarting world in 5 seconds."
		sleep(50*tick_multiplier)
		world.Reboot()
		return

	if(revs_possible.len >= 3)
		rev_number = 3
	else
		rev_number = revs_possible.len

	while(rev_number > 0)
		head_revolutionaries += pick(revs_possible)
		rev_number--

	for(var/datum/mind/rev_mind in head_revolutionaries)
		for(var/datum/mind/head_mind in heads)
			var/datum/objective/assassinate/rev_obj = new
			rev_obj.owner = rev_mind
			rev_obj.find_target_by_role(head_mind.assigned_role)
			rev_mind.objectives += rev_obj

		equip_revolutionary(rev_mind.current)
		update_rev_icons_added(rev_mind)

	for(var/datum/mind/rev_mind in head_revolutionaries)
		var/obj_count = 1
		rev_mind.current << "\blue You are a member of the revolutionaries' leadership!"
		for(var/datum/objective/objective in rev_mind.objectives)
			rev_mind.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++

	spawn (rand(waittime_l, waittime_h)*tick_multiplier)
		send_intercept()

/datum/game_mode/proc/equip_revolutionary(mob/living/carbon/human/rev_mob)
	if(!istype(rev_mob))
		return

	spawn (100*tick_multiplier)
		/*
		var/freq = 1441
		var/list/freqlist = list()
		while (freq <= 1489)
			if (freq < 1451 || freq > 1459)
				freqlist += freq
			freq += 2
			if ((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, freqlist.len)]
		var/loc = ""
		var/obj/item/device/radio/R = null
		if (!R && istype(rev_mob.l_hand, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = rev_mob.l_hand
			var/list/L = S.return_inv()
			for (var/obj/item/device/radio/foo in L)
				R = foo
				loc = "in the [S.name] in your left hand"
				break
		if (!R && istype(rev_mob.r_hand, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = rev_mob.r_hand
			var/list/L = S.return_inv()
			for (var/obj/item/device/radio/foo in L)
				R = foo
				loc = "in the [S.name] in your right hand"
				break
		if (!R && istype(rev_mob.back, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = rev_mob.back
			var/list/L = S.return_inv()
			for (var/obj/item/device/radio/foo in L)
				R = foo
				loc = "in the [S.name] on your back"
				break
		if (!R && rev_mob.w_uniform && istype(rev_mob.belt, /obj/item/device/radio))
			R = rev_mob.belt
			loc = "on your belt"
		if (!R && istype(rev_mob.ears, /obj/item/device/radio))
			R = rev_mob.ears
			loc = "on your head"
		if (!R)
			rev_mob << "Unfortunately, the Syndicate wasn't able to get you a radio."
		else
			var/obj/item/device/uplink/radio/T = new /obj/item/device/uplink/radio(R)
			R.traitorradio = T
			R.traitor_frequency = freq
			T.name = R.name
			T.icon_state = R.icon_state
			T.origradio = R
			rev_mob << "The Syndicate have cunningly disguised a Syndicate Uplink as your [R.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock it's hidden features.
			rev_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc]).", 0, 0)*/
		if(rev_mob.r_store)
			rev_mob.equip_if_possible(new /obj/item/device/flash(rev_mob), rev_mob.slot_l_store)
		if(rev_mob.l_store)
			rev_mob.equip_if_possible(new /obj/item/device/flash(rev_mob), rev_mob.slot_r_store)



/datum/game_mode/revolution/send_intercept()
	var/intercepttext = "<FONT size = 3><B>Cent. Com. Update</B> Requested staus information:</FONT><HR>"
	intercepttext += "<B> Cent. Com has recently been contacted by the following syndicate affiliated organisations in your area, please investigate any information you may have:</B>"

	var/list/possible_modes = list()
	possible_modes.Add("revolution", "wizard", "nuke", "traitor", "malf")
	possible_modes -= "[ticker.mode]"
	var/number = pick(2, 3)
	var/i = 0
	for(i = 0, i < number, i++)
		possible_modes.Remove(pick(possible_modes))
	possible_modes.Insert(rand(possible_modes.len), "[ticker.mode]")

	var/datum/intercept_text/i_text = new /datum/intercept_text
	for(var/A in possible_modes)
		intercepttext += i_text.build(A, pick(head_revolutionaries))

	for (var/obj/machinery/computer/communications/comm in world)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "paper- 'Cent. Com. Status Summary'"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. Status Summary")
			comm.messagetext.Add(intercepttext)

	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")


/datum/game_mode/revolution/check_win()
	if(check_rev_victory())
		finished = 1
	else if(check_heads_victory())
		finished = 2
	return

/datum/game_mode/revolution/check_finished()
	if(finished != 0)
		return 1
	else
		return 0

/datum/game_mode/revolution/proc/check_rev_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		for(var/datum/objective/objective in rev_mind.objectives)
			if(!(objective.check_completion()))
				return 0

		return 1

/datum/game_mode/revolution/proc/check_heads_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		if(rev_mind.current && rev_mind.current.stat != DEAD)
			return 0
	return 1

/datum/game_mode/revolution/declare_completion()

	var/text = ""
	if(finished == 1)
		world << "\red <FONT size = 3><B> The heads of staff were killed! The revolutionaries win!</B></FONT>"
	else if(finished == 2)
		world << "\red <FONT size = 3><B> The heads of staff managed to stop the revolution!</B></FONT>"

	world << "<FONT size = 2><B>The head revolutionaries were: </B></FONT>"
	for(var/datum/mind/rev_mind in head_revolutionaries)
		text = ""
		if(rev_mind.current)
			text += "[rev_mind.current.real_name]"
			if(rev_mind.current.stat == DEAD)
				text += " (died)"
		else
			text += "[rev_mind.key] (character destroyed)"

		world << text

	text = ""
	world << "<FONT size = 2><B>The converted revolutionaries were: </B></FONT>"
	for(var/datum/mind/rev_nh_mind in revolutionaries)
		if(rev_nh_mind.current)
			text += "[rev_nh_mind.current.real_name]"
			if(rev_nh_mind.current.stat == DEAD)
				text += " (died)"
		else
			text += "[rev_nh_mind.key] (character destroyed)"
		text += ", "

	world << text

	world << "<FONT size = 2><B>The heads of staff were: </B></FONT>"
	for(var/datum/mind/head_mind in get_all_heads())
		text = ""
		if(head_mind.current)
			text += "[head_mind.current.real_name]"
			if(head_mind.current.stat == 2)
				text += " (died)"
			else
				text += " (survived the revolution!)"
		else
			text += "[head_mind.key] (character destroyed)"

		world << text
	check_round()
	return 1