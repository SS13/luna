/obj/effect/spawner/bomb
	name = "bomb"
	icon = 'screen1.dmi'
	icon_state = "x"
	var/btype = 0  //0 = radio, 1= prox, 2=time
	var/explosive = 1	// 0= firebomb
	var/btemp = 500	// bomb temperature (degC)
	var/active = 0

/obj/effect/spawner/bomb/New()
	..()

	switch (src.btype)
		// radio
		if (0)
			var/obj/item/assembly/r_i_ptank/R = new /obj/item/assembly/r_i_ptank(src.loc)
			var/obj/item/weapon/tank/plasma/p3 = new /obj/item/weapon/tank/plasma(R)
			var/obj/item/device/radio/signaler/p1 = new /obj/item/device/radio/signaler(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R

			p1.b_stat = 0
			p2.status = 1
			p3.air_contents.temperature = btemp + T0C

			R.status = explosive

		// proximity
		if (1)
			var/obj/item/assembly/m_i_ptank/R = new /obj/item/assembly/m_i_ptank(src.loc)
			var/obj/item/weapon/tank/plasma/p3 = new /obj/item/weapon/tank/plasma(R)
			var/obj/item/device/prox_sensor/p1 = new /obj/item/device/prox_sensor(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R

			p3.air_contents.temperature = btemp + T0C
			p2.status = 1

			if(src.active)
				R.part1.state = 1
				R.part1.icon_state = text("motion[]", 1)
				R.c_state(1, src)

			R.status = explosive

		// timer
		if (2)
			var/obj/item/assembly/t_i_ptank/R = new /obj/item/assembly/t_i_ptank(src.loc)
			var/obj/item/weapon/tank/plasma/p3 = new /obj/item/weapon/tank/plasma(R)
			var/obj/item/device/timer/p1 = new /obj/item/device/timer(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R

			p3.air_contents.temperature = btemp + T0C
			p2.status = 1

			R.status = explosive
		//bombvest
		if(3)
			var/obj/item/clothing/suit/armor/a_i_a_ptank/R = new /obj/item/clothing/suit/armor/a_i_a_ptank(src.loc)
			var/obj/item/weapon/tank/plasma/p4 = new /obj/item/weapon/tank/plasma(R)
			var/obj/item/device/healthanalyzer/p1 = new /obj/item/device/healthanalyzer(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			var/obj/item/clothing/suit/armor/vest/p3 = new /obj/item/clothing/suit/armor/vest(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			R.part4 = p4
			p1.master = R
			p2.master = R
			p3.master = R
			p4.master = R

			p4.air_contents.temperature = btemp + T0C
			p2.status = 1

			R.status = explosive

	del(src)

/obj/effect/spawner/bomb/radio
	btype = 0

/obj/effect/spawner/bomb/proximity
	btype = 1

/obj/effect/spawner/bomb/timer
	btype = 2

/obj/effect/spawner/bomb/timer/syndicate
	btemp = 450

/obj/effect/spawner/bomb/suicide
	btype = 3


/obj/effect/spawner/newbomb
	name = "bomb"
	icon = 'screen1.dmi'
	icon_state = "x"
	var/btype = 0 // 0=radio, 1=prox, 2=time
	var/btemp1 = 1000
	var/btemp2 = 800	// tank temperatures

/obj/effect/spawner/newbomb/New()
	..()
	var/obj/item/device/transfer_valve/V = new(src.loc)
	var/obj/item/weapon/tank/plasma/PT = new(V)
	var/obj/item/weapon/tank/oxygen/OT = new(V)
	PT.master = V
	OT.master = V
	V.tank_one = PT
	V.tank_two = OT

	PT.air_contents.temperature = btemp1 + T0C
	OT.air_contents.temperature = btemp2 + T0C

	switch (src.btype)
		// radio
		if (0)
			var/obj/item/device/radio/signaler/S = new(V)
			V.attached_device = S
			S.master = V
			S.b_stat = 0

		// proximity
		if (1)
			var/obj/item/device/prox_sensor/P = new(V)
			V.attached_device = P
			P.master = V

		// timer
		if (2)
			var/obj/item/device/timer/T = new(V)
			V.attached_device = T
			T.master = V
			T.time = 30

	V.update_icon()
	del(src)

/obj/effect/spawner/newbomb/timer
	btype = 2

/obj/effect/spawner/newbomb/timer/syndicate
	name = "Low-Yield Bomb"
	btemp1 = 1500
	btemp2 = 1000

/obj/effect/spawner/newbomb/proximity
	btype = 1

/obj/effect/spawner/newbomb/radio
	btype = 0