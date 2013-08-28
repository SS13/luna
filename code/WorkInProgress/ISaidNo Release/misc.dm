/obj/submachine/slot_machine
	name = "Slot Machine"
	desc = "Gambling for the antisocial."
	icon = 'objects.dmi'
	icon_state = "slots-off"
	anchored = 1
	density = 1
	mats = 10
	var/money = 2500000
	var/plays = 0
	var/working = 0
	var/obj/item/weapon/card/id/scan = null

	attackby(var/obj/item/I as obj, user as mob)
		if(istype(I, /obj/item/weapon/card/id))
			if(src.scan)
				user << "\red There is a card already in the slot machine."
			else
				user << "\blue You insert your ID card."
				usr.drop_item()
				I.loc = src
				src.scan = I
		else src.attack_hand(user)
		return

	attack_hand(var/mob/user as mob)
		user.machine = src
		if (!src.scan)
			var/dat = {"<B>Slot Machine</B><BR>
			<HR><BR>
			<B>Please insert card!</B><BR>"}
			user << browse(dat, "window=slotmachine;size=450x500")
			onclose(user, "slotmachine")
		else if (src.working)
			var/dat = {"<B>Slot Machine</B><BR>
			<HR><BR>
			<B>Please wait!</B><BR>"}
			user << browse(dat, "window=slotmachine;size=450x500")
			onclose(user, "slotmachine")
		else
			var/dat = {"<B>Slot Machine</B><BR>
			<HR><BR>
			Five credits to play!<BR>
			<B>Prize Money Available:</B> [src.scan.money]<BR>
			<B>Your Card:</B> [src.scan]<BR>
			<B>Credits Remaining:</B> [src.scan.money]<BR>
			[src.plays] players have tried their luck today!<BR>
			<HR><BR>
			<A href='?src=\ref[src];ops=1'>Play!<BR>
			<A href='?src=\ref[src];ops=2'>Eject card"}
			user << browse(dat, "window=slotmachine;size=400x500")
			onclose(user, "slotmachine")

	Topic(href, href_list)
		if(href_list["ops"])
			var/operation = text2num(href_list["ops"])
			if(operation == 1) // Play
				if (src.scan.money < 5)
					for(var/mob/O in hearers(src, null))
						O.show_message(text("<b>[]</b> says, 'Insufficient money to play!'", src), 1)
					return
				src.scan.money -= 5
				src.money += 5
				src.plays += 1
				src.working = 1
				src.icon_state = "slots-on"
				for(var/mob/O in hearers(src, null))
					O.show_message(text("<b>[]</b> says, 'Let's roll!'", src), 1)
				var/roll = rand(1,10000)
				spawn(100)
					if (roll == 1)
						for(var/mob/O in hearers(src, null))
							O.show_message(text("<b>[]</b> says, 'JACKPOT! You win [src.money]!'", src), 1)
						command_alert("Congratulations [src.scan.registered] on winning the Jackpot!", "Jackpot Winner")
						src.scan.money += src.money
						src.money = 0
					else if (roll > 1 && roll <= 10)
						for(var/mob/O in hearers(src, null))
							O.show_message(text("<b>[]</b> says, 'Big Winner! You win five thousand credits!'", src), 1)
						src.scan.money += 5000
						src.money -= 5000
					else if (roll > 10 && roll <= 100)
						for(var/mob/O in hearers(src, null))
							O.show_message(text("<b>[]</b> says, 'Winner! You win five hundred credits!'", src), 1)
						src.scan.money += 500
						src.money -= 500
					else if (roll > 100 && roll <= 1000)
						for(var/mob/O in hearers(src, null))
							O.show_message(text("<b>[]</b> says, 'You win a free game!'", src), 1)
						src.scan.money += 5
						src.money -= 5
					else
						for(var/mob/O in hearers(src, null))
							O.show_message(text("<b>[]</b> says, 'No luck!'", src), 1)
					src.working = 0
					src.icon_state = "slots-off"
			if(operation == 2) // Eject Card
				src.scan.loc = src.loc
				src.scan = null
				for(var/mob/O in hearers(src, null))
					O.show_message(text("<b>[]</b> says, 'Thank you for playing!'", src), 1)
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		return

/proc/say_drunk_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(lowertext(R.curr_char))
		if("k")
			if(lowertext(R.prev_char) == "n" || lowertext(R.prev_char) == "c")
				new_string = "gh"
				used = 1
			else
				new_string = "g"
				used = 1

		if("s")
			new_string = "sh"
			used = 1

		if("c")
			new_string = "g"
			used = 1

		if("t")
			if(lowertext(R.next_char) == "h")
				new_string = "du"
				used = 2
			else if(lowertext(R.prev_char) == "n")
				new_string = "ghf"
				used = 1
			else
				new_string = "g"
				used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

/proc/say_drunk(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = say_drunk_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	return modded