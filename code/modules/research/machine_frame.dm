//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/frame/machine //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	anchored = 1
	var/obj/item/weapon/circuitboard/machine/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null // user-friendly names of components
	var/state = 1

// unfortunately, we have to instance the objects really quickly to get the names
// fortunately, this is only called once when the board is added and the items are immediately GC'd
// and none of the parts do much in their constructors
/obj/structure/frame/machine/proc/update_namelist()
	if(!req_components)
		return

	req_component_names = new()
	for(var/tname in req_components)
		var/path = text2path(tname)
		var/obj/O = new path()
		req_component_names[tname] = O.name

// update description of required components remaining
/obj/structure/frame/machine/proc/update_req_desc()
	if(!req_components || !req_component_names)
		return

	var/hasContent = 0
	desc = "Requires"
	for(var/i = 1 to req_components.len)
		var/tname = req_components[i]
		var/amt = req_components[tname]
		if(amt == 0)
			continue
		var/use_and = i == req_components.len
		desc += "[(hasContent ? (use_and ? ", and" : ",") : "")] [amt] [amt == 1 ? req_component_names[tname] : "[req_component_names[tname]]\s"]"
		hasContent = 1

	if(!hasContent)
		desc = "Does not require any more components."
	else
		desc += "."

/obj/structure/frame/machine/attackby(obj/item/P as obj, mob/user as mob)
	if(P.crit_fail)
		user << "\red This part is faulty, you cannot add this to the machine!"
		return
	switch(state)
		if(1)
			if(istype(P, /obj/item/weapon/cable_coil))
				var/obj/item/weapon/cable_coil/C = P
				if(C.amount >= 5)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You start to add cables to the frame."
					if(do_after(user, 20))
						if(C)
							C.amount -= 5
							if(!C.amount) del(C)
							user << "\blue You add cables to the frame."
							state = 2
							icon_state = "box_1"
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user << "\blue You dismantle the frame"
				new /obj/item/stack/sheet/metal(src.loc, 5)
				del(src)

		if(2)
			if(istype(P, /obj/item/weapon/circuitboard/machine))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "\blue You add the circuit board to the frame."
				circuit = P
				user.drop_item()
				P.loc = src
				icon_state = "box_2"
				state = 3
				components = list()
				req_components = circuit.req_components.Copy()
				update_namelist()
				update_req_desc()
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				state = 1
				icon_state = "box_0"
				var/obj/item/weapon/cable_coil/A = new /obj/item/weapon/cable_coil( src.loc )
				A.amount = 5

		if(3)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				state = 2
				circuit.loc = src.loc
				circuit = null
				if(components.len == 0)
					user << "\blue You remove the circuit board."
				else
					user << "\blue You remove the circuit board and other components."
					for(var/obj/item/weapon/W in components)
						W.loc = src.loc
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_1"

			if(istype(P, /obj/item/weapon/screwdriver))
				var/component_check = 1
				for(var/R in req_components)
					if(req_components[R] > 0)
						component_check = 0
						break
				if(component_check)
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					var/obj/machinery/new_machine = new src.circuit.build_path(src.loc)
					for(var/obj/O in new_machine.component_parts)
						del(O)
					new_machine.component_parts = list()
					for(var/obj/O in src)
						O.loc = new_machine
						new_machine.component_parts += O
					circuit.loc = new_machine
					new_machine.RefreshParts()
					del(src)

			if(istype(P, /obj/item/weapon))
				for(var/I in req_components)
					if(istype(P, text2path(I)) && (req_components[I] > 0))
						if(istype(P, /obj/item/weapon/cable_coil))
							var/obj/item/weapon/cable_coil/CP = P
							if(CP.amount > 1)
								var/obj/item/weapon/cable_coil/CC = new /obj/item/weapon/cable_coil(src)
								CC.amount = 1
								components += CC
								req_components[I]--
								update_req_desc()
								break
						user.drop_item()
						P.loc = src
						components += P
						req_components[I]--
						update_req_desc()
						break
				if(P.loc != src && !istype(P, /obj/item/weapon/cable_coil))
					user << "\red You cannot add that component to the machine!"


//Machine Frame Circuit Boards
/*Common Parts: Parts List: Ignitor, Timer, Infra-red laser, Infra-red sensor, t_scanner, Capacitor, Valve, sensor unit,
micro-manipulator, console screen, beaker, Microlaser, matter bin, power cells.
Note: Once everything is added to the public areas, will add m_amt and g_amt to circuit boards since autolathe won't be able
to destroy them and players will be able to make replacements.
*/

/obj/item/weapon/circuitboard/machine
	var/build_path = null
	var/list/req_components = list()

/obj/item/weapon/circuitboard/machine/destructive_analyzer
	name = "Circuit board (Destructive Analyzer)"
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	origin_tech = "magnets=2;engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1)

/obj/item/weapon/circuitboard/machine/autolathe
	name = "Circuit board (Autolathe)"
	build_path = /obj/machinery/autolathe
	origin_tech = "engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 3,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/machine/protolathe
	name = "Circuit board (Protolathe)"
	build_path = /obj/machinery/r_n_d/protolathe
	origin_tech = "engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 2,
							"/obj/item/weapon/reagent_containers/glass/beaker" = 2)


/obj/item/weapon/circuitboard/machine/circuit_imprinter
	name = "Circuit board (Circuit Imprinter)"
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	origin_tech = "engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/reagent_containers/glass/beaker" = 2)

/obj/item/weapon/circuitboard/machine/pacman
	name = "Circuit Board (PACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman
	origin_tech = "programming=3:powerstorage=3;plasmatech=3;engineering=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/capacitor" = 1)

/obj/item/weapon/circuitboard/machine/pacman/super
	name = "Circuit Board (SUPERPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = "programming=3;powerstorage=4;engineering=4"

/obj/item/weapon/circuitboard/machine/pacman/mrs
	name = "Circuit Board (MRSPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = "programming=3;powerstorage=5;engineering=5"

/obj/item/weapon/circuitboard/machine/rdserver
	name = "Circuit Board (R&D Server)"
	build_path = /obj/machinery/r_n_d/server
	origin_tech = "programming=3"
	req_components = list(
							"/obj/item/weapon/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/scanning_module" = 1)

/obj/item/weapon/circuitboard/machine/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator
	origin_tech = "programming=3;engineering=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/machine/clonepod
	name = "Circuit board (Clone Pod)"
	build_path = /obj/machinery/clonepod
	origin_tech = "programming=3;biotech=3"
	req_components = list(
							"/obj/item/weapon/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 2,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/machine/clonescanner
	name = "Circuit board (Cloning Scanner)"
	build_path = /obj/machinery/dna_scannernew
	origin_tech = "programming=2;biotech=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/weapon/cable_coil" = 2)

/obj/item/weapon/circuitboard/machine/anoscan
	name = "Circuit board (Anomaly Analyser)"
	build_path = /obj/machinery/artifact_device/analyser
	origin_tech = "magnets=3;programming=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/machine/anocol
	name = "Circuit board (Exotic Particle Harvester)"
	build_path = /obj/machinery/artifact_device/harvester
	origin_tech = "magnets=3;programming=3;powerstorage=4"
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 3,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)