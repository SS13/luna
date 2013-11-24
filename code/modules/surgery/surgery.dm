/datum/surgery
	var/name = "surgery"
	var/status = 1
	var/list/steps = list()
	var/step_in_progress = 0
	var/list/species = list(/mob/living/carbon/human)

	var/list/locations = list("chest")				// possible locations of this surgery type
	var/current_location = null						// location of current surgery
	var/datum/organ/external/current_organ = null	// external organ (limb on /tg/) of current surgery

	var/organ_status_must_be = ORGAN_INTACT
	// Possible vars:
	//	ORGAN_INTACT
	//	ORGAN_DESTROYED
	//	ORGAN_ROBOTIC
	var/target_must_be_dead = 0


/datum/surgery/proc/next_step(mob/user, mob/living/carbon/target)
	if(step_in_progress)	return

	var/procedure = steps[status]
	var/datum/surgery_step/S = new procedure
	if(S)
		if(S.try_op(user, target, user.zone_sel.selecting, user.get_active_hand(), src))
			return 1
	return 0


/datum/surgery/proc/complete(mob/living/carbon/human/target)
	target.surgeries -= src
	src = null


//INFO
//Check /mob/living/carbon/attackby for how surgery progresses, and also /mob/living/carbon/attack_hand.
//As of Feb 21 2013 they are in code/modules/mob/living/carbon/carbon.dm, lines 459 and 51 respectively.
//Other important variables are var/list/surgeries (/mob/living) and var/list/internal_organs (/mob/living/carbon).
//Surgical procedures are initiated by attempt_initiate_surgery(), which is called by surgical drapes and bedsheets.


//TODO
//randomised complications
//add a probability modifier for the state of the surgeon- health, twitching, etc. blindness, god forbid.
//helper for converting a zone_sel.selecting to body part (for damage)