//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.

/datum/supply_packs
	var/name = null
	var/list/contains = new/list()
	var/amount = null
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null

	var/list/types = list("Miscellaneous")
	//Can contain:
	//"Emergency" "Security" "Engineering"
	//"Medical" "Science" "Food"
	//"Materials" "Miscellaneous"

	var/manifest

	var/emagged = 0
	var/hacked = 0

/datum/supply_packs/New()
	if(emagged || hacked || !contains.len) return // No manifests for illegal stuff

	manifest += "<ul>"
	for(var/path in contains)
		var/atom/movable/AM = new path()
		manifest += "<li>[AM.name]</li>"
		AM.loc = null	//just to make sure they're deleted by the garbage collector
	manifest += "</ul>"




/*
 ILLEGAL
 */

/datum/supply_packs/specialops
	name = "Special supplies"
	contains = list(/obj/item/weapon/storage/box/grenades/emp,
					/obj/item/weapon/pen/sleepypen,
					/obj/item/weapon/grenade/incendiarygrenade)
	cost = 30
	containertype = /obj/structure/closet/crate
	emagged = 1
	types = list("Miscellaneous", "Security")

/datum/supply_packs/randomised/contraband
	num_contained = 5
	contains = list(/obj/item/weapon/contraband/poster,
					/obj/item/weapon/cigpacket/dromedaryco)
	name = "Contraband crate"
	cost = 25
	hacked = 1

/*
 EMERGECNCY
 */

/datum/supply_packs/internals
	name = "Internals crate"
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/oxygen,
					/obj/item/weapon/tank/oxygen,
					/obj/item/weapon/tank/oxygen)
	cost = 10
	containertype = /obj/structure/closet/crate/internals
	containername = "Internals crate"
	types = list("Emergency")

/datum/supply_packs/evacuation
	name = "Emergency crate"
	contains = list(/obj/machinery/bot/floorbot,
					/obj/machinery/bot/floorbot,
					/obj/machinery/bot/medbot,
					/obj/machinery/bot/medbot,
					/obj/item/weapon/storage/box/grenades/metalfoam,
					/obj/item/weapon/storage/box/grenades/metalfoam)
	cost = 40
	containertype = /obj/structure/closet/crate/internals
	containername = "Emergency crate"
	types = list("Emergency")



/*
 MEDICAL
 */

/datum/supply_packs/medical
	name = "Medical crate"
	contains = list(/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
					/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
					/obj/item/weapon/storage/box/syringes)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	types = list("Medical")

/datum/supply_packs/surgical
	name = "Surgical tools crate"
	contains = list(/obj/item/weapon/surgical/circular_saw,
					/obj/item/weapon/surgical/scalpel,
					/obj/item/weapon/surgical/cautery,
					/obj/item/weapon/surgical/hemostat,
					/obj/item/weapon/surgical/bonegel,
					/obj/item/weapon/surgical/drapes)
	cost = 20
	containertype = /obj/structure/closet/crate/medical
	containername = "surgical tools crate"
	types = list("Medical")

/datum/supply_packs/daimp
	name = "Death Alarm implants crate"
	contains = list(/obj/item/weapon/storage/box/imp_kit/da)
	cost = 15
	containername = "death alarm implants crate"
	containertype = /obj/structure/closet/crate/medical
	types = list("Medical")

/datum/supply_packs/medical/virus
	name = "Virus crate"
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/virus/flu_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/cold,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/epiglottis_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/liver_enhance_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/fake_gbs,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/magnitis,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/pierrot_throat,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/brainrot,
					/obj/item/weapon/reagent_containers/glass/bottle/virus/hullucigen_virion,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/beaker,
					/obj/item/weapon/reagent_containers/glass/bottle/mutagen)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "virus crate"
	access = access_medical
	types = list("Medical")

/*
 ENGINEERING
 */

/datum/supply_packs/electrical
	name = "Electrical maintenance crate"
	contains = list(/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/clothing/gloves/yellow,
					/obj/item/clothing/gloves/yellow,
					/obj/item/weapon/cell,
					/obj/item/weapon/cell,
					/obj/item/weapon/cell/high,
					/obj/item/weapon/cell/high)
	cost = 20
	containertype = /obj/structure/closet/crate/electrical
	containername = "electrical maintenance crate"
	types = list("Engineering")

/datum/supply_packs/mechanical
	name = "Mechanical maintenance crate"
	contains = list(/obj/item/weapon/storage/belt/utility/loaded,
					/obj/item/weapon/storage/belt/utility/loaded,
					/obj/item/weapon/storage/belt/utility/loaded,
					/obj/item/clothing/suit/storage/hazard,
					/obj/item/clothing/suit/storage/hazard,
					/obj/item/clothing/suit/storage/hazard,
					/obj/item/clothing/head/helmet/welding,
					/obj/item/clothing/head/helmet/welding,
					/obj/item/clothing/head/helmet/welding,
					/obj/item/clothing/head/helmet/hardhat,
					/obj/item/clothing/head/helmet/hardhat,
					/obj/item/clothing/head/helmet/hardhat)
	cost = 15
	containertype = /obj/structure/closet/crate/engineering
	containername = "mechanical maintenance crate"
	types = list("Engineering")

/datum/supply_packs/solar
	name = "Solar pack crate"
	contains  = list(/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, /obj/item/weapon/solar_assembly,
					/obj/item/weapon/solar_assembly, // 21 Solar Assemblies. 1 Extra for the controller
					/obj/item/weapon/circuitboard/computer/solar_control,
					/obj/item/weapon/circuitboard/tracker)
	cost = 20
	containertype = /obj/structure/closet/crate/engineering
	containername = "solar pack crate"
	types = list("Engineering")

/*
 SCIENCE
 */

/datum/supply_packs/plasma
	name = "Plasma assembly crate"
	contains = list(/obj/item/weapon/tank/plasma,
					/obj/item/weapon/tank/plasma,
					/obj/item/weapon/tank/plasma,
					/obj/item/device/igniter,
					/obj/item/device/igniter,
					/obj/item/device/igniter,
					/obj/item/device/prox_sensor,
					/obj/item/device/prox_sensor,
					/obj/item/device/prox_sensor,
					/obj/item/device/timer,
					/obj/item/device/timer,
					/obj/item/device/timer)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "plasma assembly crate"
	access = access_tox_storage
	types = list("Science")

/datum/supply_packs/robotics
	name = "Robotics assembly crate"
	contains = list(/obj/item/device/prox_sensor,
					/obj/item/device/prox_sensor,
					/obj/item/device/prox_sensor,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/device/flash,
					/obj/item/weapon/cell/high,
					/obj/item/weapon/cell/high)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "robotics assembly crate"
	access = access_robotics
	types = list("Science")

/datum/supply_packs/mecha_ripley
	name = "Circuit crate (\"Ripley\" APLU)"
	contains = list(/obj/item/weapon/circuitboard/mecha/ripley/main,
					/obj/item/weapon/circuitboard/mecha/ripley/peripherals)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper APLU \"Ripley\" circuit crate"
	types = list("Science")

/datum/supply_packs/mecha_odysseus
	name = "Circuit crate (\"Odysseus\")"
	contains = list(/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,
					/obj/item/weapon/circuitboard/mecha/odysseus/main)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper \"Odysseus\" circuit crate"
	types = list("Science")


/*
 SECURITY
 */

// Armor
/datum/supply_packs/armor
	name = "Armor crate"
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/head/helmet)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "armor crate"
	access = access_security
	types = list("Security")

/datum/supply_packs/riot
	name = "Riot gear crate"
	contains = list(/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/storage/box/grenades/flashbang,
					/obj/item/weapon/storage/box/grenades/teargas,
					/obj/item/weapon/storage/box/handcuffs,
					/obj/item/weapon/storage/box/handcuffs)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Riot gear crate"
	access = access_security
	types = list("Security")

// Weapons
/datum/supply_packs/weapons
	name = "Weapons crate"
	contains = list(/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/melee/baton,
					/obj/item/weapon/gun/energy/taser,
					/obj/item/weapon/gun/energy/taser,
					/obj/item/weapon/gun/energy/taser)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = access_security
	types = list("Security")

/datum/supply_packs/eweapons
	name = "Experimental weapons crate"
	contains = list(/obj/item/clothing/gloves/yellow/stun)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Experimental weapons crate"
	access = access_heads
	types = list("Security")

/datum/supply_packs/laser
	name = "Lasers crate"
	contains = list(/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "laser crate"
	access = access_armory
	types = list("Security")

/datum/supply_packs/ballistic
	name = "Shotguns crate"
	contains = list(/obj/item/ammo_magazine/box/shotgun,
					/obj/item/ammo_magazine/box/shotgun,
					/obj/item/ammo_magazine/box/shotgun,
					/obj/item/weapon/gun/projectile/shotgun/combat,
					/obj/item/weapon/gun/projectile/shotgun/combat,
					/obj/item/weapon/gun/projectile/shotgun/combat)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "combat shotgun crate"
	access = access_armory
	types = list("Security")

/datum/supply_packs/egun
	name = "Energy guns crate"
	contains = list(/obj/item/weapon/gun/energy/gun,
					/obj/item/weapon/gun/energy/gun,
					/obj/item/weapon/gun/energy/gun)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "energy gun crate"
	access = access_armory
	types = list("Security")

/datum/supply_packs/laserarmor
	name = "Ablative armor crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "ablative armor crate"
	access = access_armory
	types = list("Security")

// Implants
/*datum/supply_packs/loyalty
	name = "Loyalty implants crate"
	contains = list (/obj/item/weapon/storage/lockbox/loyalty)
	cost = 40
	containername = "loyalty implant crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_armory
	types = list("Security")*/

/datum/supply_packs/trackingimp
	name = "Tracking implants crate"
	contains = list (/obj/item/weapon/storage/box/imp_kit/track)
	cost = 20
	containername = "tracking implants crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_armory
	types = list("Security")

/datum/supply_packs/chemimp
	name = "Chemical implants crate"
	contains = list (/obj/item/weapon/storage/box/imp_kit/chem)
	cost = 20
	containername = "chemical implants crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_armory
	types = list("Security")

// Misc
/datum/supply_packs/securitybarriers
	name = "Security barrier"
	contains = list(/obj/machinery/deployable/barrier)
	cost = 10
	types = list("Security")


/*
 MATERIALS
 */

/datum/supply_packs/watertank
	name = "Water tank"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 10
	types = list("Materials")

/datum/supply_packs/hvwatertank
	name = "High-volume water tank"
	contains = list(/obj/structure/reagent_dispensers/watertank/hv)
	cost = 15
	types = list("Materials")

/datum/supply_packs/fueltank
	name = "Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 15
	types = list("Materials")

/datum/supply_packs/hvfueltank
	name = "High-volume fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank/hv)
	cost = 20
	types = list("Materials")


/datum/supply_packs/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/sheet/metal)
	amount = 50
	cost = 15
	types = list("Materials")

/datum/supply_packs/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/sheet/glass)
	amount = 50
	cost = 15
	types = list("Materials")


/datum/supply_packs/gascanisterair
    name = "Gas canister \[Air\]"
    contains = list(/obj/machinery/portable_atmospherics/canister/air)
    cost = 10
    types = list("Materials", "Emergency", "Engineering")

/datum/supply_packs/gascanisternitrogen
    name = "Gas canister \[N2\]"
    contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
    cost = 10
    types = list("Materials", "Engineering")

/datum/supply_packs/gascanisteroxygen
    name = "Gas canister \[Oxygen\]"
    contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)
    cost = 10
    types = list("Materials", "Emergency", "Engineering")

/datum/supply_packs/gascanisterco2
    name = "Gas canister \[CO2\]"
    contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
    cost = 10
    types = list("Materials")

/datum/supply_packs/gascanisterplasma
    name = "Gas canister \[Plasma\]"
    contains = list(/obj/machinery/portable_atmospherics/canister/toxins)
    cost = 40
    types = list("Materials", "Science")

/datum/supply_packs/gascanisterlaughgas
    name = "Gas canister \[N2O\]"
    contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)
    cost = 40
    types = list("Materials")


/*
 MISC
 */

/datum/supply_packs/costume
	name = "Standard costume crate"
	contains = list(/obj/item/weapon/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/clown,
					/obj/item/weapon/bikehorn,
					/obj/item/clothing/under/rank/mime,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/gloves/latex,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/suit/suspenders,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "standard costumes"
	access = access_theater

/datum/supply_packs/wizard
	name = "Wizard costume crate"
	contains = list(/obj/item/weapon/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Wizard costume crate"

/datum/supply_packs/janitor
	name = "Janitorial supplies"
	contains = list(/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/weapon/caution,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/storage/box/grenades/cleaner,
					/obj/structure/mopbucket)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Janitorial supplies"

/datum/supply_packs/party
	name = "Party equipment"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer,
	/obj/item/weapon/reagent_containers/food/drinks/beer)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Party equipment"

/datum/supply_packs/mule
	name = "MULEbot"
	contains = list(/obj/machinery/bot/mulebot)
	cost = 20

/datum/supply_packs/randomised
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	name = "Collectable hat crate!"
	containertype = /obj/structure/closet/crate
	cost = 100
	containername = "Collectable hats crate! Brought to you by Bass.inc!"

/datum/supply_packs/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()

/datum/supply_packs/paper
	name = "Bureaucracy crate"
	contains = list(/obj/structure/filingcabinet/chestdrawer/wheeled,
					/obj/item/weapon/camera_test,
					/obj/item/weapon/hand_labeler,
					/obj/item/weapon/hand_labeler_refill,
					/obj/item/weapon/hand_labeler_refill,
					/obj/item/weapon/paper_bin,
					/obj/item/weapon/pen,
					/obj/item/weapon/pen,
					/obj/item/weapon/pen,
					/obj/item/weapon/folder/blue,
					/obj/item/weapon/folder/red,
					/obj/item/weapon/folder/yellow,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/clipboard)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Bureaucracy crate"

/datum/supply_packs/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "toner cartridges"

/* RIP charges system
/datum/supply_packs/medical
	name = "Medical Charge"
	contains = list(/obj/item/weapon/vending_charge/medical)
	cost = 10

/datum/supply_packs/toxins
	name = "Toxins Research Charge"
	contains = list(/obj/item/weapon/vending_charge/toxins)
	cost = 10

/datum/supply_packs/robotics
	name = "Robotics Charge"
	contains = list(/obj/item/weapon/vending_charge/robotics)
	cost = 10

/datum/supply_packs/bar
	name = "Bar Charge"
	contains = list(/obj/item/weapon/vending_charge/bar)
	cost = 10

/datum/supply_packs/kitchen
	name = "Kitchen Charge"
	contains = list(/obj/item/weapon/vending_charge/kitchen)
	cost = 10

/datum/supply_packs/engineering
	name = "Engineering Charge"
	contains = list(/obj/item/weapon/vending_charge/engineering)
	cost = 10

/datum/supply_packs/security
	name = "Security Charge"
	contains = list(/obj/item/weapon/vending_charge/security)
	cost = 10

/datum/supply_packs/coffee
	name = "Coffee Charge"
	contains = list(/obj/item/weapon/vending_charge/coffee)
	cost = 10

/datum/supply_packs/snack
	name = "Snack Charge"
	contains = list(/obj/item/weapon/vending_charge/snack)
	cost = 10

/datum/supply_packs/cart
	name = "PDA Cart Charge"
	contains = list(/obj/item/weapon/vending_charge/cart)
	cost = 10

/datum/supply_packs/cigarette
	name = "Cigarette Charge"
	contains = list(/obj/item/weapon/vending_charge/cigarette)
	cost = 10

/datum/supply_packs/soda
	name = "Soda Charge"
	contains = list(/obj/item/weapon/vending_charge/soda)
	cost = 10*/

/*
/datum/supply_packs/hats
	name = "Clown Gear"
	contains = list(/obj/item/clothing/head/that,
	/obj/item/clothing/under/psyche,
	/obj/item/clothing/under/johnny,
	/obj/item/clothing/under/mario,
	/obj/item/clothing/under/luigi,
	/obj/item/clothing/head/butt)
	cost = 20
	containertype = /obj/structure/closet/crate"
	containername = "Clown Gear"


/datum/supply_packs/robot
	name = "Robotics Crate"
	contains = list(/obj/machinery/bot/floorbot,
	/obj/machinery/bot/cleanbot,
	/obj/machinery/bot/medbot)
	cost = 35
	containertype = /obj/structure/closet/crate"
	containername = "Robotics Crate"
*/

///datum/supply_packs/food
//	name = "Food crate"
//	contains = list(/obj/item/weapon/reagent_containers/food/snacks/flour,
//					/obj/item/weapon/reagent_containers/food/snacks/flour,
//					/obj/item/weapon/reagent_containers/food/snacks/flour,
			//		/obj/item/weapon/reagent_containers/food/snacks/meatball,
			//		/obj/item/weapon/reagent_containers/food/snacks/meatball,
			//		/obj/item/weapon/reagent_containers/food/snacks/meatball,
//					/obj/item/kitchen/egg_box,
//					/obj/item/weapon/banana,
//					/obj/item/weapon/banana,
//					/obj/item/weapon/banana)
//	cost = 5
//	containertype = /obj/structure/closet/crate/freezer
//	containername = "Food crate"

///datum/supply_packs/engineering
//	name = "Engineering crate"
//	contains = list(/obj/item/weapon/storage/toolbox/electrical,
//					/obj/item/weapon/storage/toolbox/electrical,
//					/obj/item/clothing/head/helmet/welding,
//					/obj/item/clothing/head/helmet/welding,
//					/obj/item/clothing/gloves/yellow,
//					/obj/item/clothing/gloves/yellow)
//	cost = 5
//	containertype = /obj/structure/closet/crate
//	containername = "Engineering crate"

///datum/supply_packs/plasma
//	name = "Plasma assembly crate"
//	contains = list(/obj/item/weapon/tank/plasma,
//					/obj/item/device/igniter,
//					/obj/item/device/prox_sensor,
//					/obj/item/device/timer)
//	cost = 10
//	containertype = /obj/structure/closet/crate/secure/plasma
//	containername = "Plasma assembly crate"
//	access = access_tox