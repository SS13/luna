/datum/organ
	var/name = "organ"
	var/mob/living/owner = null

/datum/organ/external
	name = "external"
	var/icon_name = null
	var/list/wounds = list()
	var/damage_state = "00"
	var/brute_dam = 0
	var/burn_dam = 0
	var/slash_dam = 0
	var/bandaged = 0
	var/max_damage = 0
	var/wound_size = 0
	var/max_size = 0
	var/critical = 0
	var/perma_dmg = 0
	var/bleeding = 0
	var/perma_injury = 0
	var/broken = 0
	var/destroyed = 0
	var/robotic = 0
	var/destspawn
	var/obj/item/weapon/implant/implant = null
	var/min_broken_damage = 30
	var/datum/organ/external/parent
	var/damage_msg = "\red You feel a intense pain"

	var/body_part = null

	process()
		if(destroyed)
			if(destspawn)
				droplimb()
			return
		if(broken == 0 || robotic)
			perma_dmg = 0
		if(parent)
			if(parent.destroyed)
				destroyed = 1
				owner:update_body()
				return
		if(brute_dam > min_broken_damage)
			if(robotic)
				if(prob(20))
					return
			else
				if(broken == 0)
					var/dmgmsg = "[damage_msg] in your [display_name]"
					owner << dmgmsg
					owner.unlock_medal("Broke Yarrr Bones!", 0, "Break a bone.", "easy")
					for(var/mob/M in viewers(owner))
						if(M != owner)
							M.show_message("\red You hear a loud cracking sound coming from [owner.name].")
					owner.emote("scream")
					broken = 1
					wound = "broken" //Randomise in future
					perma_injury = brute_dam
				return
		return

	var/open = 0
	var/display_name
	var/clean = 1
	var/stage = 0
	var/wound = 0
	var/split = 0

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
	var/t = 10 * src.wound_size
	src.owner:bloodloss -= t
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
	max_damage = 75
	min_broken_damage = 30
	display_name = "left arm"

	body_part = ARM_LEFT

/datum/organ/external/l_foot
	name = "l_foot"
	icon_name = "foot_left"
	max_damage = 40
	min_broken_damage = 20
	display_name = "left foot"

	body_part = FOOT_LEFT

/datum/organ/external/l_hand
	name = "l_hand"
	icon_name = "hand_left"
	max_damage = 40
	min_broken_damage = 20
	display_name = "left hand"

	body_part = HAND_LEFT

/datum/organ/external/l_leg
	name = "l_leg"
	icon_name = "leg_left"
	max_damage = 75
	min_broken_damage = 30
	display_name = "left leg"

	body_part = LEG_LEFT

/datum/organ/external/r_arm
	name = "r_arm"
	icon_name = "arm_right"
	max_damage = 75
	min_broken_damage = 30
	display_name = "right arm"

	body_part = ARM_RIGHT

/datum/organ/external/r_foot
	name = "r_foot"
	icon_name = "foot_right"
	max_damage = 40
	min_broken_damage = 20
	display_name = "right foot"

	body_part = FOOT_RIGHT

/datum/organ/external/r_hand
	name = "r_hand"
	icon_name = "hand_right"
	max_damage = 40
	min_broken_damage = 20
	display_name = "right hand"

	body_part = HAND_RIGHT

/datum/organ/external/r_leg
	name = "r_leg"
	icon_name = "leg_right"
	max_damage = 75
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
	if(destroyed)
		if(destroyed)
			owner.unlock_medal("Lost something?", 0, "Lose a limb.", "easy")
			if(name == "chest")
				owner.gib()
			if(name == "head")
				var/obj/item/weapon/organ/head/H = new(owner.loc)
				var/lol = pick(cardinal)
				step(H,lol)
				owner:update_face()
				owner:update_body()
				return
			if(name == "r arm")
				var/obj/item/weapon/organ/r_arm/H = new(owner.loc)
				if(owner:organs["l_hand"])
					var/datum/organ/external/S = owner:organs["l_hand"]
					if(!S.destroyed)
						var/obj/item/weapon/organ/r_hand/X = new(owner.loc)
						for(var/mob/M in viewers(owner))
							M.show_message("\red [owner.name]'s [X.name] flies off in arc.")
						var/lol2 = pick(cardinal)
						step(X,lol2)
				var/lol = pick(cardinal)
				step(H,lol)
				destroyed = 1
				robotic = 0
				return
			if(name == "l arm")
				var/obj/item/weapon/organ/l_arm/H = new(owner.loc)
				if(owner:organs["l_hand"])
					var/datum/organ/external/S = owner:organs["l_hand"]
					if(!S.destroyed)
						var/obj/item/weapon/organ/l_hand/X = new(owner.loc)
						for(var/mob/M in viewers(owner))
							M.show_message("\red [owner.name]'s [X.name] flies off in arc.")
						var/lol2 = pick(cardinal)
						step(X,lol2)
				var/lol = pick(cardinal)
				step(H,lol)
				destroyed = 1
				robotic = 0
				return
			if(name == "r leg")
				var/obj/item/weapon/organ/r_leg/H = new(owner.loc)
				if(owner:organs["r_foot"])
					var/datum/organ/external/S = owner:organs["r_foot"]
					if(!S.destroyed)
						var/obj/item/weapon/organ/l_foot/X = new(owner.loc)
						for(var/mob/M in viewers(owner))
							M.show_message("\red [owner.name]'s [X.name] flies off.")
						var/lol2 = pick(cardinal)
						step(X,lol2)
				var/lol = pick(cardinal)
				step(H,lol)
				destroyed = 1
				robotic = 0
				return
			if(name == "l leg")
				var/obj/item/weapon/organ/l_leg/H = new(owner.loc)
				if(owner:organs["l_foot"])
					var/datum/organ/external/S = owner:organs["l_foot"]
					if(!S.destroyed)
						var/obj/item/weapon/organ/l_foot/X = new(owner.loc)
						for(var/mob/M in viewers(owner))
							M.show_message("\red [owner.name]'s [X.name] flies off.")
						var/lol2 = pick(cardinal)
						step(X,lol2)
				var/lol = pick(cardinal)
				step(H,lol)
				destroyed = 1
				robotic = 0
				return

/datum/organ/proc/process()
	return

/datum/organ/external/proc/take_damage(brute, burn, slash, supbrute)
	if ((brute <= 0 && burn <= 0))
		return 0
	if(destroyed)
		return 0
	// make the target feel heavy pain
	if(owner && prob((brute+burn)*2)) owner.pain(display_name, (brute+burn)*2, 1)
	if(slash)
		var/chance = rand(1,5)
		var/nux = brute * chance
		if(brute_dam >= max_damage)
			if(prob(5 * brute))
				for(var/mob/M in viewers(owner))
					M.show_message("\red [owner.name]'s [display_name] flies off.")
				if(name == "chest")
					owner.gib()
				if(name == "head")
					var/obj/item/weapon/organ/head/H = new(owner.loc)
					var/lol = pick(cardinal)
					step(H,lol)
					destroyed = 1
					owner:update_face()
					owner:update_body()
					owner.death()
					return
				if(name == "r arm")
					var/obj/item/weapon/organ/r_arm/H = new(owner.loc)
					if(owner:organs["r_hand"])
						var/datum/organ/external/S = owner:organs["r_hand"]
						if(!S.destroyed)
							var/obj/item/weapon/organ/r_hand/X = new(owner.loc)
							for(var/mob/M in viewers(owner))
								M.show_message("\red [owner.name]'s [X.name] flies off.")
							var/lol2 = pick(cardinal)
							step(X,lol2)
					var/lol = pick(cardinal)
					step(H,lol)
					destroyed = 1
					robotic = 0
					return
				if(name == "l arm")
					var/obj/item/weapon/organ/l_arm/H = new(owner.loc)
					if(owner:organs["l_hand"])
						var/datum/organ/external/S = owner:organs["l_hand"]
						if(!S.destroyed)
							var/obj/item/weapon/organ/l_hand/X = new(owner.loc)
							for(var/mob/M in viewers(owner))
								M.show_message("\red [owner.name]'s [X.name] flies off in an arc.")
							var/lol2 = pick(cardinal)
							step(X,lol2)
					var/lol = pick(cardinal)
					step(H,lol)
					destroyed = 1
					robotic = 0
					return
				if(name == "r leg")
					var/obj/item/weapon/organ/r_leg/H = new(owner.loc)
					if(owner:organs["r_foot"])
						var/datum/organ/external/S = owner:organs["r_foot"]
						if(!S.destroyed)
							var/obj/item/weapon/organ/l_foot/X = new(owner.loc)
							for(var/mob/M in viewers(owner))
								M.show_message("\red [owner.name]'s [X.name] flies off flies off in an arc.")
							var/lol2 = pick(cardinal)
							step(X,lol2)
					var/lol = pick(cardinal)
					step(H,lol)
					destroyed = 1
					robotic = 0
					return
				if(name == "l leg")
					var/obj/item/weapon/organ/l_leg/H = new(owner.loc)
					if(owner:organs["l_foot"])
						var/datum/organ/external/S = owner:organs["l_foot"]
						if(!S.destroyed)
							var/obj/item/weapon/organ/l_foot/X = new(owner.loc)
							for(var/mob/M in viewers(owner))
								M.show_message("\red [owner.name]'s [X.name] flies off.")
							var/lol2 = pick(cardinal)
							step(X,lol2)
					var/lol = pick(cardinal)
					step(H,lol)
					destroyed = 1
					robotic = 0
					return
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

/datum/organ/external/proc/heal_damage(brute, burn,var/internal = 0)
	brute_dam = max(0, brute_dam - brute)
	burn_dam = max(0, burn_dam - burn)
	if(internal)
		broken = 0
		perma_injury = 0
		perma_dmg = 0
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

obj/item/weapon/organ/
	icon = 'human.dmi'
obj/item/weapon/organ/head
	name = "head"
	icon_state = "head_l"
obj/item/weapon/organ/l_arm
	name = "left arm"
	icon_state = "arm_left_l"
obj/item/weapon/organ/l_foot
	name = "left foot"
	icon_state = "foot_left_l"
obj/item/weapon/organ/l_hand
	name = "left hand"
	icon_state = "hand_left_l"
obj/item/weapon/organ/l_leg
	name = "left leg"
	icon_state = "leg_left_l"
obj/item/weapon/organ/r_arm
	name = "right arm"
	icon_state = "arm_right_l"
obj/item/weapon/organ/r_foot
	name = "right foot"
	icon_state = "foot_right_l"
obj/item/weapon/organ/r_hand
	name = "right hand"
	icon_state = "hand_right_l"
obj/item/weapon/organ/r_leg
	name = "right leg"
	icon_state = "leg_right_l"

