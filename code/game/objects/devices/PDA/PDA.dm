
//The advanced pea-green monochrome lcd of tomorrow.

/obj/item/device/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 2.0
	flags = FPRINT | TABLEPASS | ONBELT

	//Main variables
	var/owner = null
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/weapon/cartridge/cartridge = null //current cartridge
	var/mode = 0 //Controls what menu the PDA will display. 0 is hub; the rest are either built in or based on cartridge.

	//Secondary variables
	var/scanmode = 0 //1 is medical scanner, 2 is forensics, 3 is reagent scanner.
	var/fon = 0 //Is the flashlight function on?
	var/f_lum = 4 //Luminosity for the flashlight function
	var/silent = 0 //To beep or not to beep, that is the question
	var/toff = 0 //If 1, messenger disabled
	var/tnote = null //Current Texts
	var/last_text //No text spamming
	var/last_honk //Also no honk spamming that's bad too
	var/ttone = "beep" //The ringtone!
	var/honkamt = 0 //How many honks left when infected with honk.exe
	var/mimeamt = 0 //How many silence left when infected with mime.exe
	var/note = "Congratulations, your station has chosen the Thinktronic 5230 Personal Data Assistant!" //Current note in the notepad function.
	var/cart = "" //A place to stick cartridge menu information

	//var/obj/item/weapon/integrated_uplink/uplink = null
	var/obj/item/device/uplink/pda/uplink = null

	var/obj/item/weapon/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above

	var/obj/item/device/paicard/pai = null	// A slot for a personal AI device

/obj/item/device/pda/bar
	icon_state = "pda-bar"

/obj/item/device/pda/chef
	icon_state = "pda-chef"

/obj/item/device/pda/medical
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-medical"

/obj/item/device/pda/robot
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-robot"

/obj/item/device/pda/hydro
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-hydro"

/obj/item/device/pda/gene
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-gene"

/obj/item/device/pda/engineering
	default_cartridge = /obj/item/weapon/cartridge/engineering
	icon_state = "pda-engineering"

/obj/item/device/pda/security
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-security"

/obj/item/device/pda/det
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-det"

/obj/item/device/pda/warden
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-warden"

/obj/item/device/pda/janitor
	default_cartridge = /obj/item/weapon/cartridge/janitor
	icon_state = "pda-janitor"
	ttone = "slip"

/obj/item/device/pda/toxins
	default_cartridge = /obj/item/weapon/cartridge/signal/toxins
	icon_state = "pda-tox"
	ttone = "boom"

/obj/item/device/pda/chem
	default_cartridge = /obj/item/weapon/cartridge/signal/toxins
	icon_state = "pda-chem"
	ttone = "boom"

/obj/item/device/pda/clown
	default_cartridge = /obj/item/weapon/cartridge/clown
	icon_state = "pda-clown"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	ttone = "honk"

/obj/item/device/pda/mime
	default_cartridge = /obj/item/weapon/cartridge/mime
	icon_state = "pda-mime"
	silent = 1
	ttone = "silence"

/obj/item/device/pda/heads
	default_cartridge = /obj/item/weapon/cartridge/head
	icon_state = "pda-heads"

/obj/item/device/pda/heads/hop
	default_cartridge = /obj/item/weapon/cartridge/hop
	icon_state = "pda-hop"

/obj/item/device/pda/heads/hos
	default_cartridge = /obj/item/weapon/cartridge/hos
	icon_state = "pda-hos"

/obj/item/device/pda/heads/ce
	default_cartridge = /obj/item/weapon/cartridge/engineering/ce
	icon_state = "pda-ce"

/obj/item/device/pda/heads/cmo
	default_cartridge = /obj/item/weapon/cartridge/cmo
	icon_state = "pda-cmo"

/obj/item/device/pda/heads/rd
	default_cartridge = /obj/item/weapon/cartridge/rd
	icon_state = "pda-rd"

/obj/item/device/pda/heads/captain
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-cap"
	toff = 1

/obj/item/device/pda/quartermaster
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon_state = "pda-qm"

/obj/item/device/pda/cargo
	icon_state = "pda-cargo"

/obj/item/device/pda/miner
	icon_state = "pda-miner"

/obj/item/device/pda/syndicate
	default_cartridge = /obj/item/weapon/cartridge/syndicate
	icon_state = "pda-syn"
	name = "Military PDA"
	owner = "John Doe"
	toff = 1

/obj/item/device/pda/chaplain
	icon_state = "pda-holy"
	ttone = "holy"

/*
 *	The Actual PDA
 */
/obj/item/device/pda/pickup(mob/user)
	if (fon)
		user.ul_SetLuminosity(user.luminosity + f_lum)
		user.ul_SetLuminosity(user.luminosity - f_lum)

/obj/item/device/pda/dropped(mob/user)
	if (fon)
		user.ul_SetLuminosity(user.luminosity - f_lum)
		user.ul_SetLuminosity(user.luminosity + f_lum)

/obj/item/device/pda/New()
	..()
	spawn(3)
	if (default_cartridge)
		cartridge = new default_cartridge(src)

//NOTE: graphic resources are loaded on client login
/obj/item/device/pda/attack_self(mob/user as mob)
	user.machine = src

	var/dat = "<html><head><title>Personal Data Assistant</title><META http-equiv='Content-Type' content='text/html; charset=windows-1251'></head><body bgcolor=\"#808000\"><style>a, a:link, a:visited, a:active, a:hover { color: #000000; }img {border-style:none;}</style>"

	dat += "<a href='byond://?src=\ref[src];choice=Close'><img src=pda_exit.png> Close</a>"

	if ((!isnull(cartridge)) && (mode == 0))
		dat += " | <a href='byond://?src=\ref[src];choice=Eject'><img src=pda_eject.png> Eject [cartridge]</a>"
	if (mode)
		dat += " | <a href='byond://?src=\ref[src];choice=Return'><img src=pda_menu.png> Return</a>"
	dat += " | <a href='byond://?src=\ref[src];choice=Refresh'><img src=pda_refresh.png> Refresh</a>"

	dat += "<br>"

	if (!owner)
		dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
		dat += "<a href='byond://?src=\ref[src];choice=Refresh'><img src=pda_refresh.png> Retry</a>"
	else
		switch (mode)
			if (0)
				dat += "<h2>PERSONAL DATA ASSISTANT v.1.2</h2>"
				dat += "Owner: [owner], [ownjob]<br>"
				dat += text("ID: <A href='?src=\ref[];choice=Authenticate'>[]</A><br>", src, (id ? "[id.registered], [id.assignment]" : "----------"))
				dat += "Station Time: [round(world.time / 36000)+12]:[(world.time / 600 % 60) < 10 ? add_zero(world.time / 600 % 60, 1) : world.time / 600 % 60]"//:[world.time / 100 % 6][world.time / 100 % 10]"

				dat += "<br><br>"

				dat += "<h4>General Functions</h4>"
				dat += "<ul>"
				dat += "<li><a href='byond://?src=\ref[src];choice=1'><img src=pda_notes.png> Notekeeper</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=2'><img src=pda_mail.png> Messenger</a></li>"

				if (cartridge)
					if (cartridge.access_clown)
						dat += "<li><a href='byond://?src=\ref[src];choice=Honk'><img src=pda_honk.png> Honk Synthesizer</a></li>"
					if (cartridge.access_manifest)
						dat += "<li><a href='byond://?src=\ref[src];choice=41'><img src=pda_notes.png> View Crew Manifest</a></li>"
					if(cartridge.access_status_display)
						dat += "<li><a href='byond://?src=\ref[src];choice=42'><img src=pda_status.png> Set Status Display</a></li>"
					dat += "</ul>"
					if (cartridge.access_engine)
						dat += "<h4>Engineering Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=43'><img src=pda_power.png> Power Monitor</a></li>"
						dat += "</ul>"
					if (cartridge.access_medical)
						dat += "<h4>Medical Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=44'><img src=pda_medical.png> Medical Records</a></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=Medical Scan'><img src=pda_scanner.png> [scanmode == 1 ? "Disable" : "Enable"] Medical Scanner</a></li>"
						dat += "</ul>"
					if (cartridge.access_security)
						dat += "<h4>Security Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=45'><img src=pda_cuffs.png> Security Records</A></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=Forensic Scan'><img src=pda_scanner.png> [scanmode == 2 ? "Disable" : "Enable"] Forensic Scanner</a></li>"
					if(istype(cartridge.radio, /obj/item/radio/integrated/beepsky))
						dat += "<li><a href='byond://?src=\ref[src];choice=46'><img src=pda_cuffs.png> Security Bot Access</a></li>"
						dat += "</ul>"
					else	dat += "</ul>"
					if(cartridge.access_quartermaster)
						dat += "<h4>Quartermaster Functions:</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=47'><img src=pda_crate.png> Supply Records</A></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=48'><img src=pda_mule.png> Delivery Bot Control</A></li>"
						dat += "</ul>"
				dat += "</ul>"

				dat += "<h4>Utilities</h4>"
				dat += "<ul>"
				if (cartridge)
					if (cartridge.access_janitor)
						dat += "<li><a href='byond://?src=\ref[src];choice=49'><img src=pda_bucket.png> Equipment Locator</a></li>"
					if (istype(cartridge.radio, /obj/item/radio/integrated/signal))
						dat += "<li><a href='byond://?src=\ref[src];choice=40'><img src=pda_signaler.png> Signaler System</a></li>"
					if (cartridge.access_reagent_scanner)
						dat += "<li><a href='byond://?src=\ref[src];choice=Reagent Scan'><img src=pda_reagent.png> [scanmode == 3 ? "Disable" : "Enable"] Reagent Scanner</a></li>"
					if (cartridge.access_engine)
						dat += "<li><a href='byond://?src=\ref[src];choice=Halogen Counter'><img src=pda_reagent.png> [scanmode == 4 ? "Disable" : "Enable"] Halogen Counter</a></li>"
					if (cartridge.access_remote_door)
						dat += "<li><a href='byond://?src=\ref[src];choice=Toggle Door'><img src=pda_rdoor.png> Toggle Remote Door</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=3'><img src=pda_atmos.png> Atmospheric Scan</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=Light'><img src=pda_flashlight.png> [fon ? "Disable" : "Enable"] Flashlight</a></li>"
				/*if (pai)
					if(pai.loc != src)
						pai = null
					else*/
						//dat += "<li><a href='byond://?src=\ref[src];choice=pai;option=1'>pAI Device Configuration</a></li>"
						//dat += "<li><a href='byond://?src=\ref[src];choice=pai;option=2'>Eject pAI Device</a></li>"
				dat += "</ul>"

			if (1)
				dat += "<h4><img src=pda_notes.png> Notekeeper V2.1</h4>"
				if ((!isnull(uplink)) && uplink.active)
					dat += "<a href='byond://?src=\ref[src];choice=Lock'> Lock</a><br>"
				else
					dat += "<a href='byond://?src=\ref[src];choice=Edit'> Edit</a><br>"
				dat += note

			if (2)
				dat += "<h4><img src=pda_mail.png> SpaceMessenger V3.9.4</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Toggle Ringer'><img src=pda_bell.png> Ringer: [silent == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=Toggle Messenger'><img src=pda_mail.png> Send / Receive: [toff == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=Ringtone'><img src=pda_bell.png> Set Ringtone</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=21'><img src=pda_mail.png> Messages</a><br>"

				if (istype(cartridge, /obj/item/weapon/cartridge/syndicate))
					dat += "<b>[cartridge:shock_charges] detonation charges left.</b><HR>"
				if (istype(cartridge, /obj/item/weapon/cartridge/clown))
					dat += "<b>[cartridge:honk_charges] viral files left.</b><HR>"
				if (istype(cartridge, /obj/item/weapon/cartridge/mime))
					dat += "<b>[cartridge:mime_charges] viral files left.</b><HR>"

				dat += "<h4><img src=pda_menu.png> Detected PDAs</h4>"

				dat += "<ul>"

				var/count = 0

				if (!toff)
					for (var/obj/item/device/pda/P in world)
						if (!P.owner||P.toff||P == src)	continue
						dat += "<li><a href='byond://?src=\ref[src];choice=Message;target=\ref[P]'>[P]</a>"
						if (istype(cartridge, /obj/item/weapon/cartridge/syndicate))
							dat += " (<a href='byond://?src=\ref[src];choice=Detonate;target=\ref[P]'><img src=pda_boom.png>*Detonate*</a>)"
						if (istype(cartridge, /obj/item/weapon/cartridge/clown))
							dat += " (<a href='byond://?src=\ref[src];choice=Send Honk;target=\ref[P]'><img src=pda_honk.png>*Send Virus*</a>)"
						if (istype(cartridge, /obj/item/weapon/cartridge/mime))
							dat += " (<a href='byond://?src=\ref[src];choice=Send Silence;target=\ref[P]'>*Send Virus*</a>)"
						dat += "</li>"
						count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"

			if(21)
				dat += "<h4><img src=pda_mail.png> SpaceMessenger V3.9.4</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Clear'><img src=pda_blank.png> Clear Messages</a>"

				dat += "<h4><img src=pda_mail.png> Messages</h4>"

				dat += tnote
				dat += "<br>"

			if (3)
				dat += "<h4><img src=pda_atmos.png> Atmospheric Readings</h4>"

				var/turf/T = get_turf_or_move(user.loc)
				if (isnull(T))
					dat += "Unable to obtain a reading.<br>"
				else
					var/datum/gas_mixture/environment = T.return_air()

					var/pressure = environment.return_pressure()
					var/total_moles = environment.total_moles()

					dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

					if (total_moles)
						var/o2_level = environment.oxygen/total_moles
						var/n2_level = environment.nitrogen/total_moles
						var/co2_level = environment.carbon_dioxide/total_moles
						var/plasma_level = environment.toxins/total_moles
						var/unknown_level =  1-(o2_level+n2_level+co2_level+plasma_level)
						dat += "Nitrogen: [round(n2_level*100)]%<br>"
						dat += "Oxygen: [round(o2_level*100)]%<br>"
						dat += "Carbon Dioxide: [round(co2_level*100)]%<br>"
						dat += "Plasma: [round(plasma_level*100)]%<br>"
						if(unknown_level > 0.01)
							dat += "OTHER: [round(unknown_level)]%<br>"
					dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
				dat += "<br>"
			else//Else it links to the cart menu proc. Although, it really uses menu hub 4--menu 4 doesn't really exist as it simply redirects to hub.
				dat += cart

	dat += "</body></html>"
	user << browse(dat, "window=pda;size=400x444;border=1;can_resize=1;can_close=0;can_minimize=0")
	onclose(user, "pda", src)

/obj/item/device/pda/Topic(href, href_list)
	..()
	var/mob/living/U = usr
	//Looking for master was kind of pointless since PDAs don't appear to have one.
	if ((src in U.contents) || ( istype(loc, /turf) && in_range(src, U) ) )
		if ( !(U.stat || U.restrained()) )

			add_fingerprint(U)
			U.machine = src

			switch(href_list["choice"])

//BASIC FUNCTIONS===================================

				if("Close")//Self explanatory
					U.machine = null
					U << browse(null, "window=pda")
					return
				if("Refresh")//Refresh, goes to the end of the proc.
				if("Return")//Return
					if(mode<=9)
						mode = 0
					else
						mode = round(mode/10)
						if(mode==4)//Fix for cartridges. Redirects to hub.
							mode = 0
						else if(mode >= 40 && mode <= 49)//Fix for cartridges. Redirects to refresh the menu.
							cartridge.mode = mode
							cartridge.unlock()
				if ("Authenticate")//Checks for ID
					id_check(U, 1)
				if("Eject")//Ejects the cart, only done from hub.
					if (!isnull(cartridge))
						var/turf/T = loc
						if(ismob(T))
							T = T.loc
						cartridge.loc = T
						scanmode = 0
						if (cartridge.radio)
							cartridge.radio.hostpda = null
						cartridge = null

//MENU FUNCTIONS===================================

				if("0")//Hub
					mode = 0
				if("1")//Notes
					mode = 1
				if("2")//Messenger
					mode = 2
				if("21")//Read messeges
					mode = 21
				if("3")//Atmos scan
					mode = 3
				if("4")//Redirects to hub
					mode = 0


//MAIN FUNCTIONS===================================

				if("Light")
					fon = (!fon)
					if (src in U.contents)
						if (fon)
							U.ul_SetLuminosity(U.luminosity + f_lum)
						else
							U.ul_SetLuminosity(U.luminosity - f_lum)
					else
						U.ul_SetLuminosity(fon * f_lum)
				if("Medical Scan")
					if(scanmode == 1)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_medical))
						scanmode = 1
				if("Forensic Scan")
					if(scanmode == 2)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_security))
						scanmode = 2
				if("Reagent Scan")
					if(scanmode == 3)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_reagent_scanner))
						scanmode = 3
				if("Halogen Counter")
					if(scanmode == 4)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_engine))
						scanmode = 4
				if("Honk")
					if ( !(last_honk && world.time < last_honk + 20) )
						playsound(loc, 'bikehorn.ogg', 50, 1)
						last_honk = world.time

//MESSENGER/NOTE FUNCTIONS===================================

				if ("Edit")
					var/n = sanitize(input(U, "Please enter message", name, note)) as message
					if (in_range(src, U) && loc == U)
						n = copytext(adminscrub(n), 1, MAX_MESSAGE_LEN)
						if (mode == 1)
							note = n
					else
						U << browse(null, "window=pda")
						return
				if("Toggle Messenger")
					toff = !toff
				if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
					silent = !silent
				if("Clear")//Clears messages
					tnote = null
				if("Ringtone")
					var/t = sanitize(input(U, "Please enter new ringtone", name, ttone)) as text
					if (in_range(src, U) && loc == U)
						if (t)
							if ((uplink) && (cmptext(t,uplink.unlocking_code)))
								if(uplink.active)
									U << "The PDA uplink is already unlocked."
									mode = 1
								else
									U << "The PDA softly beeps."
									uplink.unlock()
							else
								t = copytext(sanitize(t), 1, 20)
								ttone = t
					else
						U << browse(null, "window=pda")
						return
				if("Message")
					var/t = input(U, "Please enter message", name, null) as text
					t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
					if (!t)
						return
					if (!in_range(src, U) && loc != U)
						return

					var/obj/item/device/pda/P = locate(href_list["target"])

					if (isnull(P)||P.toff || toff)
						return

					if (last_text && world.time < last_text + 5)
						return

					last_text = world.time

					for (var/obj/machinery/message_server/MS in world)
						MS.send_pda_message("[P.owner]","[owner]","[t]")

					tnote += "<i><b>&rarr; To [P.owner]:</b></i><br>[t]<br>"
					P.tnote += "<i><b>&larr; From <a href='byond://?src=\ref[P];choice=Message;target=\ref[src]'>[owner]</a>:</b></i><br>[t]<br>"

					if (prob(15)) //Give the AI a chance of intercepting the message
						for (var/mob/living/silicon/ai/A in world)
							A.show_message("<i>Intercepted message from <b>[P:owner]</b>: [t]</i>")

					if (!P.silent)
						playsound(P.loc, 'twobeep.ogg', 50, 1)
						for (var/mob/O in hearers(3, P.loc))
							O.show_message(text("\icon[P] *[P.ttone]*"))

					P.overlays = null
					P.overlays += image('pda.dmi', "pda-r")
				if("Send Honk")//Honk virus
					if(istype(cartridge, /obj/item/weapon/cartridge/clown))//Cartridge checks are kind of unnecessary since everything is done through switch.
						var/obj/item/device/pda/P = locate(href_list["target"])//Leaving it alone in case it may do something useful, I guess.
						if(!isnull(P))
							if (!P.toff && cartridge:honk_charges > 0)
								cartridge:honk_charges--
								U.show_message("\blue Virus sent!", 1)
								P.honkamt = (rand(15,20))
						else
							U << "PDA not found."
					else
						U << browse(null, "window=pda")
						return
				if("Send Silence")//Silent virus
					if(istype(cartridge, /obj/item/weapon/cartridge/mime))
						var/obj/item/device/pda/P = locate(href_list["target"])
						if(!isnull(P))
							if (!P.toff && cartridge:mime_charges > 0)
								cartridge:mime_charges--
								U.show_message("\blue Virus sent!", 1)
								P.silent = 1
								P.ttone = "silence"
						else
							U << "PDA not found."
					else
						U << browse(null, "window=pda")
						return


//SYNDICATE FUNCTIONS===================================

				if("Toggle Door")
					if(!isnull(cartridge) && cartridge.access_remote_door)
						for(var/obj/machinery/door/poddoor/M in machines)
							if(M.id == cartridge.remote_door_id)
								if(M.density)
									spawn(0)
										M.open()
								else
									spawn(0)
										M.close()
				if("Lock")
					if(uplink)
						uplink.active = 0
						note = uplink.orignote
				if("Detonate")//Detonate PDA
					if(istype(cartridge, /obj/item/weapon/cartridge/syndicate))
						var/obj/item/device/pda/P = locate(href_list["target"])
						if(!isnull(P))
							if (!P.toff && cartridge:shock_charges > 0)
								cartridge:shock_charges--

								var/difficulty = 0

								if (!isnull(P.cartridge))
									difficulty += P.cartridge.access_medical
									difficulty += P.cartridge.access_security
									difficulty += P.cartridge.access_engine
									difficulty += P.cartridge.access_clown
									difficulty += P.cartridge.access_janitor
									difficulty += P.cartridge.access_manifest * 2
								else
									difficulty += 2

								if ((prob(difficulty * 12)) || (P.uplink))
									U.show_message("\red An error flashes on your [src].", 1)
								else if (prob(difficulty * 3))
									U.show_message("\red Energy feeds back into your [src]!", 1)
									U << browse(null, "window=pda")
									explode()
								else
									U.show_message("\blue Success!", 1)
									P.explode()
						else
							U << "PDA not found."
					else
						U.machine = null
						U << browse(null, "window=pda")
						return

//pAI FUNCTIONS===================================
				/*if("pai")
					switch(href_list["option"])
						if("1")		// Configure pAI device
							pai.attack_self(U)
						if("2")		// Eject pAI device
							var/turf/T = get_turf_or_move(src.loc)
							if(T)
								pai.loc = T*/

//LINK FUNCTIONS===================================

				else//Cartridge menu linking
					mode = text2num(href_list["choice"])
					cartridge.mode = mode
					cartridge.unlock()
		else//If can't interact.
			U.machine = null
			U << browse(null, "window=pda")
			return
	else//If not in range or not using the pda.
		U.machine = null
		U << browse(null, "window=pda")
		return

//EXTRA FUNCTIONS===================================

	if (mode == 2||mode == 21)//To clear message overlays.
		overlays = null

	if ((honkamt > 0) && (prob(60)))//For clown virus.
		honkamt--
		playsound(loc, 'bikehorn.ogg', 30, 1)

	if(U.machine == src)//Final safety.
		attack_self(U)//It auto-closes the menu prior if the user is not in range and so on.
	else
		U.machine = null
		U << browse(null, "window=pda")
	return

/obj/item/device/pda/proc/id_check(mob/user as mob, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			if (istype(loc, /mob))
				var/obj/item/W = loc:equipped()
				var/emptyHand = (W == null)
				if(emptyHand)
					id.DblClick()
					if(!istype(id.loc, /obj/item/device/pda))
						id = null
			else
				id.loc = loc
				id = null
		else
			var/obj/item/I = user.equipped()
			if (istype(I, /obj/item/weapon/card/id))
				user.drop_item()
				I.loc = src
				id = I
	else
		var/obj/item/weapon/card/I = user.equipped()
		if(id) // Get id and replace it.
			user.drop_item()
			I.loc = src
			user.put_in_hand(id)
			id = I
		else // Insert id.
			user.drop_item()
			I.loc = src
			id = I
	return

// access to status display signals
/obj/item/device/pda/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if (istype(C, /obj/item/weapon/cartridge) && isnull(src.cartridge))
		user.drop_item()
		C.loc = src
		user << "\blue You insert [C] into [src]."
		cartridge = C
		if (cartridge.radio)
			cartridge.radio.hostpda = src

	else if (istype(C, /obj/item/weapon/card/id) && C:registered)
		if(!owner)
			owner = C:registered
			ownjob = C:assignment
			name = "PDA-[owner] ([ownjob])"
			user << "\blue Card scanned."
		else
			var/input=alert("Would you like to insert the card or update owner information?",,"Insert","Update")
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.

			if ( ( (src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_range(src, user) && (C in user.contents)) )
				if ( !(user.stat || user.restrained()) )//If they can still act.
					if(input=="Insert")
						id_check(user, 2)
					else
						if(!(owner == C:registered))
							user << "\blue Name on card does not match registered name. Please try again."
						else if((owner == C:registered) && (ownjob == C:assignment))
							user << "\blue Rank is up to date."
						else if((owner == C:registered) && (ownjob != C:assignment))
							ownjob = C:assignment
							name = "PDA-[owner] ([ownjob])"
							user << "\blue Rank updated."
					updateSelfDialog()//Update self dialog on success.
			return//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	/*else if (istype(C, /obj/item/device/paicard) && !src.pai)
		user.drop_item()
		C.loc = src
		pai = C
		user << "\blue You slot \the [C] into [src]."
		updateUsrDialog()*/
	return

/obj/item/device/pda/attack(mob/M as mob, mob/user as mob)
	if (istype(M, /mob/living/carbon))
		switch(scanmode)
			if(1)
				if ((user.mutations & CLUMSY || user.brainloss >= 60) && prob(50))
					user << text("\red You try to analyze the floor's vitals!")
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [user] has analyzed the floor's vitals!"), 1)
					user.show_message(text("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
					user.show_message(text("\blue \t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
					user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
					user.show_message("\blue Body Temperature: ???", 1)
					return
				if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
					usr << "\red You don't have the dexterity to do this!"
					return
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] has analyzed []'s vitals!", user, M), 1)
					//Foreach goto(67)
				user.show_message(text("\blue Analyzing Results for []:\n\t Overall Status: []", M, (M.stat > 1 ? "\red dead" : text("[]% healthy", M.health))), 1)
				user.show_message(text("\blue \t Damage Specifics: []-[]-[]-[]", M.oxyloss > 50 ? "\red [M.oxyloss]" : M.oxyloss, M.toxloss > 50 ? "\red [M.toxloss]" : M.toxloss, M.fireloss > 50 ? "\red[M.fireloss]" : M.fireloss, M.bruteloss > 50 ? "\red[M.bruteloss]" : M.bruteloss), 1)
				user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
				user.show_message("\blue Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)", 1)
				user.show_message(text("\blue [] | [] | [] | []", M.oxyloss > 50 ? "\red Severe oxygen deprivation detected\blue" : "Subject bloodstream oxygen level normal", M.toxloss > 50 ? "\red Dangerous amount of toxins detected\blue" : "Subject bloodstream toxin level minimal", M.fireloss > 50 ? "\red Severe burn damage detected\blue" : "Subject burn injury status O.K", M.bruteloss > 50 ? "\red Severe anatomical damage detected\blue" : "Subject brute-force injury status O.K"), 1)
				if (M.virus)
					user.show_message(text("\red <b>Warning: Pathogen Detected</b>\nName: [M.virus.name].\nType: [M.virus.spread].\nStage: [M.virus.stage]/[M.virus.max_stages].\nPossible Cure: [M.virus.cure]"))
				if (istype(M, /mob/living/carbon) && M:virus2)
					user.show_message(text("\red <b>Warning: Unknown Pathogen Detected</b>"))
				if (M.reagents && M.reagents:get_reagent_amount("inaprovaline"))
					user.show_message(text("\blue Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals."), 1)
				if (M.brainloss >= 100 || istype(M, /mob/living/carbon/human) && M:brain_op_stage == 4.0)
					user.show_message(text("\red Subject is brain dead."), 1)
				else if (M.brainloss >= 60)
					user.show_message(text("\red Severe brain damage detected. Subject likely to have mental retardation."), 1)
				else if (M.brainloss >= 10)
					user.show_message(text("\red Significant brain damage detected. Subject may have had a concussion."), 1)
				if(!M.client)
					user.show_message(text("\red Subject is disconnected from the reality"), 1)
				for(var/obj/item/I in M)
					if(I.contaminated)
						user.show_message("\red <b>Warning: Plasma Contaminated Items Detected</b>\nAnalysis and cleaning or disposal of affected items is necessary.",1)
						break
				if(ishuman(M))
					if(M:vessel)
						var/amt = M:vessel.get_reagent_amount("blood")
						var/lol = round(amt)
						var/calc =  lol / 560
						calc *= 100
						if(amt <= 448)
							user.show_message("\red <b>Warning: Blood Level LOW: [calc]% [amt]cl")
						else if(amt <= 336)
							user.show_message("\red <b>Warning: Blood Level CRITICAL: [calc]% [amt]cl")
						else
							user.show_message("\blue Blood Level Normal: [calc]% [amt]cl")
				src.add_fingerprint(user)
				return

/obj/item/device/pda/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	switch(scanmode)
		if(1) // medical scanner
			if(isobj(A))
				user << "\blue Scanning for contaminants..."
				sleep(1)
				if(!(A in range(user,1)))
					user << "\red Error: Target object not found."
				else
					if(A:contaminated)
						user << "\red [A] shows signs of plasma contamination!"
					else
						user << "\blue [A] is free of contamination."
		if(2) // forensics
			if (!A.fingerprints)
				user << "\blue Unable to locate any fingerprints on [A]!"
			else
				var/list/L = params2list(A:fingerprints)
				user << "\blue Isolated [L.len] fingerprints."
				for(var/i in L)
					user << "\blue \t [i]"

		if(3) // reagent
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					user << "\blue [reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."
					for (var/re in A.reagents.reagent_list)
						user << "\blue \t [re]"
				else
					user << "\blue No active chemical agents found in [A]."
			else
				user << "\blue No significant chemical agents found in [A]."

	if (!scanmode && istype(A, /obj/item/weapon/paper) && owner)
		if ((!isnull(uplink)) && (uplink.active))
			uplink.orignote = A:info
		else
			note = A:info
		user << "\blue Paper scanned." //concept of scanning paper copyright brainoblivion 2009

/obj/item/device/pda/proc/explode() //This needs tuning.

	var/turf/T = get_turf(src.loc)

	if (ismob(loc))
		var/mob/M = loc
		M.show_message("\red Your [src] explodes!", 1)

	if(T)
		T.hotspot_expose(700,125)

		explosion(T, -1, -1, 2, 3)

	del(src)
	return

/obj/item/device/pda/Del()
	if (src.id)
		if(istype(src.loc, /mob))
			src.id.loc = src.loc.loc
		else src.id.loc = src.loc
	..()

/obj/item/device/pda/clown/HasEntered(AM as mob|obj) //Clown PDA is slippery.
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		//if ((istype(M, /mob/living/carbon/human) && (istype(M:shoes, /obj/item/clothing/shoes) && M:shoes.flags&NOSLIP)) || M.m_intent == "walk") // tg one, make it work later -- Nikie
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk") // bay12 one
			return

		if ((istype(M, /mob/living/carbon/human) && (M.real_name != src.owner) && (istype(src.cartridge, /obj/item/weapon/cartridge/clown))))
			if (src.cartridge:honk_charges < 5)
				src.cartridge:honk_charges++

		M.pulling = null
		M << "\blue You slipped on the PDA!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5


//AI verb and proc for sending PDA messages.

/mob/living/silicon/ai/verb/cmd_send_pdamesg()
	set category = "AI Commands"
	set name = "Send PDA Message"
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if(usr.stat == 2)
		usr << "You can't send PDA messages because you are dead!"
		return

	for (var/obj/item/device/pda/P in world)
		if (!P.owner)
			continue
		else if (P == src)
			continue
		else if (P.toff)
			continue

		var/name = P.owner
		if (name in names)
			namecounts[name]++
			name = text("[name] ([namecounts[name]])")
		else
			names.Add(name)
			namecounts[name] = 1

		plist[text("[name]")] = P

	var/c = input(usr, "Please select a PDA") as null|anything in plist

	if (!c)
		return

	var/selected = plist[c]
	ai_send_pdamesg(selected)

/mob/living/silicon/ai/proc/ai_send_pdamesg(obj/selected as obj)
	var/t = input(usr, "Please enter message", src.name, null) as text
	var/t_chat = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
	t = copytext(sanitize_spec(t), 1, MAX_MESSAGE_LEN)
	if (!t)
		return

	if (selected:toff)
		return

	usr.show_message("<i>PDA message to <b>[selected:owner]</b>: [t_chat]</i>")
	selected:tnote += "<i><b>&larr; From (AI) [usr.name]:</b></i><br>[t]<br>"

	if (!selected:silent)
		playsound(selected.loc, 'twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(3, selected.loc))
			O.show_message(text("\icon[selected] *[selected:ttone]*"))

	selected.overlays = null
	selected.overlays += image('pda.dmi', "pda-r")


//Some spare PDAs in a box

/obj/item/weapon/storage/box/PDA
	name = "spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'pda.dmi'
	icon_state = "pdabox"
	item_state = "syringe_kit"

/obj/item/weapon/storage/box/PDA/New()
	..()
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)

	var/newcart = pick(1,2,3,4)
	switch(newcart)
		if(1)
			new /obj/item/weapon/cartridge/janitor(src)
		if(2)
			new /obj/item/weapon/cartridge/security(src)
		if(3)
			new /obj/item/weapon/cartridge/medical(src)
		if(4)
			new /obj/item/weapon/cartridge/head(src)

	new /obj/item/weapon/cartridge/signal/toxins(src)


// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/*/obj/item/device/pda/emp_act(severity)
	for(var/atom/A in src)
		A.emp_act(severity)*/