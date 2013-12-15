/mob/living/Login()
	..()
	if (!isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE

	update_clothing()

	if(mind && ticker && ticker.mode) // Updating game mode icons
		if(mind in ticker.mode.get_all_revolutionaries())
			ticker.mode.update_rev_icons_login(mind)

	if(stat == DEAD)
		verbs += /mob/living/proc/ghostize