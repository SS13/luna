/datum/game_mode/proc/get_all_revolutionaries()
	var/list/rev_minds = list()
	rev_minds += head_revolutionaries
	rev_minds += revolutionaries

	return rev_minds

/datum/game_mode/proc/update_all_rev_icons()
	spawn(0)
		var/list/rev_minds = get_all_revolutionaries()

		for(var/datum/mind/rev_mind in rev_minds)
			if(rev_mind.current && rev_mind.current.client)
				for(var/image/I in rev_mind.current.client.images)
					if(I.icon_state == "rev" || I.icon_state == "rev_head")
						del(I)

		for(var/datum/mind/rev in rev_minds)
			if(rev.current && rev.current.client)
				for(var/datum/mind/head_rev in head_revolutionaries)
					if(head_rev.current)
						var/I = image('mob.dmi', loc = head_rev.current, icon_state = "rev")
						rev.current.client.images += I
				for(var/datum/mind/rev_1 in revolutionaries)
					if(rev_1.current)
						var/I = image('mob.dmi', loc = rev_1.current, icon_state = "rev_head")
						rev.current.client.images += I

/datum/game_mode/proc/update_rev_icons_added(datum/mind/rev_mind)
	var/newicon = "rev"
	if(rev_mind in head_revolutionaries)
		newicon = "rev_head"

	spawn(0)
		for(var/datum/mind/rev_mind_1 in get_all_revolutionaries())
			if(rev_mind_1.current && rev_mind_1.current.client)
				var/I = image('mob.dmi', loc = rev_mind.current, icon_state = newicon)
				rev_mind_1.current.client.images += I
			if(rev_mind.current && rev_mind.current.client)
				var/newicon_1 = "rev"
				if(rev_mind_1 in head_revolutionaries)
					newicon_1 = "rev_head"

				var/image/J = image('mob.dmi', loc = rev_mind_1.current, icon_state = newicon_1)
				rev_mind.current.client.images += J

/datum/game_mode/proc/update_rev_icons_login(datum/mind/rev_mind)
	spawn(0)
		for(var/datum/mind/rev_mind_1 in get_all_revolutionaries())
			if(rev_mind_1.current && rev_mind_1.current.client)
				var/newicon = "rev"
				if(rev_mind_1 in head_revolutionaries)
					newicon = "rev_head"

				var/image/J = image('mob.dmi', loc = rev_mind_1.current, icon_state = newicon)
				rev_mind.current.client.images += J


/datum/game_mode/proc/update_rev_icons_removed(datum/mind/rev_mind)
	spawn(0)
		for(var/datum/mind/rev_mind_1 in get_all_revolutionaries())
			if(rev_mind_1.current && rev_mind_1.current.client)
				for(var/image/I in rev_mind_1.current.client.images)
					if(I.loc == rev_mind.current)
						del(I)
		if(rev_mind.current && rev_mind.current.client)
			for(var/image/I in rev_mind.current.client.images)
				if(I.icon_state == "rev" || I.icon_state == "rev_head")
					del(I)

/datum/game_mode/proc/get_possible_revolutionaries()
	var/list/candidates = list()

	for(var/mob/living/carbon/human/player in world)
		if(player.client && player.be_syndicate)
			candidates += player.mind

	if(candidates.len < 1)
		for(var/mob/living/carbon/human/player in world)
			if(player.client)
				candidates += player.mind

	var/list/uncons = get_unconvertables()
	for(var/datum/mind/mind in uncons)
		candidates -= mind

	if(candidates.len < 1)
		return null
	else
		return candidates

/datum/game_mode/proc/get_living_heads()
	var/list/heads = list()

	for(var/mob/living/carbon/human/player in world)
		if(player.mind)
			var/role = player.mind.assigned_role
			if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director"))
				heads += player.mind

	return heads


/datum/game_mode/proc/get_all_heads()
	var/list/heads = list()

	for(var/mob/player in world)
		if(player.mind)
			var/role = player.mind.assigned_role
			if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director"))
				heads += player.mind

	return heads

/datum/game_mode/proc/get_unconvertables()
	var/list/ucs = list()
	for(var/mob/living/carbon/human/player in world)
		if(player.mind)
			var/role = player.mind.assigned_role
			if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director", "Security Officer", "Forensic Technician", "AI"))
				ucs += player.mind
	return ucs

/datum/game_mode/proc/add_revolutionary(datum/mind/rev_mind)
	if(!(rev_mind in revolutionaries) && !(rev_mind in head_revolutionaries) && !(rev_mind in get_unconvertables()))
		revolutionaries += rev_mind
		rev_mind.current << "\red <FONT size = 3> You are now a revolutionary! Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them kill the heads to win the game!</FONT>"
		update_rev_icons_added(rev_mind)
		return 1
	return 0

/datum/game_mode/proc/remove_revolutionary(datum/mind/rev_mind)
	if(rev_mind in revolutionaries)
		rev_mind.current << "\red <FONT size = 3><B>You have been brainwashed! You are no longer a revolutionary!</B></FONT>"
		update_rev_icons_removed(rev_mind)
		for(var/mob/living/M in view(rev_mind.current))
			M << "[rev_mind.current] looks like they just remembered their real allegiance!"
		return 1
	return 0