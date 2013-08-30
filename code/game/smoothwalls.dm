turf/proc/update_nearby_tiles(need_rebuild)
	if(!air_master) return 0

	var/turf/simulated/source = src
	var/turf/simulated/north = get_step(source,NORTH)
	var/turf/simulated/south = get_step(source,SOUTH)
	var/turf/simulated/east = get_step(source,EAST)
	var/turf/simulated/west = get_step(source,WEST)
	var/turf/simulated/up = get_step_3d(source,UP)
	var/turf/simulated/down = get_step_3d(source,DOWN)

	if(need_rebuild)
		if(istype(source)) //Rebuild/update nearby group geometry
			if(source.parent)
				air_master.groups_to_rebuild += source.parent
			else
				air_master.tiles_to_update += source
		if(istype(north))
			if(north.parent)
				air_master.groups_to_rebuild += north.parent
			else
				air_master.tiles_to_update += north
		if(istype(south))
			if(south.parent)
				air_master.groups_to_rebuild += south.parent
			else
				air_master.tiles_to_update += south
		if(istype(east))
			if(east.parent)
				air_master.groups_to_rebuild += east.parent
			else
				air_master.tiles_to_update += east
		if(istype(west))
			if(west.parent)
				air_master.groups_to_rebuild += west.parent
			else
				air_master.tiles_to_update += west
		if(istype(up))
			if(up.parent)
				air_master.groups_to_rebuild += up.parent
			else
				air_master.tiles_to_update += up
		if(istype(down))
			if(down.parent)
				air_master.groups_to_rebuild += down.parent
			else
				air_master.tiles_to_update += down
	else
		if(istype(source)) air_master.tiles_to_update += source
		if(istype(north)) air_master.tiles_to_update += north
		if(istype(south)) air_master.tiles_to_update += south
		if(istype(east)) air_master.tiles_to_update += east
		if(istype(west)) air_master.tiles_to_update += west
		if(istype(up)) air_master.tiles_to_update += up
		if(istype(down)) air_master.tiles_to_update += down

	return 1


//Separate dm because it relates to two types of atoms + ease of removal in case it's needed.
//Also assemblies.dm for falsewall checking for this when used.
//I should really make the shuttle wall check run every time it's moved, but centcom uses unsimulated floors so !effort

/atom/proc/relativewall() //atom because it should be useable both for walls and false walls
//	if(istype(src,/turf/simulated/floor/vault)||istype(src,/turf/simulated/wall/vault)) //HACK!!!
	if(istype(src,/turf/simulated/wall/heatshield))
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	if(!istype(src,/turf/simulated/shuttle/wall)) //or else we'd have wacky shuttle merging with walls action
		for(var/turf/simulated/wall/W in orange(src,1))
			if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
				junction |= get_dir(src,W)
		for(var/obj/structure/falsewall/W in orange(src,1))
			if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
				junction |= get_dir(src,W)
		for(var/obj/structure/falserwall/W in orange(src,1))
			if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
				junction |= get_dir(src,W)

	if(istype(src,/turf/simulated/wall))
		var/turf/simulated/wall/wall = src
		wall.icon_state = "[wall.walltype][junction]"
	else if (istype(src,/obj/structure/falserwall))
		src.icon_state = "rwall[junction]"
	else if (istype(src,/obj/structure/falsewall))
		var/obj/structure/falsewall/fwall = src
		fwall.icon_state = "[fwall.mineral][junction]"
	return

/atom/proc/relativewall_neighbours()
	for(var/turf/simulated/wall/W in range(src,1))
		W.relativewall()
	for(var/obj/structure/falsewall/W in range(src,1))
		W.relativewall()
		W.update_icon()//Refreshes the wall to make sure the icons don't desync
	for(var/obj/structure/falserwall/W in range(src,1))
		W.relativewall()
	return



/turf/simulated/wall/New()
	update_nearby_tiles(0)
	relativewall_neighbours()
	..()

/turf/simulated/wall/Del()
	update_nearby_tiles(0)

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			W.relativewall()

		for(var/obj/structure/falsewall/W in range(temploc,1))
			W.relativewall()
	..()


/turf/simulated/wall/relativewall()
//	if(istype(src,/turf/simulated/wall/vault)) //HACK!!!
	if(istype(src,/turf/simulated/wall/heatshield))
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	for(var/obj/structure/falserwall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	var/turf/simulated/wall/wall = src
	wall.icon_state = "[wall.walltype][junction]"
	return