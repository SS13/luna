mob/proc/flash_pain()
	flick("pain",pain)

mob/proc/flash_weak_pain()
	flick("weak_pain",pain)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// partname is the name of a body part
// amount is a num from 1 to 100
mob/proc/pain(var/partname, var/amount, var/force)
	if(stat != CONSCIOUS) return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && istype(src,/mob/living/carbon/human))
		if(src:paralysis)
			src:paralysis = max(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	switch(amount)
		if(1 to 10)
			if(prob(25)) flash_weak_pain()
			msg = "<b>Your [partname] hurts a bit.</b>"
		if(11 to 90)
			if(prob(50)) flash_weak_pain()
			msg = "<b><font size=1>Ouch! Your [partname] hurts.</font></b>"
		if(91 to 10000)
			if(prob(25)) flash_pain()
			else if(prob(25)) flash_weak_pain()
			msg = "<b><font size=3>OH GOD! Your [partname] is hurting terribly!</font></b>"
	if(msg && prob(20) && (last_pain_message != msg || prob(20)))
		last_pain_message = msg
		src << msg
	next_pain_time = world.time + (100 - amount) * tick_multiplier

mob/living/carbon/proc/handle_pain()
	// not when sleeping
	if(stat != CONSCIOUS) return
	if(istype(src,/mob/living/carbon/human))
		var/maxdam = 0
		var/datum/organ/external/damaged_organ = null
		for(var/datum/organ/external/E in src.organs)
			if(E.status != ORGAN_INTACT)
				continue
			var/dam = E.get_damage()
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(70)) )
				damaged_organ = E
				maxdam = dam
		if(damaged_organ)
			pain(damaged_organ.display_name, maxdam, 0)