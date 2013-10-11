/obj/machinery/computer/door_control
	name = "Door Control"
	icon = 'stationobjs.dmi'
	icon_state = "sec_computer"
	req_access = list(access_brig)
//	var/authenticated = 0.0		if anyone wants to make it so you need to log in in future go ahead.
	var/id = 1.0

/obj/machinery/computer/door_control/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return
	for(var/obj/machinery/door/window/brigdoor/M in world)
		if (M.id == src.id)
			if(M.density)
				spawn( 0 )
					M.open()
			else
				spawn( 0 )
					M.close()
	src.updateUsrDialog()
	return

/obj/machinery/computer/door_control/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/door_control/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/door_control/attack_hand(var/mob/user as mob)
	if(..())
		return
	var/dat = "<HTML><BODY><TT><B>Brig Computer</B><br><br>"
	user.machine = src
	for(var/obj/machinery/door/window/brigdoor/M in world)
		if(M.id == 1)
			dat += text("<A href='?src=\ref[src];setid=1'>Door 1: [(M.density ? "Closed" : "Opened")]</A><br>")
		else if(M.id == 2)
			dat += text("<A href='?src=\ref[src];setid=2'>Door 2: [(M.density ? "Closed" : "Opened")]</A><br>")
		else if(M.id == 3)
			dat += text("<A href='?src=\ref[src];setid=3'>Door 3: [(M.density ? "Closed" : "Opened")]</A><br>")
		else if(M.id == 4)
			dat += text("<A href='?src=\ref[src];setid=4'>Door 4: [(M.density ? "Closed" : "Opened")]</A><br>")
		else if(M.id == 5)
			dat += text("<A href='?src=\ref[src];setid=5'>Door 5: [(M.density ? "Closed" : "Opened")]</A><br>")
		else
			world << "Invalid ID detected on brigdoor ([M.x],[M.y],[M.z]) with id [M.id]"
	dat += text("<br><A href='?src=\ref[src];openall=1'>Open All</A><br>")
	dat += text("<A href='?src=\ref[src];closeall=1'>Close All</A><br>")
	dat += text("<BR><BR><A href='?src=\ref[user];mach_close=computer'>Close</A></TT></BODY></HTML>")
	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/door_control/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["setid"])
			if(src.allowed(usr))
				src.id = text2num(href_list["setid"])
				src.alarm()
		if (href_list["openall"])
			if(src.allowed(usr))
				for(var/obj/machinery/door/window/brigdoor/M in world)
					if(M.density)
						M.open()
		if (href_list["closeall"])
			if(src.allowed(usr))
				for(var/obj/machinery/door/window/brigdoor/M in world)
					if(!M.density)
						M.close()
		src.add_fingerprint(usr)
		src.updateUsrDialog()
	return




//////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
/obj/machinery/door_timer
	name = "Door Timer"
	icon = 'stationobjs.dmi'
	icon_state = "doortimer0"
	desc = "A remote control switch for a door."
	req_access = list(access_brig)
	anchored = 1.0
	var/id = null
	var/time = 30.0
	var/timing = 0.0
	var/timerstart
/obj/machinery/door_timer/process()
	..()
	if (src.timing)
		if(world.timeofday >= timerstart)
			alarm()
			src.time = 0
			src.timing = 0
			timerstart = null
		else
			var/times = timerstart - world.timeofday
			times /= 10
			src.time = round(times)

/*		if(!timerstart)
			timerstart = world.timeofday
		if (src.time > 0)
			src.time = round(src.time) - 1
		else
			alarm()
			src.time = 0
			src.timing = 0*/
		src.updateDialog()
		src.update_icon()
	return

/obj/machinery/door_timer/power_change()
	update_icon()


/obj/machinery/door_timer/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return
	for(var/obj/machinery/door/window/brigdoor/M in world)
		if (M.id == src.id)
			if(M.density)
				spawn( 0 )
					M.open()
			else
				spawn( 0 )
					M.close()
	for(var/obj/structure/closet/secure_closet/brig/B in world)
		if (B.id == src.id)
			if(B.locked)
				B.locked = 0
			B.icon_state = text("[(B.locked ? "1" : null)]secloset0")
	src.updateUsrDialog()
	src.update_icon()
	return

/obj/machinery/door_timer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_timer/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_timer/attack_hand(var/mob/user as mob)
	if(..())
		return

	var/dat = "<HTML><BODY><TT><B>Door [src.id] controls</B>"
	user.machine = src
	var/d2
	if (src.timing)
		d2 = text("<A href='?src=\ref[];time=0'>Stop Timed</A><br>", src)
	else
		d2 = text("<A href='?src=\ref[];time=1'>Initiate Time</A><br>", src)
	var/second = src.time % 60
	var/minute = (src.time - second) / 60
	if(!src.timing)
		dat += text("<br><HR>\nTimer System: [d2]\nTime Left: [(minute ? text("[minute]:") : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>")
	else
		dat += "<br><HR>\nTimer System: [d2]\nTime Left: [(minute ? text("[minute]:") : null)][second] "
	for(var/obj/machinery/flasher/F in world)
		if(F.id == src.id)
			if(F.last_flash && world.time < F.last_flash + 500)
				dat += text("<BR><BR><A href='?src=\ref[];fc=1'>Flash Cell (Charging)</A>", src)
			else
				dat += text("<BR><BR><A href='?src=\ref[];fc=1'>Flash Cell</A>", src)
	dat += text("<BR><BR><A href='?src=\ref[];mach_close=computer'>Close</A></TT></BODY></HTML>", user)
	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/door_timer/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["time"])
			if(src.allowed(usr))
				src.timing = text2num(href_list["time"])
				if(text2num(href_list["time"]))
					var/num = src.time * 10
					timerstart = world.timeofday +  num
				else
					timerstart = null
		else
			if (href_list["tp"])
				if(src.allowed(usr))
					var/tp = text2num(href_list["tp"])
					src.time += tp
					src.time = min(max(round(src.time), 0), 3000)
			if (href_list["fc"])
				if(src.allowed(usr))
					for (var/obj/machinery/flasher/F in world)
						if (F.id == src.id)
							F.flash()
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		src.update_icon()
	return

/obj/machinery/door_timer/update_icon()
	if(stat & (NOPOWER))
		icon_state = "doortimer-p"
		return
	else if(stat & (BROKEN))
		icon_state = "doortimer-b"
		return
	else
		if(src.timing)
			icon_state = "doortimer1"
		else if(src.time > 0)
			icon_state = "doortimer0"
		else
			spawn( 50 )
				icon_state = "doortimer0"
			icon_state = "doortimer2"*/


#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

///////////////////////////////////////////////////////////////////////////////////////////////
// Brig Door control displays.
//  Description: This is a controls the timer for the brig doors, displays the timer on itself and
//               has a popup window when used, allowing to set the timer.
//  Code Notes: Combination of old brigdoor.dm code from rev4407 and the status_display.dm code
//  Date: 01/September/2010
//  Programmer: Veryinky
/////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/door_timer
	name = "Door Timer"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	desc = "A remote control for a door."
	req_access = list(access_brig)
	anchored = 1.0    		// can't pull it away
	density = 0       		// can walk through it.
	var/id = null     		// id of door it controls.
	var/releasetime = 0		// when world.time reaches it - release the prisoneer
	var/timelength = 0		// the length of time this door will be set for
	var/timing = 1    		// boolean, true/1 timer is on, false/0 means it's not timing
	var/picture_state		// icon_state of alert picture, if not displaying text/numbers
	var/list/obj/machinery/targets = list()

	maptext_height = 26
	maptext_width = 32

	New()
		..()

		//pixel_x = ((src.dir & 3)? (0) : (src.dir == 4 ? 32 : -32))
		//pixel_y = ((src.dir & 3)? (src.dir ==1 ? 24 : -32) : (0))

		spawn(20)
			for(var/obj/machinery/door/window/brigdoor/M in world)
				if (M.id == src.id)
					targets += M

			for(var/obj/machinery/flasher/F in world)
				if(F.id == src.id)
					targets += F

			for(var/obj/structure/closet/secure_closet/brig/C in world)
				if(C.id == src.id)
					targets += C

			if(targets.len==0)
				stat |= BROKEN
			update_icon()
			return
		return


//Main door timer loop, if it's timing and time is >0 reduce time by 1.
// if it's less than 0, open door, reset timer
// update the door_timer window and the icon
	process()
		if(stat & (NOPOWER|BROKEN))	return
		if(timing)
			if(world.time > src.releasetime)
				src.timer_end() // open doors, reset timer, clear status screen
				timing = 0
				timeset(0)
			src.updateUsrDialog()
			src.update_icon()
		else
			timer_end()
		return


// has the door power sitatuation changed, if so update icon.
	power_change()
		..()
		update_icon()
		return


// open/closedoor checks if door_timer has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.
	proc/timer_start()
		if(stat & (NOPOWER|BROKEN))	return 0

		for(var/obj/machinery/door/window/brigdoor/door in targets)
			if(door.density)	continue
			spawn(0)
				door.close()

		for(var/obj/structure/closet/secure_closet/brig/C in targets)
			if(C.broken)	continue
			if(C.opened && !C.close())	continue
			C.locked = 1
			C.icon_state = C.icon_locked
		return 1


	proc/timer_end()
		if(stat & (NOPOWER|BROKEN))	return 0

		for(var/obj/machinery/door/window/brigdoor/door in targets)
			if(!door.density)	continue
			spawn(0)
				door.open()

		for(var/obj/structure/closet/secure_closet/brig/C in targets)
			if(C.broken)	continue
			if(C.opened)	continue
			C.locked = 0
			C.icon_state = C.icon_closed

		return 1


	proc/timeleft()
		. = (timing ? (releasetime-world.time) : timelength)/10
		if(. < 0)
			. = 0


	proc/timeset(var/seconds)
		if(timing)
			releasetime=world.time+seconds*10
		else
			timelength=seconds*10
		return

//Allows AIs to use door_timer, see human attack_hand function below
	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)


//Allows humans to use door_timer
//Opens dialog window when someone clicks on door timer
// Allows altering timer and the timing boolean.
// Flasher activation limited to 150 seconds
	attack_hand(var/mob/user as mob)

		var/second = round(timeleft() % 60)
		var/minute = round((timeleft() - second) / 60)
		user.set_machine(src)
		var/dat = "<HTML><BODY><TT>"
		dat += "<HR>Timer System:</hr>"
		dat += "<b>Door [src.id] controls</b><br/>"
		if (timing)
			dat += "<a href='?src=\ref[src];timing=0'>Stop Timer and open door</a><br/>"
		else
			dat += "<a href='?src=\ref[src];timing=1'>Activate Timer and close door</a><br/>"

		dat += "Time Left: [(minute ? text("[minute]:") : null)][second] <br/>"
		dat += "<a href='?src=\ref[src];tp=-60'>-</a> <a href='?src=\ref[src];tp=-1'>-</a> <a href='?src=\ref[src];tp=1'>+</a> <A href='?src=\ref[src];tp=60'>+</a><br/>"

		for(var/obj/machinery/flasher/F in targets)
			if(F.last_flash && (F.last_flash + 150) > world.time)
				dat += "<br/><A href='?src=\ref[src];fc=1'>Flash Charging</A>"
			else
				dat += "<br/><A href='?src=\ref[src];fc=1'>Activate Flash</A>"

		dat += "<br/><br/><a href='?src=\ref[user];mach_close=computer'>Close</a>"
		dat += "</TT></BODY></HTML>"
		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return


//Function for using door_timer dialog input, checks if user has permission
// href_list to
//  "timing" turns on timer
//  "tp" value to modify timer
//  "fc" activates flasher
// Also updates dialog window and timer icon
	Topic(href, href_list)
		if(..())
			return
		if(!src.allowed(usr))
			return

		usr.set_machine(src)
		if(href_list["timing"]) //switch between timing and not timing
			var/timeleft = timeleft()
			timeleft = min(max(round(timeleft), 0), 3000)
			timing = text2num(href_list["timing"])
			timeset(timeleft)
		else if(href_list["tp"]) //adjust timer
			var/timeleft = timeleft()
			var/tp = text2num(href_list["tp"])
			timeleft += tp
			timeleft = min(max(round(timeleft), 0), 3000)
			timeset(timeleft)
			//src.timing = 1
			//src.closedoor()
		else if(href_list["fc"])
			for(var/obj/machinery/flasher/F in targets)
				F.flash()
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		src.update_icon()
		if(timing)
			src.timer_start()
		else
			src.timer_end()
		return


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
// if timing=true, run update display function
	update_icon()
		if(stat & (NOPOWER))
			icon_state = "frame"
			return
		if(stat & (BROKEN))
			set_picture("ai_bsod")
			return
		if(timing)
			var/disp1 = id
			var/timeleft = timeleft()
			var/disp2 = "[add_zero(num2text((timeleft / 60) % 60),2)]~[add_zero(num2text(timeleft % 60), 2)]"
			if(length(disp2) > CHARS_PER_LINE)
				disp2 = "Error"
			update_display(disp1, disp2)
		else
			if(maptext)	maptext = ""
		return


// Adds an icon in case the screen is broken/off, stolen from status_display.dm
	proc/set_picture(var/state)
		if(maptext)	maptext = ""
		picture_state = state
		overlays.Cut()
		overlays += image('icons/obj/status_display.dmi', icon_state=picture_state)


//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
	proc/update_display(line1, line2)
		var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
		if(maptext != new_text)
			maptext = new_text

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef CHARS_PER_LINE