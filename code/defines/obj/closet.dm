/obj/structure/closet/portal
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
	flags = FPRINT


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

/obj/structure/closet/wardrobe/BlackAdvanced
	name = "Black Wardrobe"
	icon_state = "black"
	icon_closed = "black"


/obj/secure_closet
	desc = "An immobile card-locked storage closet."
	name = "Security Locker"
	icon = 'closet.dmi'
	icon_state = "secure1"
	density = 1
	var/opened = 0
	var/locked = 1
	var/bang_time = 0
	var/broken = 0
	var/large = 1
	var/icon_closed = "secure"
	var/icon_locked = "secure1"
	var/icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"

/obj/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(access_heads)

/obj/secure_closet/animal
	name = "Animal Control"
	req_access = list(access_medical)

/obj/secure_closet/brig
	name = "Brig Locker"
	req_access = list(access_brig)
	var/id = null

/obj/secure_closet/highsec
	name = "Head of Personnel's Closet"
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"
	req_access = list(access_heads)

/obj/secure_closet/hos
	name = "Head Of Security's Closet"
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	req_access = list(access_heads)

/obj/secure_closet/warden
	name = "Warden's Closet"
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"
	req_access = list(access_armory)

/obj/secure_closet/rd
	name = "Research Director's Closet"
	icon_state = "rdsecure1"
	icon_closed = "rdsecure"
	icon_locked = "rdsecure1"
	icon_opened = "rdsecureopen"
	icon_broken = "rdsecurebroken"
	icon_off = "rdsecureoff"
	req_access = list(access_heads)

/obj/secure_closet/captains
	name = "Captain's Closet"
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"
	req_access = list(access_captain)

/obj/secure_closet/eng
	name = "Engineering Closet"
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"
	req_access = list(access_engine)

/obj/secure_closet/engelec
	name = "Engineering Electrical Closet"
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "secureengelecopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"
	req_access = list(access_engine_equip)

/obj/secure_closet/engweld
	name = "Engineering Welding Closet"
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "secureengweldopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"
	req_access = list(access_engine_equip)

/obj/secure_closet/ce
	name = "Chief Engineer's Closet"
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"
	req_access = list(access_heads)

/obj/secure_closet/hydro
	name = "Hydroponical Closet"
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"
	req_access = list(access_hydroponics)

/obj/secure_closet/genetics
	name = "Genetic's Closet"
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"
	req_access = list(access_medlab)

/obj/secure_closet/genetics/New()
    ..()
    sleep(2)
    new /obj/item/device/pda/gene(src)
    new /obj/item/clothing/under/rank/geneticist( src )
    new /obj/item/clothing/shoes/white( src )
    new /obj/item/weapon/storage/box/stma( src )
    new /obj/item/clothing/suit/storage/labcoat(src)
    new /obj/item/device/radio/headset/headset_medsci(src)
    new /obj/item/clothing/gloves/latex(src)
    new /obj/item/weapon/storage/belt/medical(src)
    new /obj/item/weapon/storage/backpack/medic(src)
    return


/obj/secure_closet/cmo
	name = "Chief Medical Officer's Closet"
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"
	req_access = list(access_medical)

/obj/secure_closet/chemical
	name = "Chemical Closet"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_chemistry)

/obj/secure_closet/chem/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/headset_medsci(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/device/pda/chem(src)
	new /obj/item/clothing/under/rank/chemist( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/glasses/regular( src )
	new /obj/item/clothing/suit/storage/labcoat( src )
	new /obj/item/weapon/storage/backpack(src)
	return

/obj/secure_closet/chem
	name = "Chemical's Closet"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_chemistry)


/obj/secure_closet/robot
	name = "Robotic Closet"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_robotics)

/obj/secure_closet/robot/New()
	..()
	sleep(2)
	new /obj/item/device/pda/robot(src)
	new /obj/item/clothing/under/rank/roboticist( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/weapon/storage/box/lglo( src )
	new /obj/item/clothing/suit/storage/labcoat(src)
	new /obj/item/device/radio/headset/headset_rob(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/weapon/storage/backpack(src)
	return


/obj/secure_closet/medical2
	name = "Anesthetic"
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medical1"
	req_access = list(access_medical)

/obj/secure_closet/personal
	desc = "The first card swiped gains control."
	name = "Personal Closet"


/obj/secure_closet/security1
	name = "Security Equipment"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	req_access = list(access_security)

/obj/secure_closet/security2
	name = "Forensics Locker"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	req_access = list(access_forensics_lockers)

/obj/secure_closet/scientist
	name = "Scientist Locker"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_tox_storage)

/obj/secure_closet/chemtoxin
	name = "Chemistry Locker"
	req_access = list(access_medical)

/obj/secure_closet/bar
	name = "Booze"
	req_access = list(access_bar)

/obj/secure_closet/kitchen
	name = "Kitchen Cabinet"
	req_access = list(access_kitchen)

/obj/secure_closet/meat
	name = "Meat Locker"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

/obj/secure_closet/fridge
	name = "Refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

/obj/secure_closet/refrigerator
	name = "Refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

/obj/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0