/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	density = 1
	anchored = 1.0
	var/obj/item/weapon/circuitboard/computer/circuit = null //if circuit==null, computer can't disassemble
	var/brightnessred = 2
	var/brightnessgreen = 2
	var/brightnessblue = 2

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()

/*
/obj/machinery/computer/airtunnel
	name = "Air Tunnel Control"
	icon = 'airtunnelcomputer.dmi'
	icon_state = "console00"
*/

/obj/machinery/computer/aiupload
	name = "AI Upload"
	icon_state = "aiupload"
	circuit = "/obj/item/weapon/circuitboard/computer/aiupload"
	brightnessred = 0
	brightnessgreen = 2
	brightnessblue = 0

/obj/machinery/computer/atmosphere
	name = "atmos"

/obj/machinery/computer/atmosphere/alerts
	name = "Alert Computer"
	icon_state = "atmos"
	circuit = "/obj/item/weapon/circuitboard/computer/atmospherealerts"
	var/alarms = list("Fire"=list(), "Atmosphere"=list())

/obj/machinery/computer/general_alert
	name = "General Alert Computer"
	icon_state = "alert:0"
	circuit = "/obj/item/weapon/circuitboard/computer/general_alert"
	var/list/priority_alarms = list()
	var/list/minor_alarms = list()
	var/receive_frequency = "1437"


/obj/machinery/computer/atmosphere/siphonswitch
	name = "Area Air Control"
	icon_state = "atmos"
	var/otherarea
	var/area/area

/obj/machinery/computer/atmosphere/siphonswitch/mastersiphonswitch
	name = "Master Air Control"

/obj/machinery/computer/card
	name = "Identification Computer"
	icon_state = "id"
	circuit = "/obj/item/weapon/circuitboard/computer/card"
	var/obj/item/weapon/card/id/scan = null
	var/obj/item/weapon/card/id/modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null
	req_access = list(access_change_ids)
	brightnessred = 0
	brightnessgreen = 0
	brightnessblue = 2

/obj/machinery/computer/data
	name = "data"
	icon_state = "aiupload"

	var/list/topics = list(  )

/obj/machinery/computer/data/weapon
	name = "weapon"

/obj/machinery/computer/data/weapon/info
	name = "Research Computer"

/obj/machinery/computer/data/weapon/log
	name = "Log Computer"

/obj/machinery/computer/dna
	name = "DNA operations computer"
	icon_state = "dna"
	var/obj/item/weapon/card/data/scan = null
	var/obj/item/weapon/card/data/modify = null
	var/obj/item/weapon/card/data/modify2 = null
	var/mode = null
	var/temp = null

/obj/machinery/computer/hologram_comp
	name = "Hologram Computer"
	icon = 'stationobjs.dmi'
	icon_state = "holo_console0"
	var/obj/machinery/hologram_proj/projector = null
	var/id = null
	var/temp = null
	var/lumens = 0.0
	var/h_r = 245.0
	var/h_g = 245.0
	var/h_b = 245.0

/obj/machinery/computer/med_data
	name = "Medical Records"
	icon_state = "medical"
	req_access = list(access_medical)
	circuit = "/obj/item/weapon/circuitboard/computer/med_data"
	brightnessred = 0
	brightnessgreen = 2
	brightnessblue = 0
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/obj/item/weapon/disk/data/diskette = null

/obj/machinery/computer/pod
	name = "Pod Launch Control"
	icon_state = "computer_generic"
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = 0.0
	var/time = 30.0

/obj/machinery/computer/pod/old
	icon_state = "old"
	name = "DoorMex Control Computer"

/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	desc = "The Syndicate operate on a tight budget. Operates external airlocks."

/obj/machinery/computer/pod/old/swf
	name = "Magix System IV"
	desc = "An arcane artifact that holds much magic. Running E-Knock 2.2: Sorceror's Edition"

/obj/machinery/computer/prison_shuttle
	name = "Prison Shuttle"
	icon_state = "shuttle"
	var/allowedtocall = 0

/obj/machinery/computer/secure_data
	name = "Security Records"
	icon_state = "security"
	req_access = list(access_security)
	circuit = "/obj/item/weapon/circuitboard/computer/secure_data"
	brightnessred = 2
	brightnessgreen = 0
	brightnessblue = 0
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/obj/item/weapon/disk/data/diskette = null

/obj/machinery/computer/secure_data/detective_computer
	icon = 'computer.dmi'
	icon_state = "messyfiles"

/obj/machinery/computer/shuttle
	name = "Shuttle"
	icon_state = "shuttle"
	var/auth_need = 3.0
	var/list/authorized = list(  )

/obj/machinery/computer/teleporter
	name = "Teleporter"
	icon_state = "teleport"
	circuit = "/obj/item/weapon/circuitboard/computer/teleporter"
	var/obj/item/locked = null
	var/id = null

/obj/machinery/computer/robotics
	name = "Robotics Control"
	icon = 'computer.dmi'
	icon_state = "robotics"
	req_access = list(access_captain)
	circuit = "/obj/item/weapon/circuitboard/computer/robotics"
	brightnessred = 0
	brightnessgreen = 2
	brightnessblue = 0

	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0