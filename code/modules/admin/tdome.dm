// Awful TD code by Relativist

/client/proc/revive_td()
	set category = "Roleplay"
	set name = "Revive TD teams"
	set desc = "this smallgay don't know how to put this shit in secrets"

	for(var/mob/living/carbon/human/H in world)
		if(H.z == 7)
			H.revive()

/client/proc/tdparty()
	set category = "Roleplay"
	set name = "TD party"
	set desc = "cause all so lazy"

	switch(alert("Do you wanna party with Buonaparte?",,"Yes","No",))
		if("Yes")
			var/t = 0
			for(var/mob/living/carbon/human/H in world)
				for(var/obj/item/W in H)
					if (!istype(W,/datum/organ))
						H.u_equip(W)
						if (H.client)
							H.client.screen -= W
						if (W)
							W.loc = H.loc
							W.dropped(H)
							W.layer = initial(W.layer)
					H.paralysis += 5
					sleep(5)
				if(t)
					H.loc = pick(tdome2)
					H.tdome_team = 1
					t = !t
				else
					H.loc = pick(tdome1)
					H.tdome_team = 2
					t = !t
		if("No")
			return

/client/proc/tp_td()
	set category = "Roleplay"
	set name = "Teleport TD teams"
	set desc = "just a teleportation without any healing"

	for(var/mob/living/carbon/human/H in world)
		if(H.tdome_team == 1)
			H.loc = pick(tdome2)
		else if(H.tdome_team == 2)
			H.loc = pick(tdome1)


/client/proc/c_op()
	set category = "Roleplay"
	set name = "Toggle extinguishers podlock"
	var/id = "clothing2"

	open_blastdoors_by_id(id)

/client/proc/e_op()
	set category = "Roleplay"
	set name = "Toggle energy podlock"
	var/id = "energy1"

	open_blastdoors_by_id(id)

/client/proc/g_op()
	set category = "Roleplay"
	set name = "Toggle gun podlock"
	var/id = "gun1"

	open_blastdoors_by_id(id)

/client/proc/t_op()
	set category = "Roleplay"
	set name = "Toggle arena podlocks"
	var/id = "td1"

	open_blastdoors_by_id(id)

/proc/open_blastdoors_by_id(var/id, var/toggle)
	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id == id)
			if(!toggle)
				if(M.density)
					M.open()
				else
					M.close()
			else if(toggle == 1)
				if(M.density)
					M.open()
			else if(toggle == -1)
				if(!M.density)
					M.close()
