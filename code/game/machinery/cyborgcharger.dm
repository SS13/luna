/obj/machinery/cyborgcharger
	name = "Cyborg Charging Station"
	icon = 'cyborgcharger.dmi'
	icon_state = "charge"
	density = 0
	anchored = 1
	dir = 4
	var/powerrate = 20

/obj/machinery/cyborgcharger/process()
	if(powered())
		for(var/obj/mecha/M in src.loc)
			var/added
			if(M.cell)
				added = M.cell.maxcharge/20*powerrate
				M.cell:give(added*powerrate)
				use_power(added*powerrate)

		for(var/mob/living/silicon/robot/R in src.loc)
			var/added
			if(R.cell)
				added = R.cell.maxcharge/20*powerrate
				if(R.module_state_1)
					added+=5
				if(R.module_state_2)
					added+=5
				if(R.module_state_3)
					added+=5
				R.cell:give(added)
			use_power(added)
			/*The following was added for cyborgchargers to refill cyborg modules.
			if(R.class == "standard")		Removed Standard module refilling to fix problem with standard robots standing on recharge pad being unable to pick a module.
				R.module_state_1 = null
				R.module_state_2 = null
				R.module_state_3 = null
				del(R.module)
				R.module = new /obj/item/weapon/robot_module/standard(src)*/
			if(R.class == "engineer")
				R.deactivate_all_modules()
				del(R.module)
				R.module = new /obj/item/weapon/robot_module/engineering(src)
			if(R.class == "medical")
				R.deactivate_all_modules()
				del(R.module)
				R.module = new /obj/item/weapon/robot_module/medical(src)
			if(R.class == "security")
				R.deactivate_all_modules()
				del(R.module)
				R.module = new /obj/item/weapon/robot_module/security(src)
			if(R.class == "janitor")
				R.deactivate_all_modules()
				del(R.module)
				R.module = new /obj/item/weapon/robot_module/janitor(src)
	return ..()

/obj/machinery/cyborgcharger/power_change()
	if(powered())
		stat &= ~NOPOWER
		src.icon_state = "charge"
	else
		stat |= NOPOWER
		src.icon_state = "charge0"
	return

