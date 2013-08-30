/proc/replace(haystack, needle, newneedle)
	var
		list/find_list = stringsplit(haystack, needle)
		final_text = listjoin(find_list,newneedle)
	return final_text

/proc/listjoin(list/list, delimiter)
	var
		final_text
		iter = 1
	for(var/E in list)
		if(iter > 1) final_text += "[delimiter]"
		final_text += E
		iter++
	return final_text

/proc/get_dir_3d(var/atom/ref, var/atom/target)
	if (get_turf(ref) == get_turf(target))
		return 0
	return get_dir(ref, target) | (target.z > ref.z ? DOWN : 0) | (target.z < ref.z ? UP : 0)

//Bwahahaha! I am extending a built-in proc for personal gain!
//(And a bit of nonpersonal gain, I guess)
/proc/get_step_3d(atom/ref, dir)
	if(!dir)
		return get_turf(ref)
	if(!dir&(UP|DOWN))
		return get_step(ref,dir)
	//Well, it *did* use temporary vars dx, dy, and dz, but this probably should be as fast as possible
	return locate(ref.x+((dir&EAST)?1:0)-((dir&WEST)?1:0),ref.y+((dir&NORTH)?1:0)-((dir&SOUTH)?1:0),ref.z+((dir&DOWN)?1:0)-((dir&UP)?1:0))

/proc/get_dist_3d(var/atom/Ref, var/atom/Trg)
	return max(abs(Trg.x - Ref.x), abs(Trg.y - Ref.y), abs(Trg.z - Ref.z))

/proc/reverse_dir_3d(dir)
	var/ndir = (dir&NORTH)?SOUTH : 0
	ndir |= (dir&SOUTH)?NORTH : 0
	ndir |= (dir&EAST)?WEST : 0
	ndir |= (dir&WEST)?EAST : 0
	ndir |= (dir&UP)?DOWN : 0
	ndir |= (dir&DOWN)?UP : 0
	return ndir

/proc/step_towards_3d(var/atom/movable/Ref, var/atom/movable/Trg)
	if (!Ref || !Trg)
		return 0
	if(Ref.z == Trg.z)
		var/S = Ref.loc
		step_towards(Ref, Trg)
		if(Ref.loc != S)
			return 1
		return 0

	var/dx = (Trg.x - Ref.x) / max(abs(Trg.x - Ref.x), 1)
	var/dy = (Trg.y - Ref.y) / max(abs(Trg.y - Ref.y), 1)
	var/dz = (Trg.z - Ref.z) / max(abs(Trg.z - Ref.z), 1)

	var/turf/T = locate(Ref.x + dx, Ref.y + dy, Ref.z + dz)

	if (!T)
		return 0

	Ref.Move(T)

	if (Ref.loc != T)
		return 0

	return 1

/proc/walk_to_3d(var/atom/movable/Ref, var/atom/movable/Trg, var/min=0, var/lag=0)
	if (Ref.is_walking_to_3d)
		return
	else
		Ref.is_walking_to_3d = 1
		spawn(0) walk_to_3d_loop(Ref, Trg, min, lag)
	return

/proc/walk_to_3d_loop(var/atom/movable/Ref, var/atom/movable/Trg, var/min=0, var/lag=0)
	if (istype(Ref, /obj/machinery/bot/secbot))
		var/obj/machinery/bot/secbot/S = Ref
		var/blockcount
		S.path = AStar(S.loc, S.target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=S.botcard, exclude=list(/obj/effect/landmark/alterations/nopath, avoid=null))
		S.path = reverselist(S.path)
		while (S.target && get_dist(S,S.target) > min)
			sleep(lag * tick_multiplier)
			var/turf/next
			if (S.path.len > 0)
				next = S.path[1]
				if(next == S.loc)
					S.path -= next
					continue
			if (!S.path.len || (S.target && S.path.len && get_dist(S.path[S.path.len],S.target) > 4)) // Recalculate the path if there is no path or if the target has moved too far away from the end of it
				spawn(lag)
					if (S.target)
						S.path = AStar(S.loc, S.target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=S.botcard, exclude=list(/obj/effect/landmark/alterations/nopath, avoid=null))
						S.path = reverselist(S.path)
			if(istype( next, /turf/simulated))
				var/moved = step_towards_3d(S, next)	// attempt to move
				if(moved)	// successful move
					blockcount = 0
					S.path -= S.loc
				else		// failed to move
					blockcount++

					if(blockcount > 10)	// attempt 5 times before recomputing
						// find new path excluding blocked turf
						spawn(lag)
							if (S.target)
								S.path = AStar(S.loc, S.target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=S.botcard, exclude=list(/obj/effect/landmark/alterations/nopath, avoid=next))
								S.path = reverselist(S.path)
								if(S.path.len == 0)
									continue
								else
									blockcount = 0
	Ref.is_walking_to_3d = 0

/atom/movable/var/is_walking_to_3d


/*/proc/sanitize(var/t)
	var/index = findtext(t, "\n")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\n")

	index = findtext(t, "\t")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\t")

	index = findtext(t, "ÿ")
	while(index)
		t = copytext(t, 1, index) + "__255;" + copytext(t, index+1)
		index = findtext(t, "ÿ")

	t = html_encode(t)

	index = findtext(t, "__255;")
	while(index)
		t = copytext(t, 1, index) + "&#255;" + copytext(t, index+6)
		index = findtext(t, "__255;")

	return t

/proc/sanitize_spec(var/t)
	var/index = findtext(t, "\n")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\n")

	index = findtext(t, "\t")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\t")

	index = findtext(t, "ÿ")
	while(index)
		t = copytext(t, 1, index) + "ß" + copytext(t, index+1)
		index = findtext(t, "ÿ")

	t = html_encode(t)

	return t*/

/proc/dd_file2list(file_path, separator)
	var/file
	if(separator == null)
		separator = "\n"
	if(isfile(file_path))
		file = file_path
	else
		file = file(file_path)
	return dd_text2list(file2text(file), separator)

/proc/dd_replacetext(text, search_string, replacement_string)
	var/textList = dd_text2list(text, search_string)
	return dd_list2text(textList, replacement_string)

/proc/dd_replaceText(text, search_string, replacement_string)
	var/textList = dd_text2list(text, search_string)
	return dd_list2text(textList, replacement_string)

/proc/dd_hasPrefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end) //was findtextEx


/proc/dd_hasSuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext(text, suffix, start, null) //was findtextEx

/proc/dd_text2list(text, separator, var/list/withinList)
	var/textlength = length(text)
	var/separatorlength = length(separator)
	if(withinList && !withinList.len) withinList = null
	var/list/textList = new()
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtext(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		if(!withinList || (buggyText in withinList)) textList += "[buggyText]"
		if(!findPosition) return textList
		searchPosition = findPosition + separatorlength
		if(searchPosition > textlength)
			textList += ""
			return textList
	return

/proc/text_input(var/Message, var/Title, var/Default, var/length=MAX_MESSAGE_LEN)
	return sanitize(input(Message, Title, Default) as text, length)

/proc/scrub_input(var/Message, var/Title, var/Default, var/length=MAX_MESSAGE_LEN)
	return strip_html(input(Message,Title,Default) as text, length)


/*	//Kelson's version (doesn't work)
/proc/getline(atom/M,atom/N)
	if(!M || !M.loc) return
	if(!N || !N.loc) return
	if(M.z != N.z) return
	var/line = new/list()

	var/dx = abs(M.x - N.x)
	var/dy = abs(M.y - N.y)
	var/cx = M.x < N.x ? 1 : -1
	var/cy = M.y < N.y ? 1 : -1
	var/slope = dy ? dx/dy : INFINITY

	var/tslope = slope
	var/turf/tloc = M.loc

	while(tloc != N.loc)
		if(tslope>0)
			--tslope
			tloc = locate(tloc.x+cx,tloc.y,tloc.z)
		else
			tslope += slope
			tloc = locate(tloc.x,tloc.y+cy,tloc.z)
		line += tloc
	return line
*/


/proc/sortmobs()

	var/list/mob_list = list()
	for(var/mob/living/silicon/ai/M in world)
		mob_list.Add(M)
	for(var/mob/living/silicon/robot/M in world)
		mob_list.Add(M)
	for(var/mob/living/carbon/human/M in world)
		mob_list.Add(M)
	for(var/mob/living/carbon/alien/M in world)
		mob_list.Add(M)
	for(var/mob/dead/observer/M in world)
		mob_list.Add(M)
	for(var/mob/dead/official/M in world)
		mob_list.Add(M)
	for(var/mob/new_player/M in world)
		mob_list.Add(M)
	for(var/mob/living/carbon/monkey/M in world)
		mob_list.Add(M)

	return mob_list

/proc/FindRecursive(var/target,var/atom/haystack)
	for(var/v in haystack.contents)
		if(v==target)
			return v
		else
			var/other = FindRecursive(target,v)
			if(other)
				return other
	return null
