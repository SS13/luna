/obj/machinery/anomaly/anomalyanalyser
	name = "Anomaly Analyser"
	var/scanning = 0
	var/analysing = 0
	var/spectral = 0
	var/pause = 0
	var/obj/item/weapon/disk/anomalyfilter/filter
	var/maxid = 1



/obj/machinery/anomaly/anomalyanalyser/attackby(var/obj/I as obj, var/mob/user as mob)

	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/frame/computer/A = new /obj/structure/frame/computer( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/computer/diseasesplicer/M = new /obj/item/weapon/circuitboard/computer/diseasesplicer( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/frame/computer/A = new /obj/structure/frame/computer( src.loc )
				var/obj/item/weapon/circuitboard/computer/diseasesplicer/M = new /obj/item/weapon/circuitboard/computer/diseasesplicer( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)

	if(istype(I,/obj/item/weapon/anomaly))
		if(!anomaly)
			anomaly = I
			user.drop_item()
			anomaly.loc.contents.Remove(anomaly)
			anomaly.loc = src
			for(var/mob/M in viewers(src))
				if(M == user)	continue
				M.show_message("\blue [user.name] inserts the [anomaly.name] in the [src.name]", 3)
			if(!anomaly.id)
				anomaly.id = maxid
				maxid++
				for(var/obj/machinery/anomaly/anomalyanalyser/an in world)
					an.maxid = maxid
				anomaly.name = "Anomaly A-[anomaly.id]"
	if(istype(I,/obj/item/weapon/disk/anomalyfilter))
		if(!filter)
			user << "You insert the [I.name]."
			user.drop_item()
			I.loc = src
			filter = I


	//else
	src.attack_hand(user)
	return

/obj/machinery/anomaly/anomalyanalyser/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/anomaly/anomalyanalyser/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/anomaly/anomalyanalyser/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(analysing)
		dat = "Analysing in progress"
	else if(scanning)
		dat = "Scanning in progress"
	else if(spectral)
		dat = "Spectral scan in progress"
	else
		if(anomaly)
			dat = "[anomaly.name] inserted"
			dat += "<BR><A href='?src=\ref[src];eject=1'>Eject</a>"
			dat += "<BR><A href='?src=\ref[src];analyse=1'>Analyse</a>"
			if(filter)
				dat += "<BR><BR>[filter.name] inserted"
				dat += "<BR><A href='?src=\ref[src];spectral=1'>High fidelity spectral scan</a>"
				dat += "<BR><A href='?src=\ref[src];ejectf=1'>Eject filter</a>"
			else
				dat += "<BR>Please insert filter for spectral scan"
		else
			dat = "Please insert anomaly"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return



/obj/machinery/anomaly/anomalyanalyser/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	src.updateDialog()


	if(analysing)
		analysing -= 1
		if(!analysing)
			state("The [src.name] pings", "blue")
			var/r = "[anomaly.name]"
			r += "<BR>Range	: [anomaly.effect.range]"
			r += "<BR>Magnitude : [anomaly.effect.magnitude]"
			r += "<BR>Effect : [anomaly.effect.fluff]"
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src.loc)
			P.name = "Results"
			P.info = r
			icon_state = "analyser"

	if(spectral)
		spectral -= 1
		if(!spectral)
			state("The [src.name] beeps", "blue")
			filter.effectname = anomaly.effect.effectname
			filter.name = "Spectral filter A-[anomaly.id]"
			filter.desc = "Spectral filter for \"[anomaly.effect.fluff]\""
			filter.loc = src.loc
			filter = null
			icon_state = "analyser"

	return

/obj/machinery/anomaly/anomalyanalyser/Topic(href, href_list)
	if(..())
		return
	if (usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf)) || istype(usr, /mob/living/silicon))
		usr.machine = src

		if (href_list["analyse"])
			analysing = 15
			icon_state = "analyser_processing"
		if (href_list["spectral"])
			spectral = 40
			icon_state = "analyser_processing"
		if (href_list["eject"])
			src.anomaly.loc = src.loc
			src.anomaly = null
		if (href_list["ejectf"])
			src.filter.loc = src.loc
			src.filter = null
		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/item/weapon/disk/anomalyfilter
	name = "Spectral filter"
	icon = 'items.dmi'
	icon_state = "datadisk0"
	var/effectname = null