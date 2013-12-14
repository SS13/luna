/datum/game_mode/wizard
	name = "wizard"
	config_tag = "wizard"
	enabled = 0

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/wizard/announce()
	world << "<B>The current game mode is - Wizard!</B>"
	world << "<B>There is a \red SPACE WIZARD\black on the station. You can't let him achieve his objective!</B>"

/datum/game_mode/wizard/pre_setup()
	// Can't pick a wizard here, as we don't want him to then become the AI.
	return 1

/datum/game_mode/wizard/post_setup()
	var/list/possible_wizards = get_possible_wizards()

	if(possible_wizards.len>0)
		wizard = pick(possible_wizards)

	if(istype(wizard))
		wizard.special_role = "wizard"
		if(wizardstart.len == 0)
			wizard.current << "<B>\red A starting location for you could not be found, please report this bug!</B>"
		else
			var/starting_loc = pick(wizardstart)
			wizard.current.loc = starting_loc

	for (var/obj/effect/landmark/A in world)
		if (A.name == "Teleport-Scroll")
			new /obj/item/weapon/teleportation_scroll(A.loc)
			del(A)
			continue

	switch(rand(1,100))
		if(1 to 30)

			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = wizard
			wizard.objectives += escape_objective
		if(31 to 60)
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = wizard
			wizard.objectives += escape_objective

		if(61 to 85)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			var/datum/objective/survive/survive_objective = new
			survive_objective.owner = wizard
			wizard.objectives += survive_objective

		else
			var/datum/objective/hijack/hijack_objective = new
			hijack_objective.owner = wizard
			wizard.objectives += hijack_objective


	equip_wizard(wizard.current)

	wizard.current << "<B>\red You are the Space Wizard!</B>"
	wizard.current << "<B>The Space Wizards Federation has given you the following tasks:</B>"

	var/obj_count = 1
	for(var/datum/objective/objective in wizard.objectives)
		wizard.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

/datum/game_mode/wizard/proc/get_possible_wizards()
	var/list/candidates = list()
	for(var/mob/living/carbon/player in world)
		if (player.client)
			if(player.be_syndicate)
				candidates += player.mind

	if(candidates.len < 1)
		for(var/mob/living/carbon/player in world)
			if (player.client)
				candidates += player.mind

	return candidates

/datum/game_mode/wizard/proc/equip_wizard(mob/living/carbon/human/wizard_mob)
	if (!istype(wizard_mob))
		return

/datum/game_mode/wizard/send_intercept()
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
		intercepttext += i_text.build(A, wizard)

	for (var/obj/machinery/computer/communications/comm in world)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "paper- 'Cent. Com. Status Summary'"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. Status Summary")
			comm.messagetext.Add(intercepttext)

	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")

/datum/game_mode/wizard/declare_completion()
	if(finished)
		world << "\red <FONT size = 3><B> The wizard has been killed by the crew! The Space Wizards Fediration has been taught a lesson they will not soon forget!</B></FONT>"

	var/wizard_name
	if(wizard.current)
		wizard_name = "[wizard.current.real_name] (played by [wizard.key])"
	else
		wizard_name = "[wizard.key] (character destroyed)"
	world << "<B>The wizard was [wizard_name]</B>"
	var/count = 1

	var/wizardwin = 1
	for(var/datum/objective/objective in wizard.objectives)
		if(objective.check_completion())
			world << "<B>Objective #[count]</B>: [objective.explanation_text] \green <B>Success</B>"
		else
			world << "<B>Objective #[count]</B>: [objective.explanation_text] \red Failed"
			wizardwin = 0
		count++

	if(!finished)
		if(wizardwin)
			world << "<B>The wizard was successful!<B>"
		else
			world << "<B>The wizard has failed!<B>"
	check_round()
	return 1


/datum/game_mode/wizard/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/living/player in world)
		if (player.client)
			mobs += player
	return mobs

/datum/game_mode/wizard/proc/pick_human_name_except(excluded_name)
	var/list/names = list()
	for(var/mob/living/player in world)
		if (player.client && (player.real_name != excluded_name))
			names += player.real_name
	if(!names.len)
		return null
	return pick(names)

/datum/game_mode/wizard/check_finished()
	if(!wizard.current)
		return 1
	if(wizard.current.stat == 2)
		return 1
	else
		return 0