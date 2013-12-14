/datum/mind
	var/key
	var/mob/current
	var/name

	var/memory

	var/assigned_role
	var/special_role

	var/datum/changeling/changeling

	var/title
	var/datum/logging/log

	var/list/datum/objective/objectives = list()

	var/rev_cooldown = 0



	proc/transfer_to(mob/new_character)
		if(current)
			current.mind = null

		new_character.mind = src
		current = new_character

		if(ticker.mode.name == "rp-revolution" && (src in ticker.mode:head_revolutionaries | ticker.mode:revolutionaries))
			current.verbs += /mob/living/carbon/human/proc/RevConvert

		new_character.key = key

	proc/store_memory(new_text)
		memory += "[new_text]<BR>"

	proc/show_memory(mob/recipient)
		var/output = "<B>[current.real_name]'s Memory</B><HR>"
		output += memory

		if(objectives.len>0)
			output += "<HR><B>Objectives:</B>"

			var/obj_count = 1
			for(var/datum/objective/objective in objectives)
				output += "<B>Objective #[obj_count]</B>: [objective.explanation_text]<br>"
				obj_count++

		recipient << browse(output,"window=memory")
	New()
		log = new /datum/logging


	proc/edit_memory()		//This is called by admin panels to edit traitor objectives.
		var/dat = "<B>[current.real_name]</B><br>"
		var/datum/game_mode/current_mode = ticker.mode
		switch (current_mode.config_tag)
			if("malfunction")
				if (src in current_mode:malf_ai)
					dat += "<font color=red>Malfunction</font>"

		if(src in current_mode.traitors)
			dat += "<b>Traitor</b> | "
			dat += "<a href='?src=\ref[src];traitorize=syndicate'>Syndicate Operative</a> | "
			dat += "<a href='?src=\ref[src];traitorize=civilian'>Not Traitor</a> <br>"
		else if(src in current_mode.syndicates)
			dat += "<a href='?src=\ref[src];traitorize=traitor'>Traitor</a> | "
			dat += "<font color=red>Syndicate Operative</font> | "
			dat += "<a href='?src=\ref[src];traitorize=civilian'>Not Traitor</a> <br>"
		else
			dat += "<a href='?src=\ref[src];traitorize=traitor'>Traitor</a> | "
			dat += "<a href='?src=\ref[src];traitorize=syndicate'>Syndicate Operative</a> | "
			dat += "<B>Not Traitor</B> <br>"

		if(src in current_mode.head_revolutionaries)
			dat += "<font color=red>Head Revolutionary</font> | "
			dat += "<a href='?src=\ref[src];revolution=rev'>Revolutionary</a> | "
			dat += "<a href='?src=\ref[src];revolution=civilian'>Civilian</a> <br>"
		else if(src in current_mode.revolutionaries)
			dat += "<a href='?src=\ref[src];revolution=headrev'>Head Revolutionary</a> | "
			dat += "<font color=red>Revolutionary</font> | "
			dat += "<a href='?src=\ref[src];revolution=civilian'>Civilian</a> <br>"
		else
			dat += "<a href='?src=\ref[src];revolution=headrev'>Head Revolutionary</a> | "
			dat += "<a href='?src=\ref[src];revolution=rev'>Revolutionary</a> | "
			dat += "<b>Civilian</b> <br>"

		if((src in current_mode.changelings) || changeling)
			dat += "<b>Changeling</b> | "
			dat += "<a href='?src=\ref[src];changeling=clear'>Not Changeling</a> <br>"
		else
			dat += "<a href='?src=\ref[src];changeling=changeling'>Changeling</a> | "
			dat += "<B>Not Changeling</B> <br>"


		dat += "<br>"
		dat += "Memory:<hr>"
		if(!memory)
			dat += "EMPTY"
		else
			dat += memory
		dat += "<hr><a href='?src=\ref[src];memory_edit=1'>Edit memory</a><br>"
		dat += "Objectives:<br>"
		if (objectives.len == 0)
			dat += "EMPTY<br>"
		else
			var/obj_count = 1
			for(var/datum/objective/objective in objectives)
				dat += "<B>#[obj_count]</B>: [objective.explanation_text] <a href='?src=\ref[src];obj_edit=\ref[objective]'>Edit</a> <a href='?src=\ref[src];obj_delete=\ref[objective]'>Delete</a><br>"
				obj_count++
		dat += "<br><a href='?src=\ref[src];obj_add=1'>Add objective</a><br>"
		dat += "<a href='?src=\ref[src];obj_random=1'>Randomize objectives</a><br>"
		dat += "<a href='?src=\ref[src];obj_announce=1'>Announce objectives</a><br><br>"
		dat += "Admin Note: Add objectives first, before you make them traitor."

		usr << browse(dat, "window=edit_memory[src]")


	Topic(href, href_list)
		if (href_list["role_edit"])
			var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in get_all_jobs()
			if (!new_role) return
			assigned_role = new_role

		else if (href_list["memory_edit"])
			var/new_memo = input("Write new memory", "Memory", memory) as message
			if (!new_memo) return
			memory = new_memo

		else if (href_list["obj_edit"] || href_list["obj_add"])
			var/datum/objective/objective
			var/objective_pos
			var/def_value

			if (href_list["obj_edit"])
				objective = locate(href_list["obj_edit"])
				if (!objective) return
				objective_pos = objectives.Find(objective)

				//Text strings are easy to manipulate. Revised for simplicity.
				var/temp_obj_type = "[objective.type]"//Convert path into a text string.
				def_value = copytext(temp_obj_type, 19)//Convert last part of path into an objective keyword.
				if(!def_value)//If it's a custom objective, it will be an empty string.
					def_value = "custom"

			var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null|anything in list("assassinate", "debrain", "stealreagent"/*, "prevent"*/, "hijack", "escape", "survive", "steal", "stealreagent", "nuclear", /*"download", "capture",*/ "absorb", "custom")
			if (!new_obj_type) return

			var/datum/objective/new_objective = null

			switch (new_obj_type)
				if ("assassinate","protect","debrain")
					//To determine what to name the objective in explanation text.
					var/objective_type_capital = uppertext(copytext(new_obj_type, 1,2))//Capitalize first letter.
					var/objective_type_text = copytext(new_obj_type, 2)//Leave the rest of the text.
					var/objective_type = "[objective_type_capital][objective_type_text]"//Add them together into a text string.

					var/list/possible_targets = list("Free objective")
					for(var/datum/mind/possible_target in ticker.minds)
						if ((possible_target != src) && istype(possible_target.current, /mob/living/carbon/human))
							possible_targets += possible_target.current

					var/mob/def_target = null
					var/objective_list[] = list(/datum/objective/assassinate/*, /datum/objective/protect, /datum/objective/debrain*/)
					if (objective&&(objective.type in objective_list) && objective:target)
						def_target = objective:target.current

					var/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
					if (!new_target) return

					var/objective_path = text2path("/datum/objective/[new_obj_type]")
					if (new_target == "Free objective")
						new_objective = new objective_path
						new_objective.owner = src
						new_objective:target = null
						new_objective.explanation_text = "Free objective"
					else
						new_objective = new objective_path
						new_objective.owner = src
						new_objective:target = new_target:mind
						//Will display as special role if the target is set as MODE. Ninjas/commandos/nuke ops.
						new_objective.explanation_text = "[objective_type] [new_target:real_name], the [new_target:mind:assigned_role=="MODE" ? (new_target:mind:special_role) : (new_target:mind:assigned_role)]."

/*				if ("prevent")
					new_objective = new /datum/objective/block
					new_objective.owner = src*/

				if ("hijack")
					new_objective = new /datum/objective/hijack
					new_objective.owner = src

				if ("escape")
					new_objective = new /datum/objective/escape
					new_objective.owner = src

				if ("survive")
					new_objective = new /datum/objective/survive
					new_objective.owner = src

				if ("nuclear")
					new_objective = new /datum/objective/nuclear
					new_objective.owner = src

				if ("steal")
					if (!istype(objective, /datum/objective/steal))
						new_objective = new /datum/objective/steal
						new_objective.owner = src
					else
						new_objective = objective
					var/datum/objective/steal/steal = new_objective
					if (!steal.select_target())
						return

				if ("stealreagent")
					if (!istype(objective, /datum/objective/stealreagent))
						new_objective = new /datum/objective/stealreagent
						new_objective.owner = src
					else
						new_objective = objective
					var/datum/objective/stealreagent/steal = new_objective
					if (!steal.select_target())
						return

				if("download","capture","absorb")
					var/def_num
					if(objective&&objective.type==text2path("/datum/objective/[new_obj_type]"))
						def_num = objective.target_amount

					var/target_number = input("Input target number:", "Objective", def_num) as num|null
					if (isnull(target_number))//Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
						return

					switch(new_obj_type)
		/*				if("download")
							new_objective = new /datum/objective/download
							new_objective.explanation_text = "Download [target_number] research levels."
						if("capture")
							new_objective = new /datum/objective/capture
							new_objective.explanation_text = "Accumulate [target_number] capture points."*/
						if("absorb")
							new_objective = new /datum/objective/absorb
							new_objective.explanation_text = "Absorb [target_number] compatible genomes."
					new_objective.owner = src
					new_objective.target_amount = target_number

				if ("custom")
					var/expl = copytext(sanitize(input("Custom objective:", "Objective", objective ? objective.explanation_text : "") as text|null),1,MAX_MESSAGE_LEN)
					if (!expl) return
					new_objective = new /datum/objective
					new_objective.owner = src
					new_objective.explanation_text = expl

			if (!new_objective) return

			if (objective)
				objectives -= objective
				objectives.Insert(objective_pos, new_objective)
				message_admins("[key_name_admin(usr)] edited [current]'s objective to [new_objective.explanation_text]")
				log_admin("[key_name(usr)] edited [current]'s objective to [new_objective.explanation_text]")
			else
				objectives += new_objective
				message_admins("[key_name_admin(usr)] added a new objective for [current]: [new_objective.explanation_text]")
				log_admin("[key_name(usr)] added a new objective for [current]: [new_objective.explanation_text]")

		else if (href_list["obj_delete"])
			var/datum/objective/objective = locate(href_list["obj_delete"])
			if (!objective) return

			objectives -= objective

		else if (href_list["traitorize"])
			var/datum/game_mode/current_mode = ticker.mode
			switch (href_list["traitorize"])
				if("syndicate")
					var/obj/effect/landmark/synd_spawn = locate("landmark*Syndicate-Spawn")
					current.loc = get_turf(synd_spawn)
					current_mode.equip_syndicate(current)
					current_mode.syndicates += src

					if (src in current_mode.traitors)
						current_mode.traitors -= src

				if("traitor")
					current_mode.equip_traitor(current)
					current_mode.traitors += src
					current << "<B>You are the traitor.</B>"
					special_role = "traitor"

					if (src in current_mode.syndicates)
						current_mode.syndicates -= src

					var/obj_count = 1
					current << "\blue Your current objectives:"
					for(var/datum/objective/objective in objectives)
						current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
						obj_count++

				if("civilian")
					if (src in current_mode.traitors)
						current_mode.traitors -= src
						src.current << "\red <B>You are no longer a traitor!</B>"

						// remove traitor uplinks
						var/list/L = current.get_contents()
						for (var/t in L)
							if (istype(t, /obj/item/device/pda))
								if (t:uplink) del(t:uplink)
								t:uplink = null
							else if (istype(t, /obj/item/device/radio))
								if (t:uplink) del(t:uplink)
								t:uplink = null
								t:traitor_frequency = 0.0

					if (src in current_mode.syndicates)
						current_mode.syndicates -= src
						src.current << "\red <B>You are no longer a Syndicate operative!</B>"

					special_role = null
					memory = ""

		else if (href_list["revolution"])
			switch(href_list["revolution"])
				if("rev")
					if(src in ticker.mode.head_revolutionaries)
						ticker.mode.head_revolutionaries -= src
						ticker.mode.update_rev_icons_removed(src)
						current << "\red <FONT size = 3><B>Revolution has been disappointed of your leader traits! You are a regular revolutionary now!</B></FONT>"
					else if(!(src in ticker.mode.revolutionaries))
						current << "\red <FONT size = 3> You are now a revolutionary! Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them kill the heads to win the revolution!</FONT>"
					else
						return
					ticker.mode.revolutionaries += src
					ticker.mode.update_rev_icons_added(src)
					special_role = "Revolutionary"
					message_admins("[key_name_admin(usr)] has rev'ed [current].")
					log_admin("[key_name_admin(usr)] has rev'ed [current].")

				if("headrev")
					if(src in ticker.mode.revolutionaries)
						ticker.mode.revolutionaries -= src
						ticker.mode.update_rev_icons_removed(src)
						current << "\red <FONT size = 3><B>You have proved your devotion to revoltion! You are a head revolutionary now!</B></FONT>"
					else if(!(src in ticker.mode.head_revolutionaries))
						current << "\red <FONT size = 3><B>You are a member of the revolutionaries' leadership now!</B></FONT>"
					else
						return
					if (ticker.mode.head_revolutionaries.len>0)
						// copy targets
						var/datum/mind/valid_head = locate() in ticker.mode.head_revolutionaries
						if (valid_head)
							for (var/datum/objective/assassinate/O in valid_head.objectives)
								var/datum/objective/assassinate/rev_obj = new
								rev_obj.owner = src
								rev_obj.target = O.target
								rev_obj.explanation_text = "Assassinate [O.target.name], the [O.target.assigned_role]."
								objectives += rev_obj
					ticker.mode.head_revolutionaries += src
					ticker.mode.update_rev_icons_added(src)
					special_role = "Head Revolutionary"
					message_admins("[key_name_admin(usr)] has head-rev'ed [current].")
					log_admin("[key_name_admin(usr)] has head-rev'ed [current].")

				if("flash")
					if (!ticker.mode.equip_revolutionary(current))
						usr << "\red Spawning flash failed!"

				if("takeflash")
					var/list/L = current.get_contents()
					var/obj/item/device/flash/flash = locate() in L
					if (!flash)
						usr << "\red Deleting flash failed!"
					del(flash)

				if("reequip")
					var/list/L = current.get_contents()
					var/obj/item/device/flash/flash = locate() in L
					del(flash)
					var/fail = 0
					fail |= !ticker.mode.equip_traitor(current, 1)
					fail |= !ticker.mode.equip_revolutionary(current)
					if (fail)
						usr << "\red Reequipping revolutionary goes wrong!"

				if("civilian")
					if(src in ticker.mode.revolutionaries)
						ticker.mode.revolutionaries -= src
						current << "\red <FONT size = 3><B>You have been brainwashed! You are no longer a revolutionary!</B></FONT>"
						ticker.mode.update_rev_icons_removed(src)
					if(src in ticker.mode.head_revolutionaries)
						ticker.mode.head_revolutionaries -= src
						current << "\red <FONT size = 3><B>You have been brainwashed! You are no longer a head revolutionary!</B></FONT>"
						ticker.mode.update_rev_icons_removed(src)
					memory = ""
					special_role = null

		else if (href_list["changeling"])
			switch(href_list["changeling"])
				if("clear")
					if(src in ticker.mode.changelings)
						ticker.mode.changelings -= src
						special_role = null
						current.remove_changeling_powers()
						current.verbs -= /datum/changeling/proc/EvolutionMenu
						current << "<FONT color='red' size = 3><B>You grow weak and lose your powers! You are no longer a changeling and are stuck in your current form!</B></FONT>"
						message_admins("[key_name_admin(usr)] has de-changeling'ed [current].")
						log_admin("[key_name_admin(usr)] has de-changeling'ed [current].")
					if(changeling)
						del(changeling)
				if("changeling")
					if(!(src in ticker.mode.changelings))
						ticker.mode.changelings += src
						current.make_changeling()
						special_role = "Changeling"
						current << "<B><font color='red'>Your powers are awoken. A flash of memory returns to us...we are a changeling!</font></B>"
						message_admins("[key_name_admin(usr)] has changeling'ed [current].")
						log_admin("[key_name_admin(usr)] has changeling'ed [current].")
				if("autoobjectives")
					SelectChangelingObjectives(src.assigned_role, src)
					usr << "\blue The objectives for changeling [key] have been generated. You can edit them and anounce manually."

				if("initialdna")
					if( !changeling || !changeling.absorbed_dna.len || !istype(current, /mob/living/carbon))
						usr << "\red Resetting DNA failed!"
					else
						var/mob/living/carbon/C = current
						C.dna = changeling.absorbed_dna[1]
						C.real_name = C.dna.real_name
						updateappearance(C)
						domutcheck(C, null)

		else if (href_list["obj_announce"])
			var/obj_count = 1
			current << "\blue Your current objectives:"
			for(var/datum/objective/objective in objectives)
				current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
				obj_count++

		else if (href_list["obj_random"])
			clear_memory()
			for(var/datum/objective/deleteobj in objectives)
				objectives -= deleteobj
			SelectObjectives(assigned_role, src)

		else if (href_list["clear_memory"])
			clear_memory(0)

		edit_memory()


	proc/clear_memory(var/silent = 1)
		var/datum/game_mode/current_mode = ticker.mode

		// remove traitor uplinks
		var/list/L = current.get_contents()
		for (var/t in L)
			if (istype(t, /obj/item/device/pda))
				if (t:uplink) del(t:uplink)
				t:uplink = null
			else if (istype(t, /obj/item/device/radio))
				if (t:uplink) del(t:uplink)
				t:uplink = null
				t:traitor_frequency = 0.0

		// clear memory
		memory = ""
		special_role = null

		// remove from traitors list
		if(src in current_mode.traitors)
			current_mode.traitors -= src
			if (!silent)
				src.current << "\red <B>You are no longer a traitor!</B>"

		if(src in current_mode.revolutionaries)
			current_mode.revolutionaries -= src
			if (!silent)
				current << "\red <FONT size = 3><B>You have been brainwashed! You are no longer a revolutionary!</B></FONT>"
			current_mode.update_rev_icons_removed(src)
		if(src in current_mode.head_revolutionaries)
			current_mode.head_revolutionaries -= src
			if (!silent)
				current << "\red <FONT size = 3><B>You have been brainwashed! You are no longer a head revolutionary!</B></FONT>"
			current_mode.update_rev_icons_removed(src)

		if(src in current_mode.syndicates)
			current_mode.syndicates -= src
			if (!silent)
				src.current << "\red <B>You are no longer a nuclear operative!</B>"





/datum/logging
	var/writes = 0

	var/list/logs = list()
	var/area/loc = null

	proc/log_m(var/logtext,var/mob/mob)
		logs += "[logtext] - [mob.name]([mob.real_name])([mob.key]) - [world.timeofday]"
		writes += 1
		if(writes > 100)
			return // Write contents to file here
	proc/updateloc(var/area/area,var/mob/mob)
		if(loc != area.master)
			loc = area.master
			log_m("Moved to [loc.name]",mob)