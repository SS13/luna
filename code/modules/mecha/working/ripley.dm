/obj/mecha/working/ripley
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world."
	name = "APLU \"Ripley\""
	icon_state = "ripley"
	step_in = 6
	max_temperature = 20000
	health = 200
	wreckage = /obj/structure/mecha_wreckage/ripley
	var/list/cargo = new
	var/cargo_capacity = 15


/obj/mecha/working/ripley/shitty
	desc = "You can't describe this awful... Mecha?"
	name = "\"Frankenstein\""
	icon_state = "shit"

/obj/mecha/working/ripley/firefighter
	desc = "Standart APLU chassis was refitted with additional thermal protection."
	name = "APLU \"Firefighter\""
	icon_state = "firefighter"
	max_temperature = 65000
	health = 250
	lights_power = 8
	damage_absorption = list("fire"=0.5,"bullet"=0.8,"bomb"=0.5)
	wreckage = /obj/structure/mecha_wreckage/ripley/firefighter

/obj/mecha/working/ripley/deathripley
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	name = "DEATH-RIPLEY"
	icon_state = "deathripley"
	step_in = 4
	opacity=0
	lights_power = 60
	wreckage = /obj/structure/mecha_wreckage/ripley/deathripley
	step_energy_drain = 0

/obj/mecha/working/ripley/deathripley/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/safety_clamp
	ME.attach(src)
	return

/obj/mecha/working/ripley/mining
	desc = "An old, dusty mining ripley."
	name = "APLU \"Miner\""

/obj/mecha/working/ripley/mining/New()
	..()
	//Attach drill
	if(prob(40)) //Possible diamond drill... Feeling lucky?
		var/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill/D = new /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
		D.attach(src)
	else
		var/obj/item/mecha_parts/mecha_equipment/tool/drill/D = new /obj/item/mecha_parts/mecha_equipment/tool/drill
		D.attach(src)

	//Attach hydrolic clamp
	var/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/HC = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	HC.attach(src)
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)//Deletes the beacon so it can't be found easily
		del (B)

/obj/mecha/working/ripley/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()

/obj/mecha/working/ripley/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && O in src.cargo)
			src.occupant_message("\blue You unload [O].")
			O.loc = get_turf(src)
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return



/obj/mecha/working/ripley/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/working/ripley/Del()
	for(var/mob/M in src)
		if(M==src.occupant)
			continue
		M.loc = get_turf(src)
		M.loc.Entered(M)
		step_rand(M)
	for(var/atom/movable/A in src.cargo)
		A.loc = get_turf(src)
		var/turf/T = get_turf(A)
		if(T)
			T.Entered(A)
		step_rand(A)
	..()
	return




/obj/mecha/working/ripley/syndie
	desc = "OH SHIT IT'S THE SYNDICATE WE'RE ALL GONNA DIE"
	name = "APLU \"REAPER\""
	icon_state = "deathripley"
	step_in = 3
	health = 300
	lights_power = 60
	wreckage = /obj/structure/mecha_wreckage/ripley/deathripley
	cargo_capacity = 10
	var/thrusters = 0

/obj/mecha/working/ripley/syndie/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/D = new /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
	D.attach(src)
	D = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	D.attach(src)
	D = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	D.attach(src)
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)//Deletes the beacon so it can't shut down easily
		del (B)

/obj/mecha/working/ripley/syndie/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle thrusters"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(src.occupant)
		if(get_charge() > 0)
			thrusters = !thrusters
			src.log_message("Toggled thrusters.")
			src.occupant_message("<font color='[src.thrusters?"blue":"red"]'>Thrusters [thrusters?"en":"dis"]abled.")
	return

/obj/mecha/working/ripley/syndie/relaymove(mob/user,direction)
	if(user != src.occupant) //While not "realistic", this piece is player friendly.
		user.loc = get_turf(src)
		user << "You climb out from [src]"
		return 0
	if(!can_move)
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port")
			last_message = world.time
		return 0
	if(!thrusters && src.pr_inertial_movement.active())
		return 0
	if(state || !has_charge(step_energy_drain))
		return 0
	var/tmp_step_in = step_in
	var/tmp_step_energy_drain = step_energy_drain
	var/move_result = 1
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		mechsteprand()
	else if(direction == UP || direction == DOWN)
		move_result = move_z(cardinal)
	else if(src.dir!=direction)
		mechturn(direction)
	else
		mechstep(direction)
	if(move_result)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
				if(thrusters)
					src.pr_inertial_movement.set_process_args(list(src,direction))
					tmp_step_energy_drain = step_energy_drain*2

		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0

/obj/mecha/working/ripley/syndie/move_z(cardinal)
	if (!thrusters) return 0
	if (z > 4)
		occupant << "\red There is nothing of interest in that direction."
		return
	switch(cardinal)
		if (UP) // Going up!
			if(z != 1) // If we aren't at the very top of the ship
				var/turf/T = locate(x, y, z - 1)
				// You can only jetpack up if there's space above, and you're sitting on either hull (on the exterior), or space
				if(T && istype(T, /turf/space) && istype(loc, /turf/space))
					step(src, cardinal)
					return 1
				else occupant << "\red You bump into the ship's plating."
			else occupant << "\red The ship's gravity well keeps you in orbit!" // Assuming the ship starts on z level 1, you don't want to go past it

		if (DOWN) // Going down!
			if (z != 4 && z != 5) // If we aren't at the very bottom of the ship, or out in space
				var/turf/T = locate(x, y, z + 1)
				// You can only jetpack down if you're sitting on space and there's space down below, or hull
				if(T && istype(T, /turf/space) && istype(loc, /turf/space))
					step(src, cardinal)
					return 1
				else occupant << "\red You bump into the ship's plating."
			else occupant << "\red The ship's gravity well keeps you in orbit!"
	return 0