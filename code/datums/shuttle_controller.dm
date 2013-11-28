/* Controls the emergency shuttle */
//This code needs major cleanup
//The way that the goons setup the shuttle was VERY VERY VERY wierd

// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
#define SHUTTLEARRIVETIME 600		// 10 minutes = 600 seconds
#define PODLAUNCHTIME 600
#define PODTRANSITTIME 150
#define SHUTTLELEAVETIME 10		// 3 minutes = 180 seconds


//Areas, centcom(start),station(dest),transit(deepspace)
//Endtime holds the time that the shuttle will arrive
//All shuttle code now uses timeleft() to get a countdown
//When countdown reaches 0, shuttle moves

//At all times while the countdown is not 0, if the shuttle is online, it ensures that it is in the transit space
//Direction determines where to go next (0 = transit, 1 = Start, 2 = dest), it hasn't been tested when set to 0, but it might work
//Online is weither the shuttle is actaully countingdown and moving (hard one to guess)

var/global/datum/shuttle/main_shuttle
var/global/list/datum/shuttle/shuttles = list()
var/global/list/datum/shuttle/prisonshuttles = list()

/datum/shuttle
	var
		name = "Shuttle"
		location = 1 // 0 = Transit, 1 = Start, 2 = dest
		online = 0
		direction = 1 // 1 = Start, 2 = Dest

		area/centcom //Destination
		area/station //Start
		area/transit //Transit area

		turf_to_leave_station // Shuttle turf in start will be replaced with it after departure
		turf_to_leave_centcom // Shuttle turf in destination will be replaced with it after departure

		endtime		 // timeofday that shuttle arrives
		//timeleft = 360 //600


	New(var/name, var/station, var/transit, var/centcom)
		src.name = name
		src.station = station
		src.transit = transit
		src.centcom = centcom

	proc/depart()
		settimeleft(PODTRANSITTIME)
		online = 1
		if(location == 1)
			direction = 2
		else
			direction = 1

	proc/recall()
		if(direction == 1)
			setdirection(2)
			online = 1
		else
			setdirection(1)
			online = 1

	proc/abletolaunch()
		if(location != 0 && online == 0)
			return 1
		else
			return 0

	// returns the time (in seconds) before shuttle arrival
	proc/timeleft()
		if(online)
			var/timeleft = round((endtime - world.timeofday)/10 ,1)
			return timeleft
		else
			return PODTRANSITTIME

	// sets the time left to a given delay (in seconds)
	proc/settimeleft(var/delay)
		endtime = world.timeofday + delay * 10

	// sets the shuttle direction

	//1 = Starting location,2 = Destination, 0 = Deep space
	proc/setdirection(var/dirn)
		if(direction == dirn)
			return
		direction = dirn
		// if changing direction, flip the timeleft by SHUTTLEARRIVETIME
		var/ticksleft = endtime - world.timeofday
		endtime = world.timeofday + (SHUTTLEARRIVETIME*10 - ticksleft)
		return

	proc
		process()
			if(!online) return
			var/timeleft = timeleft()
			if(timeleft > 1e5)		// midnight rollover protection
				timeleft = 0
			switch(location)

				//If at location 1 or 2 (Starting points), and the timer is still running, then move to the transit point

				if(1)
					if(timeleft>0)
					//	world << "MOVE"
						var/area/start_location = locate(station)
						var/area/end_location = locate(transit)
						for(var/mob/m in start_location)
							shake_camera(m, 3, 1)
						for(var/obj/machinery/door/unpowered/shuttle/D in start_location) // Made doors close when pod launches, too --Mloc
							if(!D.density)
								D.close()
						for(var/turf/simulated/shuttle/wall/S in start_location)
							if(S.icon_state == "wall_hull")
								S.icon_state = "wall_space"  // Quickish hack to fix the hull sprites moving with the pod --Mloc
						start_location.move_contents_to(end_location, /turf/space/hull)
						location = 0
						direction = 2

				if(0)
					if(timeleft > 0)
						return 0

					else if(timeleft <= 0)
						//Move
						location = direction

						var/area/start_location = locate(transit)
						var/area/end_location
						if(direction == 1)
							end_location = locate(station)
						else
							end_location = locate(centcom)

						var/list/dstturfs = list()
						var/throwy = world.maxy

						for(var/turf/T in end_location)
							dstturfs += T
							if(T.y < throwy)
								throwy = T.y

						// hey you, get out of the way!
						for(var/turf/T in dstturfs)
							// find the turf to move things to
							var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
							for(var/atom/movable/AM as mob|obj in T)
								AM.Move(D)
							if(istype(T, /turf/simulated))
								del(T)
						for(var/mob/m in start_location)
							shake_camera(m, 3, 1)
						start_location.move_contents_to(end_location, /turf/space)


						online = 0

						return 1

				if(2)
					if(timeleft>0)
				//		world << "MOVE"
						var/area/start_location = locate(station)
						for(var/mob/m in start_location)
							shake_camera(m, 3, 1)
						var/area/end_location = locate(transit)
						start_location.move_contents_to(end_location, /turf/space)
						location = 0
						direction = 1

				else
					return 1



proc/CreateShuttles() //Would do this via config, but map changes are rare and need source code anyway
	var/datum/shuttle/pod1 = new /datum/shuttle("Escape pod 1","/area/shuttle/escape/station/pod1","/area/shuttle/escape/transit/pod1","/area/shuttle/escape/centcom/pod1")
	var/datum/shuttle/pod2 = new /datum/shuttle("Escape pod 2","/area/shuttle/escape/station/pod2","/area/shuttle/escape/transit/pod2","/area/shuttle/escape/centcom/pod2")
	var/datum/shuttle/prisonshuttle/prisonshuttle1 = new /datum/shuttle/prisonshuttle("Prison Shuttle","/area/shuttle/prison/station","/area/shuttle/prison/transit","/area/shuttle/prison/prison")
	shuttles += pod1
	shuttles += pod2
	prisonshuttles += prisonshuttle1
	main_shuttle = pod1 // Hack, until proper gameplay for multiple shuttles is established

/datum/PodControl
	var/endtime
	var/online = 0
	var/departed = 0

	var/last60 = 0
	var/unlocked = 0

	proc/start()
		settimeleft(PODLAUNCHTIME)
		online = 1
		last60 = timeleft()

		spawn(0)
			for(var/area/ToggleAlert in world)
				if (ToggleAlert.applyalertstatus && ToggleAlert.type != /area)
					ToggleAlert.redalert = 1

	proc/stop()
		online = 0

	proc/timeleft()
		var/timeleft = round((endtime - world.timeofday)/10 ,1)
		return timeleft

	proc/settimeleft(var/delay)
		endtime = world.timeofday + delay * 10


	proc/process()
		//world << "PODCONo[timeleft()]"
		var/timeleft = timeleft()
		if(timeleft > 1e5)		// midnight rollover protection
			timeleft = 0

		if(online && !unlocked)
			for(var/datum/shuttle/s in shuttles)
				var/area/shuttle_area = locate(s.station)
				for(var/obj/machinery/door/unpowered/shuttle/d in shuttle_area)
					d.locked = 0
			unlocked = 1

		if(online && timeleft() < last60)
			if(timeleft > 60)
				radioalert("Escape Computer", "[round(timeleft()/60,1)] minutes until escape pod launch.")
				if(timeleft() - 60 > 60)
					last60 = timeleft() - 60
				else
					last60 = 60
			else if(timeleft > 30)
				radioalert("Escape Computer", "[round(timeleft(),1)] seconds until escape pod launch.")
				if(timeleft() - 10 > 10)
					last60 = timeleft() - 10
				else
					last60 = timeleft() - 1
			else
				if(timeleft() > 0)
					radioalert("Escape Computer", "[round(timeleft(),1)] seconds.")
				else
					radioalert("Escape Computer", "Escape pods launched.")
				last60 = timeleft() - 1


		if(online && timeleft <= 0)
			for(var/datum/shuttle/s in shuttles)
				s.depart()
			online = 0
			departed = 1



/proc/radioalert(var/message,var/from)
	var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
	a.autosay(message, from)


/datum/shuttle/prisonshuttle
	name = "Prison Shuttle"
	location = 1 // 0 = Transit, 1 = Start, 2 = dest
	online = 0
	direction = 1 // 1 = Start, 2 = Dest
	area/centcom //Destination
	area/station //Start
	area/transit //Transit area
	endtime		 // timeofday that shuttle arrives
		//timeleft = 360 //600

	depart()
		settimeleft(20)
		online = 1
		if(location == 1)
			direction = 2
		else
			direction = 1
	recall()
		settimeleft(20)
		online = 1
		if(direction == 1)
			setdirection(2)
		else
			setdirection(1)

	process()
		if(!online) return
		var/timeleft = timeleft()
		if(timeleft > 1e5)		// midnight rollover protection
			timeleft = 0

		switch(location) //If at location 1 or 2 (Starting points), and the timer is still running, then move to the transit point
			if(1)
				//world << "HURR 1"
				if(timeleft > 0)
				//	world << "MOVE"
					var/area/start_location = locate(station)
					var/area/end_location = locate(transit)
					for(var/mob/m in start_location)
						shake_camera(m, 3, 1)
					for(var/obj/machinery/door/poddoor/D in start_location) /* Made doors close when pod launches, too --Mloc */
						if(!D.density)
							D.close()
							for(var/obj/machinery/door/poddoor/D2 in orange(1,D))
								if(!D2.density)
									D2.close()

					for(var/turf/simulated/shuttle/wall/S in start_location)
						if(S.icon_state == "wall3_hull")
							S.icon_state = "wall3_space"  /* Quickish hack to fix the hull sprites moving with the pod --Mloc */
					start_location.move_contents_to(end_location, /turf/space/hull)
					location = 0
					direction = 2
					//radioalert("Prison Notice", "Prisoner Shuttle has departed.")

			if(0)
				if(timeleft > 0)
					return 0

				else if(timeleft <= 0)
					//Move
					var/area/start_location = locate(transit)
					var/area/end_location
					var/opendoorsid
					if(direction == 1)
						end_location = locate(station)
						opendoorsid = "siberia_shuttle_ship"
						for(var/turf/simulated/shuttle/wall/S in start_location)
							if(S.icon_state == "wall3_space")
								S.icon_state = "wall3_hull"
					else
						end_location = locate(centcom)
						opendoorsid = "siberia_shuttle_camp"

					var/list/dstturfs = list()
					var/throwy = world.maxy

					for(var/turf/T in end_location)
						dstturfs += T
						if(T.y < throwy)
							throwy = T.y

					// hey you, get out of the way!
					for(var/turf/T in dstturfs)
						// find the turf to move things to
						var/turf/D = locate(T.x, throwy - 1, 1)
						//var/turf/E = get_step(D, SOUTH)
						for(var/atom/movable/AM as mob|obj in T)
							AM.Move(D)
						if(istype(T, /turf/simulated))
							del(T)
					for(var/mob/m in start_location)
						shake_camera(m, 3, 1)
					start_location.move_contents_to(end_location, /turf/space)
					location = direction

					for(var/obj/machinery/door/poddoor/D in end_location) /* Made doors open when pod arrives, too --ACCount */
						if(D.id == opendoorsid)
							D.open()
							for(var/obj/machinery/door/poddoor/D2 in orange(1,D))
								if(D2.id == opendoorsid)
									D2.open()

					online = 0
					PrisonControl.location = direction
					PrisonControl.departed = 0
					//radioalert("Prison Notice", "Prisoner Shuttle has arrived at the prison.")

					return 1

			if(2)
				//world << "HURRR 2"
				if(timeleft > 0)
				//	world << "MOVE"
					var/area/start_location = locate(centcom)
					var/area/end_location = locate(transit)
					for(var/mob/m in start_location)
						shake_camera(m, 3, 1)
					for(var/obj/machinery/door/poddoor/D in start_location) /* Made doors close when pod launches, too --Mloc */
						if(!D.density)
							D.close()
							for(var/obj/machinery/door/poddoor/D2 in orange(1,D))
								if(!D2.density)
									D2.close()
					start_location.move_contents_to(end_location, /turf/space)
					location = 0
					direction = 1
					//radioalert("Prison Notice", "Prisoner Shuttle has departed.")

			else
				return 1


/datum/PodControl/prisonPodControl
	endtime
	online = 0
	departed = 0
	var/location = 1

	last60 = 0
	unlocked = 0

	start()
		settimeleft(20)
		online = 1
		last60 = timeleft()

	proc/recall()
		for(var/datum/shuttle/prisonshuttle/s in prisonshuttles)
			s.recall()
		online = 0
		departed = 1
		if(siberia_controller)
			siberia_controller.stacker_drop()

	process()
		//world << "PODCON[timeleft()]"
		var/timeleft = timeleft()
		if(timeleft > 1e5)		// midnight rollover protection
			timeleft = 0

		if(online && timeleft <= 0)
			for(var/datum/shuttle/prisonshuttle/s in prisonshuttles)
				s.depart()
			online = 0
			departed = 1