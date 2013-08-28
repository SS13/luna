
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
	var/hidden = 0

/datum/supply_packs/specialops
	name = "Special Ops supplies"
	contains = list("/obj/item/weapon/storage/box/emp",
					"/obj/item/weapon/pen/sleepypen",
					"/obj/item/weapon/grenade/incendiarygrenade")
	cost = 20
	containertype = "/obj/structure/crate"
	containername = "Special Ops crate"
	hidden = 1

/datum/supply_packs/medical
	name = "Medical Charge"
	contains = list("/obj/item/weapon/vending_charge/medical")
	cost = 10

/datum/supply_packs/toxins
	name = "Toxins Research Charge"
	contains = list("/obj/item/weapon/vending_charge/toxins")
	cost = 10

/datum/supply_packs/robotics
	name = "Robotics Charge"
	contains = list("/obj/item/weapon/vending_charge/robotics")
	cost = 10

/datum/supply_packs/bar
	name = "Bar Charge"
	contains = list("/obj/item/weapon/vending_charge/bar")
	cost = 10

/datum/supply_packs/kitchen
	name = "Kitchen Charge"
	contains = list("/obj/item/weapon/vending_charge/kitchen")
	cost = 10

/datum/supply_packs/engineering
	name = "Engineering Charge"
	contains = list("/obj/item/weapon/vending_charge/engineering")
	cost = 10

/datum/supply_packs/security
	name = "Security Charge"
	contains = list("/obj/item/weapon/vending_charge/security")
	cost = 10

/datum/supply_packs/coffee
	name = "Coffee Charge"
	contains = list("/obj/item/weapon/vending_charge/coffee")
	cost = 10

/datum/supply_packs/snack
	name = "Snack Charge"
	contains = list("/obj/item/weapon/vending_charge/snack")
	cost = 10

/datum/supply_packs/cart
	name = "PDA Cart Charge"
	contains = list("/obj/item/weapon/vending_charge/cart")
	cost = 10

/datum/supply_packs/cigarette
	name = "Cigarette Charge"
	contains = list("/obj/item/weapon/vending_charge/cigarette")
	cost = 10

/datum/supply_packs/soda
	name = "Soda Charge"
	contains = list("/obj/item/weapon/vending_charge/soda")
	cost = 10

/*/datum/supply_packs/wizard
	name = "Wizard costume"
	contains = list("/obj/item/weapon/staff",
					"/obj/item/clothing/suit/wizrobe",
					"/obj/item/clothing/shoes/sandal",
					"/obj/item/clothing/head/wizard")
	cost = 20
	containertype = "/obj/structure/crate"
	containername = "Wizard costume crate"*/

/datum/supply_packs/metal50
	name = "50 Metal Sheets"
	contains = list("/obj/item/stack/sheet/metal")
	amount = 50
	cost = 15
	containertype = "/obj/structure/crate"
	containername = "Metal sheets crate"

/datum/supply_packs/glass50
	name = "50 Glass Sheets"
	contains = list("/obj/item/stack/sheet/glass")
	amount = 50
	cost = 15
	containertype = "/obj/structure/crate"
	containername = "Glass sheets crate"

/datum/supply_packs/internals
	name = "Internals crate"
	contains = list("/obj/item/clothing/mask/gas",
					"/obj/item/clothing/mask/gas",
					"/obj/item/clothing/mask/gas",
					"/obj/item/weapon/tank/air",
					"/obj/item/weapon/tank/air",
					"/obj/item/weapon/tank/air")
	cost = 10
	containertype = "/obj/structure/crate/internals"
	containername = "Internals crate"

///datum/supply_packs/food
//	name = "Food crate"
//	contains = list("/obj/item/weapon/reagent_containers/food/snacks/flour",
//					"/obj/item/weapon/reagent_containers/food/snacks/flour",
//					"/obj/item/weapon/reagent_containers/food/snacks/flour",
			//		"/obj/item/weapon/reagent_containers/food/snacks/meatball",
			//		"/obj/item/weapon/reagent_containers/food/snacks/meatball",
			//		"/obj/item/weapon/reagent_containers/food/snacks/meatball",
//					"/obj/item/kitchen/egg_box",
//					"/obj/item/weapon/banana",
//					"/obj/item/weapon/banana",
//					"/obj/item/weapon/banana")
//	cost = 5
//	containertype = "/obj/structure/crate/freezer"
//	containername = "Food crate"

///datum/supply_packs/engineering
//	name = "Engineering crate"
//	contains = list("/obj/item/weapon/storage/toolbox/electrical",
//					"/obj/item/weapon/storage/toolbox/electrical",
//					"/obj/item/clothing/head/helmet/welding",
//					"/obj/item/clothing/head/helmet/welding",
//					"/obj/item/clothing/gloves/yellow",
//					"/obj/item/clothing/gloves/yellow")
//	cost = 5
//	containertype = "/obj/structure/crate"
//	containername = "Engineering crate"

/datum/supply_packs/medical
	name = "Medical crate"
	contains = list("/obj/item/weapon/storage/firstaid/regular",
					"/obj/item/weapon/storage/firstaid/fire",
					"/obj/item/weapon/storage/firstaid/toxin",
					"/obj/item/weapon/storage/firstaid/o2",
					"/obj/item/weapon/reagent_containers/glass/bottle/antitoxin",
					"/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline",
					"/obj/item/weapon/reagent_containers/glass/bottle/stoxin",
					"/obj/item/weapon/storage/box/syringes")
	cost = 10
	containertype = "/obj/structure/crate/medical"
	containername = "Medical crate"

/datum/supply_packs/janitor
	name = "Janitorial supplies"
	contains = list("/obj/item/weapon/reagent_containers/glass/bucket",
					"/obj/item/weapon/mop",
					"/obj/item/weapon/caution",
					"/obj/item/weapon/cleaner",
					"/obj/item/weapon/grenade/chem_grenade/cleaner",
					"/obj/mopbucket")
	cost = 10
	containertype = "/obj/structure/crate"
	containername = "Janitorial supplies"

///datum/supply_packs/plasma
//	name = "Plasma assembly crate"
//	contains = list("/obj/item/weapon/tank/plasma",
//					"/obj/item/device/igniter",
//					"/obj/item/device/prox_sensor",
//					"/obj/item/device/timer")
//	cost = 10
//	containertype = "/obj/structure/crate/secure/plasma"
//	containername = "Plasma assembly crate"
//	access = access_tox

/datum/supply_packs/weapons
	name = "Security crate"
	contains = list("/obj/item/weapon/baton",
					"/obj/item/weapon/baton",
//					"/obj/item/weapon/gun/energy/laser_gun",
//					"/obj/item/weapon/gun/energy/laser_gun",
					"/obj/item/weapon/gun/energy/taser_gun",
					"/obj/item/weapon/gun/energy/taser_gun",
					"/obj/item/weapon/storage/box/flashbang",
					"/obj/item/weapon/storage/box/flashbang")
	cost = 20
	containertype = "/obj/structure/crate/secure/weapon"
	containername = "Weapons crate"
	access = access_security

/datum/supply_packs/eweapons
	name = "Experimental weapons crate"
	contains = list("/obj/item/clothing/gloves/yellow/stun")
	cost = 25
	containertype = "/obj/structure/crate/secure/weapon"
	containername = "Experimental weapons crate"
	access = access_heads

/datum/supply_packs/riot
	name = "Riot crate"
	contains = list("/obj/item/weapon/baton",
					"/obj/item/weapon/baton",
					"/obj/item/weapon/baton",
					"/obj/item/weapon/shield/riot",
					"/obj/item/weapon/shield/riot",
					"/obj/item/weapon/shield/riot",
					"/obj/item/weapon/smokebomb",
					"/obj/item/weapon/smokebomb",
					"/obj/item/weapon/smokebomb",
					"/obj/item/weapon/handcuffs",
					"/obj/item/weapon/handcuffs",
					"/obj/item/weapon/handcuffs")
	cost = 20
	containertype = "/obj/structure/crate/secure/gear"
	containername = "Riot crate"
	access = access_security

/datum/supply_packs/gascanisterair
    name = "Gas Canister \[Air\] Crate"
    contains = list("/obj/machinery/portable_atmospherics/canister/air")
    cost = 10

/datum/supply_packs/gascanisternitrogen
    name = "Gas Canister \[N2\] Crate"
    contains = list("/obj/machinery/portable_atmospherics/canister/nitrogen")
    cost = 10

/datum/supply_packs/gascanisteroxygen
    name = "Gas Canister \[Oxygen\] Crate"
    contains = list("/obj/machinery/portable_atmospherics/canister/oxygen")
    cost = 10

/datum/supply_packs/gascanisterco2
    name = "Gas Canister \[CO2\] Crate"
    contains = list("/obj/machinery/portable_atmospherics/canister/carbon_dioxide")
    cost = 10

/datum/supply_packs/gascanisterplasma
    name = "Gas Canister \[Plasma\] Crate"
    contains = list("/obj/machinery/portable_atmospherics/canister/toxins")
    cost = 10

/datum/supply_packs/gascanisterlaughgas
    name = "Gas Canister \[N2O\] Crate"
    contains = list("/obj/machinery/portable_atmospherics/canister/sleeping_agent")
    cost = 10

/datum/supply_packs/evacuation
	name = "Emergency equipment"
	contains = list("/obj/machinery/bot/floorbot",
	"/obj/machinery/bot/floorbot",
	"/obj/machinery/bot/floorbot",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/weapon/tank/air",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas",
	"/obj/item/clothing/mask/gas")
	cost = 75
	containertype = "/obj/structure/crate/internals"
	containername = "Emergency Crate"

/datum/supply_packs/party
	name = "Party equipment"
	contains = list("/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer",
	"/obj/item/weapon/reagent_containers/food/drinks/beer")
	cost = 20
	containertype = "/obj/structure/crate"
	containername = "Party equipment"
/*
/datum/supply_packs/hats
	name = "Clown Gear"
	contains = list("/obj/item/clothing/head/that",
	"/obj/item/clothing/under/psyche",
	"/obj/item/clothing/under/johnny",
	"/obj/item/clothing/under/mario",
	"/obj/item/clothing/under/luigi",
	"/obj/item/clothing/head/butt")
	cost = 20
	containertype = "/obj/structure/crate"
	containername = "Clown Gear"


/datum/supply_packs/robot
	name = "Robotics Crate"
	contains = list("/obj/machinery/bot/floorbot",
	"/obj/machinery/bot/cleanbot",
	"/obj/machinery/bot/medbot")
	cost = 35
	containertype = "/obj/structure/crate"
	containername = "Robotics Crate"
*/

/datum/supply_packs/mule
	name = "M.U.L.E. Bot"
	contains = list("/obj/machinery/bot/mulebot")
	cost = 20

/datum/supply_packs/watertank
    name = "Water Tank"
    contains = list("/obj/structure/reagent_dispensers/watertank")
    cost = 15

/datum/supply_packs/hvwatertank
    name = "High-Volume Water Tank"
    contains = list("/obj/structure/reagent_dispensers/hvwatertank")
    cost = 45

/datum/supply_packs/fueltank
    name = "Fuel Tank"
    contains = list("/obj/structure/reagent_dispensers/fueltank")
    cost = 15