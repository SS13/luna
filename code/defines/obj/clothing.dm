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
	name = "Earmuffs"
	icon_state = "earmuffs"
	protective_temperature = 500
	item_state = "earmuffs"

// NO GLOVES NO LOVES

/obj/item/clothing/gloves
	name = "Gloves"
	w_class = 2.0
	icon = 'gloves.dmi'
	protective_temperature = 400
	heat_transfer_coefficient = 0.25
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	body_parts_covered = HANDS
	flags = TABLEPASS


// HATS. OH MY WHAT A FINE CHAPEAU, GOOD SIR.

/obj/item/clothing/head
	name = "Head"
	icon = 'hats.dmi'
	body_parts_covered = HEAD

/obj/item/clothing/head/bio_hood
	name = "Bio hood"
	icon_state = "bio_hood"
	item_state = "bio_hood"
	permeability_coefficient = 0.01
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH|PLASMAGUARD

/obj/item/clothing/head/caphat
	name = "Captain's hat"
	icon_state = "captain"
	flags = FPRINT|TABLEPASS
	item_state = "caphat"

/obj/item/clothing/head/det_hat
	name = "Hat"
	desc = "Someone who wears this will look very smart"
	icon_state = "detective"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/chefhat
	name = "Chef's hat"
	icon_state = "chef"
	item_state = "chef"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/beret
	name = "Red beret"
	icon_state = "beret"
	item_state = "secsoft"
	flags = FPRINT | TABLEPASS


// CHUMP HELMETS: COOKING THEM DESTROYS THE CHUMP HELMET SPAWN.

/obj/item/clothing/head/helmet
	name = "Helmet"
	icon_state = "helmet"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "helmet"

	protective_temperature = 500
	heat_transfer_coefficient = 0.10

/obj/item/clothing/head/helmet/riot
	name = "Riot helmet"
	icon_state = "riot"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | HEADCOVERSMOUTH
	item_state = "helmet"

/obj/item/clothing/head/helmet/swat
	name = "SWAT helmet"
	icon_state = "swat"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "swat"

/obj/item/clothing/head/helmet/thunderdome
	name = "Thunderdome helmet"
	icon_state = "thunderdome"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "thunderdome"


/obj/item/clothing/head/helmet/plump
	name = "Plump helmet helmet"
	icon_state = "plump"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "plump"

/obj/item/clothing/head/helmet/cargosoft
	name = "Cargo Soft"
	icon_state = "cargosoft"
	item_state = "cargosoft"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/helmet/HoS
	name = "HoS helmet"
	icon_state = "hoscap"
	item_state = "that"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/helmet/Secsoft
	name = "Security Soft"
	icon_state = "secsoft"
	item_state = "secsoft"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/helmet/Policehat
	name = "Police Hat"
	icon_state = "policehelm"
	item_state = "that"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/helmet/wardencap
	name = "Warden Cap"
	icon_state = "wardencap"
	item_state = "that"
	flags = FPRINT | TABLEPASS

// MASK WAS THAT MOVIE WITH THAT GUY WITH THE MESSED UP FACE. WHAT'S HIS NAME . . . JIM CARREY, I THINK.

/obj/item/clothing/mask
	name = "Mask"
	icon = 'masks.dmi'
	var/vchange = 0
	body_parts_covered = HEAD
	flags = TABLEPASS

/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "gas_mask"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | MASKINTERNALS
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
	flags = FPRINT | MASKCOVERSMOUTH | MASKINTERNALS
	w_class = 2
	protective_temperature = 420
	heat_transfer_coefficient = 0.90
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/mask/breath/milbreath
	name = "military breath mask"
	desc = "A hard, dark plastic version of the normal breathmask, usually used by military personnel. Not rated for operations in vacuum."
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
	name = "Muzzle"
	icon_state = "muzzle"
	item_state = "muzzle"
	flags = FPRINT | MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/surgical
	name = "Sterile mask"
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
	flags = FPRINT | TABLEPASS

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	permeability_coefficient = 0.50


/obj/item/clothing/shoes/magnetic
	name = "magboots"
	flags = FPRINT | TABLEPASS | NOSLIP | CONDUCT
	icon_state = "magboots"
	item_state = "o_shoes"

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

// SUITS
/obj/item/clothing/suit
	icon = 'suits.dmi'
	name = "Suit"
	var/fire_resist = T0C+100
	flags = FPRINT | TABLEPASS
	var/airflowprot = 0
	var/reflectchance = 0

/obj/item/clothing/suit/bio_suit
	name = "Bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio_suit"
	item_state = "bio_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.30
	slowdown = 1

	flags = FPRINT|TABLEPASS|PLASMAGUARD

/obj/item/clothing/suit/storage
    name = "Storage"

/obj/item/clothing/suit/storage/det_suit
	name = "Coat"
	desc = "Someone who wears this means business"
	icon_state = "detective"
	item_state = "det_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/judgerobe
	name = "Judge's robe"
	desc = "This robe commands authority"
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/storage/labcoat
	name = "Labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75

/obj/item/clothing/suit/storage/chef
	name = "Chef coat"
	desc = "A fancy chef's coat."
	icon_state = "chef"
	item_state = "chef"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/storage/chaplain_hoodie
	name = "Chaplain hoodie"
	desc = "A black hoodie."
	icon_state = "chaplain_hoodie"
	item_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/storage/apron
	name = "Apron"
	desc = "A simple blue apron. It has a big pocket on the front you could store something in."
	icon_state = "apron"
	item_state = "apron"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/storage/captunic
	name = "Captain tunic"
	desc = "A captain tunic."
	icon_state = "captunic"
	item_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/storage/hazard
	name = "hazard west"
	desc = "A orange west."
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

/obj/item/clothing/suit/storage/hos
	name = "HoS coat"
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = CHEST|GROIN|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/warden_jacket
	name = "warden jacket"
	icon_state = "warden_jacket"
	item_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

// ARMOR

/obj/item/clothing/suit/armor/vest
	name = "armor vest"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	body_parts_covered = CHEST|GROIN
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	reflectchance = 60

/obj/item/clothing/suit/storage/gearharness
	name = "Gear harness"
	desc = "A simple security harness, used for storing small objects"
	icon_state = "gearharness"
	item_state = "gearharness"
	body_parts_covered = CHEST|GROIN
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/storage/armourrigvest
	name = "Armour rig vest"
	desc = "An important looking armoured vest, outfitted with pockets."
	icon_state = "armourrigvest"
	item_state = "armourrigvest"
	body_parts_covered = CHEST|GROIN
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

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
	flags = FPRINT | TABLEPASS | CONDUCT | ONESIZEFITSALL
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	icon_state = "caparmor"
	item_state = "caparmor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/captain/newstyle
	name = "Captain's armor"
	icon_state = "caparmor_b"
	item_state = "caparmor_b"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/heavy
	name = "Heavy armor"
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
	name = "Riot suit"
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
	name = "Chameleon Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	desc = null
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()

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