/*
//////////////////////////////////////

Fake Death

	Stealthy.
	Lowers resistance considerably.
	Decreases stage speed.
	Reduced transmittable.
	Critical Level.

Bonus
	Makes you almost dead.

//////////////////////////////////////
*/

/datum/symptom/fakedeath

	name = "Fake Death"
	stealth = 3
	resistance = -2
	stage_speed = -3
	transmittable = -4
	level = 5

/datum/symptom/fakedeath/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/M = A.affected_mob
		if(A.stage == 5)
			M.changeling_fakedeath = 1
			M.adjustOxyLoss(max(0, (101 - M.getFireLoss() - M.getBruteLoss() - M.getOxyLoss() - M.getToxLoss()))) //no more real death
			M.Paralyse(300)
			M.emote("gasp")
			spawn(100*tick_multiplier)
				M.emote("deathgasp")
				M.adjustOxyLoss(-30)
			spawn(200*tick_multiplier)
				M.adjustOxyLoss(-30)
			spawn(300*tick_multiplier)
				M.adjustOxyLoss(-30)
				M.changeling_fakedeath = 0
				M.visible_message(text("\red <B>[M] appears to wake from the dead, having healed all wounds.</B>"))
	return