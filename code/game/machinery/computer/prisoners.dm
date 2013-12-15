/obj/machinery/computer/prisoner
	name = "Prisoner Management Console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "explosive"
	req_access = list(access_armory)
	circuit = "/obj/item/weapon/circuitboard/computer/prisoner"
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

	attack_paw(var/mob/user as mob)
		return

	attack_hand(var/mob/user as mob)
		if(..())
			return
		user.set_machine(src)
		var/dat = ""
		if(screen == 0)
			dat += "<HR><A href='?src=\ref[src];lock=1'>Unlock Console</A>"
		else if(screen == 1)
			dat += "<H3>Prisoner Implant Management</H3>"
			dat += "<HR>Chemical Implants<BR>"
			var/turf/Tr = null
			for(var/obj/item/weapon/implant/chem/prison/C in world)
				Tr = get_turf(C)
				if(Tr && Tr.z > 4)	continue //Out of range
				if(!C.implanted) continue
				dat += "[C.implanted.name] | Remaining Units: [C.reagents.total_volume] | Inject: "
				dat += "<A href='?src=\ref[src];inject1=\ref[C]'>(<font class='bad'>(1)</font>)</A>"
				dat += "<A href='?src=\ref[src];inject5=\ref[C]'>(<font class='bad'>(5)</font>)</A>"
				dat += "<A href='?src=\ref[src];inject10=\ref[C]'>(<font class='bad'>(10)</font>)</A><BR>"
				dat += "********************************<BR>"
			dat += "<HR>Tracking Implants<BR>"
			for(var/obj/item/weapon/implant/tracking/T in world)
				Tr = get_turf(T)
				if(Tr && Tr.z > 4)	continue //Out of range
				if(!T.implanted) continue
				var/loc_display = "Unknown"
				var/mob/living/carbon/M = T.implanted
				if(M.z < 5 && !istype(M.loc, /turf/space))
					var/turf/mob_loc = get_turf(M)
					loc_display = mob_loc.loc
				dat += "ID: [T.id] | Location: [loc_display]<BR>"
				dat += "<A href='?src=\ref[src];warn=\ref[T]'>(<font class='bad'><i>Message Holder</i></font>)</A> |<BR>"
				dat += "********************************<BR>"
			dat += "<HR><A href='?src=\ref[src];lock=1'>Lock Console</A>"

		//user << browse(dat, "window=computer;size=400x500")
		//onclose(user, "computer")
		user << browse(dat, "window=prisonerconsole;size=575x500")
		onclose(user, "prisonerconsole")
		return


	process()
		if(!..())
			src.updateDialog()
		return


	Topic(href, href_list)
		if(..())
			return
		if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || istype(usr, /mob/living/silicon))
			usr.set_machine(src)

			if(href_list["inject1"])
				var/obj/item/weapon/implant/chem/prison/I = locate(href_list["inject1"])
				if(I)	I.activate(1)

			else if(href_list["inject5"])
				var/obj/item/weapon/implant/chem/prison/I = locate(href_list["inject5"])
				if(I)	I.activate(5)

			else if(href_list["inject10"])
				var/obj/item/weapon/implant/chem/prison/I = locate(href_list["inject10"])
				if(I)	I.activate(10)

			else if(href_list["lock"])
				if(src.allowed(usr))
					screen = !screen
				else
					usr << "Unauthorized Access."

			else if(href_list["warn"])
				var/warning = copytext(sanitize(input(usr,"Message:","Enter your message here!","")),1,MAX_MESSAGE_LEN)
				if(!warning) return
				var/obj/item/weapon/implant/I = locate(href_list["warn"])
				if(I && I.implanted)
					var/mob/living/carbon/R = I.implanted
					R << "You hear a voice in your head saying: '[warning]'"
					log_say("[usr]/[usr.ckey] sent an implant message to [R]/[R.ckey]: '[warning]'")

			src.add_fingerprint(usr)
		src.updateUsrDialog()
		return
