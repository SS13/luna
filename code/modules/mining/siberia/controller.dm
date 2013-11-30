var/datum/siberia_controller/siberia_controller

/datum/siberia_controller
	var/list/prisoners = list("Unknown" = 87) // prisoner.name = points
	var/list/maint_doors
	var/obj/machinery/mineral/stacking_machine/stacker
	var/maint_status = "closed"

	New()
		..()
		stacker = locate() in /area/asteroid/siberia

		for(var/obj/machinery/door/poddoor/D in /area/asteroid/siberia)
			if(D.id == "siberia_maint")
				maint_doors.Add(D)


	proc/stacker_drop()
		if(stacker)
			stacker.drop_stacks()

	proc/toggle_maint()
		if(maint_status == "closed")
			for(var/obj/machinery/door/poddoor/D in maint_doors)
				D.open()
			maint_status = "open"
		else
			for(var/obj/machinery/door/poddoor/D in maint_doors)
				D.close()
			maint_status = "closed"

	proc/get_points(var/name = "Unknown") // Returns points by prisoner's name.
		if(!(name in prisoners))
			prisoners[name] = 500 // If there is no prisoner, create him!
		return prisoners[name]

	proc/get_points_text(var/name = "Unknown")
		var/points = get_points(name)

		if(points)
			return "[points] points left."
		else
			return "No points left. You can leave the labor camp now."

	proc/adjust_points(var/name = "Unknown", var/points = 0)
		prisoners[name] = max(get_points(name) - points, 0)
		return get_points(name)

	proc/get_prisoners_list()
		var/list/rt = prisoners
		rt -= "Unknown" // Unknown is easter egg, shitcurity mustn't know about him.
		return rt