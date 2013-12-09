/*
CONTAINS:

CIG PACKET
ZIPPO
CIGS
*/

///////////
//MATCHES//
///////////
/obj/item/weapon/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = 0
	var/smoketime = 15
	w_class = 1
	origin_tech = "materials=1"
	attack_verb = list("burnt", "singed")

/obj/item/weapon/match/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		icon_state = "match_burnt"
		lit = -1
		processing_items.Remove(src)
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/weapon/match/dropped(mob/user as mob)
	if(lit == 1)
		lit = -1
		damtype = "brute"
		icon_state = "match_burnt"
		item_state = "cigoff"
		name = "burnt match"
		desc = "A match. This one has seen better days."
	return ..()

/obj/item/weapon/storage/matches
	name = "matchbox"
	desc = "A small box of Plasma Premium Matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 2
	slot_flags = SLOT_BELT
	can_hold = list("/obj/item/weapon/match")

	New()
		..()
		for(var/i=1; i <= 7; i++)
			new /obj/item/weapon/match(src)

	attackby(obj/item/weapon/match/W as obj, mob/user as mob)
		if(istype(W) && W.lit == 0)
			W.lit = 1
			W.icon_state = "match_lit"
			processing_items.Add(W)
		W.update_icon()
		return

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/weapon/cigpacket
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT

	var/allowreagents = 1
	var/list/cigtypes = list(/obj/item/clothing/mask/cigarette)
	var/cigcount = 6

/obj/item/weapon/cigpacket/New()
	..()
	if(allowreagents)
		flags |= NOREACT
		create_reagents(cigcount * 20)

/obj/item/weapon/cigpacket/update_icon()
	src.icon_state = text("[initial(icon_state)][cigcount]")
	src.desc = text("There are [cigcount] cigs\s left!")
	return

/obj/item/weapon/cigpacket/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.cigcount == 0)
			user << "\red You're out of cigs, shit! How you gonna get through the rest of the day..."
			return
		else
			var/cig = pick(cigtypes)
			var/obj/item/clothing/mask/cigarette/W = new cig(user)
			if(allowreagents)
				reagents.trans_to(W, (reagents.total_volume/cigcount))
			cigcount--
			if(allowreagents)
				reagents.maximum_volume = 20 * cigcount
			if(user.hand)
				user.l_hand = W
			else
				user.r_hand = W
			W.layer = 20
			user.update_clothing()
	else
		return ..()
	src.update_icon()
	return

/obj/item/weapon/cigpacket/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"

/obj/item/weapon/cigpacket/med
	name = "\improper MediU packet"
	allowreagents = 0
	cigtypes = list(/obj/item/clothing/mask/cigarette/med/o2,
					/obj/item/clothing/mask/cigarette/med/fire,
					/obj/item/clothing/mask/cigarette/med/brute,
					/obj/item/clothing/mask/cigarette/med/tox)

/obj/item/weapon/cigpacket/robust
	name = "\improper RobustCo packet"
	desc = "A packet of six imported RobustCo combat sticks. A label on the packaging reads, \"Robuster's choise!\""
	icon_state = "Dpacket"
	item_state = "Dpacket"
	allowreagents = 0
	cigtypes = list(/obj/item/clothing/mask/cigarette/robust)


/obj/item/weapon/cigpacket/o2
	name = "oxygarette packet"
	allowreagents = 0
	cigtypes = list(/obj/item/clothing/mask/cigarette/med/o2)

#define ZIPPO_LUM 2
//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	body_parts_covered = null
	attack_verb = list("burnt", "singed")

	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/weapon/cigbutt
	var/lastHolder = null
	var/smoketime = 150
	var/chem_volume = 20

/obj/item/clothing/mask/cigarette/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume)

/obj/item/clothing/mask/cigarette/Del()
	..()
	del(reagents)

/obj/item/clothing/mask/cigarette/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())//Badasses dont get blinded while lighting their cig with a welding tool
			light("<span class='notice'>[user] casually lights the [name] with [W], what a badass.</span>")

	else if(istype(W, /obj/item/toy/minisingulo))
		var/obj/item/toy/minisingulo/S = W
		if(S.on)
			light("<span class='notice'>[user] casually lights the [name] with the singularity, what a badass.</span>")

	else if(istype(W, /obj/item/weapon/lighter/zippo))
		var/obj/item/weapon/lighter/zippo/Z = W
		if(Z.lit)
			light("<span class='rose'>With a single flick of their wrist, [user] smoothly lights their [name] with their [W]. Damn they're cool.</span>")

	else if(istype(W, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/L = W
		if(L.lit)
			light("<span class='notice'>After some fiddling, [user] manages to light their [name] with [W].</span>")

	else if(istype(W, /obj/item/weapon/match))
		var/obj/item/weapon/match/M = W
		if(M.lit)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/toy/fire))
		var/obj/item/toy/fire/F = W
		if(F.lit)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing their nose. They light their [name] in the process.</span>")

	else if(istype(W, /obj/item/device/assembly/igniter))
		light("<span class='notice'>[user] fiddles with [W], and manages to light their [name].</span>")

	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/M = W
		if(M.lit)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")
	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/C = W
		if(C.on)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")
	return


/obj/item/clothing/mask/cigarette/afterattack(obj/item/weapon/reagent_containers/glass/glass, mob/user as mob)
	..()
	if(istype(glass))	//you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			user << "<span class='notice'>You dip \the [src] into \the [glass].</span>"
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				user << "<span class='notice'>[glass] is empty.</span>"
			else
				user << "<span class='notice'>[src] is full.</span>"


/obj/item/clothing/mask/cigarette/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			if(ismob(loc))
				var/mob/M = loc
				M.drop_from_inventory(src)
			del(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			if(ismob(loc))
				var/mob/M = loc
				M.drop_from_inventory(src)
			del(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		processing_items.Add(src)

		//can't think of any other way to update the overlays :<
		if(ismob(loc))
			var/mob/M = loc
			M.update_clothing()


/obj/item/clothing/mask/cigarette/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new type_butt(location)
		processing_items.Remove(src)
		if(ismob(loc))
			var/mob/living/M = loc
			M << "<span class='notice'>Your [name] goes out.</span>"
			M.u_equip(src)	//un-equip it so the overlays can update
		del(src)
		return
	if(location)
		location.hotspot_expose(700, 5)
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		if(iscarbon(loc) && (src == loc:wear_mask)) // if it's in the human/monkey mouth, transfer reagents to the mob
			var/mob/living/carbon/C = loc
			if(prob(15)) // so it's not an instarape in case of acid
				reagents.reaction(C, INGEST)
			reagents.trans_to(C, 1)
		else // else just remove some of the reagents
			reagents.remove_any(1)
	return


/obj/item/clothing/mask/cigarette/attack_self(mob/user as mob)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on the lit [src], putting it out instantly.</span>")
		var/turf/T = get_turf(src)
		new type_butt(T)
		processing_items.Remove(src)
		del(src)
	return ..()

/obj/item/clothing/mask/cigarette/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_sel && user.zone_sel.selecting == "mouth" && lit)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		return ..()

////////////
//  CIGS  //
////////////
/obj/item/clothing/mask/cigarette/med
	chem_volume = 30
	smoketime = 200

/obj/item/clothing/mask/cigarette/med/o2
	desc = "A roll of tobacco and nicotine that can replace emergency oxygen tank."
	New()
		..()
		reagents.add_reagent("dexalinp", 25)

/obj/item/clothing/mask/cigarette/med/fire
	desc = "A roll of tobacco and nicotine made special for firestarters."
	New()
		..()
		reagents.add_reagent("dermaline", 12)
		reagents.add_reagent("tricordrazine", 3)

/obj/item/clothing/mask/cigarette/med/brute
	desc = "A roll of tobacco and bicardine."
	New()
		..()
		reagents.add_reagent("bicardine", 12)
		reagents.add_reagent("tricordrazine", 3)

/obj/item/clothing/mask/cigarette/med/tox
	desc = "A roll of tobacco and nicotine."
	New()
		..()
		reagents.add_reagent("anti_toxin", 12)
		reagents.add_reagent("alkysine", 3)

/obj/item/clothing/mask/cigarette/robust
	name = "big cigarette"
	desc = "A very robust roll of tobacco and nicotine."
	icon_off = "cig_r_off"
	icon_state = "cig_r_off"
	chem_volume = 45
	smoketime = 200
	New()
		..()
		reagents.add_reagent("bicardine", 9)
		reagents.add_reagent("synaptizine", 9)
		reagents.add_reagent("hyperzine", 9)
		reagents.add_reagent("tricordrazine", 9)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "Premium Cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	type_butt = /obj/item/weapon/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 3000
	chem_volume = 30

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "Cohiba Robusto Cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 5000
	chem_volume = 40

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "Premium Havanian Cigar"
	desc = "A cigar fit for only the best for the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 8000
	chem_volume = 50

/obj/item/clothing/mask/cigarette/cigar/space
	desc = "A very, very badass sigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 1000
	chem_volume = 100
	New()
		..()
		reagents.add_reagent("dexalinp", 45)
		reagents.add_reagent("leporazine", 45)

/obj/item/clothing/mask/cigarette/cigar/badmin
	desc = "It looks badminous."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 50000
	chem_volume = 5000
	New()
		..()
		reagents.add_reagent("dexalinp", 250)
		reagents.add_reagent("bicardine", 250)
		reagents.add_reagent("tricordrazine", 250)
		reagents.add_reagent("anti_toxin", 250)
		reagents.add_reagent("leporazine", 250)
		reagents.add_reagent("dermaline", 250)
		reagents.add_reagent("kelotane", 250)
		reagents.add_reagent("synaptizine", 250)
		reagents.add_reagent("hyperzine", 250)

		reagents.add_reagent("alkysine", 50)
		reagents.add_reagent("imidazoline", 50)
		reagents.add_reagent("inaprovaline", 50)
		//SO BADMINOUS!

////////////
// JOINTS //
////////////
/obj/item/clothing/mask/cigarette/weed
	name = "joint"
	desc = "420 smoke weed errday."
	smoketime = 250
	chem_volume = 50

/obj/item/clothing/mask/cigarette/weed/mega
	desc = "This thing smells weird even unlit."
	New()
		..()
		reagents.add_reagent("space_drugs", 10)
		reagents.add_reagent("LSD", 15)

/obj/item/clothing/mask/cigarette/weed/black
	desc = "There's a really strong odor coming from this..."
	New()
		..()
		reagents.add_reagent("space_drugs", 10)
		reagents.add_reagent("cyanide", 5)
		reagents.add_reagent("lexorin", 10)

/obj/item/clothing/mask/cigarette/weed/white
	desc = "It has an unusual minty scent."
	New()
		..()
		reagents.add_reagent("space_drugs", 10)
		reagents.add_reagent("bicaridine", 5)
		reagents.add_reagent("kelotane", 5)
		reagents.add_reagent("anti_toxin", 5)
		reagents.add_reagent("hyronalin", 5)
		reagents.add_reagent("dexalin", 5)

////////////
//CIGBUTTS//
////////////
/obj/item/weapon/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1

/obj/item/weapon/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 100

/obj/item/clothing/mask/cigarette/pipe/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			M << "<span class='notice'>Your [name] goes out, and you empty the ash.</span>"
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_clothing()
		processing_items.Remove(src)
		return
	if(location)
		location.hotspot_expose(700, 5)
	return

/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user as mob) //Refills the pipe. Can be changed to an attackby later, if loose tobacco is added to vendors or something.
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>")
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		processing_items.Remove(src)
		return
	if(smoketime <= 0)
		user << "<span class='notice'>You refill the pipe with tobacco.</span>"
		smoketime = initial(smoketime)
	return

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen and kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	smoketime = 400



/////////
//ZIPPO//
/////////
/obj/item/weapon/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	var/icon_on = "lighter-g-on"
	var/icon_off = "lighter-g"
	w_class = 1
	throwforce = 4
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/lit = 0

/obj/item/weapon/lighter/zippo
	name = "Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"
	flags = CONDUCT | FPRINT
	slot_flags = SLOT_BELT


/obj/item/weapon/lighter/random
	New()
		var/lcolor = pick("r","c","y","g")
		icon_on = "lighter-[lcolor]-on"
		icon_off = "lighter-[lcolor]"
		icon_state = icon_off

/obj/item/weapon/lighter/attack_self(mob/living/carbon/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			icon_state = icon_on
			item_state = icon_on
			if(istype(src, /obj/item/weapon/lighter/zippo) )
				user.visible_message("<span class='rose'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
			else
				if(prob(80))
					user.visible_message("<span class='notice'>After a few attempts, [user] manages to light the [src].</span>")
				else if(ishuman(user))
					var/mob/living/carbon/human/H = user
					user << "<span class='warning'>You burn yourself while lighting the lighter.</span>"

					var/datum/organ/external/affecting = H.get_organ(pick("l_arm", "r_arm"))
					if(affecting)
						if(affecting.take_damage(0, 2))
							H.UpdateDamageIcon(0)
							H.updatehealth()
					user.visible_message("<span class='notice'>After a few attempts, [user] manages to light the [src], they however burn their finger in the process.</span>")

			user.ul_SetLuminosity(user.luminosity + 1)
			processing_items.Add(src)
		else
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			if(istype(src, /obj/item/weapon/lighter/zippo) )
				user.visible_message("<span class='rose'>You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing. Wow.")
			else
				user.visible_message("<span class='notice'>[user] quietly shuts off the [src].")

			user.ul_SetLuminosity(user.luminosity - 1)
			processing_items.Remove(src)
	else
		return ..()
	return


/obj/item/weapon/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_sel.selecting == "mouth" && lit)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/weapon/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M]. Their arm is as steady as the unflickering flame they light \the [cig] with.</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/weapon/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

/obj/item/weapon/lighter/pickup(mob/user)
	if(lit)
		ul_SetLuminosity(0)
		user.ul_SetLuminosity(user.luminosity+1)
	return

/obj/item/weapon/lighter/dropped(mob/user)
	if(lit)
		user.ul_SetLuminosity(user.luminosity-1)
		ul_SetLuminosity(1)
	return