// All currently in-game clothing. Gimmicks moved to obj\clothing\gimmick.dm for all of your gay fantasy roleplay dress-up shenanigans.

/obj/item/clothing
	name = "Clothing"
//	var/obj/item/clothing/master = null

	var/see_face = 1.0
	var/color = null

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

// GLASSES

/obj/item/clothing/glasses
	name = "Glasses"
	icon = 'glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES | TABLEPASS

/obj/item/clothing/glasses/blindfold
	name = "Blindfold"
	icon_state = "blindfold"
	item_state = "blindfold"

/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "meson"

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	icon_state = "glasses"
	item_state = "glasses"

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "Sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	protective_temperature = 1300
	var/already_worn = 0

/obj/item/clothing/glasses/thermal
	name = "Thermal"
	desc = "Optical Thermal Scanner."
	icon_state = "thermal"
	item_state = "thermal"

// NO GLOVES NO LOVES

/obj/item/clothing/gloves
	name = "Gloves"
	w_class = 2.0
	icon = 'gloves.dmi'
	protective_temperature = 400
	heat_transfer_coefficient = 0.25
	siemens_coefficient = 0.50
	var/elecgen = 0
	var/uses = 0
	body_parts_covered = HANDS
	flags = TABLEPASS

/obj/item/clothing/gloves/black
	desc = "These gloves are fire-resistant."
	name = "Black Gloves"
	icon_state = "black"
	item_state = "bgloves"

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01


/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "Cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/latex
	name = "Latex Gloves"
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30

	protective_temperature = 310
	heat_transfer_coefficient = 0.90

/obj/item/clothing/gloves/captain
	name = "Captain Gloves"
	icon_state = "captain"
	item_state = "swat_gl"
	siemens_coefficient = 0.30

	protective_temperature = 310
	heat_transfer_coefficient = 0.90

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.30

	protective_temperature = 1100
	heat_transfer_coefficient = 0.05

/obj/item/clothing/gloves/stungloves/
	name = "Stungloves"
	desc = "These gloves are electrically charged."
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0.30
	elecgen = 1
	uses = 10

/obj/item/clothing/gloves/yellow
	desc = "These gloves are electrically insulated."
	name = "Insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0

	protective_temperature = 1000
	heat_transfer_coefficient = 0.01

/obj/item/clothing/gloves/green
	desc = "Fancy green gloves with fancy gold embroidery."
	name = "Green gloves"
	icon_state = "green"
	item_state = "greengloves"
	siemens_coefficient = 0.30

	protective_temperature = 1100
	heat_transfer_coefficient = 0.05

/obj/item/clothing/gloves/red
	desc = "Heavily padded heavy-duty red gloves."
	name = "Red gloves"
	icon_state = "red"
	item_state = "redgloves"
	siemens_coefficient = 0.30

	protective_temperature = 1100
	heat_transfer_coefficient = 0.05


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

/obj/item/clothing/head/righelm
	name = "Rig Helm"
	icon_state = "rig_helm"
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH|PLASMAGUARD
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02
	gas_transfer_coefficient = 0.01
	body_parts_covered = HEAD

/obj/item/clothing/head/cakehat
	name = "Cakehat"
	desc = "It is a cakehat"
	icon_state = "cake0"
	var/onfire = 0.0
	var/status = 0
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES
	var/fire_resist = T0C+1300	//this is the max temp it can stand before you start to cook. although it might not burn away, you take damage

/obj/item/clothing/head/caphat
	name = "Captain's hat"
	icon_state = "captain"
	flags = FPRINT|TABLEPASS
	item_state = "caphat"

/obj/item/clothing/head/centhat
	name = "Cent. Comm. hat"
	icon_state = "centcom"
	flags = FPRINT|TABLEPASS
	item_state = "centcom"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/det_hat
	name = "Hat"
	desc = "Someone who wears this will look very smart"
	icon_state = "detective"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/powdered_wig
	name = "Powdered wig"
	desc = "A powdered wig"
	icon_state = "pwig"
	item_state = "pwig"


/obj/item/clothing/head/that
	name = "Hat"
	desc = "An amish looking hat"
	icon_state = "tophat"
	item_state = "that"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/wizard
	name = "Wizard hat"
	desc = "It has WIZZARD written across it in sequins"
	icon_state = "wizard"

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

/obj/item/clothing/head/green_band
	name = "Green Bandana"
	icon_state = "green_bandana"
	item_state = "green_bandana"
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
	icon_state = "riothelmet"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | HEADCOVERSMOUTH
	item_state = "helmet"

/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	flags = FPRINT |TABLEPASS| HEADSPACE | HEADCOVERSEYES | HEADCOVERSMOUTH | PLASMAGUARD
	see_face = 0.0
	item_state = "space"

/obj/item/clothing/head/helmet/space/syndicate
	name = "Red space helmet"
	icon_state = "syndicate"
	item_state = "syndicate"

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

/obj/item/clothing/head/helmet/hardhat
	name = "Hard hat"
	icon_state = "hardhat0"
	flags = FPRINT | TABLEPASS
	item_state = "hardhat0"
	var/on = 0

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

/obj/item/clothing/head/helmet/welding
	name = "Welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | HEADCOVERSMOUTH
	see_face = 0.0
	item_state = "welding"
	protective_temperature = 1300
	m_amt = 3000
	g_amt = 1000

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
	icon_state = "policehat"
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
	name = "Gas mask"
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
	name = "Emergency gas mask"
	icon_state = "gas_alt"
	item_state = "gas_alt"

/obj/item/clothing/mask/gas/swat
	name = "SWAT mask"
	desc = "A close-fitting tactical mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "swat"

/obj/item/clothing/mask/gas/voice
	name = "gas mask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "gas_mask"
	var/voice = "Unknown"
	vchange = 1

/obj/item/clothing/mask/breath
	name = "Breath mask"
	desc = "A close-fitting mask that can be connected to an air supply but does not work very well in hard vacuum."
	icon_state = "breath"
	item_state = "breath"
	flags = FPRINT | MASKCOVERSMOUTH | MASKINTERNALS
	w_class = 2
	protective_temperature = 420
	heat_transfer_coefficient = 0.90
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/mask/milbreath
	name = "Military breath mask"
	desc = "A hard, dark plastic version of the normal breathmask, usually used by military personnel. Not rated for operations in vacuum."
	icon_state = "milbreath"
	item_state = "milbreath"
	flags = FPRINT | MASKCOVERSMOUTH | MASKINTERNALS
	w_class = 2
	protective_temperature = 420
	heat_transfer_coefficient = 0.90
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/mask/clown_hat
	name = "Clown wig and mask"
	desc = "You're gay for even considering wearing this."
	icon_state = "clown"
	item_state = "clown"

/obj/item/clothing/mask/mime
	name = "Mime mask"
	icon_state = "mime"
	item_state = "mime"

/obj/item/clothing/mask/medical
	name = "Medical mask"
	desc = "This mask does not work very well in low pressure environments."
	icon_state = "medical"
	item_state = "medical"
	flags = FPRINT | MASKCOVERSMOUTH | MASKINTERNALS
	w_class = 3
	protective_temperature = 420
	gas_transfer_coefficient = 0.10

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


/obj/item/clothing/mask/cigarette
	name = "Cigarette"
	icon_state = "cigoff"
	var/lit = 0
	throw_speed = 0.5
	item_state = "cigoff"
	var/lastHolder = null
	var/smoketime = 300
	w_class = 1

// OMG SHOES

/obj/item/clothing/shoes
	name = "Shoes"
	icon = 'shoes.dmi'
	var/chained = 0

	body_parts_covered = FEET
	flags = FPRINT | TABLEPASS

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/shoes/black
	name = "Black shoes"
	icon_state = "black"
	item_state = "bl_shoes"

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/magnetic
	name = "Magboots"
	icon_state = "magboots"
	item_state = "o_shoes"

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/brown
	name = "Brown Shoes"
	icon_state = "brown"
	item_state = "b_shoes"

/obj/item/clothing/shoes/orange
	name = "Orange Shoes"
	icon_state = "orange"
	item_state = "o_shoes"

/obj/item/clothing/shoes/blue
	name = "Blue Shoes"
	icon_state = "blue"
	item_state = "bl_shoes"

/obj/item/clothing/shoes/green
	name = "Green Shoes"
	icon_state = "green"
	item_state = "bl_shoes"

/obj/item/clothing/shoes/swat
	name = "SWAT shoes"
	icon_state = "swat"
	item_state = "bl_shoes"

/obj/item/clothing/shoes/boots
	name = "Black boots"
	icon_state = "boots"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.01
	permeability_coefficient = 0.25

/obj/item/clothing/shoes/jackboots
	name = "Jackboots"
	desc = "heavy duty protective boots"
	icon_state = "jackboots"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.01
	permeability_coefficient = 0.25

/obj/item/clothing/shoes/white
	name = "White Shoes"
	icon_state = "white"
	permeability_coefficient = 0.25

/obj/item/clothing/shoes/sandal
	name = "Sandals"
	icon_state = "wizard"

/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots"
	name = "Galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05

/obj/item/clothing/shoes/clown_shoes
	desc = "Damn, thems some big shoes."
	name = "Clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"

// SUITS

/obj/item/clothing/suit
	icon = 'suits.dmi'
	name = "Suit"
	var/fire_resist = T0C+100
	flags = FPRINT | TABLEPASS
	var/airflowprot = 0

/obj/item/clothing/suit/rig
	name = "Rig Suit"
	desc = "Rig"
	icon_state = "rig"
	item_state = "rig"
	flags = FPRINT|TABLEPASS|PLASMAGUARD
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02
	gas_transfer_coefficient = 0.01
	airflowprot = 1

/obj/item/clothing/suit/bio_suit
	name = "Bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio_suit"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.30

	flags = FPRINT|TABLEPASS|PLASMAGUARD

/obj/item/clothing/suit/storage
    name = "Storage"

/obj/item/clothing/suit/storage/det_suit
	name = "Coat"
	desc = "Someone who wears this means business"
	icon_state = "detective"
	item_state = "det_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/judgerobe
	name = "Judge's robe"
	desc = "This robe commands authority"
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/labcoat
	name = "Labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75

/obj/item/clothing/suit/storage/labcoat/gen
	name = "Genetic's labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_gen"
	item_state = "labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75

/obj/item/clothing/suit/storage/labcoat/chem
	name = "Chemical's labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_chem"
	item_state = "labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75

/obj/item/clothing/suit/storage/labcoat/tox
	name = "Scienist's labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_tox"
	item_state = "labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75

/obj/item/clothing/suit/storage/chef
	name = "Chef coat"
	desc = "A fancy chef's coat."
	icon_state = "chef"
	item_state = "chef"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/chaplain_hoodie
	name = "Chaplain hoodie"
	desc = "A black hoodie."
	icon_state = "chaplain_hoodie"
	item_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/apron
	name = "Apron"
	desc = "A simple blue apron. It has a big pocket on the front you could store something in."
	icon_state = "apron"
	item_state = "apron"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/chicken
	name = "Chiken suit"
	desc = "A chicken suit."
	icon_state = "chickensuit"
	item_state = "chickensuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|FEET

/obj/item/clothing/suit/storage/holydaypriest
	name = "Holidaypriest robe"
	desc = "A white robe."
	icon_state = "holidaypriest"
	item_state = "w_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/captunic
	name = "Captain tunic"
	desc = "A captain tunic."
	icon_state = "captunic"
	item_state = "w_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/hazard
	name = "Hazard west"
	desc = "A orange west."
	icon_state = "hazard"
	item_state = "orangebook"
	permeability_coefficient = 0.50
	protective_temperature = 300
	siemens_coefficient = 0.30
	heat_transfer_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO


/obj/item/clothing/suit/straight_jacket
	name = "Straight jacket"
	desc = "A suit that totally restrains an individual"
	icon_state = "straightjacket"
	item_state = "straightjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/wcoat
	name = "Waistcoat"
	icon_state = "vest"
	item_state = "wcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/hos
	name = "HoS coat"
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/warden_jacket
	name = "Warden jacket"
	icon_state = "warden_jacket"
	item_state = "r_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/wizrobe
	name = "Robe"
	desc = "A magnificent blue robe that seems to radiate power"
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

// ARMOR

/obj/item/clothing/suit/armor/vest
	name = "Armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/storage/gearharness
	name = "Gear harness"
	desc = "A simple security harness, used for storing small objects"
	icon_state = "gearharness"
	item_state = "gearharness"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/storage/armourrigvest
	name = "Armour rig vest"
	desc = "An important looking armoured vest, outfitted with pockets."
	icon_state = "armourrigvest"
	item_state = "armourrigvest"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
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
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	icon_state = "caparmor"
	item_state = "caparmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/captain_b
	name = "Captain's armor"
	icon_state = "caparmor_b"
	item_state = "caparmor_b"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/heavy
	name = "Heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

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
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/riot
	name = "Riot suit"
	desc = "Heavy segmented armor designed to help control rioters."
	icon_state = "riotsuit"
	item_state = "riotsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

// FIRE SUITS

/obj/item/clothing/suit/fire
	name = "Firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "fire"
	item_state = "fire"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

	protective_temperature = 4500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/suit/fire/heavy
	name = "Firesuit"
	desc = "A suit that protects against extreme fire and heat."
	icon_state = "thermal"
	item_state = "ro_suit"

	protective_temperature = 10000
	heat_transfer_coefficient = 0.01

// SPACE SUITS

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments."
	icon_state = "space"
	gas_transfer_coefficient = 0.01
	item_state = "s_suit"
	flags = FPRINT | TABLEPASS | SUITSPACE | PLASMAGUARD
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02


/obj/item/clothing/suit/space/syndicate
	name = "Red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"

// UNDERS AND BY THAT, NATURALLY I MEAN UNIFORMS/JUMPSUITS

/obj/item/clothing/under
	icon = 'uniforms.dmi'
	name = "Under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	protective_temperature = T0C + 50
	heat_transfer_coefficient = 0.30
	permeability_coefficient = 0.90
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

// Colors

/obj/item/clothing/under/chameleon
//starts off as black
	name = "Chameleon Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	color = "black"
	desc = null
	var/list/clothing_choices = list()

/obj/item/clothing/under/chameleon/all

/obj/item/clothing/under/color/black
	name = "Black Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	color = "black"

/obj/item/clothing/under/color/blue
	name = "Blue Jumpsuit"
	icon_state = "blue"
	item_state = "b_suit"
	color = "blue"

/obj/item/clothing/under/color/green
	name = "Green Jumpsuit"
	icon_state = "green"
	item_state = "g_suit"
	color = "green"

/obj/item/clothing/under/color/grey
	name = "Grey Jumpsuit"
	icon_state = "grey"
	item_state = "gy_suit"
	color = "grey"

/obj/item/clothing/under/color/orange
	name = "Orange Jumpsuit"
	icon_state = "orange"
	item_state = "o_suit"
	color = "orange"

/obj/item/clothing/under/color/pink
	name = "Pink Jumpsuit (F)"
	icon_state = "pink"
	item_state = "p_suit"
	color = "pink"

/obj/item/clothing/under/color/red
	name = "Red Jumpsuit"
	icon_state = "red"
	item_state = "r_suit"
	color = "red"

/obj/item/clothing/under/color/white
	desc = "Made of a special fiber that gives special protection against biohazards."
	name = "White Jumpsuit"
	icon_state = "white"
	item_state = "w_suit"
	color = "white"
	permeability_coefficient = 0.50

/obj/item/clothing/under/color/yellow
	name = "Yellow Jumpsuit"
	icon_state = "yellow"
	item_state = "y_suit"
	color = "yellow"

// RANKS

/obj/item/clothing/under/rank/atmospheric_technician
	desc = "It has an Atmospherics rank stripe on it."
	name = "Atmospherics Jumpsuit"
	icon_state = "atmos"
	item_state = "atmos_suit"
	color = "atmos"

/obj/item/clothing/under/rank/captain
	desc = "It has a Captains rank stripe on it."
	name = "Captain Jumpsuit"
	icon_state = "captain"
	item_state = "dg_suit"
	color = "captain"

/obj/item/clothing/under/rank/counselor
	desc = "It has a Counselor rank stripe on it."
	name = "Counselor Jumpsuit"
	icon_state = "counselor"
	item_state = "bl_suit"
	color = "counselor"

/obj/item/clothing/under/rank/chemist
	desc = "Made of a special fiber that gives protection against biohazards. Has a Chemist rank stripe on it."
	name = "Chemistry Jumpsuit"
	icon_state = "chemistry"
	item_state = "w_suit"
	color = "chemistry"
	permeability_coefficient = 0.40

/obj/item/clothing/under/rank/engineer
	desc = "It has an Engineering rank stripe on it."
	name = "Engineering Jumpsuit"
	icon_state = "engine"
	item_state = "engi_suit"
	color = "engine"

/obj/item/clothing/under/rank/forensic_technician
	desc = "It has a Forensics rank stripe on it."
	name = "Forensics Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	color = "forensicsred"

/obj/item/clothing/under/rank/geneticist
	desc = "Made of a special fiber that gives protection against biohazards. Has a genetics rank stripe on it."
	name = "Genetics Jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	color = "geneticswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It has a Head of Personnel rank stripe on it."
	name = "Head of Personnel Jumpsuit"
	icon_state = "hop"
	item_state = "b_suit"
	color = "hopblue"

/obj/item/clothing/under/rank/head_of_security
	desc = "It has a Head of Security rank stripe on it."
	name = "Head of Security Jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	color = "hosred"

/obj/item/clothing/under/rank/warden
	desc = "It has a Warden rank stripe on it."
	name = "Warden Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	color = "darkred"

/obj/item/clothing/under/rank/chief_engineer
	desc = "It has a Chief Engineer rank stripe on it."
	name = "Chief Engineer Jumpsuit"
	icon_state = "chiefengineer"
	item_state = "gy_suit"
	color = "chief"

/obj/item/clothing/under/rank/research_director
	desc = "It has a Research Director rank stripe on it."
	name = "Research Director Jumpsuit"
	icon_state = "director"
	item_state = "lb_suit"
	color = "director"

/obj/item/clothing/under/rank/janitor
	desc = "The janitorial crew jumpsuit."
	name = "Janitor's Jumpsuit"
	icon_state = "janitor"
	item_state = "janitor"
	color = "janitor"

/obj/item/clothing/under/rank/scientist
	desc = "Made of a special fiber that gives special protection against biohazards. Has a toxins rank stripe on it."
	name = "Scientist's Jumpsuit"
	icon_state = "toxins"
	item_state = "w_suit"
	color = "toxinswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/medical
	desc = "Made of a special fiber that gives special protection against biohazards. Has a medical rank stripe on it."
	name = "Medical Doctor's Jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	color = "medical"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/hydroponics
	desc = "Made of a special fiber that gives special protection against biohazards. Has a Hydroponics rank stripe on it."
	name = "Hydroponics Jumpsuit"
	icon_state = "hydroponics"
	item_state = "g_suit"
	color = "hydroponics"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/roboticist
	desc = "Made of a special fiber that gives protection against electrocution. Has a Robotics rank stripe on it."
	name = "Robotics Jumpsuit"
	icon_state = "robotics"
	item_state = "bl_suit"
	color = "robotics"
	siemens_coefficient = 0.50

/obj/item/clothing/under/rank/qm
	name = "Quartermaster's Jumpsuit"
	desc = "What can brown do for you?"
	icon_state = "qm"
	item_state = "lb_suit"
	color = "qm"

/obj/item/clothing/under/rank/cargo
	name = "Cargo's Jumpsuit"
	desc = "What can brown do for you?"
	icon_state = "cargo"
	item_state = "lb_suit"
	color = "cargo"

/obj/item/clothing/under/rank/miner
	name = "Miner's Jumpsuit"
	desc = "What can brown do for you?"
	icon_state = "miner"
	item_state = "lb_suit"
	color = "miner"

// OTHER NONRANKED STATION JOBS

/obj/item/clothing/under/bartender
	desc = "It looks like it could use more flair."
	name = "Bartender's Uniform"
	icon_state = "ba_suit"
	item_state = "ba_suit"
	color = "ba_suit"

/obj/item/clothing/under/clown
	name = "Clown suit"
	desc = "Wearing this, all the children love you, for all the wrong reasons."
	icon_state = "clown"
	item_state = "clown"
	color = "clown"

/obj/item/clothing/under/mime
	name = "Mime suit"
	icon_state = "mime"
	item_state = "mime_suit"
	color = "mime"

/obj/item/clothing/under/chef
	desc = "Issued only to the most hardcore chefs in space."
	name = "Chef's Uniform"
	icon_state = "chef"
	color = "chef"

/obj/item/clothing/under/det
	name = "Hard worn suit"
	desc = "Someone who wears this means business"
	icon_state = "detective"
	item_state = "det"
	color = "detective"

/obj/item/clothing/under/ftech
	name = "Forensic technician jumpsuit"
	desc = "A variant of the security outfit, for forensic techs."
	icon_state = "forensicsred"
	item_state = "r_suit"
	color = "forensicsred"

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "Lawyer suit"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/lawyer/black
	icon_state = "lawyer_black"
	item_state = "lawyer_black"
	color = "lawyer_black"

/obj/item/clothing/under/lawyer/red
	icon_state = "lawyer_red"
	item_state = "lawyer_red"
	color = "lawyer_red"

/obj/item/clothing/under/lawyer/blue
	icon_state = "lawyer_blue"
	item_state = "lawyer_blue"
	color = "lawyer_blue"


/obj/item/clothing/under/sl_suit
	desc = "A very amish looking suit"
	name = "Amish Suit"
	icon_state = "sl_suit"
	color = "sl_suit"


/obj/item/clothing/under/syndicate
	name = "Tactical Turtleneck"
	desc = "Non-descript, slightly suspicious civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"
	color = "syndicate"


// Athletic shorts.. heh
/obj/item/clothing/under/shorts
	name = "Athletic shorts"
	desc = "95% Polyester, 5% Spandex!"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/shorts/red
	icon_state = "redshorts"
	color = "redshorts"

/obj/item/clothing/under/shorts/green
	icon_state = "greenshorts"
	color = "greenshorts"

/obj/item/clothing/under/shorts/blue
	icon_state = "blueshorts"
	color = "blueshorts"

/obj/item/clothing/under/shorts/black
	icon_state = "blackshorts"
	color = "blackshorts"

/obj/item/clothing/under/shorts/grey
	icon_state = "greyshorts"
	color = "greyshorts"