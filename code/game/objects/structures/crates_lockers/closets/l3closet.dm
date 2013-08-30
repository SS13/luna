/*obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/bio_suit/general( src )
	new /obj/item/clothing/head/bio_hood/general( src )


/obj/structure/closet/l3closet/general
	icon_state = "bio_general"
	icon_closed = "bio_general"
	icon_opened = "bio_generalopen"

/obj/structure/closet/l3closet/general/New()
	..()
	sleep(2)
	contents = list()
	new /obj/item/clothing/suit/bio_suit/general( src )
	new /obj/item/clothing/head/bio_hood/general( src )


/obj/structure/closet/l3closet/virology
	icon_state = "bio_virology"
	icon_closed = "bio_virology"
	icon_opened = "bio_virologyopen"

/obj/structure/closet/l3closet/virology/New()
	..()
	sleep(2)
	contents = list()
	new /obj/item/clothing/suit/bio_suit/virology( src )
	new /obj/item/clothing/head/bio_hood/virology( src )


/obj/structure/closet/l3closet/security
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

/obj/structure/closet/l3closet/security/New()
	..()
	sleep(2)
	contents = list()
	new /obj/item/clothing/suit/bio_suit/security( src )
	new /obj/item/clothing/head/bio_hood/security( src )


/obj/structure/closet/l3closet/janitor
	icon_state = "bio_janitor"
	icon_closed = "bio_janitor"
	icon_opened = "bio_janitoropen"

/obj/structure/closet/l3closet/janitor/New()
	..()
	sleep(2)
	contents = list()
	new /obj/item/clothing/suit/bio_suit/janitor( src )
	new /obj/item/clothing/head/bio_hood/janitor( src )


/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

/obj/structure/closet/l3closet/scientist/New()
	..()
	sleep(2)
	contents = list()
	new /obj/item/clothing/suit/bio_suit/scientist( src )
	new /obj/item/clothing/head/bio_hood/scientist( src )*/


/obj/structure/closet/l3closet
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	name = "Level 3 Biohazard Suit"
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/sci/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/bio_suit( src )
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/head/bio_hood( src )
	new /obj/item/clothing/gloves/latex( src )


/obj/structure/closet/l3closet/jan
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	name = "Level 3 Janitor Biohazard Suit"
	icon_state = "bio_janitor"
	icon_closed = "bio_janitor"
	icon_opened = "bio_janitoropen"

/obj/structure/closet/l3closet/jan/New()
	..()
	sleep(2)
	new /obj/item/clothing/head/bio_hood/janitor( src )
	new /obj/item/clothing/suit/bio_suit/janitor( src )
	new /obj/item/clothing/gloves/latex( src )


/obj/structure/closet/l3closet/sec
	desc = "A bulky (yet mobile) closet. Comes prestocked with level 3 biohazard gear for emergencies."
	name = "Level 3 Security Biohazard Suit"
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

/obj/structure/closet/l3closet/sec/New()
    ..()
    sleep(2)
    new /obj/item/clothing/head/bio_hood/fred(src)
    new /obj/item/clothing/suit/bio_suit/fred(src)
    new /obj/item/clothing/gloves/latex( src )
    new /obj/item/clothing/shoes/orange( src )
    new /obj/item/clothing/under/color/white( src )