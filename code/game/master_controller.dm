var/global/datum/controller/game_controller/master_controller //Set in world.New()
var/ticker_debug
var/updatetime
var/global/gametime = 0
var/global/gametime_last_updated
datum/controller/game_controller
	var/processing = 1
	//var/lastannounce = 0
	var/tick = 0

	proc
		setup()
		setup_objects()
		process()

	setup()
		set background = 1
		if(master_controller && (master_controller != src))
			del(src) // There can be only one master.
		world << "Initializing world.."
		diary << "World initialization started at [time2text(world.timeofday, "hh:mm.ss")]"
		var/start_worldinit = world.timeofday

		spawn(0)
			world.startmysql()
			world.load_mode()
			world.load_motd()
			world.load_rules()
			world.load_admins()
			world.update_status()

		world << "\red \b Setting up shields.."
		var/start_shieldnetwork = world.timeofday
		ShieldNetwork = new /datum/shieldnetwork()
		vsc = new()

		ShieldNetwork.makenetwork()

		world << "\red \b Shield network set up in [(world.timeofday - start_shieldnetwork)/10] seconds"

		setupnetwork()
		sun = new /datum/sun()

		vote = new /datum/vote()

		world << "\red \b Creating radio controller.."
		var/start_radio_controller = world.timeofday
		radio_controller = new /datum/controller/radio()
		world << "\red \b Radio controller created in [(world.timeofday - start_radio_controller)/10] seconds"
		//main_hud1 = new /obj/hud()
		data_core = new /obj/datacore()
		CreateShuttles()

		if(!air_master)
			world << "\red \b Initializing air controller"
			diary << "Air controller initialization started at [time2text(world.timeofday, "hh:mm.ss")]"
			var/start_airmaster = world.timeofday
			air_master = new /datum/controller/air_system()
			air_master.setup()
			world << "\red \b Air controller initialized in [(world.timeofday - start_airmaster)/10] seconds!"
			diary << "Air controller initialized at [time2text(world.timeofday, "hh:mm.ss")]. It took [(world.timeofday - start_airmaster)/10] seconds."

		plmaster = new /obj/overlay(  )
		plmaster.icon = 'tile_effects.dmi'
		plmaster.icon_state = "plasma"
		plmaster.layer = FLY_LAYER
		plmaster.mouse_opacity = 0

		slmaster = new /obj/overlay(  )
		slmaster.icon = 'tile_effects.dmi'
		slmaster.icon_state = "sleeping_agent"
		slmaster.layer = FLY_LAYER
		slmaster.mouse_opacity = 0

		world.update_status()

		ClearTempbans()

		setup_objects()

		setupgenetics()

		setupmining() //mining setup

		setuptitles()
		SetupAnomalies()
	//	tgrid.Setup()
		setupdooralarms() // Added by Strumpetplaya - Alarm Change
		BOOKHAND = new()
		world << "\red \b Setting up the book system..."

	// main_shuttle = new /datum/shuttle_controller/main_shuttle()
	// Handled by datum declerations now in the shuttle controller file

		if(!ticker)
			ticker = new /datum/controller/gameticker()

		// setup the in-game time
		gametime = rand(0,2200)
		gametime_last_updated = world.timeofday

		spawn
			ticker.pregame()

		world << "\red \b World initialized in [(world.timeofday - start_worldinit)/10] seconds"
		diary << "World initialized in [time2text(world.timeofday, "hh:mm.ss")]. It took [(world.timeofday - start_worldinit)/10] seconds."

	setup_objects()
		world << "\red \b Initializing objects..."
		diary << "Object initialization started at [time2text(world.timeofday, "hh:mm.ss")]"
		sleep(-1)

		var/count_obj = 0
		var/start_objects_init = world.timeofday

		for(var/obj/object in world)
			object.initialize()
			count_obj++

		world << "\red \b [count_obj] objects initialized in [(world.timeofday - start_objects_init)/10] seconds!"
		diary << "Object initialization finished at [time2text(world.timeofday, "hh:mm.ss")]. It took [(world.timeofday - start_objects_init)/10] seconds to start [count_obj] objects."

		world << "\red \b Initializing pipe networks..."
		sleep(-1)

		for(var/obj/machinery/atmospherics/machine in world)
			machine.build_network()


		world << "\red \b Building Unified Networks..."
		diary << "Unified Network creation started at [time2text(world.timeofday, "hh:mm.ss")]"
		var/start_network_creation = world.timeofday

		MakeUnifiedNetworks()

		world << "\red \b Unified Networks created in [(world.timeofday - start_network_creation)/10] seconds!"
		diary << "Unified Networks created in [time2text(world.timeofday, "hh:mm.ss")]. It took [(world.timeofday-start_network_creation)/10] seconds."

		world << "\red \b Initializations complete."

		/*var/list/l = new /list
		var/savefile/f = new("closet.sav")
		var/turf/t = locate(38,56,7)
		f["list"]>>l
		for(var/obj/o in l)
			var/obj/b = new o.type
			//var/obj/b.vars = o.vars.Copy()
			b.loc = t*/


	process()

		if(!processing)
			return 0

		// keep track of the ticks
		tick++

		// update the clock
		// one real-life minute is 100 time-units
		gametime += (100 / 60) * (world.timeofday - gametime_last_updated) / 10
		gametime_last_updated = world.timeofday
		if(gametime > 2200) gametime -= 2200

		/*
		if (start_time - lastannounce >= 18000)
			world << "\blue <b>Automatic Announcement:</b>\n \t The forum went down, so we're now at http://whoopshop.com"
			lastannounce = start_time*/

		if(tick % 60 == 0)
			world.keepalive()

		// reduce frequency of the air process
		if(tick % 5 == 0)
			sleep(1 * tick_multiplier)
			ticker_debug = "Airprocess"
			air_master.process()

		sleep(1 * tick_multiplier)
		ticker_debug = "Sun calc"
		sun.calc_position()

		sleep(-1)

		for(var/mob/M in world)
			ticker_debug = "[M] [M.real_name] life calc"
			M.Life()

		sleep(-1)

		for(var/obj/machinery/machine in machines)
			ticker_debug = "[machine.name] processing"
			machine.process()

		sleep(-1)

		for(var/obj/fire/F in world)
			ticker_debug = "fire processing"
			F.process()

		sleep(1 * tick_multiplier)

		for(var/obj/item/item in processing_items)
			ticker_debug = "[item] [item.name] processing"
			item.process()

		for(var/datum/pipe_network/network in pipe_networks)
			ticker_debug = "pipe processing"
			network.process()

		for(var/OuterKey in AllNetworks)
			ticker_debug = "uninet processing"
			var/list/NetworkSet = AllNetworks[OuterKey]
			for(var/datum/UnifiedNetwork/Network in NetworkSet)
				if(Network)
					Network.Controller.Process()

		for(var/turf/t in processing_turfs)
			ticker_debug = "turf processing"
			t.process()

		if(world.timeofday >= updatetime)
			updatetime = world.timeofday + 3000

		for(var/obj/O in processing_others) // The few exceptions which don't fit in the above lists
			ticker_debug = "[O] [O.name] processing"
			O:process()

		//tgrid.Tick(0) // Part of Alfie's travel code
		sleep(-1)

		ticker.process()

		sleep(10 * tick_multiplier)

		spawn process()

		return 1