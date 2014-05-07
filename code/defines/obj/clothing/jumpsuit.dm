// UNDERS AND BY THAT, NATURALLY I MEAN UNIFORMS/JUMPSUITS

/obj/item/clothing/under
	icon = 'uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	protective_temperature = T0C + 50
	heat_transfer_coefficient = 0.30
	permeability_coefficient = 0.90
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/

// colours

/obj/item/clothing/under/chameleon
//starts off as black
	name = "Black Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	colour = "black"
	desc = null
	var/list/clothing_choices = list()

/obj/item/clothing/under/chameleon/all

/obj/item/clothing/under/color/black
	name = "Black Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	colour = "black"

/obj/item/clothing/under/color/blue
	name = "Blue Jumpsuit"
	icon_state = "blue"
	item_state = "b_suit"
	colour = "blue"

/obj/item/clothing/under/color/green
	name = "Green Jumpsuit"
	icon_state = "green"
	item_state = "g_suit"
	colour = "green"

/obj/item/clothing/under/color/grey
	name = "Grey Jumpsuit"
	icon_state = "grey"
	item_state = "gy_suit"
	colour = "grey"

/obj/item/clothing/under/color/orange
	name = "Orange Jumpsuit"
	icon_state = "orange"
	item_state = "o_suit"
	colour = "orange"

/obj/item/clothing/under/color/pink
	name = "Pink Jumpsuit"
	icon_state = "pink"
	item_state = "p_suit"
	colour = "pink"

/obj/item/clothing/under/color/red
	name = "Red Jumpsuit"
	icon_state = "red"
	item_state = "r_suit"
	colour = "red"

/obj/item/clothing/under/color/white
	desc = "Made of a special fiber that gives special protection against biohazards."
	name = "White Jumpsuit"
	icon_state = "white"
	item_state = "w_suit"
	colour = "white"
	permeability_coefficient = 0.50

/obj/item/clothing/under/color/yellow
	name = "Yellow Jumpsuit"
	icon_state = "yellow"
	item_state = "y_suit"
	colour = "yellow"

// RANKS
/obj/item/clothing/under/rank



/obj/item/clothing/under/rank/atmospheric_technician
	desc = "It has an Atmospherics rank stripe on it."
	name = "Atmospherics Jumpsuit"
	icon_state = "atmos"
	item_state = "y_suit"
	colour = "atmos"

/obj/item/clothing/under/rank/captain
	desc = "It has a Captains rank stripe on it."
	name = "Captain Jumpsuit"
	icon_state = "captain"
	item_state = "caparmor"
	colour = "captain"

/obj/item/clothing/under/rank/chaplain
	desc = "It has a Chaplain rank stripe on it."
	name = "Chaplain Jumpsuit"
	icon_state = "chaplain"
	item_state = "bl_suit"
	colour = "chapblack"

/obj/item/clothing/under/rank/engineer
	desc = "It has an Engineering rank stripe on it."
	name = "Engineering Jumpsuit"
	icon_state = "engine"
	item_state = "y_suit"
	colour = "engine"

/obj/item/clothing/under/rank/forensic_technician
	desc = "It has a Forensics rank stripe on it."
	name = "Forensics Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	colour = "forensicsred"

/obj/item/clothing/under/rank/warden
	desc = "It has a Warden rank stripe on it."
	name = "Warden Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	colour = "darkred"

/obj/item/clothing/under/rank/geneticist
	desc = "Made of a special fiber that gives special protection against biohazards. Has a genetics rank stripe on it."
	name = "Genetics Jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	colour = "geneticswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/chemist
	desc = "Made of a special fiber that gives special protection against biohazards. Has a chemist rank stripe on it."
	name = "Chemist Jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	colour = "geneticswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It has a Head of Personnel rank stripe on it."
	name = "Head of Personnel Jumpsuit"
	icon_state = "hop"
	item_state = "b_suit"
	colour = "hop"

/obj/item/clothing/under/rank/centcom_officer
	desc = "It has a CentCom officer rank stripe on it."
	name = "CentCom Officer Jumpsuit"
	icon_state = "officer"
	item_state = "g_suit"
	colour = "officer"

/obj/item/clothing/under/rank/centcom_commander
	desc = "It has a CentCom commander rank stripe on it."
	name = "CentCom Officer Jumpsuit"
	icon_state = "centcom"
	item_state = "dg_suit"
	colour = "centcom"

/obj/item/clothing/under/rank/miner
	desc = "A snappy jumpsuit with a sturdy set of overalls. It is very dirty. It has a shaft miner rank stripe on it."
	name = "Shaft Miner Jumpsuit"
	icon_state = "miner"
	item_state = "miner"
	colour = "miner"

/obj/item/clothing/under/rank/roboticist
	desc = "A slimming black with reinforced seams. Great for industrial work."
	name = "Roboticist Jumpsuit"
	icon_state = "robotics"
	item_state = "robotics"
	colour = "robotics"

/obj/item/clothing/under/rank/head_of_security
	desc = "It has a Head of Security rank stripe on it."
	name = "Head of Security Jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	colour = "hosred"

/obj/item/clothing/under/rank/chief_engineer
	desc = "It has a Chief Engineer rank stripe on it."
	name = "Chief Engineer Jumpsuit"
	icon_state = "chiefengineer"
	item_state = "g_suit"
	colour = "chief"

/obj/item/clothing/under/rank/research_director
	desc = "It has a Research Director rank stripe on it."
	name = "Research Director Jumpsuit"
	icon_state = "director"
	item_state = "g_suit"
	colour = "director"

/obj/item/clothing/under/rank/janitor
	desc = "Official clothing of the station's poopscooper. It has a janitor rank stripe on it"
	name = "Janitor's Jumpsuit"
	icon_state = "janitor"
	colour = "janitor"

/obj/item/clothing/under/rank/scientist
	desc = "Made of a special fiber that gives special protection against biohazards. Has a toxins rank stripe on it."
	name = "Scientist's Jumpsuit"
	icon_state = "toxins"
	item_state = "w_suit"
	colour = "toxinswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/medical
	desc = "Made of a special fiber that gives special protection against biohazards. It has a medical rank stripe on it."
	name = "Medical Doctor's Jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	colour = "medical"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/chief_medical_officer
	desc = "Made of a special fiber that gives special protection against biohazards. Has a Chief Medical Officer rank stripe on it."
	name = "Chief Medical Officer's Jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	colour = "medical"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/hydroponics
	desc = "Made of a special fiber that gives special protection against biohazards. Has a Hydroponics rank stripe on it."
	name = "Hydroponics Jumpsuit"
	icon_state = "hydroponics"
	item_state = "g_suit"
	colour = "hydroponics"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/cargo
	name = "Quartermaster's Jumpsuit"
	desc = "What can brown do for you?"
	icon_state = "lightbrown"
	item_state = "lb_suit"
	colour = "cargo"

/obj/item/clothing/under/rank/bartender
	desc = "It looks like it could use more flair."
	name = "Bartender's Uniform"
	icon_state = "ba_suit"
	item_state = "ba_suit"
	colour = "ba_suit"

/obj/item/clothing/under/rank/clown
	name = "clown suit"
	desc = "Wearing this, all the children love you, for all the wrong reasons."
	icon_state = "clown"
	colour = "clown"

/obj/item/clothing/under/rank/chef
	desc = "Issued only to the most hardcore chefs in space."
	name = "Chef's Uniform"
	icon_state = "chef"
	colour = "chef"

// OTHER NONRANKED STATION JOBS
/obj/item/clothing/under/det
	name = "Hard worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	colour = "detective"

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "Lawyer suit"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/lawyer/black
	icon_state = "lawyer_black"
	item_state = "lawyer_black"
	colour = "lawyer_black"

/obj/item/clothing/under/lawyer/red
	icon_state = "lawyer_red"
	item_state = "lawyer_red"
	colour = "lawyer_red"

/obj/item/clothing/under/lawyer/blue
	icon_state = "lawyer_blue"
	item_state = "lawyer_blue"
	colour = "lawyer_blue"


/obj/item/clothing/under/sl_suit
	desc = "A very amish looking suit."
	name = "Amish Suit"
	icon_state = "sl_suit"
	colour = "sl_suit"

/obj/item/clothing/under/syndicate
	name = "Tactical Turtleneck"
	desc = "Non-descript, slightly suspicious civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"
	colour = "syndicate"
	has_sensor = 0

/obj/item/clothing/under/syndicate/tacticool
	name = "Tacticool Turtleneck"
	desc = "Wearing this makes you feel like buying an SKS, going into the woods, and operating."
	icon_state = "tactifool"
	item_state = "bl_suit"
	colour = "tactifool"

/obj/item/clothing/under/librarian
	name = "Sensible Suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	item_state = "red_suit"
	colour = "red_suit"

/obj/item/clothing/under/mime
	name = "Mime Outfit"
	desc = "It's not very colourful."
	icon_state = "mime"
	item_state = "mime"
	colour = "mime"

/obj/item/clothing/under/waiter
	name = "Waiter Outfit"
	desc = "There is a special pocket for tip."
	icon_state = "waiter"
	item_state = "waiter"
	colour = "waiter"


// Athletic shorts.. heh
/obj/item/clothing/under/shorts
	name = "athletic shorts"
	desc = "95% Polyester, 5% Spandex!"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/shorts/red
	icon_state = "redshorts"
	colour = "redshorts"

/obj/item/clothing/under/shorts/green
	icon_state = "greenshorts"
	colour = "greenshorts"

/obj/item/clothing/under/shorts/blue
	icon_state = "blueshorts"
	colour = "blueshorts"

/obj/item/clothing/under/shorts/black
	icon_state = "blackshorts"
	colour = "blackshorts"

/obj/item/clothing/under/shorts/grey
	icon_state = "greyshorts"
	colour = "greyshorts"

/obj/item/clothing/under/space
	name = "NASA Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	colour = "black"
	desc = "Has a NASA logo on it, made of space proofed materials."
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	heat_transfer_coefficient = 0.02
	radiation_protection = 0.25
	protective_temperature = 1000
	flags = FPRINT | TABLEPASS | SUITSPACE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS