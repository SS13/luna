/obj/structure/closet/wardrobe
	desc = "A bulky (yet mobile) wardrobe closet. Comes prestocked with 6 changes of clothes."
	name = "wardrobe"
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/regular/New()
	..()
	new /obj/item/clothing/under/color/blue( src )
	new /obj/item/clothing/under/color/blue( src )
	new /obj/item/clothing/under/color/blue( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	return


/obj/structure/closet/wardrobe/red
	name = "red wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/red/New()
	..()
	new /obj/item/clothing/under/color/red( src )
	new /obj/item/clothing/under/color/red( src )
	new /obj/item/clothing/under/color/red( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	return


/obj/structure/closet/wardrobe/forensics_red
	name = "forensics wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/forensics_red/New()
	..()
	new /obj/item/clothing/under/rank/forensic_technician( src )
	new /obj/item/clothing/under/rank/forensic_technician( src )
	new /obj/item/clothing/under/rank/forensic_technician( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	return


/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

/obj/structure/closet/wardrobe/pink/New()
	..()
	new /obj/item/clothing/under/color/pink( src )
	new /obj/item/clothing/under/color/pink( src )
	new /obj/item/clothing/under/color/pink( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	return


/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/black/New()
	..()
	new /obj/item/clothing/under/color/black( src )
	new /obj/item/clothing/under/color/black( src )
	new /obj/item/clothing/under/color/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	return


/obj/structure/closet/wardrobe/chaplain_black
	icon_state = "closed"
	icon_closed = "closed"
	icon_opened = "open"

/obj/structure/closet/wardrobe/chaplain_black/New()
	..()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/suit/storage/chaplain_hoodie/holyday(src)
	new /obj/item/clothing/head/chaplain_hood/nun(src)
	new /obj/item/clothing/suit/storage/chaplain_hoodie(src)
	new /obj/item/clothing/head/chaplain_hood(src)
	return


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/green/New()
	..()
	new /obj/item/clothing/under/color/green( src )
	new /obj/item/clothing/under/color/green( src )
	new /obj/item/clothing/under/color/green( src )
	new /obj/item/clothing/shoes/green( src )
	new /obj/item/clothing/shoes/green( src )
	new /obj/item/clothing/shoes/green( src )
	return


/obj/structure/closet/wardrobe/orange
	name = "prisoners wardrobe"
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/wardrobe/orange/New()
	..()
	new /obj/item/clothing/under/color/orange( src )
	new /obj/item/clothing/under/color/orange( src )
	new /obj/item/clothing/under/color/orange( src )
	new /obj/item/clothing/shoes/orange( src )
	new /obj/item/clothing/shoes/orange( src )
	new /obj/item/clothing/shoes/orange( src )
	return


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/yellow/New()
	..()
	new /obj/item/clothing/under/color/yellow( src )
	new /obj/item/clothing/under/color/yellow( src )
	new /obj/item/clothing/under/color/yellow( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	return


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow/New()
	..()
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	return


/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/New()
	..()
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	return


/obj/structure/closet/wardrobe/quartermasters
	name = "quartermasters wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/quartermasters/New()
	..()
	new /obj/item/clothing/under/rank/cargotech ( src )
	new /obj/item/clothing/under/rank/cargotech ( src )
	new /obj/item/clothing/under/rank/cargotech ( src )
	new /obj/item/clothing/under/rank/cargotech ( src )
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/clothing/gloves/black ( src )
	new /obj/item/weapon/hand_labeler ( src )
	new /obj/item/clothing/shoes/black ( src )
	new /obj/item/clothing/shoes/black ( src )
	new /obj/item/clothing/shoes/black ( src )
	new /obj/item/clothing/shoes/black ( src )
	return


/obj/structure/closet/wardrobe/white
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/white/New() // Medical wardrobe
	..()
	new /obj/item/clothing/under/rank/medical( src )
	new /obj/item/clothing/under/rank/medical( src )
	new /obj/item/clothing/under/rank/medical( src )
	new /obj/item/clothing/under/rank/medical( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/weapon/storage/box/stma( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/device/radio/headset/headset_med(src)
	new /obj/item/device/radio/headset/headset_med(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/chemistry_white/New()
	..()
	new /obj/item/clothing/under/rank/chemist( src )
	new /obj/item/clothing/under/rank/chemist( src )
	new /obj/item/clothing/under/rank/chemist( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/weapon/storage/box/stma( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	return


/obj/structure/closet/wardrobe/toxins_white
	name = "toxins wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/toxins_white/New()
	..()
	new /obj/item/clothing/under/rank/scientist( src )
	new /obj/item/clothing/under/rank/scientist( src )
	new /obj/item/clothing/under/rank/scientist( src )
	new /obj/item/clothing/under/rank/scientist( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/weapon/storage/box/stma( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	return


/obj/structure/closet/wardrobe/robotics_white
	name = "robotics wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/robotics_white/New()
	..()
	new /obj/item/clothing/under/rank/roboticist( src )
	new /obj/item/clothing/under/rank/roboticist( src )
	new /obj/item/clothing/under/rank/roboticist( src )
	new /obj/item/clothing/under/rank/roboticist( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/weapon/storage/box/stma( src )
	new /obj/item/weapon/storage/box/lglo( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white/New()
	..()
	new /obj/item/clothing/under/rank/geneticist( src )
	new /obj/item/clothing/under/rank/geneticist( src )
	new /obj/item/clothing/under/rank/geneticist( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/clothing/shoes/white( src )
	new /obj/item/weapon/storage/box/stma( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/device/radio/headset/headset_medsci(src)
	return


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/grey/New()
	..()
	new /obj/item/clothing/under/color/grey( src )
	new /obj/item/clothing/under/color/grey( src )
	new /obj/item/clothing/under/color/grey( src )
	new /obj/item/clothing/under/color/grey( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	return


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/mixed/New()
	..()
	new /obj/item/clothing/under/color/blue( src )
	new /obj/item/clothing/under/color/blue( src )
	new /obj/item/clothing/under/color/pink( src )
	new /obj/item/clothing/under/color/pink( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/shoes/brown( src )
	return


/obj/structure/closet/wardrobe/bar
	name = "bar wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/bar/New()
	..()
	new /obj/item/clothing/under/rank/bartender( src )
	new /obj/item/clothing/under/rank/bartender( src )
	new /obj/item/clothing/head/that( src )
	new /obj/item/clothing/head/that( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/device/pda/bar( src )
	new /obj/item/device/pda/bar( src )
	return


/obj/structure/closet/wardrobe/hydroponics
	name = "hydroponics wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/hydroponics/New()
	..()
	new /obj/item/clothing/under/rank/hydroponics( src )
	new /obj/item/clothing/under/rank/hydroponics( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/weapon/storage/box/lglo( src )
	return


/obj/structure/closet/lawcloset/New()
	..()
	new /obj/item/clothing/under/lawyer/black( src )
	new /obj/item/clothing/under/lawyer/red ( src )
	new /obj/item/clothing/under/lawyer/blue ( src )
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/weapon/storage/briefcase(src)
	new /obj/item/weapon/storage/briefcase(src)
	return