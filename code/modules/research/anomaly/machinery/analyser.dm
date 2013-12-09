/obj/machinery/artifact_device/analyser
	name = "Anomaly Analyser"
	desc = "Studies the emissions of anomalous materials to discover their uses."
	icon_state = "anoscan"
	anchored = 1
	density = 1
	var/scan_in_progress = 0
	var/scan_num = 0
	var/obj/scanned_obj
	var/scan_completion_time = 0
	var/scan_duration = 160
	var/obj/scanned_object
	var/report_num = 0

/obj/machinery/artifact_device/analyser/attack_hand(var/mob/user as mob)
	src.add_fingerprint(user)
	interact(user)

/obj/machinery/artifact_device/analyser/RefreshParts()
	..()
	scan_duration = 160
	for(var/obj/item/weapon/stock_parts/scanning_module/SM in component_parts)
		scan_duration -= 20 * SM.rating

	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		scan_duration -= 10 * M.rating

	for(var/obj/item/weapon/stock_parts/micro_laser/ML in component_parts)
		scan_duration -= 10 * ML.rating

/obj/machinery/artifact_device/analyser/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/machine/anoscan(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/artifact_device/analyser/attackby(var/obj/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/screwdriver) && !scan_in_progress)
		if (!open)
			open = 1
			user << "You open the maintenance hatch of [src]."
		else
			open = 0
			user << "You close the maintenance hatch of [src]."
		update_icon()
		return

	else if(istype(O, /obj/item/weapon/crowbar) && open)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		var/obj/structure/frame/machine/M = new /obj/structure/frame/machine(src.loc)
		M.state = 2
		M.icon_state = "box_1"
		for(var/obj/C in component_parts)
			if(C.reliability != 100 && crit_fail)
				C.crit_fail = 1
			C.loc = src.loc

		for(var/obj/I2 in src)
			I2.loc = src.loc

		del(src)
		return 1
	else
		..()

/obj/machinery/artifact_device/analyser/interact(mob/user)
	if(stat & (NOPOWER|BROKEN) || get_dist(src, user) > 1)
		user.unset_machine(src)
		return

	if(open)
		return

	var/dat = "<B>Anomalous material analyser</B><BR>"
	dat += "<HR>"
	if(scan_in_progress)
		dat += "Please wait. Analysis in progress.<br>"
		dat += "<a href='?src=\ref[src];halt_scan=1'>Halt scanning.</a><br>"
	else
		dat += "Scanner is ready.<br>"
		dat += "<a href='?src=\ref[src];begin_scan=1'>Begin scanning.</a><br>"

	dat += "<br>"
	dat += "<hr>"
	dat += "<a href='?src=\ref[src]'>Refresh</a> <a href='?src=\ref[src];close=1'>Close</a>"
	user << browse(dat, "window=artanalyser;size=450x500")
	user.set_machine(src)
	onclose(user, "artanalyser")

/obj/machinery/artifact_device/analyser/process()
	if(scan_in_progress && world.time > scan_completion_time)
		//finish scanning
		scan_in_progress = 0
		updateDialog()

		//print results
		var/results = ""
		if(!scanned_object || scanned_object.loc != locate(src.x + 1, src.y, src.z))
			results = "Unable to locate scanned object. Ensure it was not moved in the process."
		else
			results = get_scan_info(scanned_object)

		src.visible_message("<b>[name]</b> states, \"Scanning complete.\"")
		var/obj/item/weapon/paper/P = new(src.loc)
		P.name = "[src] report #[++report_num]"
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<br>"
		P.info += "\icon[scanned_object] [results]"

		if(scanned_object && istype(scanned_object, /obj/machinery/artifact))
			var/obj/machinery/artifact/A = scanned_object
			A.anchored = 0
			A.being_used = 0

/obj/machinery/artifact_device/analyser/Topic(href, href_list)
	if(..())
		return
	if(open)
		return

	if(href_list["begin_scan"])
		var/artifact_in_use = 0
		for(var/obj/O in locate(src.x + 1, src.y, src.z))
			if(O.invisibility)
				continue

			if(O.pixel_x > 20 || O.pixel_x < -20 || O.pixel_y > 20 || O.pixel_y < -20)
				continue

			scanned_object = O

			if(istype(scanned_object, /obj/machinery/artifact))
				var/obj/machinery/artifact/A = scanned_object
				if(A.being_used)
					artifact_in_use = 1
				else
					A.anchored = 1
					A.being_used = 1

			if(artifact_in_use)
				src.visible_message("<b>[name]</b> states, \"Cannot harvest. Too much interference.\"")
			else
				scanned_object = O
				scan_in_progress = 1
				scan_completion_time = world.time + scan_duration
				src.visible_message("<b>[name]</b> states, \"Scanning begun.\"")
			break
		if(!scanned_object)
			src.visible_message("<b>[name]</b> states, \"Unable to isolate scan target.\"")

	if(href_list["halt_scan"])
		scan_in_progress = 0
		src.visible_message("<b>[name]</b> states, \"Scanning halted.\"")
		if(istype(scanned_object, /obj/machinery/artifact))
			var/obj/machinery/artifact/A = scanned_object
			A.anchored = 0
			A.being_used = 0

	if(href_list["close"])
		usr.unset_machine(src)
		usr << browse(null, "window=artanalyser")

	updateDialog()

//hardcoded responses, oh well
/obj/machinery/artifact_device/analyser/proc/get_scan_info(var/obj/scanned_obj)
	switch(scanned_obj.type)
/*		if(/obj/machinery/auto_cloner)
			return "Automated cloning pod - appears to rely on organic nanomachines with a self perpetuating \
			ecosystem involving self cannibalism and a symbiotic relationship with the contained liquid.<br><br>\
			Structure is composed of a carbo-titanium alloy with interlaced reinforcing energy fields, and the contained liquid \
			resembles proto-plasmic residue supportive of single cellular developmental conditions."*/
		if(/obj/machinery/engine/supermatter)
			return "Super dense plasma clump - Appears to have been shaped or hewn, structure is composed of matter 2000% denser than ordinary carbon matter residue.\
			Potential application as energy source."
/*		if(/obj/structure/constructshell)
			return "Tribal idol - Item resembles statues/emblems built by superstitious pre-warp civilisations to honour their gods. Material appears to be a \
			rock/plastcrete composite."
		if(/obj/machinery/giga_drill)
			return "Automated mining drill - structure composed of titanium-carbide alloy, with tip and drill lines edged in an alloy of diamond and plasma."
		if(/obj/structure/cult/pylon)
			return "Tribal pylon - Item resembles statues/emblems built by cargo cult civilisations to honour energy systems from post-warp civilisations."
		if(/obj/mecha/working/hoverpod)
			return "Vacuum capable repair pod - Item is a remarkably intact single man repair craft capable of flight in a vacuum. Outer shell composed of primarily \
			post-warp hull alloys, with internal wiring and circuitry consistent with modern electronics and engineering."
		if(/obj/machinery/replicator)
			return "Automated construction unit - Item appears to be able to synthesize synthetic items, some with simple internal circuitry. Method unknown, \
			phasing suggested?"
		if(/obj/structure/crystal)
			return "Crystal formation - Pseudo organic crystalline matrix, unlikely to have formed naturally. No known technology exists to synthesize this exact composition."*/
		if(/obj/machinery/artifact)
			//the fun one
			var/obj/machinery/artifact/A = scanned_obj
			var/out = "Anomalous alien device - Composed of an unknown alloy, "

			//primary effect
			if(A.my_effect)
				//what kind of effect the artifact has
				switch(A.my_effect.effect_type)
					if(1)
						out += "concentrated energy emissions"
					if(2)
						out += "intermittent psionic wavefront"
					if(3)
						out += "electromagnetic energy"
					if(4)
						out += "high frequency particles"
					if(5)
						out += "organically reactive exotic particles"
					if(6)
						out += "interdimensional/bluespace? phasing"
					if(7)
						out += "atomic synthesis"
					else
						out += "low level energy emissions"
				out += " have been detected "

				//how the artifact does it's effect
				switch(A.my_effect.effect_type)
					if(1)
						out += " emitting in an ambient energy field."
					if(2)
						out += " emitting in periodic bursts."
					else
						out += " interspersed throughout substructure and shell."

				if(A.my_effect.trigger >= 0 && A.my_effect.trigger <= 4)
					out += " Activation index involves physical interaction with artifact surface."
				else if(A.my_effect.trigger >= 5 && A.my_effect.trigger <= 8)
					out += " Activation index involves energetic interaction with artifact surface."
				else if(A.my_effect.trigger >= 9 && A.my_effect.trigger <= 12)
					out += " Activation index involves precise local atmospheric conditions."
				else
					out += " Unable to determine any data about activation trigger."

			//secondary:
			if(A.secondary_effect && A.secondary_effect.activated)
				//sciencey words go!
				out += "<br><br>Warning, internal scans indicate ongoing [pick("subluminous","subcutaneous","superstructural")] activity operating \
				independantly from primary systems. Auxiliary activity involves "

				//what kind of effect the artifact has
				switch(A.secondary_effect.effect_type)
					if(1)
						out += "concentrated energy emissions"
					if(2)
						out += "intermittent psionic wavefront"
					if(3)
						out += "electromagnetic energy"
					if(4)
						out += "high frequency particles"
					if(5)
						out += "organically reactive exotic particles"
					if(6)
						out += "interdimensional/bluespace? phasing"
					if(7)
						out += "atomic synthesis"
					else
						out += "low level radiation"

				//how the artifact does it's effect
				switch(A.secondary_effect.effect_type)
					if(1)
						out += " emitting in an ambient energy field."
					if(2)
						out += " emitting in periodic bursts."
					else
						out += " interspersed throughout substructure and shell."

				if(A.secondary_effect.trigger >= 0 && A.secondary_effect.trigger <= 4)
					out += " Activation index involves physical interaction with artifact surface, but subsystems indicate \
					anomalous interference with standard attempts at triggering."
				else if(A.secondary_effect.trigger >= 5 && A.secondary_effect.trigger <= 8)
					out += " Activation index involves energetic interaction with artifact surface, but subsystems indicate \
					anomalous interference with standard attempts at triggering."
				else if(A.secondary_effect.trigger >= 9 && A.secondary_effect.trigger <= 12)
					out += " Activation index involves precise local atmospheric conditions, but subsystems indicate \
					anomalous interference with standard attempts at triggering."
				else
					out += " Unable to determine any data about activation trigger."
			return out
		else
			//it was an ordinary item
			return "[scanned_obj.name] - Mundane application, composed of carbo-ferritic alloy composite."