/mob/proc/tech()
	set category = "Spells"
	set name = "Disable Technology"
	if(usr.stat)
		usr << "Not when you're incapicated."
		return
	if(!istype(usr:wear_suit, /obj/item/clothing/suit/wizrobe))
		usr << "I don't feel strong enough without my robe."
		return
	if(!istype(usr:shoes, /obj/item/clothing/shoes/sandal))
		usr << "I don't feel strong enough without my sandals."
		return
	if(!istype(usr:head, /obj/item/clothing/head/wizard))
		usr << "I don't feel strong enough without my hat."
		return

	usr.verbs -= /mob/proc/tech
	spawn(400*tick_multiplier)
		usr.verbs += /mob/proc/tech

	usr.say("NEC CANTIO")

	var/turf/myturf = get_turf(usr)

	var/obj/overlay/pulse = new/obj/overlay ( myturf )
	pulse.icon = 'effects.dmi'
	pulse.icon_state = "emppulse"
	pulse.name = "emp pulse"
	pulse.anchored = 1
	spawn(20*tick_multiplier)
		del(pulse)

	for(var/obj/item/weapon/W in range(world.view-1, myturf))
		if (istype(W, /obj/item/assembly/m_i_ptank) || istype(W, /obj/item/assembly/r_i_ptank) || istype(W, /obj/item/assembly/t_i_ptank))
			var/O
			if(istype(W:part1,/obj/item/weapon/tank/plasma))
				O = W:part1
				O:ignite()
			if(istype(W:part2,/obj/item/weapon/tank/plasma))
				O = W:part2
				O:ignite()
			if(istype(W:part3,/obj/item/weapon/tank/plasma))
				O = W:part3
				O:ignite()


	for(var/mob/M in viewers(world.view-1, myturf))

		if(!istype(M, /mob/living)) continue
		if(M == usr) continue

		if (istype(M, /mob/living/silicon))
			M.fireloss += 25
			flick("noise", M:flash)
			M << "\red <B>*BZZZT*</B>"
			M << "\red Warning: Electromagnetic pulse detected."
			if(istype(M, /mob/living/silicon/ai))
				if (prob(30))
					switch(pick(1,2,3)) //Add Random laws.
						if(1)
							M:cancel_camera()
						if(2)
							M:lockdown()
						if(3)
							M:ai_call_shuttle()
			continue


		for(var/obj/item/device/cloak/S in M)
			S.active = 0
			S.icon_state = "shield0"

		if (locate(/obj/item/device/radio, M))
			for(var/obj/item/device/radio/R in M) //Add something for the intercoms.
				R.broadcasting = 0
				R.listening = 0

		if (locate(/obj/item/device/flash, M))
			for(var/obj/item/device/flash/F in M) //Add something for the intercoms.
				F.attack_self()

		if (locate(/obj/item/weapon/melee/baton, M))
			for(var/obj/item/weapon/melee/baton/B in M) //Add something for the intercoms.
				B.charges = 0

		M << "\red <B>BZZZT</B>"


	for(var/obj/machinery/A in range(world.view-1, myturf))
		if(istype(A, /obj/machinery/turret))
			A:enabled = 0
			A:lasers = 0
			A:power_change()

		if(istype(A, /obj/machinery/power/smes))
			A:online = 0
			A:charging = 0
			A:output = 0
			A:charge -= 1e6
			if (A:charge < 0)
				A:charge = 0
			spawn(100*tick_multiplier)
				A:output = initial(A:output)
				A:charging = initial(A:charging)
				A:online = initial(A:online)

		if(istype(A, /obj/machinery/door))
			if(prob(20) && (istype(A,/obj/machinery/door/airlock) || istype(A,/obj/machinery/door/window)) )
				A:open()
			if(A:secondsElectrified != 0) continue
			A:secondsElectrified = -1
			spawn(300*tick_multiplier)
				A:secondsElectrified = 0

		if(istype(A, /obj/machinery/power/apc))
			if(A:cell)
				A:cell:charge -= 1000
				if (A:cell:charge < 0)
					A:cell:charge = 0
			A:lighting = 0
			A:equipment = 0
			A:environ = 0
			spawn(600*tick_multiplier)
				A:equipment = 3
				A:environ = 3

		if(istype(A, /obj/machinery/camera))
			A.icon_state = "cameraemp"
			A:network = null                   //Not the best way but it will do. I think.
			spawn(600*tick_multiplier)
				A:network = initial(A:network)
				A:icon_state = initial(A:icon_state)
			for(var/mob/living/silicon/ai/O in world)
				if (O.current == A)
					O.cancel_camera()
					O << "Your connection to the camera has been lost."
			for(var/mob/O in world)
				if (istype(O.machine, /obj/machinery/computer/security))
					var/obj/machinery/computer/security/S = O.machine
					if (S.current == A)
						O.machine = null
						S.current = null
						O.reset_view(null)
						O << "The screen bursts into static."

		if(istype(A, /obj/machinery/clonepod))
			A:malfunction()