/mob/dead/observer
	icon = 'mob.dmi'
	icon_state = "ghost"
	layer = 4
	density = 0
	stat = 2
	canmove = 0
	blinded = 0
	anchored = 1	//  don't get pushed around
	var/mob/corpse = null	//	observer mode
	var/datum/hud/living/carbon/hud = null // hud

/mob/dead/observer/New(turf/loc,mob/the_corpse)
	invisibility = 10
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = 15
	ear_deaf = 0
	ear_damage = 0
	see_in_dark = 100
	verbs += /mob/dead/observer/proc/dead_tele
	src.loc = loc
	if(the_corpse)
		corpse = the_corpse
		real_name = corpse.real_name
		name = corpse.real_name
		verbs += /mob/dead/observer/proc/reenter_corpse

/mob/living/proc/ghostize()
	set name = "Ghost"
	set desc = "You cannot be revived as a ghost"
	if(client)
		if(isturf(get_turf(src)))
			var/mob/dead/observer/newghost = new/mob/dead/observer(get_turf(src),src)
			newghost.timeofdeath = src.timeofdeath
			client.mob = newghost
	return


/mob/dead/observer/Login()
	..()
	client.screen = null

	if (!isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE


/mob/dead/observer/Move(NewLoc, direct)
	if(NewLoc)
		loc = NewLoc
		return
	if((direct & NORTH) && y < world.maxy)
		y++
	if((direct & SOUTH) && y > 1)
		y--
	if((direct & EAST) && x < world.maxx)
		x++
	if((direct & WEST) && x > 1)
		x--

/mob/dead/observer/examine()
	if(usr)
		usr << desc

/mob/dead/observer/can_use_hands()	return 0
/mob/dead/observer/is_active()		return 0

/mob/dead/observer/Stat()
	..()
	statpanel("Status")
	if (client.statpanel == "Status")
		if(LaunchControl.online && main_shuttle.location < 2)
			var/timeleft = LaunchControl.timeleft()
			if (timeleft)
				stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/dead/observer/proc/reenter_corpse()
	set category = "Special Verbs"
	set name = "Re-enter Corpse"
	if(!corpse)
		alert("You don't have a corpse!")
		return
//	if(corpse.stat == 2)
//		alert("Your body is dead!")
//		return
	if(client && client.holder && client.holder.state == 2)
		var/rank = client.holder.rank
		client.clear_admin_verbs()
		client.holder.state = 1
		client.update_admins(rank)
	client.mob = corpse
	del(src)

/mob/dead/observer/proc/dead_tele(var/area/A in world)
	set category = "Special Verbs"
	set name = "Teleport"
	set desc= "Teleport"

	if(usr.stat != 2 || !istype(usr, /mob/dead/observer))
		usr << "Not when you're not dead!"
		return

	usr.verbs -= /mob/dead/observer/proc/dead_tele
	spawn(100)
		usr.verbs += /mob/dead/observer/proc/dead_tele

	if(!A)
		return
	usr.loc = pick(get_area_turfs(A))