/*obj/structure/closet/portal
	desc = "It's a closet!"
	name = "Closet"
	icon = 'closet.dmi'
	icon_state = "closed"
	density = 1
	anchored = 1
	var/id
	var/t_id
	var/locked = 1
	var/turf/target = null
	var/obj/structure/closet/portal/link = null
	req_access = list(access_captain)
	flags = FPRINT*/


/obj/spresent
	desc = "It's a ... present?"
	name = "strange present"
	icon = 'items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

/obj/structure/closet/gmcloset
	desc = "A bulky (yet mobile) closet. Comes with formal clothes"
	name = "Formal closet"

/obj/structure/closet/jcloset
	desc = "A bulky (yet mobile) closet. Comes with janitor's clothes and biohazard gear."
	name = "Custodial Closet"

/obj/structure/closet/lawcloset
	desc = "A bulky (yet mobile) closet. Comes with lawyer apparel and items."
	name = "Legal Closet"

/obj/structure/closet/coffin
	desc = "A burial receptacle for the dearly departed."
	name = "coffin"
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"

/obj/structure/closet/syndicate
	desc = "Syndicate preparations closet."
	name = "Weapons Closet"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/toolcloset
	desc = "Tools closet."
	name = "Tools Closet"
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/thunderdome
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	desc = "Thunderdome closet."
	anchored = 1

/obj/structure/closet/thunderdome/tdred
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	desc = "Thunderdome closet."

/obj/structure/closet/thunderdome/tdgreen
	desc = "Everything you need!"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	desc = "Thunderdome closet."

/obj/structure/closet/malf/suits
	desc = "Gear preperations closet."
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/wardrobe
	desc = "A bulky (yet mobile) wardrobe closet. Comes prestocked with 6 changes of clothes."
	name = "Wardrobe"
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/black
	name = "Black Wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/Counselor_black
	name = "Counselor Wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/green
	name = "Green Wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/mixed
	name = "Mixed Wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/orange
	name = "Prisoners Wardrobe"
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/wardrobe/pink
	name = "Pink Wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

/obj/structure/closet/wardrobe/quartermasters
	name = "Quartermasters Wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/red
	name = "Red Wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/forensics_red
	name = "Forensics Wardrobe"
	icon_state = "red"
	icon_closed = "red"


/obj/structure/closet/wardrobe/white
	name = "Medical Wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/chemistry_white
	name = "Chemistry Wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/toxins_white
	name = "Toxins Wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/robotics_white
	name = "Robotics Wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white
	name = "Genetics Wardrobe"
	icon_state = "white"
	icon_closed = "white"


/obj/structure/closet/wardrobe/yellow
	name = "Yellow Wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow
	name = "Engineering Wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "Atmospherics Wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/hydroponics
	name = "Hydroponics Wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/grey
	name = "Grey Wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/bar
	name = "Bar Wardrobe"
	icon_state = "black"
	icon_closed = "black"