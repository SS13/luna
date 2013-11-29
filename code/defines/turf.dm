/turf
	icon = 'floors.dmi'
	var/intact = 1

	level = 1.0

	var
		//Properties for open tiles (/floor)
		oxygen = 0
		carbon_dioxide = 0
		nitrogen = 0
		toxins = 0

		//Properties for airtight tiles (/wall)
		thermal_conductivity = 0.05
		heat_capacity = 1

		//Properties for both
		temperature = T20C

		blocks_air = 0
		icon_old = null
		pathweight = 1
		list/obj/machinery/network/wirelessap/wireless = list( )
		explosionstrength = 1 //NEVER SET THIS BELOW 1
		floorstrength = 6

/turf/proc/Bless()
	if(flags & NOJAUNT)
		return
	flags |= NOJAUNT

/turf/space
	icon = 'space.dmi'
	name = "space"
	icon_state = "placeholder"
	temperature = TSPC
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000
	mouse_opacity = 2

/turf/space/New()
	. = ..()
	icon = 'space.dmi'
	icon_state = "[rand(1,25)]"

/turf/space/proc/Check()
	var/turf/T = locate(x, y, z + 1)
	if(T)
		if(!istype(T, /turf/space) && !istype(T, /turf/unsimulated))
			var/turf/space/S = src
			var/turf/simulated/floor/open/open = new(src)
			open.LightLevelRed = S.LightLevelRed
			open.LightLevelBlue = S.LightLevelBlue
			open.LightLevelGreen = S.LightLevelGreen
			open.ul_UpdateLight()



/turf/simulated/floor/prison			//Its good to be lazy.
	name = "Welcome to Admin Prison"
	wet = 0
	image/wet_overlay = null

	thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/simulated/floor/engine/vacuum
	oxygen = 0
	nitrogen = 0.000
	temperature = TSPC

///turf/space/hull //TEST
/turf/space/hull
	name = "hull plating"
	icon = 'floors.dmi'
	icon_state = "engine"

/turf/space/hull/New()
	return
/*	oxygen = 0
	nitrogen = 0.000
	temperature = TSPC
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000*/

/turf/simulated/floor
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "floor"
	thermal_conductivity = 0.040
	heat_capacity = 225000
	var/broken = 0
	var/burnt = 0
	var/turf/simulated/floor/open/open = null

	New()
		..()
		var/turf/T = locate(x,y,z-1)
		if(T)
			if(istype(T, /turf/simulated/floor/open))
				open = T
				open.update()

	Enter(var/atom/movable/AM)
		. = ..()
		if(open && istype(open))
			open.update()

	Exit(var/atom/movable/AM)
		. = ..()
		if(open && istype(open))
			open.update()

	airless
		name = "floor"
		oxygen = 0.01
		nitrogen = 0.01
		temperature = TSPC

	open
		name = "open space"
		intact = 0
		icon_state = "open"
		pathweight = 100000 //Seriously, don't try and path over this one numbnuts
		var/icon/darkoverlays = null
		var/turf/floorbelow
		floorstrength = 1

		mouse_opacity = 2

		New()
			..()
			if(z > 4)
				new/turf/space(src)
				return

			spawn(1)
				if(!istype(src, /turf/simulated/floor/open)) //This should not be needed but is.
					return

				floorbelow = locate(x, y, z + 1)
				if(ticker)
					add_to_other_zone()
				update()
			var/turf/T = locate(x, y, z + 1)
			if(T)
				//Fortunately, I've done this before. - Aryn
				if(istype(T,/turf/space) || T.z > 4)
					new/turf/space(src)
				else if(!istype(T,/turf/simulated/floor))
					new/turf/simulated/floor/plating(src)
				/*
				switch (T.type) //Somehow, I don't think I thought this cunning plan all the way through - Sukasa
					if (/turf/simulated/floor)
						//Do nothing - valid
					if (/turf/simulated/floor/plating)
						//Do nothing - valid
					if (/turf/simulated/floor/engine)
						//Do nothing - valid
					if (/turf/simulated/floor/engine/vacuum)
						//Do nothing - valid
					if (/turf/simulated/floor/airless)
						//Do nothing - valid
					if (/turf/simulated/floor/grid)
						//Do nothing - valid
					if (/turf/simulated/floor/plating/airless)
						//Do nothing - valid
					if (/turf/simulated/floor/open)
						//Do nothing - valid
					if (/turf/space)
						var/turf/space/F = new(src)									//Then change to a Space tile (no falling into space)
						F.name = F.name
						return
					else
						var/turf/simulated/floor/plating/F = new(src)				//Then change to a floor tile (no falling into unknown crap)
						F.name = F.name
						return*/
		Del()
			if(zone)
				zone.Disconnect(src,floorbelow)
			. = ..()


		Enter(var/atom/movable/AM)
			if (..()) //TODO make this check if gravity is active (future use) - Sukasa
				spawn(1)
					if(AM && !AM.anchored)
						AM.Move(locate(x, y, z + 1))
						if(AM.loc == locate(x, y, z + 1))
							if (istype(AM, /mob))
								AM:adjustBruteLoss(10)
								AM:weakened = max(AM:weakened,5)
								AM:updatehealth()
			return ..()


		attackby(obj/item/C as obj, mob/user as mob)
			if (istype(C, /obj/item/stack/rods))
				if(locate(/obj/structure/lattice, src)) return
				user << "\blue Constructing support lattice ..."
				playsound(src.loc, 'Genhit.ogg', 50, 1)
				new /obj/structure/lattice(src)
				C:use(1)
				return
			if (istype(C, /obj/item/stack/tile/metal))
				var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
				if(L)
					del(L)
					playsound(src.loc, 'Genhit.ogg', 50, 1)
					C:build(src)
					C:use(1)
					return

				else
					user << "\red The plating is going to need some support."
			return


		proc
			update() //Update the overlayss to make the openspace turf show what's down a level
				if(!floorbelow) return
				src.clearoverlays()
				src.addoverlay(floorbelow)

				for(var/obj/o in floorbelow.contents)
					if(!(o.pixel_x < -12 || o.pixel_y < -12 || o.pixel_x > 12 || o.pixel_y > 12 || istype(o, /obj/effect)))
						src.addoverlay(image(o, dir=o.dir, layer = TURF_LAYER+0.05*o.layer))

				var/image/I = image('ULIcons.dmi', "[min(max(floorbelow.LightLevelRed - 4, 0), 7)]-[min(max(floorbelow.LightLevelGreen - 4, 0), 7)]-[min(max(floorbelow.LightLevelBlue - 4, 0), 7)]")
				I.layer = TURF_LAYER + 0.2
				src.addoverlay(I)
				I = image('ULIcons.dmi', "1-1-1")
				I.layer = TURF_LAYER + 0.2
				src.addoverlay(I)

			process_extra()
				if(!floorbelow) return
				if(istype(floorbelow,/turf/simulated)) //Infeasibly complicated gooncode for the Elder System. =P
					var/turf/simulated/FB = floorbelow
					if(parent && parent.group_processing)
						if(FB.parent && FB.parent.group_processing)
							parent.air.share(FB.parent.air)

						else
							parent.air.share(FB.air)
					else
						if(FB.parent && FB.parent.group_processing)
							air.share(FB.parent.air)
						else
							air.share(FB.air)
					//var/datum/gas_mixture/fb_air = FB.return_air(1)
					//var/datum/gas_mixture/my_air = return_air(1)
					//my_air.share(fb_air)
					//my_air.temperature_share(fb_air,FLOOR_HEAT_TRANSFER_COEFFICIENT)
				else
					air.mimic(floorbelow,1)
					air.temperature_mimic(floorbelow,FLOOR_HEAT_TRANSFER_COEFFICIENT,1)

				if(floorbelow.zone && zone)
					if(!(floorbelow.zone in zone.connections))
						zone.Connect(src,floorbelow)

	plating
		name = "plating"
		icon_state = "plating"
		intact = 0



/proc/update_open()
	for(var/turf/simulated/floor/open/a in world)
		a.update()

/turf/simulated/floor/plating/airless
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TSPC

/turf/simulated/floor/grid
	icon = 'floors.dmi'
	icon_state = "circuit"

/turf/simulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "wall0"
	opacity = 1
	density = 1
	blocks_air = 1
	explosionstrength = 2
	floorstrength = 6
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall
	var/Zombiedamage

	var/mineral = "metal"
	var/walltype = "metal"

/turf/simulated/wall/r_wall
	name = "reinforced wall"
	icon = 'walls.dmi'
	icon_state = "r_wall"
	opacity = 1
	density = 1
	var/d_state = 0
	walltype = "rwall"
	explosionstrength = 4

/turf/simulated/wall/r_wall/explosionproof/ex_act(severity)
	return

/turf/simulated/wall/mineral
	name = "mineral wall"
	desc = "This shouldn't exist"
	icon_state = ""
	var/last_event = 0
	var/active = null

/turf/simulated/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon_state = "gold0"
	walltype = "gold"
	mineral = "gold"
	//var/electro = 1
	//var/shocked = null

/turf/simulated/wall/mineral/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	icon_state = "silver0"
	walltype = "silver"
	mineral = "silver"
	//var/electro = 0.75
	//var/shocked = null

/turf/simulated/wall/mineral/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon_state = "diamond0"
	walltype = "diamond"
	mineral = "diamond"

/turf/simulated/wall/mineral/clown
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon_state = "clown0"
	walltype = "clown"
	mineral = "clown"

/turf/simulated/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon_state = "sandstone0"
	walltype = "sandstone"
	mineral = "sandstone"

/turf/simulated/wall/mineral/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon_state = "uranium0"
	walltype = "uranium"
	mineral = "uranium"

/turf/simulated/wall/mineral/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon_state = "plasma0"
	walltype = "plasma"
	mineral = "plasma"



/turf/simulated/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon_state = "cult"
	walltype = "cult"

/turf/simulated/wall/heatshield
	thermal_conductivity = 0
	opacity = 0
	explosionstrength = 5
	name = "heat shielding"
	icon = 'thermal.dmi'
	icon_state = "thermal"

/turf/simulated/wall/heatshield/attackby()
	return
/turf/simulated/wall/heatshield/attack_hand()
	return

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 10000000

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall"
	explosionstrength = 4
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/wall/other
	icon = 'walls.dmi'
	icon_state = "riveted"

/turf/unsimulated
	name = "Command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/shuttle
	name = "Shuttle"
	icon = 'shuttle.dmi'

/turf/unsimulated/shuttle/floor
	name = "Shuttle Floor"
	icon_state = "floor"

/turf/unsimulated/shuttle/wall
	name = "Shuttle Wall"
	icon_state = "wall"
	opacity = 1
	density = 1

/turf/unsimulated/floor
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density && !LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
			L.Add(t)
	return L

/turf/proc/Railturfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density && !LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
			if(locate(/obj/rail) in t)
				L.Add(t)
	return L

/turf/proc/Distance(turf/t)
	if(!src || !t)
		return 1e31
	t = get_turf(t)
	if(get_dist(src, t) == 1 || src.z != t.z)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y) + (src.z - t.z) * (src.z - t.z) * 3
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return max(get_dist(src,t), 1)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/process()
	return