/datum/organ
	var/name = "organ"
	var/mob/living/carbon/owner = null

/* ORGAN STATUS
#define ORGAN_INTACT 		1
#define ORGAN_DESTROYED 	0
#define ORGAN_ROBOTIC 		2
 */

/datum/organ/external
	name = "external"
	var/icon_name = null
	var/list/wounds = list()
	var/damage_state = "00"

	var/brute_dam = 0
	var/burn_dam = 0
	var/slash_dam = 0

	var/max_damage = 0
	var/wound_size = 0
	var/max_size = 0
	var/critical = 0
	var/perma_dmg = 0
	var/broken = 0
	var/destspawn

	var/obj/item/weapon/implant/implant = null
	var/obj/item/cavity = null

	var/min_broken_damage = 30
	var/datum/organ/external/parent
	var/damage_msg = "\red You feel a intense pain"

	var/status = ORGAN_INTACT

	var/body_part = null

	var/open = 0
	var/display_name
	var/clean = 1
	var/stage = 0
	var/wound = 0
	var/split = 0
	var/bleeding = 0

	process()
		if(parent)
			if(!parent.status)
				status = ORGAN_DESTROYED
				owner:update_body()
				return
		if(brute_dam > min_broken_damage)
			if(status == ORGAN_ROBOTIC)
				if(prob(95))
					return
			else
				if(broken == 0 && prob(60))
					var/dmgmsg = "[damage_msg] in your [display_name]"
					owner << dmgmsg
					owner.unlock_medal("Broke Yarrr Bones!", 0, "Break a bone.", "easy")
					for(var/mob/M in viewers(owner))
						if(M != owner)
							M.show_message("\red You hear a loud cracking sound coming from [owner.name].")
					owner.emote("scream")
					broken = 1
					wound = "broken" //Randomise in future
					perma_dmg = brute_dam
				return
		return

/datum/organ/external/proc/robotize()
	status = ORGAN_ROBOTIC
	heal_damage(1000, 1000, 1)
	slash_dam = 0
	bleeding = 0
	open = 0
	owner:update_clothing()
	min_broken_damage += 20
	max_damage += 30

	var/list/organs = owner.GetOrgans()
	for(var/datum/organ/external/O in organs) // Robotize all connected limbs
		if(O.parent == src)
			O.robotize()

/datum/organ/external/proc/isbleeding()
	for(var/datum/organ/external/wound/W in wounds)
		if(W.bleeding)
			return 1
	return 0


/datum/organ/external/proc/createwound(var/size = 1)
	if(ishuman(src.owner))
		var/datum/organ/external/wound/W = new(src)
		W.bleeding = 1
		src.owner:bloodloss += 10 * size
		W.wound_size = size
		W.owner = src.owner
		src.wounds += W

/datum/organ/external/wound
	name = "wound"
	wound_size = 1
	icon_name = "wound"
	display_name = "wound"
	parent = null

/datum/organ/external/wound/proc/stopbleeding()
	if(!src.bleeding)
		return
	src.owner:bloodloss -= 10 * src.wound_size
	src.bleeding = 0
	del(src)

/datum/organ/external/chest
	name = "chest"
	icon_name = "chest"
	max_damage = 150
	min_broken_damage = 75
	display_name = "chest"
	var/datum/organ/internal/heart
	var/datum/organ/internal/lung
	var/datum/organ/internal/intestines

	body_part = CHEST

/datum/organ/external/groin
	name = "groin"
	icon_name = "groin"
	max_damage = 115
	min_broken_damage = 70
	display_name = "groin"

	body_part = GROIN

/datum/organ/external/head
	name = "head"
	icon_name = "head"
	max_damage = 125
	min_broken_damage = 70
	display_name = "head"
	var/datum/organ/external/eye_r
	var/datum/organ/external/eye_l
	var/datum/organ/internal/brain

	body_part = HEAD

/datum/organ/external/l_arm
	name = "l_arm"
	icon_name = "arm_left"
	max_damage = 85
	min_broken_damage = 30
	display_name = "left arm"

	body_part = ARM_LEFT

/datum/organ/external/l_foot
	name = "l_foot"
	icon_name = "foot_left"
	max_damage = 51
	min_broken_damage = 20
	display_name = "left foot"

	body_part = FOOT_LEFT

/datum/organ/external/l_hand
	name = "l_hand"
	icon_name = "hand_left"
	max_damage = 45
	min_broken_damage = 20
	display_name = "left hand"

	body_part = HAND_LEFT

/datum/organ/external/l_leg
	name = "l_leg"
	icon_name = "leg_left"
	max_damage = 85
	min_broken_damage = 30
	display_name = "left leg"

	body_part = LEG_LEFT

/datum/organ/external/r_arm
	name = "r_arm"
	icon_name = "arm_right"
	max_damage = 85
	min_broken_damage = 30
	display_name = "right arm"

	body_part = ARM_RIGHT

/datum/organ/external/r_foot
	name = "r_foot"
	icon_name = "foot_right"
	max_damage = 51
	min_broken_damage = 20
	display_name = "right foot"

	body_part = FOOT_RIGHT

/datum/organ/external/r_hand
	name = "r_hand"
	icon_name = "hand_right"
	max_damage = 45
	min_broken_damage = 20
	display_name = "right hand"

	body_part = HAND_RIGHT

/datum/organ/external/r_leg
	name = "r_leg"
	icon_name = "leg_right"
	max_damage = 85
	min_broken_damage = 30
	display_name = "right leg"

	body_part = LEG_RIGHT





/datum/organ/internal
	name = "internal"

/datum/organ/internal/blood_vessels
	name = "blood vessels"
	var/datum/reagents/reagents

/datum/organ/internal/brain
	name = "brain"
	var/head = null

/datum/organ/internal/excretory
	name = "excretory"
	var/excretory = 7.0
	var/blood_vessels = null

/datum/organ/internal/heart
	name = "heart"

/datum/organ/internal/immune_system
	name = "immune system"
	var/blood_vessels = null
	var/isys = null

/datum/organ/internal/intestines
	name = "intestines"
	var/intestines = 3.0
	var/blood_vessels = null

/datum/organ/internal/liver
	name = "liver"
	var/intestines = null
	var/blood_vessels = null

/datum/organ/internal/lungs
	name = "lungs"
	var/lungs = 3.0
	var/throat = null
	var/blood_vessels = null

/datum/organ/internal/stomach
	name = "stomach"
	var/intestines = null

/datum/organ/internal/throat
	name = "throat"
	var/lungs = null
	var/stomach = null

/datum/organ/external/proc/droplimb()
	if(status) return

	for(var/datum/organ/external/wound/W in wounds)
		W.stopbleeding()

	if(implant)
		implant.loc = owner.loc
		implant.implanted = null
		implant = null

	if(cavity)
		cavity.loc = owner.loc
		cavity = null

	owner.unlock_medal("Lost something?", 0, "Lose a limb.", "easy")

	for(var/mob/M in viewers(owner))
		M.show_message("\red [owner.name]'s [display_name] flies off.")

	var/list/organs = owner.GetOrgans()
	for(var/datum/organ/external/O in organs) // Drop all connected limbs
		if(O.parent == src && O.status)
			O.status = ORGAN_DESTROYED
			O.droplimb()

	var/lol = pick(cardinal)
	switch(name)
		if("chest")
			owner.gib()
		if("head")
			var/obj/item/weapon/organ/head/H = new(owner.loc)
			step(H,lol)
			owner:update_face()
			owner:update_body()
			if(ishuman(owner))
				var/mob/living/carbon/human/mob = owner

				var/icon/eyes_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_l")
				eyes_l.Blend(rgb(mob.r_eyes, mob.g_eyes, mob.b_eyes), ICON_ADD)
				H.overlays += image("icon" = eyes_l)

				var/icon/hair_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[mob.hair_icon_state]_l")
				hair_l.Blend(rgb(mob.r_hair, mob.g_hair, mob.b_hair), ICON_ADD)
				H.overlays += image("icon" = hair_l)

				var/icon/facial_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[mob.face_icon_state]_l")
				facial_l.Blend(rgb(mob.r_facial, mob.g_facial, mob.b_facial), ICON_ADD)
				H.overlays += image("icon" = facial_l)

			var/obj/item/organ/brain/B = getbrain(owner)
			if(B) // Move brain to dropped head, this will make body not cloneable
				owner.internal_organs -= B
				B.loc = H
				H.brain = B
			return

		if("r_arm")
			var/obj/item/weapon/organ/r_arm/H = new(owner.loc)
			step(H,lol)
			return
		if("l_arm")
			var/obj/item/weapon/organ/l_arm/H = new(owner.loc)
			step(H,lol)
			return
		if("r_leg")
			var/obj/item/weapon/organ/r_leg/H = new(owner.loc)
			step(H,lol)
			return
		if("l_leg")
			var/obj/item/weapon/organ/l_leg/H = new(owner.loc)
			step(H,lol)
			return
		if("r_hand")
			var/obj/item/weapon/organ/r_hand/H = new(owner.loc)
			step(H,lol)
			return
		if("l_hand")
			var/obj/item/weapon/organ/l_hand/H = new(owner.loc)
			step(H,lol)
			return
		if("r_foot")
			var/obj/item/weapon/organ/r_foot/H = new(owner.loc)
			step(H,lol)
			return
		if("l_foot")
			var/obj/item/weapon/organ/l_foot/H = new(owner.loc)
			step(H,lol)
			return

/datum/organ/proc/process()
	return

/datum/organ/external/proc/take_damage(brute, burn, slash, supbrute)
	if(status == ORGAN_ROBOTIC) //This makes robolimbs not damageable by chems and makes it stronger
		brute = max(0, brute - 5)
		burn = max(0, burn - 4)

	if(brute <= 0 && burn <= 0)
		return 0

	if(!status)
		return 0


	// make the target feel heavy pain
	if(owner && status == ORGAN_INTACT && prob((brute+burn)*2) )
		owner.pain(display_name, (brute+burn)*2, 1)

	if((slash || prob((brute-10)/2)) && status == ORGAN_INTACT && brute_dam >= max_damage)
		var/chance = rand(1,5)
		var/nux = brute * chance
		if(prob(2 * brute))
			status = ORGAN_DESTROYED
			droplimb()

		else if(prob(nux))
			createwound(rand(1,5))
			owner << "You feel something wet on your [display_name]"

	if ((brute_dam + burn_dam + brute + burn) < max_damage)
		brute_dam += brute
		burn_dam += burn
	else
		var/can_inflict = max_damage - (brute_dam + burn_dam)
		if (can_inflict)
			if (brute > 0 && burn > 0)
				brute = can_inflict/2
				burn = can_inflict/2
				var/ratio = brute / (brute + burn)
				brute_dam += ratio * can_inflict
				burn_dam += (1 - ratio) * can_inflict
			else
				if (brute > 0)
					brute = can_inflict
					brute_dam += brute
				else
					burn = can_inflict
					burn_dam += burn
		else
			return 0

		if(broken)
			owner.emote("scream")

	var/result = update_icon()

	return result

/datum/organ/external/proc/heal_damage(brute, burn, var/internal = 0)
	if(status == ORGAN_ROBOTIC) // This makes robolimbs not healable by chems
		brute = max(0, brute - 3)
		burn = max(0, burn - 3)

	brute_dam = max(0, brute_dam - brute)
	burn_dam = max(0, burn_dam - burn)
	if(internal)
		broken = 0
		perma_dmg = 0
		split = 0
		wound = 0
	return update_icon()

/datum/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam,perma_dmg)	//could use health?

/datum/organ/external/proc/get_damage_brute()
	return max(brute_dam,perma_dmg)

/datum/organ/external/proc/get_damage_fire()
	return burn_dam


// new damage icon system
// returns just the brute/burn damage code

/datum/organ/external/proc/damage_state_text()
	if(open)
		return "33"
	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)

/datum/organ/external/proc/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	else
		return 0
	return

/obj/item/weapon/organ
	icon = 'human.dmi'
	var/mob/living/carbon/owner = null

/obj/item/weapon/organ/head
	name = "head"
	icon_state = "head_l"
	var/obj/item/organ/brain/brain = null

/obj/item/weapon/organ/l_arm
	name = "left arm"
	icon_state = "arm_left_l"
/obj/item/weapon/organ/l_foot
	name = "left foot"
	icon_state = "foot_left_l"
/obj/item/weapon/organ/l_hand
	name = "left hand"
	icon_state = "hand_left_l"
/obj/item/weapon/organ/l_leg
	name = "left leg"
	icon_state = "leg_left_l"
/obj/item/weapon/organ/r_arm
	name = "right arm"
	icon_state = "arm_right_l"
/obj/item/weapon/organ/r_foot
	name = "right foot"
	icon_state = "foot_right_l"
/obj/item/weapon/organ/r_hand
	name = "right hand"
	icon_state = "hand_right_l"
/obj/item/weapon/organ/r_leg
	name = "right leg"
	icon_state = "leg_right_l"