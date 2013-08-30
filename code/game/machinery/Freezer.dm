/obj/machinery/atmospherics/unary/cold_sink/freezer
	name = "Freezer"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "freezer_0"
	density = 1
	anchored = 1

	current_heat_capacity = 1000

	New()
		..()
		initialize_directions = dir

	initialize()
		if(node) return

		var/node_connect = dir

		for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
			if(target.initialize_directions & get_dir(target,src))
				node = target
				break

		update_icon()


	update_icon()
		if(src.node)
			if(src.on)
				icon_state = "freezer_1"
			else
				icon_state = "freezer"
		else
			icon_state = "freezer_0"
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_paw(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		user.machine = src
		var/temp_text = ""
		if(air_contents.temperature > (T0C - 20))
			temp_text = "<span class='bad'>[air_contents.temperature]</span>"
		else if(air_contents.temperature < (T0C - 20) && air_contents.temperature > (T0C - 100))
			temp_text = "<span class='average'>[air_contents.temperature]</span>"
		else
			temp_text = "<span class='good'>[air_contents.temperature]</span>"

		var/dat = {"
		Current Status: [ on ? "<A href='?src=\ref[src];start=1'>Off</A> <span class='linkOn'>On</span>" : "<span class='linkOn'>Off</span> <A href='?src=\ref[src];start=1'>On</A>"]<BR>
		Current Gas Temperature: [temp_text]<BR>
		Current Air Pressure: [air_contents.return_pressure()]<BR>
		Target Gas Temperature: <A href='?src=\ref[src];temp=-100'>-</A> <A href='?src=\ref[src];temp=-10'>-</A> <A href='?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='?src=\ref[src];temp=1'>+</A> <A href='?src=\ref[src];temp=10'>+</A> <A href='?src=\ref[src];temp=100'>+</A><BR>
		"}

		user << browse(dat, "window=freezer;size=400x500")
		onclose(user, "freezer")

	Topic(href, href_list)
		if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
			usr.machine = src
			if (href_list["start"])
				src.on = !src.on
				update_icon()
			if(href_list["temp"])
				var/amount = text2num(href_list["temp"])
				if(amount > 0)
					src.current_temperature = min(T20C, src.current_temperature+amount)
				else
					src.current_temperature = max((T0C - 200), src.current_temperature+amount)
		src.updateUsrDialog()
		src.add_fingerprint(usr)
		return

	process()
		..()
		src.updateUsrDialog()