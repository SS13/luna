/obj/effect/proc_holder/spell/targeted/inflict_handler
	name = "Inflict Handler"
	desc = "This spell blinds and/or destroys/damages/heals and/or weakens/stuns the target."

	var/amt_weakened = 0
	var/amt_paralysis = 0
	var/amt_stunned = 0

	//set to negatives for healing
	var/amt_dam_fire = 0
	var/amt_dam_brute = 0
	var/amt_dam_oxy = 0
	var/amt_dam_tox = 0

	var/amt_eye_blind = 0
	var/amt_eye_blurry = 0

	var/destroys = "none" //can be "none", "gib" or "disintegrate"

/obj/effect/proc_holder/spell/targeted/inflict_handler/cast(list/targets)

	for(var/mob/living/target in targets)
		if(destroys != "none")
			target.gib()
/*		switch(destroys)
			if("gib")
				target.gib()
			if("gib_brain")
				if(ishuman(target) || ismonkey(target))
					var/obj/item/organ/brain/B = getbrain(target)
					if(B)
						B.loc = get_turf(target)
						B.transfer_identity(target)
				target.gib()
			if("disintegrate")
				target.dust()*/

		if(!target)
			continue

		//damage
		target.adjustBruteLoss(amt_dam_brute)
		target.adjustFireLoss(amt_dam_fire)
		target.adjustToxLoss(amt_dam_tox)
		target.adjustOxyLoss(amt_dam_oxy)

		//disabling
		target.Weaken(amt_weakened)
		target.Paralyse(amt_paralysis)
		target.Stun(amt_stunned)

		target.eye_blind += amt_eye_blind
		target.eye_blurry += amt_eye_blurry