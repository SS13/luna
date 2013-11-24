/obj/machinery/computer/siberia/airlock
	name = "airlock console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console_small"
	density = 0
	req_access = list(access_brig)
	var/obj/machinery/door/poddoor/door_in
	var/obj/machinery/door/poddoor/door_out

	New()
		..()
		spawn(5)
			for(var/obj/machinery/door/poddoor/D in range(2, src))
				if(D.id == "siberia_airlock_in")
					door_in = D
				else if(D.id == "siberia_airlock_out")
					door_out = D


	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

	attack_paw(var/mob/user as mob)
		return

	attackby()
		return

	attack_hand(var/mob/user as mob)
		if(..())
			return

		if(user.loc != src.loc)
			return

		if(src.allowed(user))
			return

		user.set_machine(src)
		var/dat = ""
		dat += "Siberia v1.3<BR><BR>"
		dat += siberia_controller.get_points_text(user.name)
		if(!siberia_controller.get_points(user.name))
			dat += "<BR>\[ <A HREF='?src=\ref[src];open=1'>Open Door</A> \]"
		user << browse(dat, "window=siberia;size=400x500")
		onclose(user, "computer")
		return

	Topic(href, href_list)
		if(..())
			return
		usr.machine = src

		if(href_list["open"])
			door_in.close()
			door_out.open()
			radioalert("Labor Camp", "[usr.name] is leaving the camp.")
			spawn(100)
				door_in.open()
				door_out.close()

		src.updateUsrDialog()