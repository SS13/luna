/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/mob/blood_owner = null

/obj/effect/decal/cleanable/blood/proc/AddHumanBlood(var/mob/living/carbon/human/M)
	blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
	for(var/datum/disease/D in M.viruses)
		var/datum/disease/newDisease = D.Copy(1)
		viruses += newDisease
		newDisease.holder = src
	blood_owner = src

/obj/effect/decal/cleanable/blood/proc/CopyBlood(var/obj/effect/decal/cleanable/blood/B)
	blood_DNA += B.blood_DNA.Copy()
	for(var/datum/disease/D in B.viruses)
		var/datum/disease/newDisease = D.Copy(1)
		viruses += newDisease
		newDisease.holder = src

/obj/effect/decal/cleanable/blood/proc/CopyViruses(var/list/vir)
	for(var/datum/disease/D in vir)
		var/datum/disease/newDisease = D.Copy(1)
		viruses += newDisease
		newDisease.holder = src

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'drip.dmi'
	icon_state = "1"
/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "Grisly..."
	density = 0
	anchored = 0
	layer = 2
	icon = 'blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/robot_debris
	name = "robot debris"
	desc = "Useless heap of junk."
	density = 0
	anchored = 0
	layer = 2
	icon = 'robots.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")

/obj/effect/decal/cleanable/robot_debris/limb
	random_icon_states = list("gibarm", "gibleg")

/obj/effect/decal/cleanable/oil
	name = "motor oil"
	desc = "It's black."
	density = 0
	anchored = 1
	layer = 2
	icon = 'oil.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")

/obj/effect/decal/cleanable/oil/streak
	random_icon_states = list("streak1", "streak2", "streak3", "streak4", "streak5")

/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	density = 0
	anchored = 1
	layer = 2
	icon = 'objects.dmi'
	icon_state = "shards"

/obj/effect/decal/cleanable/water
	name = "a pool of water"
	desc = "Someone could get hurt that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'water.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2")

/obj/effect/decal/sign
	icon = 'decals.dmi'
	anchored = 1.0
	opacity = 0
	density = 0

/obj/effect/decal/sign/bio
	desc = "A warning sign which reads 'BIO HAZARD'"
	name = "BIO HAZARD"
	icon_state = "bio"

/obj/effect/decal/sign/deck1
	desc = "A silver sign which reads 'DECK I'"
	name = "DECK I"
	icon_state = "deck1"

/obj/effect/decal/sign/deck2
	desc = "A silver sign which reads 'DECK II'"
	name = "DECK II"
	icon_state = "deck2"

/obj/effect/decal/sign/deck3
	desc = "A silver sign which reads 'DECK III'"
	name = "DECK III"
	icon_state = "deck3"

/obj/effect/decal/sign/deck4
	desc = "A silver sign which reads 'DECK IV'"
	name = "DECK IV"
	icon_state = "deck4"

/obj/effect/decal/sign/electrical
	desc = "A warning sign which reads 'ELECTRICAL HAZARD'"
	name = "ELECTRICAL HAZARD"
	icon_state = "shock"

/obj/effect/decal/sign/flammable
	desc = "A warning sign which reads 'FLAMMABLE AREA'"
	name = "FLAMMABLE AREA"
	icon_state = "fire"

/obj/effect/decal/sign/nosmoking
	desc = "A warning sign which reads 'NO SMOKING'"
	name = "NO SMOKING"
	icon_state = "nosmoking"

/obj/effect/decal/sign/securearea
	desc = "A warning sign which reads 'SECURE AREA'"
	name = "SECURE AREA"
	icon_state = "securearea"

/obj/effect/decal/sign/space
	desc = "A warning sign which reads 'SPACE DEPRESSURIZATION'"
	name = "SPACE DEPRESSURIZATION"
	icon_state = "space"

/obj/effect/decal/sign/memetic
	desc = "A warning sign of memetic danger, which reads 'MEMETIC DANGER, USE MESONS'."
	name = "MEMETIC DANGER, USE MESONS."
	icon_state = "memetic"

/obj/effect/decal/sign/stairsup
	desc = "A sign which shows an arrow pointing up stairs"
	name = "Stairs Up"
	icon_state = "sup"

/obj/effect/decal/sign/stairsdown
	desc = "A sign which shows an arrow pointing down stairs"
	name = "Stairs Down"
	icon_state = "sdown"

/obj/effect/decal/sign/deck/sub
	desc = "A sign which reads SUB DECK"
	name = "SUB DECK"
	part1
		icon_state = "sub0"
	part2
		icon_state = "sub1"

/obj/effect/decal/sign/deck/main
	desc = "A sign which reads MAIN DECK"
	name = "MAIN DECK"
	part1
		icon_state = "main0"
	part2
		icon_state = "main1"

/obj/effect/decal/sign/deck/enge
	desc = "A sign which reads ENGINEERING DECK"
	name = "ENGINEERING DECK"
	part1
		icon_state = "enge0"
	part2
		icon_state = "enge1"
	part3
		icon_state = "enge2"
	part4
		icon_state = "enge3"

/obj/effect/decal/sign/deck/bridge
	desc = "A sign which reads BRIDGE DECK"
	name = "BRIDGE DECK"
	part1
		icon_state = "bridge0"
	part2
		icon_state = "bridge1"
	part3
		icon_state = "bridge2"

/obj/effect/decal/sign/barsign
	icon = 'barsigns.dmi'
	icon_state = "empty"
	New()
		ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum"))
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//ul_SetLuminosity(4)
		return

/obj/effect/decal/signnew
	icon = 'decals-new.dmi'
	anchored = 1.0
	opacity = 0
	density = 0

/obj/effect/decal/signnew/biohazard
	name = "BIOLOGICAL HAZARD"
	desc = "Warning: Biological and-or toxic hazards present in this area!"
	icon_state = "biohazard"

/obj/effect/decal/signnew/corrosives
	name = "CORROSIVE SUBSTANCES"
	desc = "Warning: Corrosive substances prezent in this area!"
	icon_state = "corrosives"

/obj/effect/decal/signnew/explosives
	name = "EXPLOSIVE SUBSTANCES"
	desc = "Warning: Explosive substances present in this area!"
	icon_state = "explosives"

/obj/effect/decal/signnew/flammables
	name = "FLAMMABLE SUBSTANCES"
	desc = "Warning: Flammable substances present in this area!"
	icon_state = "flammable"

/obj/effect/decal/signnew/laserhazard
	name = "LASER HAZARD"
	desc = "Warning: High powered laser emitters operating in this area!"
	icon_state = "laser"

/obj/effect/decal/signnew/danger
	name = "DANGEROUS AREA"
	desc = "Warning: Generally hazardous area! Exercise caution."
	icon_state = "danger"

/obj/effect/decal/signnew/magnetics
	name = "MAGNETIC FIELD HAZARD"
	desc = "Warning: Extremely powerful magnetic fields present in this area!"
	icon_state = "magnetics"

/obj/effect/decal/signnew/opticals
	name = "OPTICAL HAZARD"
	desc = "Warning: Optical hazards present in this area!"
	icon_state = "optical"

/obj/effect/decal/signnew/radiation
	name = "RADIATION HAZARD"
	desc = "Warning: Significant levels of radiation present in this area!"
	icon_state = "radiation"

/obj/effect/decal/signnew/secure
	name = "SECURE AREA"
	desc = "Warning: Secure Area! Do not enter without authorization!"
	icon_state = "secure"

/obj/effect/decal/signnew/electrical
	name = "ELECTRICAL HAZARD"
	desc = "Warning: Electrical hazards! Wear protective equipment."
	icon_state = "electrical"

/obj/effect/decal/signnew/cryogenics
	name = "CRYOGENIC TEMPERATURES"
	desc = "Warning: Extremely low temperatures in this area."
	icon_state = "cryogenics"

/obj/effect/decal/signnew/canisters
	name = "PRESSURIZED CANISTERS"
	desc = "Warning: Highly pressurized canister storage."
	icon_state = "canisters"

/obj/effect/decal/signnew/oxidants
	name = "OXIDIZING AGENTS"
	desc = "Warning: Oxidizing agents in this area, do not start fires!"
	icon_state = "oxidants"

/obj/effect/decal/signnew/memetic
	name = "MEMETIC HAZARD"
	desc = "Warning: Memetic hazard, wear meson goggles!"
	icon_state = "memetic"
