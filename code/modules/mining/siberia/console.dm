/obj/machinery/computer/siberia/control
	name = "Shuttle Control Console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_generic"
	req_access = list(access_brig)

	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

	attack_paw(var/mob/user as mob)
		return

	attackby()
		return

	attack_hand(var/mob/user as mob)
		if(..())
			return
		user.set_machine(src)
		var/dat = ""
		dat += "Siberia v1.3"

		if(PrisonControl.departed)
			dat += "<BR>Shuttle in flight..."
		else if(PrisonControl.location == 1)
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=call-shuttle'>Send Shuttle</A> \]"
		else
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=recall-shuttle'>Send Shuttle</A> \]"

		if(siberia_controller)
			dat += "<BR><BR><BR>"
			if(src.allowed(user))
				var/list/prisoners = siberia_controller.get_prisoners_list()
				if(prisoners.len)
					dat += "There is [prisoners.len] records in database."
					for(var/prisoner_name in prisoners)
						dat += "<BR>[prisoner_name] "
						dat += "<A HREF='?src=\ref[src];record_adjust=[prisoner_name];amount=1000'>---</A> "
						dat += "<A HREF='?src=\ref[src];record_adjust=[prisoner_name];amount=100'>--</A> "
						dat += "<A HREF='?src=\ref[src];record_adjust=[prisoner_name];amount=10'>-</A> "
						dat += prisoners[prisoner_name]
						dat += " <A HREF='?src=\ref[src];record_adjust=[prisoner_name];amount=-10'>+</A> "
						dat += "<A HREF='?src=\ref[src];record_adjust=[prisoner_name];amount=-100'>++</A> "
						dat += "<A HREF='?src=\ref[src];record_adjust=[prisoner_name];amount=-1000'>+++</A> "
				else
					dat += "There is no records in database."

				dat += "<BR><A HREF='?src=\ref[src];new_record=1'>New Record</A>"

				dat += "<BR><BR>Maintence status: [siberia_controller.maint_status]. <A HREF='?src=\ref[src];operation=maint_toggle'>Toggle</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=stacker_drop'>Empty Stacking Unit</A>"
			else
				dat += siberia_controller.get_points_text(user.name)

		user << browse(dat, "window=siberia;size=400x500")
		onclose(user, "computer")
		return

	Topic(href, href_list)
		if(..())
			return
		usr.machine = src

		if(href_list["operation"])
			switch(href_list["operation"])
				if("call-shuttle")
					PrisonControl.start()
					usr << "Labor camp shuttle launching in 20 seconds."
				if("recall-shuttle")
					PrisonControl.recall()
					usr << "Labor camp shuttle launching in 20 seconds."
				if("maint_toggle")
					if(siberia_controller)
						siberia_controller.toggle_maint()
				if("stacker_drop")
					if(siberia_controller)
						siberia_controller.stacker_drop()

		if(href_list["record_adjust"] && siberia_controller)
			siberia_controller.adjust_points(href_list["record_adjust"], text2num(href_list["amount"]))

		if(href_list["new_record"] && siberia_controller)
			var/newname = input("Siberia v1.3", "Enter Record Name:") as text|null
			if(newname)
				siberia_controller.get_points(newname)

		src.updateUsrDialog()

/obj/machinery/computer/siberia/control/wall
	name = "Labor Camp Console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console_small"
	density = 0