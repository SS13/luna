/datum/event/gasleak

	Lifetime = 10

	Announce()
		var/list/possible_leaks = list()
		for(var/obj/machinery/portable_atmospherics/canister/C)
			if(istype(C, /obj/machinery/portable_atmospherics/canister/toxins) || istype(C, /obj/machinery/portable_atmospherics/canister/sleeping_agent) || istype(C, /obj/machinery/portable_atmospherics/canister/carbon_dioxide))
				continue
			possible_leaks += C


		for(var/i = 1, i <= rand(1,3), i++)
			var/obj/machinery/M = pick(possible_leaks)
			if(istype(M,/obj/machinery/portable_atmospherics/canister))
				var/obj/machinery/portable_atmospherics/canister/C = M
				if(prob(10))
					C.health = 0
					C.healthcheck()
				else
					C.release_pressure = rand(ONE_ATMOSPHERE,10*ONE_ATMOSPHERE)
					C.valve_open = 1