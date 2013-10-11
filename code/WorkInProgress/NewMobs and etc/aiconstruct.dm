/obj/structure/AIcore
	name = "AI core"
	var/buildstate = 0
	icon = 'mob.dmi'
	icon_state = "0"
	var/mob/bb

/obj/structure/AIcore/attack_hand(mob/user)
	switch(buildstate)
		if(0)
			user << "Looks like it's missing some circurity."
		if(1)
			user << "You wiggle the circurity."
		if(2)
			user << "It seems like its missing some cables."
		if(3)
			user << "It's missing a brain..."
		if(4)
			user << "It's missing a glass pane"
		if(5)
			user << "You try to boot up the AI"
			src.boot()

/obj/structure/AIcore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(user.stat >= 2)
		return
	switch(buildstate)
		if(0)
			if(istype(W,/obj/item/weapon/circuitboard/circuitry))
				user << "You place the [W] inside the [src]."
				del(W)
				buildstate++
				icon_state = "1"
		if(1)
			if(istype(W,/obj/item/weapon/screwdriver))
				user << "You screw the circuitry in place with [W]."
				buildstate++
				icon_state = "2"
		if(2)
			if(istype(W,/obj/item/weapon/cable_coil))
				var/obj/item/weapon/cable_coil/Coil = W
				if(!Coil.use(3))
					user << "Not enough cable."
					return
				user << "You wire up the inside of the [src]."
				buildstate++
				icon_state = "3"
		if(3)
			if(istype(W,/obj/item/brain))
				user << "You place the [W] inside the [src]."
				user.drop_item()
				bb = W:owner
				del(W)
				buildstate++
				icon_state = "3b"
		if(4)
			if(istype(W,/obj/item/stack/sheet/glass))
				if(W:amount < 1)
					user << "Not enough glass."
					return
				user << "You place the [W] inside the [src]."
				W:amount -= 1
				if(W:amount <= 0)
					del(W)
				buildstate++
				icon_state = "4"

/obj/structure/AIcore/proc/boot()
	if(bb)
		log_admin("Starting AI construct (1/2)")
		for(var/mob/M in world) if(M.client && M.client.key == bb.mind.key)
			bb = M
			break
		if(!bb.client)
			return
		var/mob/living/silicon/ai/A = new(src.loc)
		A.key = bb.client.key
		bb.mind.transfer_to(A)
		sleep(10)
		A << 'chime.ogg'
		roundinfo.revies++
		log_admin("Starting AI construct (2/2)")
		A.AIize()
		del(src)
mob/living/verb/head()
	set hidden = 1
	usr.unlock_medal("Find Head", 0, "You found head!", "medium")
