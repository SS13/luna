/obj/machinery/anomaly/anomalyharvester
	name = "Anomaly Power Collector"
	var/harvesting = 0
	var/obj/item/weapon/anobattery/anocell
	var/obj/item/weapon/disk/anomalyfilter/filter


/obj/machinery/anomaly/anomalyharvester/attackby(var/obj/I as obj, var/mob/living/user as mob)

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
	if(istype(I,/obj/item/weapon/disk/anomalyfilter))
		if(!filter)
			user << "You insert the filter."
			user.drop_item()
			I.loc = src
			filter = I
	if(istype(I,/obj/item/weapon/anobattery))
		if(!anocell)
			user << "You insert the battery."
			user.drop_item()
			I.loc = src
			anocell = I

	//else
	src.attack_hand(user)
	return

/obj/machinery/anomaly/anomalyharvester/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/anomaly/anomalyharvester/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/anomaly/anomalyharvester/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(harvesting)
		dat = "Harvesting in progress"
	else
		if(anomaly)
			dat = "[anomaly.name] inserted"
			dat += "<BR><A href='?src=\ref[src];eject=1'>Eject anomaly</a>"
			if(anocell && filter)
				dat += "<BR><A href='?src=\ref[src];harvest=1'>Harvest power</a>"
			else
				if(!anocell)
					dat += "<BR>Please insert battery"
				if(!filter)
					dat += "<BR>Please insert filter"
		else
			dat += "Please insert anomaly"
		if(filter)
			dat += "<BR>[filter.name] inserted"
			dat += "<BR><A href='?src=\ref[src];ejectfilter=1'>Eject filter</a>"
		if(anocell)
			dat += "<BR>[anocell.name] inserted - [anocell.GetTotalPower()]/[anocell.capacity]"
			dat += "<BR>Effects:"
			for(var/v in anocell.effects)
				var/datum/anomalyeffect/e = anocell.effects["[v]"]
				dat += "<BR>	[e.fluff] - [anocell.power[e.effectname]]"
			dat += "<BR><A href='?src=\ref[src];ejectanocell=1'>Eject battery</a>"


	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return



/obj/machinery/anomaly/anomalyharvester/process()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)
	src.updateDialog()


	if(harvesting)
		harvesting -= 1
		if(harvesting < 1)
			harvesting = 0

			var/datum/anomalyeffect/effect = new anomaly.effect.type
			if(anocell.AddPower(effect,min(anomaly.effect.magnitude*1.5*(1+(effect.range*0.25)),anocell.capacity-anocell.GetTotalPower())))
				state("The [src.name] pings", "blue")
			else
				state("\red The [src.name] buzzes", "blue")
			icon_state = "analyser"

	return

/obj/machinery/anomaly/anomalyharvester/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["harvest"])
			if(anocell.GetTotalPower() != anocell.capacity)
				if(filter.effectname == anomaly.effect.effectname)
					harvesting = min(anomaly.effect.magnitude/3,(anocell.capacity - anocell.GetTotalPower())/3)
					icon_state = "analyser_processing"
				else
					var/dat = "Error: Filter not suitable for power type."
					usr << browse(dat, "window=computer;size=400x500")
					onclose(usr, "computer")
			else
				var/dat = "Error: Battery full."
				usr << browse(dat, "window=computer;size=400x500")
				onclose(usr, "computer")
		if (href_list["eject"] && anomaly)
			anomaly.loc = src.loc
			anomaly = null

		if (href_list["ejectfilter"] && filter)
			filter.loc = src.loc
			filter = null
		if (href_list["ejectanocell"] && anocell)
			anocell.loc = src.loc
			anocell = null

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

