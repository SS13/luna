/obj/machinery/computer/arcade
	name = "arcade machine"
	desc = "Arcade machine. Does not support Pinball."
	icon = 'icons/obj/computer.dmi'
	icon_state = "arcade"
	circuit = "/obj/item/weapon/circuitboard/computer/arcade"

	var/enemy_name = "Space Villain"
	var/temp = "Winners Don't Use Spacedrugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set

	var/list/stealmsg = list("steals")
	var/list/attackmsg = list("attacks")

	var/honked = 0

	var/list/prizes = list(	/obj/item/weapon/storage/box/toy/snappops				= 2,
							/obj/item/weapon/storage/box/toy/waterballoons			= 2,
							/obj/item/toy/c4										= 2,
							/obj/item/device/radio/beacon/blink						= 2,
							/obj/item/clothing/under/syndicate						= 2,
							/obj/item/toy/sword										= 2,
							/obj/item/toy/gun										= 2,
							/obj/item/toy/crossbow									= 2,
							/obj/item/clothing/suit/syndicatefake					= 5, //vends all types, see vend_prize()
							/obj/item/weapon/storage/backpack/toy					= 2,
							/obj/item/weapon/storage/fancy/crayons					= 2,
							/obj/item/toy/spinningtoy								= 1,
							/obj/item/toy/prize										= 6, //vends all types except base, see vend_prize()
							/obj/item/weapon/storage/backpack/toy 					= 2,
							/obj/item/weapon/reagent_containers/spray/waterflower	= 2,
							)

	brightnessred = 0
	brightnessgreen = 2
	brightnessblue = 0

/obj/machinery/computer/arcade/New()
	..()
	enemy_name = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Evil ", "the Dread King ", "the Space ", "Lord ")
	enemy_name += pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Coder")

	name = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ") + enemy_name
	enemy_name = dd_replacetext(enemy_name, "the ", "")


/obj/machinery/computer/arcade/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/arcade/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/arcade/attack_hand(mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a>"
	dat += "<center><h4>[enemy_name]</h4></center>"

	dat += "<br><center><h3>[temp]</h3></center>"
	dat += "<br><center>Health: [player_hp] | Magic: [player_mp] | Enemy Health: [enemy_hp]</center>"

	if (src.gameover)
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=\ref[src];attack=1'>Attack</a> | "
		dat += "<a href='byond://?src=\ref[src];heal=1'>Heal</a> | "
		dat += "<a href='byond://?src=\ref[src];charge=1'>Recharge Power</a>"

	dat += "</b></center>"

	user << browse(dat, "window=arcade")
	onclose(user, "arcade")
	return

/obj/machinery/computer/arcade/Topic(href, href_list)
	if(..())
		return

	if (!src.blocked)
		if (href_list["attack"])
			src.blocked = 1
			var/attackamt = rand(2,6)
			src.temp = "You attack for [attackamt] damage!"
			src.updateUsrDialog()

			sleep(10)
			src.enemy_hp -= attackamt
			src.arcade_action()

		else if (href_list["heal"])
			src.blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			src.temp = "You use [pointamt] magic to heal for [healamt] damage!"
			src.updateUsrDialog()

			sleep(10)
			src.player_mp -= pointamt
			src.player_hp += healamt
			src.blocked = 1
			src.updateUsrDialog()
			src.arcade_action()

		else if (href_list["charge"])
			src.blocked = 1
			var/chargeamt = rand(4,7)
			src.temp = "You regain [chargeamt] points"
			src.player_mp += chargeamt

			src.updateUsrDialog()
			sleep(10)
			src.arcade_action()

	if (href_list["close"])
		usr.machine = null
		usr << browse(null, "window=arcade")

	else if (href_list["newgame"])
		reset()

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/arcade/proc/arcade_action()
	if (enemy_mp <= 0 || enemy_hp <= 0)
		gameover = 1
		temp = "[src.enemy_name] has fallen! Rejoice!"

		if(honked) // PRIZES PRIZES PRIZES!
			vend_prize(rand(2,6))
		vend_prize()

	else if (enemy_mp <= 5 && prob(70))
		var/stealamt = rand(2,3)
		temp = "[enemy_name] [pick(stealmsg)] [stealamt] of your power!"
		player_mp -= stealamt
		updateUsrDialog()

		if (player_mp <= 0)
			gameover = 1
			sleep(10)
			temp = "You have been drained! GAME OVER"

			if(honked)
				temp = "You have been permabrigged! GAME OVER"
			else if(emagged)
				explode()

	else if (enemy_hp <= 10 && enemy_mp > 4)
		temp = "[enemy_name] heals for 4 health!"
		enemy_hp += 4
		enemy_mp -= 4

	else
		var/attackamt = rand(3,6) + emagged*rand(1,2)
		temp = "[enemy_name] [pick(attackmsg)] for [attackamt] damage!"
		player_hp -= attackamt

	if (player_mp < 0 || player_hp <= 0)
		gameover = 1
		sleep(10)
		temp = "You have been crushed! GAME OVER"

		if(honked)
			temp = "You have been beaten! GAME OVER"
		else if(emagged)
			explode()

	blocked = 0
	return

/obj/machinery/computer/arcade/proc/vend_prize(var/prize_amount=0)
	if(prize_amount)
		for(prize_amount; prize_amount > 0; prize_amount--)
			vend_prize()
			sleep(5)
		return

	var/prize = pickweight(prizes)

	if(emagged)
		prize = /obj/effect/spawner/newbomb/timer
		new /obj/item/clothing/head/collectable/petehat(src.loc)
		message_admins("[key_name_admin(usr)] has outbombed Cuban Pete and been awarded a bomb.")

	else if(prize == /obj/item/toy/prize)
		prize = pick(typesof(/obj/item/toy/prize) - /obj/item/toy/prize)

	else if(prize == /obj/item/toy/gun) //Ammo comes with the gun
		new /obj/item/toy/ammo/gun(src.loc)

	else if(prize == /obj/item/clothing/suit/syndicatefake) //Helmet is part of the suit
		prize = pick(typesof(/obj/item/clothing/suit/syndicatefake))

	new prize(src.loc)

	if(emagged || honked)
		reset()

/obj/machinery/computer/arcade/proc/reset() //Reset everything
	if(emagged || honked)
		src.New()
		stealmsg = list("steals")
		attackmsg = list("attacks")
	emagged = 0
	honked = 0
	temp = "New Round"
	player_hp = 30
	player_mp = 10
	enemy_hp = 45
	enemy_mp = 20
	gameover = 0
	blocked = 0

/obj/machinery/computer/arcade/proc/explode() //Cuban Pete WINS!
	explosion(get_turf(src), 1, 2, 3) //BOOM
	del(src)

/obj/machinery/computer/arcade/power_change()
	if(stat & BROKEN)
		icon_state = "arcadeb"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "arcade0"
				stat |= NOPOWER

/obj/machinery/computer/arcade/attackby(I as obj, user as mob)
	if(!emagged && !honked)
		if(istype(I, /obj/item/weapon/card/emag))
			reset()
			emagged = 1

			temp = "If you die in the game, you die for real!"
			enemy_name = "Cuban Pete"
			name = "Outbomb Cuban Pete"
			attackmsg = list("throws a bomb, exploding you", "attacks")

			src.updateUsrDialog()
			return
		if(istype(I, /obj/item/weapon/bikehorn))
			reset()
			honked = 1

			temp = "HONK!"
			enemy_name = "Lord Shitcuriton"
			name = "Beat the Lord Shitcuriton"
			stealmsg = list("cuffs","stuns","brigs")
			attackmsg = list("beats you")

			src.updateUsrDialog()
			return
	..()

/obj/machinery/computer/arcade/emp_act(severity)
	if(stat & (NOPOWER|BROKEN))
		..(severity)
		return

	if(emagged && prob(90/severity))
		explode()
		return

	switch(severity)
		if(1)
			vend_prize(rand(1,4))
		if(2)
			vend_prize(rand(1,2))
		if(3)
			vend_prize(rand(0,1))

	..(severity)