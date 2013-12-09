/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)

		var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( src.loc )
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.dir = pick(cardinal)

		spawn(10)
			pulse2.delete()
	..()

/obj/machinery/alarm
	name = "alarm"
	icon = 'monitors.dmi'
	icon_state = "alarm0"
	anchored = 1.0
	var/skipprocess = 0 //Experimenting
	var/alarm_frequency = "1437"
	var/alarm_zone = null
	networking = 2
	security = 1

/obj/machinery/camera
	name = "Security Camera"
	desc = "A security camera with exposed wires."
	icon = 'monitors.dmi'
	icon_state = "camera"
	var/network = "Luna"
	layer = 5
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = 1.0
	var/invuln = null
	var/bugged = 0
	networking = PROCESS_RPCS
	security = 1

/obj/machinery/camera/call_function(datum/function/F)
	..()
	if(uppertext(F.arg1) != net_pass)
		var/datum/function/R = new()
		R.name = "response"
		R.source_id = address
		R.destination_id = F.source_id
		R.arg1 += "Incorrect Access token"
		send_packet(src,F.source_id,R)
		return 0 // send a wrong password really.
	if(F.name == "disable")
		src.status = 0
	else if(F.name == "enable")
		src.status = 1


/obj/machinery/dna_scanner
	name = "DNA Scanner/Implanter"
	icon = 'Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0

/obj/machinery/dna_scannernew
	name = "DNA Scanner"
	icon = 'Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0


/obj/machinery/firealarm
	name = "Fire Alarm"
	icon = 'monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50/severity)) alarm()
	..()

/obj/machinery/partyalarm
	name = "Party Button"
	icon = 'monitors.dmi'
	icon_state = "fire0"
	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0



/obj/machinery/hologram_proj
	name = "hologram projector"
	icon = 'stationobjs.dmi'
	icon_state = "holopad0"
	var/id = null
	var/atom/projection = null
	anchored = 1.0

/obj/machinery/igniter
	name = "floor-mounted igniter"
	icon = 'stationobjs.dmi'
	icon_state = "igniter1"
	var/id = null
	var/on = 1.0
	anchored = 1.0

/obj/machinery/injector
	name = "Gas Injector"
	icon = 'stationobjs.dmi'
	icon_state = "injector"
	density = 1
	anchored = 1.0
	flags = ON_BORDER

/obj/machinery/mass_driver
	name = "Mass Driver"
	desc = "A device for launching objects into space"
	icon = 'stationobjs.dmi'
	icon_state = "mass_driver"
	var/power = 1.0
	var/code = 1.0
	var/id = 1.0
	anchored = 1.0
	var/drive_range = 50 //this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.

/obj/machinery/meter
	name = "Pressure Meter"
	desc = "A meter for measuring the gas pressure in pipes"
	icon = 'meter.dmi'
	icon_state = "meterX"
	var/obj/machinery/atmospherics/pipe/target = null
	anchored = 1.0
	var/frequency = 0
	var/id

/obj/machinery/optable
	name = "Operating Table"
	desc = "A medical device for operating on people"
	icon = 'surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1.0

	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0

	var/obj/machinery/computer/operating/computer = null
	var/id = 0.0

/obj/machinery/vehicle
	name = "Vehicle Pod"
	icon = 'escapepod.dmi'
	icon_state = "podfire"
	density = 1
	flags = FPRINT
	anchored = 1.0
	var/speed = 10.0
	var/maximum_speed = 10.0
	var/can_rotate = 1
	var/can_maximize_speed = 0
	var/one_person_only = 0

/obj/machinery/vehicle/pod
	name = "Escape Pod"
	icon = 'escapepod.dmi'
	icon_state = "pod"
	can_rotate = 0
	var/id = 1.0

/obj/machinery/vehicle/recon
	name = "Reconaissance Pod"
	icon = 'escapepod.dmi'
	icon_state = "recon"
	speed = 1.0
	maximum_speed = 30.0
	can_maximize_speed = 1
	one_person_only = 1

/obj/machinery/restruct
	name = "DNA Physical Restructurization Accelerator"
	icon = 'Cryogenic2.dmi'
	icon_state = "restruct_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0

/obj/machinery/scan_console
	name = "DNA Scanner Access Console"
	icon = 'computer.dmi'
	icon_state = "scanner"
	density = 1
	var/obj/item/weapon/card/data/scan = null
	var/func = ""
	var/data = ""
	var/special = ""
	var/status = null
	var/prog_p1 = null
	var/prog_p2 = null
	var/prog_p3 = null
	var/prog_p4 = null
	var/temp = null
	var/obj/machinery/dna_scanner/connected = null
	anchored = 1.0

/obj/machinery/sec_lock
	name = "Security Pad"
	icon = 'stationobjs.dmi'
	icon_state = "sec_lock"
	var/obj/item/weapon/card/id/scan = null
	var/a_type = 0.0
	var/obj/machinery/door/d1 = null
	var/obj/machinery/door/d2 = null
	anchored = 1.0
	req_access = list(access_brig)



/obj/machinery/ignition_switch
	name = "ignition switch"
	icon = 'objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mounted igniter."
	var/id = null
	var/active = 0
	anchored = 1.0

/obj/machinery/shuttle
	name = "shuttle"
	icon = 'shuttle.dmi'

/obj/machinery/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/machinery/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/machinery/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/machinery/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/machinery/shuttle/engine/propulsion/pod
	icon_state = "podengine"

/obj/machinery/shuttle/engine/propulsion/burst/left
	icon_state = "burst_l"

/obj/machinery/shuttle/engine/propulsion/burst/right
	icon_state = "burst_r"

/obj/machinery/shuttle/engine/router
	name = "router"
	icon_state = "router"

/obj/machinery/wire
	name = "wire"
	icon = 'power_cond.dmi'


/obj/machinery/power
	name = null
	icon = 'power.dmi'
	anchored = 1.0
	var/netnum = 0
	var/directwired = 1		// by default, power machines are connected by a cable in a neighbouring turf
							// if set to 0, requires a 0-X cable on this turf

/obj/machinery/power/generator_type2
	name = "thermo-electric generator"
	desc = "A high efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = 1
	density = 1
	var/transferpercent = 100
	var/outputpercent = 100

	var/obj/machinery/atmospherics/unary/generator_input/input1
	var/obj/machinery/atmospherics/unary/generator_input/input2

	var/lastgen = 0
	var/lastgenlev = -1

/obj/machinery/power/generator_type3
	name = "thermo-electric generator"
	desc = "A high efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = 1
	density = 1
	var/transferpercent = 100
	var/outputpercent = 100

	var/obj/machinery/atmos_new/generator_input/input1
	var/obj/machinery/atmos_new/generator_input/input2

	var/lastgen = 0
	var/lastgenlev = -1

/obj/machinery/power/monitor
	name = "Power Monitoring Computer"
	icon = 'computer.dmi'
	icon_state = "power"
	density = 1
	anchored = 1
	var/brightnessred = 0
	var/brightnessgreen = 0
	var/brightnessblue = 0

/obj/machinery/light_switch
	desc = "A light switch"
	name = "light switch"
	icon = 'power.dmi'
	icon_state = "light1"
	anchored = 1.0
	var/on = 1
	var/area/area = null
	var/otherarea = null
	//	luminosity = 1

/obj/machinery/crema_switch
	desc = "Burn baby burn!"
	name = "crematorium igniter"
	icon = 'power.dmi'
	icon_state = "crema_switch"
	anchored = 1.0
	req_access = list(access_crematorium)
	var/on = 0
	var/area/area = null
	var/otherarea = null
	var/id = 1

/obj/machinery/gibber
	name = "Gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/mob/occupant // Mob who has been put inside