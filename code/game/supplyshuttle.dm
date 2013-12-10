//Config stuff
#define SUPPLY_DOCKZ 2         							//Z-level of the Dock.
#define SUPPLY_STATIONZ 1     							//Z-level of the Station.
#define SUPPLY_POINTSPER 1								//Points per tick.
#define SUPPLY_POINTDELAY 300							//Delay between ticks in milliseconds.
#define SUPPLY_MOVETIME 1200							//Time to station is milliseconds.
#define SUPPLY_POINTSPERCRATE 4							//Points per crate sent back.
#define SUPPLY_POINTSPERMANIFEST 4						//Points per stamped supply manifest sent back.
#define SUPPLY_POINTSPERPLASMASHEET 1					//Points per one plasma sheet sent back.
#define SUPPLY_STATION_AREATYPE "/area/supply/station" 	//Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE "/area/supply/dock"		//Type of the supply shuttle area for dock

var/supply_shuttle_moving = 0
var/supply_shuttle_at_station = 0
var/list/supply_shuttle_shoppinglist = list()
var/list/supply_shuttle_requestlist = list()
var/list/supply_packs_all = list()
var/supply_shuttle_can_send = 1
var/supply_shuttle_time = 0
var/supply_shuttle_timeleft = 0
var/supply_shuttle_points = 50

/obj/item/weapon/paper/manifest
	name = "Supply Manifest"

/area/supply/station //DO NOT TURN THE ul_Lighting STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	ul_Lighting = 0
	requires_power = 0

/area/supply/dock //DO NOT TURN THE ul_Lighting STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "supply shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	ul_Lighting = 0
	requires_power = 0


/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "plastic flaps"
	desc = "Free-hanging flaps of hard plastic."
	icon = 'stationobjs.dmi'
	icon_state = "plasticflaps"
	density = 1
	opacity = 1
	anchored = 1
	layer = 4


/obj/structure/plasticflaps/CanPass(atom/movable/A, target, height=0, air_group=0)
	if(istype(A, /mob/living)) // You Shall Not Pass!
		var/mob/living/M = A
		if(M.lying)	return 1	// unless you're lying down

	if(air_group) return 0 //AIRTIGHT

	if(istype(A, /obj)) return 1

	return ..()


/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			del(src)
		if (2)
			if (prob(50))
				del(src)
		if (3)
			if (prob(5))
				del(src)

/obj/effect/landmark/supplymarker
	icon_state = "X"
	icon = 'mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0

/area/supplyshuttle
	name = "Supply Shuttle"
	icon_state = "supply"
	requires_power = 0

/obj/machinery/computer/cargo
	var/temp = null
	var/hacked = 0
	brightnessred = 2
	brightnessgreen = 2
	brightnessblue = 2

/obj/machinery/computer/cargo/supplycomp
	name = "Supply shuttle console"
	icon_state = "shuttle"
	req_access = list(access_cargo)
	circuit = /obj/item/weapon/circuitboard/computer/supplycomp

/obj/machinery/computer/cargo/ordercomp
	name = "Supply ordering console"
	icon_state = "supply"
	circuit = /obj/item/weapon/circuitboard/computer/ordercomp

/datum/supply_order
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null

/proc/supply_ticker()
	supply_shuttle_points += SUPPLY_POINTSPER
	spawn(SUPPLY_POINTDELAY) supply_ticker()

/proc/supply_process()
	while(supply_shuttle_time - world.timeofday > 0)
		var/ticksleft = supply_shuttle_time - world.timeofday

		if(ticksleft > 1e5)
			supply_shuttle_time = world.timeofday + 10	// midnight rollover


		supply_shuttle_timeleft = round((ticksleft / 10)/60)
		sleep(10 * tick_multiplier)
	supply_shuttle_moving = 0
	send_supply_shuttle()

/proc/supply_can_move()
	if(supply_shuttle_moving) return 0

	var/shuttleat = supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE

	for(var/turf/T in get_area_turfs(shuttleat) )
		if(locate(/mob/living) in T) return 0
		for(var/atom/ATM in T)
			if(locate(/mob/living) in ATM) return 0

	return 1

/proc/sell_crates()
	var/shuttleat = supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE

	var/plasma_count = 0
	for(var/turf/T in get_area_turfs(shuttleat))
		var/crate = locate(/obj/structure/closet/crate) in T
		if(crate)
			var/find_slip = 1
			for(var/atom in crate)
				// Sell manifests
				var/atom/A = atom
				if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
					var/obj/item/weapon/paper/slip = A
					if(slip.stamped) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
						supply_shuttle_points += SUPPLY_POINTSPERMANIFEST
						find_slip = 0
				// Sell plasma
				if(istype(A, /obj/item/stack/sheet/mineral/plasma))
					var/obj/item/stack/sheet/mineral/plasma/P = A
					plasma_count += P.amount
			del(crate)
			supply_shuttle_points += SUPPLY_POINTSPERCRATE

		if(plasma_count)
			supply_shuttle_points += Floor(plasma_count * SUPPLY_POINTSPERPLASMASHEET)

/proc/process_supply_order()
	var/shuttleat = supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE

	var/list/markers = new/list()

	if(!supply_shuttle_shoppinglist.len) return

	for(var/turf/T in get_area_turfs(shuttleat))
		for(var/obj/effect/landmark/supplymarker/D in T)
			markers += D

	for(var/datum/supply_order/S in supply_shuttle_shoppinglist)
		var/pickedloc = 0
		var/found = 0
		for(var/C in markers) // Picking a location for every new supply pack
			if (locate(/obj) in get_turf(C)) continue
			found = 1
			pickedloc = get_turf(C)

		if(!found) pickedloc = get_turf(pick(markers))

		var/datum/supply_packs/SP = S.object

		var/list/order_items = list()

		if(istype(SP,/datum/supply_packs/randomised))
			var/datum/supply_packs/randomised/SPR = SP
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					var/itemtype = pick(SPR.contains)
					order_items += new itemtype()
		else
			for(var/B in SP.contains)
				var/atom/B2 = new B()
				if(SP.amount && B2:amount)
					B2:amount = SP.amount
				order_items += B2

		if(SP.manifest)
			var/obj/item/weapon/paper/manifest/manifest = new /obj/item/weapon/paper/manifest()
			manifest.info = "<h3>Centcomm Shipping Manifest</h3><hr><br>"
			//manifest.info +="Order #[S.ordernum]<br>"
			manifest.info +="Destination: NSV Luna<br>"
			manifest.info +="[supply_shuttle_shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			manifest.info +="CONTENTS:<br><ul>"
			manifest.info += SP.manifest
			manifest.info += "</ul><br>"
			manifest.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

			order_items += manifest

		if(SP.containertype) // If a container for this was selected
			var/atom/A = new SP.containertype(pickedloc)

			if(SP.containername)
				A.name = SP.containername

			if(SP.access)
				A:req_access = list()
				A:req_access += text2num(SP.access)

			for(var/obj/B in order_items)
				B.loc = A

		else // The supply pack comes by itself, not within a container. Generally used for a single larger item (watertank) or for stuff like metal sheets
			for(var/obj/B in order_items)
				B.loc = pickedloc

	return


/obj/machinery/computer/cargo/supplycomp/attackby(I as obj, user as mob)
	..()
	if(istype(I,/obj/item/weapon/card/emag) && !emagged)
		user << "\blue Special supplies unlocked."
		emagged = 1

/obj/machinery/computer/cargo/ordercomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if (src.temp)
		dat = src.temp
	else

		dat += {"<B>Supply shuttle</B><HR>
		Location: [supply_shuttle_moving ? "Moving to station ([supply_shuttle_timeleft] Mins.)":supply_shuttle_at_station ? "Station":"Dock"]<BR>
		<HR>Supply points: [supply_shuttle_points]<BR>
		<BR>\n<A href='?src=\ref[src];order=1'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/cargo/ordercomp/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

	src.temp = ""

	if (href_list["order_category"])
		src.temp = "Supply points: [supply_shuttle_points]<BR><HR>[href_list["order_category"]]<BR>Request what?<BR><BR>"
		src.temp += generate_supplypacks_html(href_list["order_category"])
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];order=1'>Back</A>"

	if (href_list["order"])
		src.temp = "Supply points: [supply_shuttle_points]<BR><HR>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Emergency'>Emergency</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Security'>Security</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Engineering'>Engineering</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Medical'>Medical</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Science'>Science</A>"
		//src.temp += "<BR><A href='?src=\ref[src];order_category=Food'>Food</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Materials'>Materials</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Miscellaneous'>Miscellaneous</A>"
		src.temp += "<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"


	else if (href_list["doorder"])
		var/datum/supply_order/O = new/datum/supply_order()
		var/supplytype = href_list["doorder"]
		var/datum/supply_packs/P = new supplytype()
		O.object = P
		O.orderedby = usr.name
		supply_shuttle_requestlist += O
		src.temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		if(href_list["category"])
			src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];order_category=[href_list["category"]]'>Back</A>"
		else
			src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["vieworders"])
		src.temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			src.temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["viewrequests"])
		src.temp = "Current requests: <BR><BR>"
		for(var/S in supply_shuttle_requestlist)
			var/datum/supply_order/SO = S
			src.temp += "[SO.object.name] requested by [SO.orderedby]<BR>"
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["mainmenu"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/cargo/supplycomp/attack_hand(var/mob/user as mob)
	if(!src.allowed(user))
		user << "\red Access Denied."
		return

	if(..())
		return
	user.machine = src
	post_signal("supply")
	var/dat
	if (src.temp)
		dat = src.temp
	else
		dat += {"<B>Supply Shuttle</B><HR>
		\nLocation: [supply_shuttle_moving ? "Moving to ship ([supply_shuttle_timeleft] Mins.)":supply_shuttle_at_station ? "Ship":"Dock"]<BR>
		<HR>\nSupply points: [supply_shuttle_points]<BR>\n<BR>
		[supply_shuttle_moving ? "\n*Must be at dock to order items*<BR>\n<BR>":supply_shuttle_at_station ? "\n*Must be at dock to order items*<BR>\n<BR>":"\n<A href='?src=\ref[src];order=1'>Order items</A><BR>\n<BR>"]
		[supply_shuttle_moving ? "\n*Shuttle already called*<BR>\n<BR>":supply_shuttle_at_station ? "\n<A href='?src=\ref[src];sendtodock=1'>Send to Dock</A><BR>\n<BR>":"\n<A href='?src=\ref[src];sendtostation=1'>Send to ship</A><BR>\n<BR>"]
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/cargo/supplycomp/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || istype(usr, /mob/living/silicon))
		usr.machine = src

	src.temp = ""

	if (href_list["sendtodock"])
		if(!supply_shuttle_at_station || supply_shuttle_moving) return

		if (!supply_can_move())
			usr << "\red The supply shuttle can not transport ship employees."
			return

		src.temp = "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()
		post_signal("supply")

		supply_shuttle_shoppinglist = null
		supply_shuttle_shoppinglist = list()

		sell_crates()
		send_supply_shuttle()

	else if (href_list["sendtostation"])
		if(supply_shuttle_at_station || supply_shuttle_moving) return

		if (!supply_can_move())
			usr << "\red The supply shuttle can not transport ship employees."
			return

		post_signal("supply")
		usr << "\blue The supply shuttle has been called and will arrive in [round(((SUPPLY_MOVETIME/10)/60))] minutes."

		src.temp = "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		supply_shuttle_moving = 1

		process_supply_order()

		supply_shuttle_time = world.timeofday + SUPPLY_MOVETIME
		spawn(0)
			supply_process()

	if (href_list["order_category"])
		src.temp = "Supply points: [supply_shuttle_points]<BR><HR>[href_list["order_category"]]<BR>Request what?<BR><BR>"
		src.temp += generate_supplypacks_html(href_list["order_category"])
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];order=1'>Back</A>"

	if (href_list["order"])
		src.temp = "Supply points: [supply_shuttle_points]<BR><HR>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Emergency'>Emergency</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Security'>Security</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Engineering'>Engineering</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Medical'>Medical</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Science'>Science</A>"
		//src.temp += "<BR><A href='?src=\ref[src];order_category=Food'>Food</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Materials'>Materials</A>"
		src.temp += "<BR><A href='?src=\ref[src];order_category=Miscellaneous'>Miscellaneous</A>"
		src.temp += "<BR><BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["doorder"])
		if(locate(href_list["doorder"])) //Comes from the viewrequests
			var/datum/supply_order/O = locate(href_list["doorder"])
			var/datum/supply_packs/P = O.object
			supply_shuttle_requestlist -= O

			if(supply_shuttle_points >= P.cost)
				supply_shuttle_points -= P.cost
				O.object = P
				O.orderedby = usr.name
				O.comment = input(usr,"Comment:","Enter comment","")
				supply_shuttle_shoppinglist += O
				src.temp = "Thanks for your order.<BR>"
			else
				src.temp = "Not enough supply points.<BR>"

			src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];viewrequests=1'>Back</A>"

		else //Comes from the order_category
			var/datum/supply_order/O = new/datum/supply_order ()
			var/supplytype = href_list["doorder"]
			var/datum/supply_packs/P = new supplytype ()
			if(supply_shuttle_points >= P.cost)
				supply_shuttle_points -= P.cost
				O.object = P
				O.orderedby = usr.name
				O.comment = input(usr,"Comment:","Enter comment","")
				supply_shuttle_shoppinglist += O
				src.temp = "Thanks for your order.<BR>"
			else
				src.temp = "Not enough supply points.<BR>"

			if(href_list["category"])
				src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];order_category=[href_list["category"]]'>Back</A>"
			else
				src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["vieworders"])
		src.temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			src.temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["viewrequests"])
		src.temp = "Current requests: <BR><BR>"
		for(var/S in supply_shuttle_requestlist)
			var/datum/supply_order/SO = S
			src.temp += "[SO.object.name] requested by [SO.orderedby]  [supply_shuttle_moving ? "":supply_shuttle_at_station ? "":"<A href='?src=\ref[src];doorder=\ref[SO]'>Approve</A> <A href='?src=\ref[src];rreq=\ref[SO]'>Remove</A>"]<BR>"

		src.temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["rreq"])
		supply_shuttle_requestlist -= locate(href_list["rreq"])
		src.temp = "Request removed.<BR>"
		src.temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A>"

	else if (href_list["clearreq"])
		supply_shuttle_requestlist = null
		supply_shuttle_requestlist = list()
		src.temp = "List cleared.<BR>"
		src.temp += "<BR><A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["mainmenu"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/cargo/supplycomp/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency("1435")

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)



/proc/send_supply_shuttle()
	if (supply_shuttle_moving) return

	if (!supply_can_move())
		usr << "\red The supply shuttle can not transport ship employees."
		return

	var/shuttleat = supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE
	var/shuttleto = !supply_shuttle_at_station ? SUPPLY_STATION_AREATYPE : SUPPLY_DOCK_AREATYPE

	var/area/from = locate(shuttleat)
	var/area/dest = locate(shuttleto)

	if(!from || !dest) return

	open_blastdoors_by_id("qmshuttle", -1) // force close shuttle doors

	from.move_contents_to(dest, /turf/space)
	supply_shuttle_at_station = !supply_shuttle_at_station

/obj/machinery/computer/cargo/proc/generate_supplypacks_html(var/category)
	var/temp
	if(!supply_packs_all.len)
		for(var/S in (typesof(/datum/supply_packs) - /datum/supply_packs))
			var/datum/supply_packs/N = new S()
			supply_packs_all += N

	for(var/datum/supply_packs/N in supply_packs_all)
		if(N.emagged && !src.emagged) continue
		if(N.hacked && !src:hacked) continue
		if(category && !(category in N.types)) continue

		temp += "<A href='?src=\ref[src];doorder=[N.type];category=[category]'>[N.name]</A> Cost: [N.cost]<BR>"

	return temp