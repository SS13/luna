/obj/item/weapon/spellbook
	name = "spell book"
	desc = "The legendary book of spells of the wizard."
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = 1
	var/uses = 6
	var/temp = null
	var/max_uses = 6
	var/op = 1

/*obj/item/weapon/spellbook/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/contract))
		var/obj/item/weapon/contract/contract = O
		if(contract.used)
			user << "The contract has been used, you can't get your points back now."
		else
			user << "You feed the contract back into the spellbook, refunding your points."
			src.max_uses++
			src.uses++
			del (O)*/


/obj/item/weapon/spellbook/attack_self(mob/user as mob)
	user.set_machine(src)
	var/dat
	if(temp)
		dat = "[temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = "<B>The Book of Spells:</B><BR>"
		dat += "Spells left to memorize: [uses]<BR>"
		dat += "<HR>"
		dat += "<B>Memorize which spell:</B><BR>"
		dat += "<I>The number after the spell name is the cooldown time.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=magicmissile'>Magic Missile</A> (15)<BR>"
		dat += "<I>This spell fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=fireball'>Fireball</A> (10)<BR>"
		dat += "<I>This spell fires a fireball in the direction you're facing and does not require wizard garb. Be careful not to fire it at people that are standing next to you.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=disintegrate'>Disintegrate</A> (60)<BR>"
		dat += "<I>This spell instantly kills somebody adjacent to you with the vilest of magick. It has a long cooldown.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=disabletech'>Disable Technology</A> (60)<BR>"
		dat += "<I>This spell disables all weapons, cameras and most other technology in range.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=smoke'>Smoke</A> (10)<BR>"
		dat += "<I>This spell spawns a cloud of choking smoke at your location and does not require wizard garb.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=blind'>Blind</A> (30)<BR>"
		dat += "<I>This spell temporarly blinds a single person and does not require wizard garb.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=mindswap'>Mind Transfer</A> (60)<BR>"
		dat += "<I>This spell allows the user to switch bodies with a target. Careful to not lose your memory in the process.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=forcewall'>Forcewall</A> (10)<BR>"
		dat += "<I>This spell creates an unbreakable wall that lasts for 30 seconds and does not need wizard garb.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=blink'>Blink</A> (2)<BR>"
		dat += "<I>This spell randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=teleport'>Teleport</A> (60)<BR>"
		dat += "<I>This spell teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=mutate'>Mutate</A> (60)<BR>"
		dat += "<I>This spell causes you to turn into a hulk and gain telekinesis for a short while.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=etherealjaunt'>Ethereal Jaunt</A> (30)<BR>"
		dat += "<I>This spell creates your ethereal form, temporarily making you invisible and able to pass through walls.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=knock'>Knock</A> (10)<BR>"
		dat += "<I>This spell opens nearby doors and does not require wizard garb.</I><BR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=horseman'>Curse of the Horseman</A> (15)<BR>"
		dat += "<I>This spell will curse a person to wear an unremovable horse mask (it has glue on the inside) and speak like a horse. It does not require wizard garb.</I><BR>"
/*
		dat += "<A href='byond://?src=\ref[src];spell_choice=fleshtostone'>Flesh to Stone</A> (60)<BR>"
		dat += "<I>This spell will curse a person to immediately turn into an unmoving statue. The effect will eventually wear off if the statue is not destroyed.</I><BR>"
*/
		dat += "<A href='byond://?src=\ref[src];spell_choice=summonguns'>Summon Guns</A> (One time use, global spell)<BR>"
		dat += "<I>Nothing could possibly go wrong with arming a crew of lunatics just itching for an excuse to kill eachother. Just be careful not to get hit in the crossfire!</I><BR>"

		dat += "<HR>"
		dat += "<B>Artefacts:</B><BR>"
		dat += "Powerful items imbued with eldritch magics. Summoning one will count towards your maximum number of spells.<BR>"
		dat += "It is recommended that only experienced wizards attempt to wield such artefacts.<BR>"
		dat += "<HR>"
/*
		dat += "<A href='byond://?src=\ref[src];spell_choice=staffchange'>Staff of Change</A><BR>"
		dat += "<I>An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself.</I><BR>"
		dat += "<HR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=soulstone'>Six Soul Stone Shards and the spell Artificer</A><BR>"
		dat += "<I>Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The spell Artificer allows you to create arcane machines for the captured souls to pilot.</I><BR>"
		dat += "<HR>"
*/
		dat += "<A href='byond://?src=\ref[src];spell_choice=armor'>Mastercrafted Armor Set</A><BR>"
		dat += "<I>An artefact suit of armor that allows you to cast spells while providing more protection against attacks and the void of space.</I><BR>"
		dat += "<HR>"
/*
		dat += "<A href='byond://?src=\ref[src];spell_choice=staffanimation'>Staff of Animation</A><BR>"
		dat += "<I>An arcane staff capable of shooting bolts of eldritch energy which cause inanimate objects to come to life. This magic doesn't affect machines.</I><BR>"
		dat += "<HR>"

		dat += "<A href='byond://?src=\ref[src];spell_choice=contract'>Contract of Apprenticeship</A><BR>"
		dat += "<I>A magical contract binding an apprentice wizard to your service, using it will summon them to your side.</I><BR>"
		dat += "<HR>"
*/
		dat += "<A href='byond://?src=\ref[src];spell_choice=scrying'>Scrying Orb</A><BR>"
		dat += "<I>An incandescent orb of crackling energy, using it will allow you to ghost while alive, allowing you to spy upon the station with ease. In addition, buying it will permanently grant you x-ray vision.</I><BR>"

		dat += "<HR>"
		dat += "<A href='byond://?src=\ref[src];spell_choice=rememorize'>Re-memorize Spells</A><BR>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/weapon/spellbook/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return
	if(!istype(H, /mob/living/carbon/human))
		return 1

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["spell_choice"])
			if(href_list["spell_choice"] == "rememorize")
				var/area/wizard_station/A = locate()
				if(usr in A.contents)
					uses = max_uses
					H.spellremove(usr)
					temp = "All spells have been removed. You may now memorize a new set of spells."
				else
					temp = "You may only re-memorize spells whilst located inside the wizard sanctuary."
			else if(uses >= 1 && max_uses >=1)
				uses--
			/*
			*/
				var/list/available_spells = list(magicmissile = "Magic Missile", fireball = "Fireball", disintegrate = "Disintegrate", disabletech = "Disable Tech", smoke = "Smoke", blind = "Blind",/* mindswap = "Mind Transfer",*/ forcewall = "Forcewall", blink = "Blink", teleport = "Teleport", mutate = "Mutate", etherealjaunt = "Ethereal Jaunt", knock = "Knock", horseman = "Curse of the Horseman",/* fleshtostone = "Flesh to Stone",*/ summonguns = "Summon Guns",/* staffchange = "Staff of Change", soulstone = "Six Soul Stone Shards and the spell Artificer",*/ armor = "Mastercrafted Armor Set"/*, staffanimate = "Staff of Animation"*/)
				var/already_knows = 0
				for(var/obj/effect/proc_holder/spell/aspell in H.spell_list)
					if(available_spells[href_list["spell_choice"]] == aspell.name)
						already_knows = 1
						temp = "You already know that spell."
						uses++
						break
			/*
			*/
				if(!already_knows)
					switch(href_list["spell_choice"])
						if("magicmissile")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile(H)
							temp = "You have learned magic missile."
						if("fireball")
							H.spell_list += new /obj/effect/proc_holder/spell/dumbfire/fireball(H)
							temp = "You have learned fireball."
						if("disintegrate")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/inflict_handler/disintegrate(H)
							temp = "You have learned disintegrate."
						if("disabletech")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/emplosion/disable_tech(H)
							temp = "You have learned disable technology."
						if("smoke")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/smoke(H)
							temp = "You have learned smoke."
						if("blind")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/trigger/blind(H)
							temp = "You have learned blind."
						if("mindswap")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/mind_transfer(H)
							temp = "You have learned mindswap."
						if("forcewall")
							H.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/forcewall(H)
							temp = "You have learned forcewall."
						if("blink")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/turf_teleport/blink(H)
							temp = "You have learned blink."
						if("teleport")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/area_teleport/teleport(H)
							temp = "You have learned teleport."
						if("mutate")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/genetic/mutate(H)
							temp = "You have learned mutate."
						if("etherealjaunt")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(H)
							temp = "You have learned ethereal jaunt."
						if("knock")
							H.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/knock(H)
							temp = "You have learned knock."
						if("horseman")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/horsemask(H)
							temp = "You have learned curse of the horseman."
/*						if("fleshtostone")
							H.spell_list += new /obj/effect/proc_holder/spell/targeted/inflict_handler/flesh_to_stone(H)
							temp = "You have learned flesh to stone."*/
						if("summonguns")
							H.rightandwrong()
							max_uses--
							temp = "You have cast summon guns."
/*						if("staffchange")
							new /obj/item/weapon/gun/energy/staff(get_turf(H))
							temp = "You have purchased a staff of change."
							max_uses--
						if("soulstone")
							new /obj/item/weapon/storage/belt/soulstone/full(get_turf(H))
							H.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/construct(H)
							temp = "You have purchased a belt full of soulstones and have learned the artificer spell."
							max_uses--*/
						if("armor")
							new /obj/item/clothing/shoes/sandal(get_turf(H)) //In case they've lost them.
							new /obj/item/clothing/gloves/purple(get_turf(H))//To complete the outfit
							new /obj/item/clothing/suit/space/rig/wizard(get_turf(H))
							new /obj/item/clothing/head/helmet/space/rig/wizard(get_turf(H))
							temp = "You have purchased a suit of wizard armor."
							max_uses--
/*						if("staffanimation")
							new /obj/item/weapon/gun/energy/staff/animate(get_turf(H))
							temp = "You have purchased a staff of animation."
							max_uses--
						if("contract")
							new /obj/item/weapon/contract(get_turf(H))
							temp = "You have purchased a contract of apprenticeship."
							max_uses--*/
						if("scrying")
							new /obj/item/weapon/scrying(get_turf(H))
							if (!(XRAY in H.mutations))
								H.mutations += XRAY
								H << "\blue The walls suddenly disappear."
							temp = "You have purchased a scrying orb, and gained x-ray vision."
							max_uses--
		else
			if(href_list["temp"])
				temp = null
		attack_self(H)

	return

/mob/proc/spellremove(var/mob/M as mob)
	for(var/obj/effect/proc_holder/spell/spell_to_remove in src.spell_list)
		del(spell_to_remove)

/obj/item/weapon/spellbook/oneuse
	name = "magic scroll"
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2f"
	desc = "This scroll seems to radiate power."
	var/spell_path
	var/spell_name = "nothing"
	uses = 1

/obj/item/weapon/spellbook/oneuse/attack_self(mob/user as mob)
	if(!uses) return

	uses--
	user.spell_list += new spell_path(user)
	user << "You have learned [spell_name]!"

/obj/item/weapon/spellbook/oneuse/fireball
	spell_path = /obj/effect/proc_holder/spell/dumbfire/fireball
	spell_name = "fireball"
	desc = "This scroll feels warm to the touch."

/obj/item/weapon/spellbook/oneuse/blink
	spell_path = /obj/effect/proc_holder/spell/targeted/turf_teleport/blink
	spell_name = "blink"
	desc = "This scroll is hard to hold in hands."

/obj/item/weapon/spellbook/oneuse/smoke
	spell_path = /obj/effect/proc_holder/spell/targeted/smoke
	spell_name = "smoke"
	desc = "This scroll is overflowing with the dank arts."

/obj/item/weapon/spellbook/oneuse/forcewall
	spell_path = /obj/effect/proc_holder/spell/aoe_turf/conjure/forcewall
	spell_name = "forcewall"
	desc = "This scroll is dedicated to mimes."