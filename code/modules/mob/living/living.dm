/mob/living/
	var/t_plasma = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null
	var/now_pushing = null
	var/cameraFollow = null
	var/lasthandcuff = null

	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/under/w_uniform = null
	var/obj/item/clothing/shoes/shoes = null
	var/obj/item/weapon/belt = null
	var/obj/item/clothing/gloves/gloves = null
	var/obj/item/clothing/glasses/glasses = null
	var/obj/item/clothing/head/head = null
	var/obj/item/clothing/ears/ears = null

	var/list/surgeries = list()	//a list of surgery datums. generally empty, they're added when the player wants them.

	var/update_slimes = 1
	var/silent = 0

	var/maxHealth = 100

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(var/amount)
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(var/amount)
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/setToxLoss(var/amount)
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(var/amount)
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	brainloss = min(max(brainloss + amount, 0),(maxHealth*2))

/mob/living/proc/setBrainLoss(var/amount)
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setHalLoss(var/amount)
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth

// ++++ROCKDTBEN++++ MOB PROCS //END

//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/weapon/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()
		return L
	else
		L += src.contents
		for(var/obj/item/weapon/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)
		return L


/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	  return 0 //only carbon liveforms have this proc

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0
	src.take_overall_damage(0,shock_damage)
	//src.burn_skin(shock_damage)
	//src.adjustFireLoss(shock_damage) //burn_skin will do this for us
	//src.updatehealth()
	src.visible_message(
		"\red [src] was shocked by the [source]!", \
		"\red <B>You feel a powerful shock course through your body!</B>", \
		"\red You hear a heavy electrical crack." \
	)
//	if(src.stunned < shock_damage)	src.stunned = shock_damage
	Stun(10 * siemens_coeff)//This should work for now, more is really silly and makes you lay there forever
//	if(src.weakened < 20*siemens_coeff)	src.weakened = 20*siemens_coeff
	Weaken(10 * siemens_coeff)
	return shock_damage

/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	if(gloves)
		siemens_coeff = gloves.siemens_coefficient
	..()


/*
/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()
*/

// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, var/burn)
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn)
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()