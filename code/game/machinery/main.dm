/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	var/stat = 0
	var/emagged = 0
	var/use_power = 1
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = EQUIP
		//EQUIP,ENVIRON or LIGHT
	var/list/component_parts = null //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/manual = 0
	var/global/gl_uid = 1
	var/mocktxt

/obj/machinery/New()
	..()
	machines.Add(src)

/obj/machinery/Del()
	machines.Remove(src)
	..()

/obj/machinery/proc/process()
	return

/obj/machinery/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(25))
				del(src)
				return
		else
	return

/obj/machinery/blob_act()
	if(prob(25))
		del(src)

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		use_power(7500/severity)

//		var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( src.loc )
//		pulse2.icon = 'icons/effects/effects.dmi'
//		pulse2.icon_state = "empdisable"
//		pulse2.name = "emp sparks"
//		pulse2.anchored = 1
//		pulse2.dir = pick(cardinal)
//
//		spawn(10)
//			pulse2.delete()
	..()

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return