// All currently in-game clothing. Gimmicks moved to obj\clothing\gimmick.dm for all of your gay fantasy roleplay dress-up shenanigans.

/obj/item/clothing
	name = "Clothing"
//	var/obj/item/clothing/master = null

	var/see_face = 1.0

	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/protective_temperature = 0
	var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)

// EARS
/obj/item/clothing/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 373.15 && protective_temperature < exposed_temperature)
		for(var/mob/M in viewers(5, src))
			M << "\red \the [src] burns up."
		del(src)
/obj/item/clothing/ears
	name = "Ears"
	w_class = 1.0
	throwforce = 2

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	icon_state = "earmuffs"
	protective_temperature = 500
	item_state = "earmuffs"

// NO GLOVES NO LOVES

/obj/item/clothing/gloves
	name = "gloves"
	w_class = 2.0
	icon = 'gloves.dmi'
	protective_temperature = 400
	heat_transfer_coefficient = 0.25
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	body_parts_covered = HANDS
	flags = FPRINT


// HATS. OH MY WHAT A FINE CHAPEAU, GOOD SIR.

/obj/item/clothing/head
	name = "head"
	icon = 'hats.dmi'
	body_parts_covered = HEAD

/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio_hood"
	item_state = "bio_hood"
	permeability_coefficient = 0.01
	flags = FPRINT|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH|PLASMAGUARD
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES


/obj/item/clothing/head/det_hat
	name = "hat"
	desc = "Someone who wears this will look very smart"
	icon_state = "detective"


// CHUMP HELMETS: COOKING THEM DESTROYS THE CHUMP HELMET SPAWN.

/obj/item/clothing/head/helmet
	name = "helmet"
	icon_state = "helmet"
	flags = FPRINT | HEADCOVERSEYES
	item_state = "helmet"

	protective_temperature = 500
	heat_transfer_coefficient = 0.10

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	icon_state = "riot"
	flags = FPRINT | HEADCOVERSEYES | HEADCOVERSMOUTH
	item_state = "helmet"

/obj/item/clothing/head/helmet/swat
	name = "SWAT helmet"
	icon_state = "swat"
	flags = FPRINT | HEADCOVERSEYES
	item_state = "swat"

/obj/item/clothing/head/helmet/thunderdome
	name = "thunderdome helmet"
	icon_state = "thunderdome"
	flags = FPRINT | HEADCOVERSEYES
	item_state = "thunderdome"


/obj/item/clothing/head/helmet/plump
	name = "plump helmet helmet"
	icon_state = "plump"
	flags = FPRINT | HEADCOVERSEYES
	item_state = "plump"

/obj/item/clothing/head/helmet/cargosoft
	name = "yellow cap"
	icon_state = "cargosoft"
	item_state = "cargosoft"

/obj/item/clothing/head/helmet/secsoft
	name = "red cap"
	icon_state = "secsoft"
	item_state = "secsoft"

/obj/item/clothing/head/helmet/Policehat
	name = "police hat"
	icon_state = "policehelm"
	item_state = "that"

/obj/item/clothing/head/helmet/wardencap
	name = "Warden Cap"
	icon_state = "wardencap"
	item_state = "that"

// MASK WAS THAT MOVIE WITH THAT GUY WITH THE MESSED UP FACE. WHAT'S HIS NAME . . . JIM CARREY, I THINK.

/obj/item/clothing/mask
	name = "Mask"
	icon = 'masks.dmi'
	var/vchange = 0
	body_parts_covered = HEAD
	flags = FPRINT

/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "gas_mask"
	flags = FPRINT | MASKCOVERSMOUTH | MASKCOVERSEYES | MASKINTERNALS
	w_class = 3.0
	see_face = 0.0
	item_state = "gas_mask"
	protective_temperature = 500
	heat_transfer_coefficient = 0.01
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01


/obj/item/clothing/mask/gas/emergency
	name = "emergency gas mask"
	icon_state = "gas_alt"
	item_state = "gas_alt"

/obj/item/clothing/mask/gas/swat
	name = "SWAT mask"
	desc = "A close-fitting tactical mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "swat"

/obj/item/clothing/mask/gas/voice
	origin_tech = "syndicate=4"
	var/voice = "Unknown"
	vchange = 1

/obj/item/clothing/mask/breath
	name = "breath mask"
	desc = "A close-fitting mask that can be connected to an air supply but does not work very well in hard vacuum."
	icon_state = "breath"
	item_state = "breath"
	body_parts_covered = 0
	flags = FPRINT | MASKINTERNALS
	w_class = 2
	protective_temperature = 420
	heat_transfer_coefficient = 0.90
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/mask/breath/milbreath
	name = "military breath mask"
	desc = "A hard, dark plastic version of the normal breath mask, usually used by military personnel. Not rated for operations in vacuum."
	icon_state = "milbreath"
	item_state = "milbreath"

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	icon_state = "clown"
	item_state = "clown"

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state = "sexyclown"

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"
	item_state = "mime"

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state = "sexymime"

/obj/item/clothing/mask/breath/medical
	name = "medical mask"
	desc = "This mask does not work very well in low pressure environments."
	icon_state = "medical"
	item_state = "medical"

/obj/item/clothing/mask/muzzle
	name = "muzzle"
	icon_state = "muzzle"
	item_state = "muzzle"
	flags = FPRINT | MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 1
	flags = FPRINT | MASKCOVERSMOUTH
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.05


// OMG SHOES

/obj/item/clothing/shoes
	name = "Shoes"
	icon = 'shoes.dmi'
	var/chained = 0
	slowdown = -1

	body_parts_covered = FEET

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	permeability_coefficient = 0.50


/obj/item/clothing/shoes/magnetic
	name = "magboots"
	flags = FPRINT | NOSLIP | CONDUCT
	icon_state = "magboots"
	item_state = "o_shoes"

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

// SUITS
/obj/item/clothing/suit
	icon = 'suits.dmi'
	name = "Suit"
	var/fire_resist = T0C+100
	var/airflowprot = 0
	var/reflectchance = 0
	var/blood_overlay_type

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio_suit"
	item_state = "bio_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.30
	slowdown = 0.8
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/weapon/pen,/obj/item/device/flashlight/pen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


	flags = FPRINT|PLASMAGUARD

/obj/item/clothing/suit/storage
    name = "Storage"

/obj/item/clothing/suit/storage/det_suit
	name = "coat"
	desc = "Someone who wears this means business"
	icon_state = "detective"
	item_state = "det_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority"
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/storage/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75

//Internal Affairs
/obj/item/clothing/suit/storage/internalaffairs
	name = "Internal Affairs jacket"
	desc = "A smooth black jacket."
	icon_state = "ia_jacket_open"
	item_state = "ia_jacket"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|ARMS

	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(icon_state)
			if("ia_jacket_open")
				src.icon_state = "ia_jacket"
				usr << "You button up the jacket."
			if("ia_jacket")
				src.icon_state = "ia_jacket_open"
				usr << "You unbutton the jacket."
			else
				usr << "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are."
				return
		usr.update_clothing()	//so our overlays update

/obj/item/clothing/suit/storage/chef
	name = "chef coat"
	desc = "A fancy chef's coat."
	icon_state = "chef"
	item_state = "chef"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/storage/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "A black hoodie."
	icon_state = "chaplain_hoodie"
	item_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/storage/apron
	name = "apron"
	desc = "A simple blue apron. It has a big pocket on the front you could store something in."
	icon_state = "apron"
	item_state = "apron"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/storage/captunic
	name = "captain's tunic"
	desc = "A captain's tunic."
	icon_state = "captunic"
	item_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/storage/hazard
	name = "hazard west"
	desc = "An orange west."
	icon_state = "hazard"
	item_state = "orangebook"
	permeability_coefficient = 0.60
	protective_temperature = 200
	siemens_coefficient = 0.30
	heat_transfer_coefficient = 0.60
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/wcoat
	name = "Waistcoat"
	icon_state = "vest"
	item_state = "wcoat"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/storage/armor/hos
	name = "armored coat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style."
	icon_state = "hos"
	item_state = "hos"
	armor = list(melee = 15, bullet = 5, laser = 10, energy = 5, bomb = 5, bio = 0, rad = 0)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	flags = FPRINT | ONESIZEFITSALL

/obj/item/clothing/head/helmet/HoS
	name = "Head of Security Hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	flags = FPRINT | HEADCOVERSEYES
	armor = list(melee = 20, bullet = 10, laser = 15,energy = 10, bomb = 10, bio = 10, rad = 0)
	flags_inv = HIDEEARS

//Jensen gear
/obj/item/clothing/head/helmet/HoS/jensen
	name = "dermal armor patch"
	desc = "It implants nicely in your head."
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	icon_state = "dermal"
	item_state = "dermal"
	canremove = 0

/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	item_state = "jensen"
	item_color = "jensen"

/obj/item/clothing/suit/storage/armor/hos/jensen
	name = "armored trenchoat"
	desc = "A trenchoat augmented with a special alloy for some protection and style"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	icon_state = "jensencoat"
	item_state = "jensencoat"
	flags_inv = 0

/obj/item/clothing/suit/warden_jacket
	name = "warden jacket"
	icon_state = "warden_jacket"
	item_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	flags = FPRINT | ONESIZEFITSALL

// ARMOR

/obj/item/clothing/suit/armor/vest
	name = "armor vest"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	flags = FPRINT | ONESIZEFITSALL

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	body_parts_covered = CHEST|GROIN
	armor = list(melee = 10, bullet = 10, laser = 70, energy = 50, bomb = 0, bio = 0, rad = 0)
	reflectchance = 60

/obj/item/clothing/suit/storage/gearharness
	name = "gear harness"
	desc = "A simple security harness, used for storing small objects"
	icon_state = "gearharness"
	item_state = "gearharness"
	body_parts_covered = CHEST|GROIN
	flags = FPRINT | ONESIZEFITSALL

/obj/item/clothing/suit/storage/armor/rigvest
	name = "armor rig vest"
	desc = "An important looking armor vest, outfitted with pockets."
	icon_state = "armourrigvest"
	item_state = "armourrigvest"
	body_parts_covered = CHEST|GROIN
	flags = FPRINT | ONESIZEFITSALL

/obj/item/clothing/suit/armor/a_i_a_ptank
	desc = "A wearable bomb with a health analyzer attached"
	name = "Analyzer/Igniter/Armor/Plasmatank Assembly"
	icon_state = "bomb"
	item_state = "bombvest"
	var/obj/item/device/healthanalyzer/part1 = null
	var/obj/item/device/igniter/part2 = null
	var/obj/item/weapon/tank/plasma/part4 = null
	var/obj/item/clothing/suit/armor/vest/part3 = null
	var/status = 0
	flags = FPRINT | CONDUCT | ONESIZEFITSALL
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	icon_state = "caparmor"
	item_state = "caparmor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags = FPRINT | SUITSPACE | PLASMAGUARD
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02

/obj/item/clothing/suit/armor/captain/newstyle
	icon_state = "caparmor_b"
	item_state = "caparmor_b"

/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.90
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome/red
	name = "Thunderdome suit (red)"
	icon_state = "tdred"
	item_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "Thunderdome suit (green)"
	icon_state = "tdgreen"
	item_state = "tdgreen"

/obj/item/clothing/suit/armor/swat
	name = "SWAT suit"
	icon_state = "heavy"
	item_state = "heavy"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "Heavy segmented armor designed to help control rioters."
	icon_state = "riot"
	item_state = "riot"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	slowdown = 2

// FIRE SUITS

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "firesuit"
	item_state = "firesuit"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 1

	protective_temperature = 8000
	heat_transfer_coefficient = 0.01

/obj/item/clothing/suit/fire/heavy
	name = "firesuit"
	desc = "A suit that protects against extreme fire and heat."
	icon_state = "fire"
	item_state = "fire"
	slowdown = 2

	protective_temperature = 30000
	heat_transfer_coefficient = 0.01

// Colors
/obj/item/clothing/under/chameleon
//starts off as black
	name = "chameleon jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	desc = null
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

	emp_act(severity)
		name = "psychedelic"
		desc = "Groovy!"
		icon_state = "psyche"
		item_color = "psyche"
		spawn(200)
			name = "Black Jumpsuit"
			icon_state = "bl_suit"
			item_color = "black"
			desc = null
		..()

/obj/item/clothing/under/chameleon/all


// RANKS
/obj/item/clothing/under/rank/captain
	desc = "It has a Captains rank stripe on it."
	name = "Captain Jumpsuit"
	icon_state = "captain"
	item_state = "dg_suit"
	item_color = "captain"

/obj/item/clothing/under/rank/geneticist
	desc = "Made of a special fiber that gives protection against biohazards. Has a genetics rank stripe on it."
	name = "Genetics Jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	item_color = "geneticswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It has a Head of Personnel rank stripe on it."
	name = "Head of Personnel Jumpsuit"
	icon_state = "hop"
	item_state = "b_suit"
	item_color = "hopblue"

/obj/item/clothing/under/rank/head_of_security
	desc = "It has a Head of Security rank stripe on it."
	name = "Head of Security Jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	item_color = "hosred"

/obj/item/clothing/under/rank/warden
	desc = "It has a Warden rank stripe on it."
	name = "Warden Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	item_color = "darkred"

/obj/item/clothing/under/rank/janitor
	desc = "The janitorial crew jumpsuit."
	name = "Janitor's Jumpsuit"
	icon_state = "janitor"
	item_state = "janitor"
	item_color = "janitor"

// OTHER NONRANKED STATION JOBS
/obj/item/clothing/under/rank/det
	name = "Hard worn suit"
	desc = "Someone who wears this means business"
	icon_state = "detective"
	item_state = "det"
	item_color = "detective"

/obj/item/clothing/under/rank/forensic_technician
	name = "Forensic technician jumpsuit"
	desc = "A variant of the security outfit, for forensic techs."
	icon_state = "forensicsred"
	item_state = "r_suit"
	item_color = "forensicsred"

/obj/item/clothing/under/sl_suit
	desc = "A very amish looking suit"
	name = "Amish Suit"
	icon_state = "sl_suit"
	item_color = "sl_suit"
