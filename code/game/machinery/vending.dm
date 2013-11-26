/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'vending.dmi'
	icon_state = "generic"
	anchored = 1
	density = 1
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/points = 0
	var/product_paths = "" //String of product paths separated by semicolons.
	var/product_amounts = "" //String of product amounts separated by semicolons, must have amount for every path in product_paths
	var/product_prices = "" //String of product prices in Points separated by semicolons, must have amount for every path in product_paths
	var/product_slogans = "" //String of slogans separated by semicolons, optional
	var/product_hidden = "" //String of products that are hidden unless hacked.
	var/hidden_prices = "" //String of product prices for hidden items
	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/slogan_list = list()
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 600 //How long until we can pitch again?
	var/icon_vend //Icon_state when vending!
	var/icon_deny //Icon_state when vending!
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/extended_inventory = 0 //can we access the hidden inventory?
	var/panel_open = 0 //Hacking that vending machine. Gonna get a free candy bar.
	var/wires = 15
	var/charge_type = ""

/obj/machinery/vending
	var/const
		WIRE_EXTEND = 1
		WIRE_SCANID = 2
		WIRE_SHOCK = 3
		WIRE_SHOOTINV = 4

/datum/data/vending_product
	var/product_name = "generic"
	var/product_path = null
	var/amount = 0
	var/price = 0
	var/display_color = "blue"

/obj/machinery/vending/New()
	..()
	spawn(4)
	//	src.slogan_list = dd_text2list(src.product_slogans, ";")
		src.slogan_list = list()
		var/list/temp_paths = dd_replacetext(src.product_paths, "\n", "")
		var/list/temp_pathsL = dd_text2list(temp_paths, ";")
		//var/list/temp_amounts = dd_text2list(src.product_amounts, ";")
		var/list/temp_prices = dd_text2list(src.product_prices, ";")
		var/list/temp_hidden = dd_text2list(src.product_hidden, ";")
		var/list/temp_hiddenprices = dd_text2list(src.hidden_prices, ";")
		//Little sanity check here
		if ((isnull(temp_pathsL)) || (isnull(temp_prices)) || (temp_pathsL.len != temp_prices.len))
			stat |= BROKEN
			return

		src.build_inventory(temp_pathsL,temp_prices)
		 //Add hidden inventory
		src.build_inventory(temp_hidden,temp_hiddenprices,1)
		return

	return

/obj/machinery/vending/ex_act(severity)
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
				spawn(0)
					src.malfunction()
					return
				return
	return

/obj/machinery/vending/blob_act()
	if (prob(25))
		spawn(0)
			src.malfunction()
			del(src)
		return
	return

/obj/machinery/vending/proc/build_inventory(var/list/path_list,var/list/price_list,hidden=0)
	for(var/p=1, p <= path_list.len ,p++)
		var/checkpath = text2path(path_list[p])
		if (!checkpath)
			continue
		var/obj/temp = new checkpath(src)
		var/datum/data/vending_product/R = new /datum/data/vending_product(  )
		R.product_name = capitalize(temp.name)
		R.product_path = path_list[p]
		R.display_color = pick("red","blue","green")

		if(hidden)
			R.price = text2num(price_list[p])
			src.hidden_records += R

		else
			R.price = text2num(price_list[p])
			src.product_records += R

		del(temp)

//			world << "Added: [R.product_name]] - [R.amount] - [R.product_path]"
		continue

	return

/obj/machinery/vending/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/emag))
		src.emagged = 1
		user << "You short out the product lock on [src]"
		return
	else if(istype(W, /obj/item/weapon/screwdriver))
		src.panel_open = !src.panel_open
		user << "You [src.panel_open ? "open" : "close"] the maintenance panel."
		src.overlays = null
		if(src.panel_open)
			src.overlays += image(src.icon, "[initial(icon_state)]-panel")
		src.updateUsrDialog()
		return
	else if (istype(W,/obj/item/weapon/vending_charge/))
		DoCharge(W,user)
			//points += W.charge_amt
			//del(W)
	else
		..()

/obj/machinery/vending/proc/DoCharge(obj/item/weapon/vending_charge/V as obj, mob/user as mob)
	if(charge_type == V.charge_type)
		points += V.charge_amt
		del(V)
		user << "You insert the charge into the machine."

/obj/item/weapon/vending_charge
	name = "Vending Charge"
	var/charge_amt = 10
	var/charge_type = "generic"
	icon = 'vending.dmi'
	icon_state = "generic-charge"

/obj/item/weapon/vending_charge/medical
	name = "Medical Charge"
	charge_type = "medical"
	icon_state = "medical-charge"

/obj/item/weapon/vending_charge/genetics
	name = "Genetics Charge"
	charge_type = "genetics"
	icon_state = "generic-charge"

/obj/item/weapon/vending_charge/toxins
	name = "Toxins Charge"
	charge_type = "toxins"
	icon_state = "toxins-charge"

/obj/item/weapon/vending_charge/robotics
	name = "Robotics Charge"
	charge_type = "robotics"
	icon_state = "robotics-charge"

/obj/item/weapon/vending_charge/bar
	name = "Bar Charge"
	charge_type = "bar"
	charge_amt = 50
	icon_state = "bar-charge"

/obj/item/weapon/vending_charge/kitchen
	name = "Kitchen Charge"
	charge_type = "kitchen"
	icon_state = "kitchen-charge"

/obj/item/weapon/vending_charge/engineering
	name = "Engineering Charge"
	charge_type = "engineering"
	icon_state = "engineering-charge"

/obj/item/weapon/vending_charge/security
	name = "Security Charge"
	charge_type = "security"
	icon_state = "security-charge"

/obj/item/weapon/vending_charge/coffee
	name = "Coffee Charge"
	charge_type = "coffee"
	icon_state = "coffee-charge"

/obj/item/weapon/vending_charge/snack
	name = "Snack Charge"
	charge_type = "snack"
	icon_state = "snack-charge"

/obj/item/weapon/vending_charge/cart
	name = "Cart Charge"
	charge_type = "cart"
	icon_state = "cart-charge"

/obj/item/weapon/vending_charge/cigarette
	name = "Cigarette Charge"
	charge_type = "cigarette"
	icon_state = "cigarette-charge"




/obj/machinery/vending/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	user.machine = src

	if(src.seconds_electrified != 0)
		if(src.shock(user, 100))
			return

	if(panel_open)
		var/list/vendwires = list(
			"Violet" = 1,
			"Orange" = 2,
			"Goldenrod" = 3,
			"Green" = 4,
		)
		var/pdat = "<B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
			pdat += "[wiredesc] wire: "
			if(!is_uncut)
				pdat += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				pdat += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				pdat += "<a href='?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			pdat += "<br>"

		pdat += "<br>"
		pdat += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
		pdat += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
		pdat += "The green light is [src.extended_inventory ? "on" : "off"].<BR>"
		pdat += "The [(src.wires & WIRE_SCANID) ? "purple" : "yellow"] light is on.<BR>"

		user << browse(pdat, "window=vendwires")
		onclose(user, "vendwires")

	var/dat = "<TT><b>Select an item:</b></TT><br>"

	if (src.product_records.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		var/list/display_records = src.product_records
		if(src.extended_inventory)
			display_records = (src.product_records + src.hidden_records)
		dat += "<TABLE width=100%><TR><TD><TT><B>Product:</B></TT></TD> <TD><TT><B>Cost:</B></TT></TD><TD></TD></TR>"

		for (var/datum/data/vending_product/R in display_records)
			dat += "<TR><TD><TT><FONT color = '[R.display_color]'><B>[R.product_name]</B></TT></TD>"
			dat += " <TD><TT>[R.price]</TT></TD> </font>"
			if (R.price <= points)
				dat += "<TD><TT><a href='byond://?src=\ref[src];vend=\ref[R]'>Vend</A></TT></TD></TR>"
			else
				dat += "<TD><TT><font color = 'red'>NOT ENOUGH POINTS</font></TD></TT></TR>"
			//dat += "<br>"

		dat += "</TABLE><br><TT><b>Points available: [points]</b><br></TT>"

	user << browse(dat, "window=vending")
	onclose(user, "vending")
	return

/obj/machinery/vending/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return

	if(istype(usr,/mob/living/silicon))
		usr << "\red The vending machine refuses to interface with you, as you are not in its target demographic!"
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.machine = src
		if ((href_list["vend"]) && (src.vend_ready))

			if ((!src.allowed(usr)) && (!src.emagged) && (src.wires & WIRE_SCANID)) //For SECURE VENDING MACHINES YEAH
				usr << "\red Access denied." //Unless emagged of course
				flick(src.icon_deny,src)
				return

			src.vend_ready = 0 //One thing at a time!!

			var/datum/data/vending_product/R = locate(href_list["vend"])
			if (!R || !istype(R))
				src.vend_ready = 1
				return
			var/product_path = text2path(R.product_path)
			if (!product_path)
				src.vend_ready = 1
				return

			if (R.price > points)
				src.vend_ready = 1
				return

			points -= R.price

			if(((src.last_reply + (src.vend_delay + 200)) <= world.time) && src.vend_reply)
				spawn(0)
					src.speak(src.vend_reply)
					src.last_reply = world.time

			use_power(5)
			if (src.icon_vend) //Show the vending animation if needed
				flick(src.icon_vend,src)
			spawn(src.vend_delay)
				new product_path(get_turf(src))
				src.vend_ready = 1
				return

			src.updateUsrDialog()
			return

		else if ((href_list["cutwire"]) && (src.panel_open))
			var/twire = text2num(href_list["cutwire"])
			if (!( istype(usr.equipped(), /obj/item/weapon/wirecutters) ))
				usr << "You need wirecutters!"
				return
			if (src.isWireColorCut(twire))
				src.mend(twire)
			else
				src.cut(twire)

		else if ((href_list["pulsewire"]) && (src.panel_open))
			var/twire = text2num(href_list["pulsewire"])
			if (!istype(usr.equipped(), /obj/item/device/multitool))
				usr << "You need a multitool!"
				return
			if (src.isWireColorCut(twire))
				usr << "You can't pulse a cut wire."
				return
			else
				src.pulse(twire)

		src.add_fingerprint(usr)
		src.updateUsrDialog()
	else
		usr << browse(null, "window=vending")
		return
	return

/obj/machinery/vending/process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!src.active)
		return

	if(src.seconds_electrified > 0)
		src.seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(prob(5) && ((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0))
		var/slogan = pick(src.slogan_list)
		src.speak(slogan)
		src.last_slogan = world.time

	if((prob(2)) && (src.shoot_inventory))
		src.throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"",2)
	return

/obj/machinery/vending/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "[initial(icon_state)]-off"
				stat |= NOPOWER

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
//	for(var/datum/data/vending_product/R in src.product_records)
//		if (R.amount <= 0) //Try to use a record that actually has something to dump.
//			continue
//		var/dump_path = text2path(R.product_path)
//		if (!dump_path)
//			continue
//
//		while(R.amount>0)
//			new dump_path(src.loc)
//			R.amount--
//		break
//
//	stat |= BROKEN
//	src.icon_state = "[initial(icon_state)]-broken"
//	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/data/vending_product/R in src.product_records)
		if (R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = text2path(R.product_path)
		if (!dump_path)
			continue

		R.amount--
		throw_item = new dump_path(src.loc)
		break

	spawn(0)
		throw_item.throw_at(target, 16, 3)
	src.visible_message("\red <b>[src] launches [throw_item.name] at [target.name]!</b>")
	return 1

/obj/machinery/vending/proc/isWireColorCut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/vending/proc/isWireCut(var/wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/vending/proc/cut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	src.wires &= ~wireFlag
	switch(wireIndex)
		if(WIRE_EXTEND)
			src.extended_inventory = 0
		if(WIRE_SHOCK)
			src.seconds_electrified = -1
		if (WIRE_SHOOTINV)
			if(!src.shoot_inventory)
				src.shoot_inventory = 1


/obj/machinery/vending/proc/mend(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	src.wires |= wireFlag
	switch(wireIndex)
//		if(WIRE_SCANID)
		if(WIRE_SHOCK)
			src.seconds_electrified = 0
		if (WIRE_SHOOTINV)
			src.shoot_inventory = 0

/obj/machinery/vending/proc/pulse(var/wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(WIRE_EXTEND)
			src.extended_inventory = !src.extended_inventory
//		if (WIRE_SCANID)
		if (WIRE_SHOCK)
			src.seconds_electrified = 30
		if (WIRE_SHOOTINV)
			src.shoot_inventory = !src.shoot_inventory


//"Borrowed" airlock shocking code.
/obj/machinery/vending/proc/shock(mob/user, prb)
	if(!prob(prb))
		return 0
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0

	return Electrocute(user, 1)




/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical Equipment dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	req_access_txt = "5"
	points = 20
	product_paths = "/obj/item/clothing/under/rank/medical;/obj/item/clothing/under/rank/chemist;/obj/item/clothing/suit/storage/labcoat;/obj/item/clothing/shoes/white;/obj/item/device/healthanalyzer;/obj/item/stack/medical/bruise_pack;/obj/item/stack/medical/ointment;/obj/item/stack/medical/bandaid;/obj/item/weapon/reagent_containers/glass/bottle/antitoxin;/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline;/obj/item/weapon/reagent_containers/glass/bottle/stoxin;/obj/item/weapon/reagent_containers/syringe;/obj/item/weapon/tank/anesthetic;/obj/item/clothing/mask/breath/medical;/obj/item/clothing/gloves/latex;/obj/item/weapon/storage/firstaid/regular;/obj/item/weapon/storage/firstaid/toxin;/obj/item/weapon/storage/firstaid/fire;/obj/item/weapon/storage/firstaid/o2"
	//product_amounts = "4;4;4;4;12"
	product_prices = "1;1;1;1;2;1;1;1;3;3;3;1;2;1;1;5;5;5;5"
	product_hidden = "/obj/item/weapon/reagent_containers/pill/tox;/obj/item/weapon/reagent_containers/glass/bottle/toxin;/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate;/obj/item/weapon/gun/syringe"
	hidden_prices = "4;2;4;6"
	charge_type = "medical"

/obj/machinery/vending/medical/wall
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access_txt = ""
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	points = 12
	product_paths = "/obj/item/device/healthanalyzer;/obj/item/stack/medical/bruise_pack;/obj/item/stack/medical/ointment;/obj/item/stack/medical/bandaid;/obj/item/weapon/reagent_containers/syringe/antitoxin;/obj/item/weapon/reagent_containers/syringe/inaprovaline;/obj/item/weapon/reagent_containers/pill/dexalin;/obj/item/weapon/reagent_containers/syringe/antiviral;/obj/item/clothing/gloves/latex"
	product_prices = "2;1;1;1;1;1;1;2;1"
	product_hidden = "/obj/item/weapon/reagent_containers/pill/tox;/obj/item/weapon/reagent_containers/glass/bottle/stoxin"
	hidden_prices = "4;2"

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access_txt = "1"
	points = 10
	product_paths = "/obj/item/clothing/under/color/red;/obj/item/clothing/under/rank/forensic_technician;/obj/item/clothing/under/rank/det;/obj/item/clothing/suit/storage/det_suit;/obj/item/clothing/head/det_hat;/obj/item/clothing/head/helmet;/obj/item/clothing/suit/armor/vest;/obj/item/clothing/suit/storage/gearharness;/obj/item/weapon/storage/belt/security;/obj/item/device/radio/headset/headset_sec;/obj/item/clothing/glasses/sunglasses;/obj/item/weapon/handcuffs;/obj/item/weapon/melee/baton;/obj/item/weapon/gun/energy/taser;/obj/item/weapon/grenade/flashbang;/obj/item/device/flash/*;/obj/item/weapon/storage/box/evidence*/"
	//product_amounts = "8;5;4"
	product_prices = "1;1;1;1;1;3;3;3;2;1;1;1;4;4;3;3;2"
	product_hidden = "/obj/item/kitchen/donut_box"
	hidden_prices = "3"
	charge_type = "security"

/obj/machinery/vending/genetics
	name = "Genetics Dispenser"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	req_access_txt = "5"
	points = 10
	product_paths = "/obj/item/clothing/suit/storage/labcoat;/obj/item/clothing/under/rank/geneticist;/obj/item/weapon/reagent_containers/glass/bottle/antitoxin;/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline;/obj/item/weapon/reagent_containers/glass/bottle/stoxin;/obj/item/weapon/reagent_containers/glass/bottle/toxin;/obj/item/weapon/reagent_containers/syringe"
	//product_amounts = "4;4;4;4;12"
	product_prices = "1;1;2;2;2;2;1"
	product_hidden = ""
	hidden_prices = ""
	charge_type = "genetics"

/obj/machinery/vending/toxins
	name = "Toxins dispenser"
	desc = "Al the tools you need to blow up the ship."
	req_access_txt = "7"
	points = 10
	product_paths = {"/obj/item/clothing/under/rank/scientist;/obj/item/clothing/suit/bio_suit;/obj/item/clothing/head/bio_hood;/obj/item/weapon/screwdriver;/obj/item/weapon/wrench;/obj/item/weapon/wirecutters;/obj/item/device/transfer_valve;/obj/item/device/igniter;/obj/item/device/timer;/obj/item/device/prox_sensor;/obj/item/device/radio/signaler"}
	//product_amounts = "4;4;4;4;12"
	product_prices = "1;2;2;1;1;1;3;1;1;1;1"
	product_hidden = ""
	hidden_prices = ""
	charge_type = "toxins"

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access_txt = "29"
	points = 10
	product_paths = "/obj/item/clothing/suit/storage/labcoat;/obj/item/clothing/under/rank/roboticist;/obj/item/weapon/cable_coil/power;/obj/item/device/flash;/obj/item/weapon/circuitboard/circuitry;/obj/item/weapon/cell/supercharged;/obj/item/device/prox_sensor;/obj/item/device/radio/signaler;/obj/item/device/healthanalyzer;/obj/item/weapon/surgical/scalpel;/obj/item/weapon/surgical/circular_saw;/obj/item/weapon/tank/anesthetic;/obj/item/clothing/mask/breath/medical;/obj/item/weapon/screwdriver;/obj/item/weapon/crowbar"
	//product_amounts = "4;4;4;4;12"
	product_prices = "1;1;1;1;1;3;2;2;2;4;4;2;1;1;1"
	product_hidden = ""
	hidden_prices = ""
	charge_type = "robotics"

/obj/machinery/vending/kitchen
    name = "Kitchen Mate Plus"
    desc = "The Kitchen Mate Plus.  Better ingredients.  Better burgers."
    icon_state = "kitchen"
    icon_deny = "kitchen-deny"
    req_access_txt = "28"
    points = 30
    product_paths = {"/obj/item/clothing/under/rank/chef;
/obj/item/clothing/suit/storage/chef;
/obj/item/clothing/head/chefhat;
/obj/item/weapon/kitchen/utensil/knife;
/obj/item/weapon/kitchen/rollingpin;
/obj/item/weapon/reagent_containers/food/drinks/soda/cola;
/obj/item/weapon/reagent_containers/food/drinks/coffee;
/obj/item/kitchen/egg_box;
/obj/item/weapon/reagent_containers/food/snacks/breadsys/butterpack;
/obj/item/weapon/reagent_containers/food/snacks/breadsys/salamistick;
/obj/item/weapon/reagent_containers/food/snacks/breadsys/bigcheese;
/obj/item/weapon/reagent_containers/food/snacks/sugar;
/obj/item/weapon/reagent_containers/food/snacks/flour;
/obj/item/weapon/reagent_containers/food/snacks/noodles;
/obj/item/weapon/reagent_containers/food/snacks/meat;
/obj/item/weapon/reagent_containers/food/snacks/rawmeatball;
/obj/item/weapon/reagent_containers/food/snacks/ketchup;
/obj/item/weapon/reagent_containers/food/snacks/potato;
/obj/item/weapon/reagent_containers/food/snacks/tomato;
/obj/item/weapon/reagent_containers/food/snacks/apple;
/obj/item/weapon/reagent_containers/food/snacks/fungi;
/obj/item/weapon/reagent_containers/food/snacks/plump"}
    //product_amounts = "10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10;10"
    product_prices = "1;1;1;1;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;2"
    product_hidden = ""
    hidden_prices = ""
    charge_type = "kitchen"

/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself ship repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access_txt = "10"
	points = 10
	product_paths = "/obj/item/clothing/under/rank/chief_engineer;/obj/item/clothing/under/rank/engineer;/obj/item/clothing/shoes/orange;/obj/item/clothing/head/helmet/hardhat;/obj/item/weapon/storage/belt/utility;/obj/item/clothing/glasses/meson;/obj/item/clothing/gloves/yellow;/obj/item/weapon/screwdriver;/obj/item/weapon/crowbar;/obj/item/weapon/wirecutters;/obj/item/device/multitool;/obj/item/weapon/wrench;/obj/item/device/t_scanner;/obj/item/weapon/cable_coil/power;/obj/item/weapon/circuitboard/circuitry;/obj/item/weapon/cell;/obj/item/weapon/weldingtool;/obj/item/clothing/head/helmet/welding;/obj/item/weapon/light/tube;/obj/item/clothing/suit/fire"
	//product_amounts = "4;4;4;4;12"
	product_prices = "1;1;1;2;2;1;2;1;1;2;2;1;1;1;2;2;1;1;1;2"
	product_hidden = ""
	hidden_prices = ""
	charge_type = "engineering"
