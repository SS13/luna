var/list/maps
datum/mapobject
	var/name = "NSV Luna"
	var/mapname = "NSV_Luna"
	var/decks = 4


/world/Topic(T, addr, master, key)
	check_diary()
//	world << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/client/C)
			n++
		return n

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		for(var/client/C)
			s["player[n]"] = C.key
			n++
		s["players"] = n
		return list2params(s)
	else if(findtext(T,"MSG:",1,0))
		var/name = copytext(T,findtext(T,":",1,0)+1,findtext(T,"/",1,0))
		var/msg =  copytext(T,findtext(T,"/",1,0)+1,0)
		for (var/client/C)
			if (C.holder)
				C.mob.ctab_message("Admin", "<span class=\"admin\"><span class=\"prefix\">ADMINIRC:</span> <span class=\"name\">[name]:</span> <span class=\"message\">[msg]</span></span>")
	else if(T == "teleplayer")
        //download and open savefile
		var/savefile/F = new(Import())
        //load mob
		var/mob/M
		var {saved_x; saved_y; saved_z}
		F["s_x"] >> saved_x
		F["s_y"] >> saved_y
		F["s_z"] >> saved_z
		F["mob"] >> M
		M.Move(locate(saved_x,saved_y,saved_z))
		return 1
	else if(T == "teleobj")
        //download and open savefile
		var/savefile/F = new(Import())
        //load mob
		var/obj/O
		var {saved_x; saved_y; saved_z}
		F["s_x"] >> saved_x
		F["s_y"] >> saved_y
		F["s_z"] >> saved_z
		F["obj"] >> O
		O.Move(locate(saved_x,saved_y,saved_z))
		return 1
	else if(T == "teleping")
		if(ticker)
			return 1
		return 2

obj/mapinfo
	invisibility = 101
	var/mapname = "thismap"
	var/decks = 4
proc/GetMapInfo()
	var/obj/mapinfo/M = locate()
	world << M.name
	world << M.mapname
proc/replacetext(haystack, needle, replace)
	if(!haystack || !needle || !replace)
		return
	var
		needleLen = length(needle)
		replaceLen = length(replace)
		pos = findtext(haystack, needle)
	while(pos)
		haystack = copytext(haystack, 1, pos) + \
			replace + copytext(haystack, pos+needleLen)
		pos = findtext(haystack, needle, pos+replaceLen)
	return haystack
proc/file2list(A)
	var/text = file2text(A)
	var/list/lines = list()
	var/done
	while (done!=1)
		var/X = findtext(text,"\n",1,0)
		if(!X)
			done = 1
			lines += text
		//	// "DONE"
			break
		else
			var/Y = copytext(text,1,X)
			text = copytext(
			text,X+1,0)
			lines += Y
		sleep(1)
	return lines