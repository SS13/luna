//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
		return
	fireloss	= 0
	bruteloss	= 0
	for(var/datum/organ/external/O in organs)	//hardcoded to streamline things a bit
		if(O.status == ORGAN_INTACT)
			bruteloss	+= O.brute_dam
			fireloss	+= O.burn_dam
	health = 100 - getOxyLoss() - getToxLoss() - fireloss - bruteloss
	return

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/datum/organ/external/O in organs)
		if(O.status) amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/datum/organ/external/O in organs)
		if(O.status) amount += O.burn_dam
	return amount


/mob/living/carbon/human/adjustBruteLoss(var/amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	update_clothing()

/mob/living/carbon/human/adjustFireLoss(var/amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	update_clothing()

/mob/living/carbon/human/Stun(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/Weaken(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/Paralyse(amount)
	if(HULK in mutations)	return
	..()

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn, var/allow_robotic = 1)
	var/list/datum/organ/external/parts = list()
	for(var/datum/organ/external/O in organs)
		if(O.status && ((brute && O.brute_dam) || (burn && O.burn_dam)))
			if(!allow_robotic && O.status == ORGAN_ROBOTIC)
				continue
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs(var/allow_robotic = 1)
	var/list/datum/organ/external/parts = list()
	for(var/datum/organ/external/O in organs)
		if(O.status && (O.brute_dam + O.burn_dam < O.max_damage))
			if(!allow_robotic && O.status == ORGAN_ROBOTIC)
				continue
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(var/brute, var/burn, var/robotic = 0)
	var/list/datum/organ/external/parts = get_damaged_organs(brute,burn,robotic)
	if(!parts.len)	return
	var/datum/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute,burn))
		UpdateDamageIcon(0)
	updatehealth()

//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(var/brute, var/burn, var/robotic = 0)
	var/list/datum/organ/external/parts = get_damageable_organs(robotic)
	if(!parts.len)	return
	var/datum/organ/external/picked = pick(parts)
	if(picked.take_damage(brute,burn))
		UpdateDamageIcon(0)
	updatehealth()


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(var/brute, var/burn, var/robotic = 0)
	var/list/datum/organ/external/parts = get_damaged_organs(brute,burn,robotic)

	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/datum/organ/external/picked = pick(parts)
		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()
	if(update)	UpdateDamageIcon(0)

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(var/brute, var/burn, var/robotic = 0)
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/organ/external/parts = get_damageable_organs(robotic)
	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/datum/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam


		update |= picked.take_damage(brute,burn)

		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	if(update)	UpdateDamageIcon(0)


////////////////////////////////////////////

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/datum/organ/external/E = get_organ(zone)
	if(istype(E, /datum/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon(0)
	else
		return 0
	return


/mob/living/carbon/human/proc/get_organ(var/zone)
	if(!zone)	zone = "chest"
	for(var/datum/organ/external/O in organs)
		if(O.name == zone)
			return O
	return null


/mob/living/carbon/human/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0)
	if((damagetype != BRUTE) && (damagetype != BURN))
		..(damage, damagetype, def_zone, blocked)
		return 1

		if(blocked >= 2)	return 0

	var/datum/organ/external/organ = null
	if(istype(def_zone, /datum/organ/external))
		organ = def_zone
	else
		if(!def_zone)	def_zone = ran_zone("chest")
		organ = get_organ(check_zone(def_zone))

	if(!organ) return 0

	if(blocked) damage = (damage/(blocked+1))

	switch(damagetype)
		if(BRUTE) organ.take_damage(damage, 0)
		if(BURN) organ.take_damage(0, damage)
	updatehealth()
	UpdateDamageIcon()
	return 1

/proc/check_zone(zone)
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("groin")
			zone = "chest"
		if("mouth")
			zone = "head"
	return zone