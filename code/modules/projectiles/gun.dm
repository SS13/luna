/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY | ONBELT
//	slot_flags = SLOT_BELT
	m_amt = 2000
	w_class = 3.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0
	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")

	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/obj/item/projectile/in_chamber = null
	var/caliber = ""
	var/silenced = 0
	var/recoil = 0
	var/ejectshell = 1
	var/clumsy_check = 1


	proc/load_into_chamber()
		return 0

	proc/special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1

	proc/prepare_shot(var/obj/item/projectile/proj) //Transfer properties from the gun to the bullet
		proj.shot_from = src
		proj.silenced = silenced
		return


	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)


	afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)//TODO: go over this
		if(flag)	//we're placing gun on a table or in backpack
			return

		//Exclude lasertag guns from the CLUMSY check.
		if(clumsy_check)
			if(istype(user, /mob/living))
				var/mob/living/M = user
				if ((user.mutations & CLUMSY) && prob(20))
					M << "<span class='danger'>You shoot yourself in the foot with the [src]!</span>"
					afterattack(user, user)
					M.drop_item()
					return

		add_fingerprint(user)

		var/turf/curloc = user.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return

		if(!special_check(user))
			return
		if(!load_into_chamber())
			user << "<span class='warning'>*click*</span>"
			return

		if(!in_chamber)
			return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting


		if(recoil)
			spawn()
				shake_camera(user, recoil + 1, recoil)

		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[user] fires [src]!</span>", "<span class='danger'>You fire [src]!</span>", "You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		prepare_shot(in_chamber)				//Set the projectile's properties



		if(targloc == curloc)			//Fire the projectile
			user.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return
		in_chamber.original = target
		in_chamber.loc = get_turf(user)
		in_chamber.starting = get_turf(user)
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x
		user.next_move = world.time + 4

		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				in_chamber.p_x = text2num(mouse_control["icon-x"])
			if(mouse_control["icon-y"])
				in_chamber.p_y = text2num(mouse_control["icon-y"])

		spawn()
			if(in_chamber)
				in_chamber.process()
		sleep(1)
		in_chamber = null

		update_icon()

		user.update_clothing()

