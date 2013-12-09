/mob/living/carbon/human/update_clothing()
	..()

	if (monkeyizing) return

	overlays = null

	var/g = "_male"
	if (gender == MALE)
		g = "_male"
	else if (gender == FEMALE)
		g = "_female"

	if(HULK in mutations)
		overlays += image("icon" = 'genetics.dmi', "icon_state" = "hulk[g][!lying ? "_s" : "_l"]")

	if(COLD_RESISTANCE in mutations)
		overlays += image("icon" = 'genetics.dmi', "icon_state" = "fire[!lying ? "_s" : "_l"]")

	if(TK in mutations)
		overlays += image("icon" = 'genetics.dmi', "icon_state" = "telekinesishead[!lying ? "_s" : "_l"]")

	if(dna && dna.mutantrace)
		overlays += image("icon" = 'genetics.dmi', "icon_state" = "[dna.mutantrace][g][!lying ? "_s" : "_l"]")
		if(face_standing)
			del(face_standing)
		if(face_lying)
			del(face_lying)
		if(stand_icon)
			del(stand_icon)
		if(lying_icon)
			del(lying_icon)
	else
		if(!face_standing || !face_lying)
			update_face()
		if(!stand_icon || !lying_icon)
			update_body()


	if(buckled)
		if(istype(buckled, /obj/structure/stool/bed)  && !istype(buckled, /obj/structure/stool/bed/chair))
			lying = 1
		else
			lying = 0

	// Automatically drop anything in store / id / belt if you're not wearing a uniform.
	if (!w_uniform)
		for (var/obj/item/thing in list(r_store, l_store, wear_id, belt))
			if (thing)
				u_equip(thing)
				if (client)
					client.screen -= thing

				if (thing)
					thing.loc = loc
					thing.dropped(src)
					thing.layer = initial(thing.layer)

	if (lying)
		icon = lying_icon

		overlays += body_lying

		if (face_lying)
			overlays += face_lying
	else
		icon = stand_icon

		overlays += body_standing

		if (face_standing)
			overlays += face_standing

	for(var/datum/organ/external/org in organs)
		if(org.status == ORGAN_ROBOTIC && ((org.name != "r_arm" && org.name != "l_arm") || !w_uniform))
			overlays += image("icon" = 'robolimbs.dmi', "icon_state" = "[org.name][lying ? "_l" : ""]")

	// Uniform
	if (w_uniform)
		w_uniform.screen_loc = ui_iclothing
		if (istype(w_uniform, /obj/item/clothing/under))
			var/t1 = w_uniform.item_color
			if (!t1)
				t1 = icon_state

			if(!lying)
				var/datum/organ/external/rhand = organs["r_hand"]
				var/datum/organ/external/lhand = organs["l_hand"]
				var/iconx = text("[][][][]",t1, (!(lying) ? "_s" : "_l"),(!rhand.status ? "_rhand" : null),(!lhand.status ? "_lhand" : null))
				overlays += image('uniform.dmi',"[iconx]",MOB_LAYER)
			else
				var/iconx = "[t1]_l"
				overlays += image('uniform.dmi',"[iconx]",MOB_LAYER)
			if (w_uniform.blood_DNA.len)
				var/icon/stain_icon = icon('blood.dmi', "uniformblood[!lying ? "" : "2"]")
				overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)

	if (wear_id)
		overlays += image("icon" = 'mob.dmi', "icon_state" = "id[!lying ? null : "2"]", "layer" = MOB_LAYER)

	if (client)
		client.screen -= hud_used.intents
		client.screen -= hud_used.mov_int

	//Screenlocs for these slots are handled by the huds other_update()
	//because theyre located on the 'other' inventory bar.

	// Gloves
	if(gloves)
		var/datum/organ/external/rhand = organs["r_hand"]
		var/datum/organ/external/lhand = organs["l_hand"]
		var/t1 = gloves.item_state
		if (!t1)
			t1 = gloves.icon_state
		if(!lying)
			if(rhand.status)
				overlays += image('hands.dmi',"[t1]_rhand",MOB_LAYER)
			if(lhand.status)
				overlays += image('hands.dmi',"[t1]_lhand",MOB_LAYER)
		else
			if(rhand.status)
				overlays += image('hands.dmi',"[t1]2_rhand",MOB_LAYER)
			if(lhand.status)
				overlays += image('hands.dmi',"[t1]2_lhand",MOB_LAYER)
		if (gloves.blood_DNA.len)
			var/icon/stain_icon = icon('blood.dmi', "bloodyhands[!lying ? "" : "2"]")
			overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)
	else if (blood_DNA.len)
		var/icon/stain_icon = icon('blood.dmi', "bloodyhands[!lying ? "" : "2"]")
		overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)
	// Glasses
	if (glasses)
		var/t1 = glasses.icon_state
		overlays += image("icon" = 'eyes.dmi', "icon_state" = text("[][]", t1, (!( lying ) ? null : "2")), "layer" = MOB_LAYER)
	// Ears
	if (ears)
		var/t1 = ears.icon_state
		overlays += image("icon" = 'ears.dmi', "icon_state" = text("[][]", t1, (!( lying ) ? null : "2")), "layer" = MOB_LAYER)
	// Shoes
	if (shoes)
		var/t1 = shoes.icon_state
		overlays += image("icon" = 'feet.dmi', "icon_state" = text("[][]", t1, (!( lying ) ? null : "2")), "layer" = MOB_LAYER)
		if (shoes.blood_DNA.len)
			var/icon/stain_icon = icon('blood.dmi', "shoesblood[!lying ? "" : "2"]")
			overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)	// Radio

	if(client) hud_used.other_update() //Update the screenloc of the items on the 'other' inventory bar
											   //to hide / show them.
	if(client)
		if (i_select)
			if (intent)
				client.screen += hud_used.intents

				var/list/L = dd_text2list(intent, ",")
				L[1] += ":-11"
				i_select.screen_loc = dd_list2text(L,",") //ICONS4, FUCKING SHIT
			else
				i_select.screen_loc = null
		if (m_select)
			if (m_int)
				client.screen += hud_used.mov_int

				var/list/L = dd_text2list(m_int, ",")
				L[1] += ":-11"
				m_select.screen_loc = dd_list2text(L,",") //ICONS4, FUCKING SHIT
			else
				m_select.screen_loc = null


	if (wear_suit)
		if (istype(wear_suit, /obj/item/clothing/suit))
			var/t1 = wear_suit.icon_state
			overlays += image("icon" = 'suit.dmi', "icon_state" = text("[][]", t1, (!lying ? null : "2")), "layer" = MOB_LAYER)
		if (wear_suit.blood_DNA.len)
			var/icon/stain_icon = null
			if (istype(wear_suit, /obj/item/clothing/suit/armor/vest || /obj/item/clothing/suit/wcoat || /obj/item/clothing/suit/armor/a_i_a_ptank))
				stain_icon = icon('blood.dmi', "armorblood[!lying ? "" : "2"]")
			else if (istype(wear_suit, /obj/item/clothing/suit/storage/det_suit || /obj/item/clothing/suit/storage/labcoat))
				stain_icon = icon('blood.dmi', "coatblood[!lying ? "" : "2"]")
			else
				stain_icon = icon('blood.dmi', "suitblood[!lying ? "" : "2"]")
			overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)
		wear_suit.screen_loc = ui_oclothing
		if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
			if (handcuffed)
				handcuffed.loc = loc
				handcuffed.layer = initial(handcuffed.layer)
				handcuffed = null
			if (l_hand || r_hand)
				var/h = hand
				hand = 1
				drop_item()
				hand = 0
				drop_item()
				hand = h
//	var/icon/hair = icon()
	if(!lying && !(dna && dna.mutantrace))
		var/icon/hair_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "[hair_icon_state]_s")
		hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
		overlays += image("icon" = hair_s, "layer" = MOB_LAYER)
	else if (!(dna && dna.mutantrace))
		var/icon/hair_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[hair_icon_state]_l")
		hair_l.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
		overlays += image("icon" = hair_l, "layer" = MOB_LAYER)

	if (wear_mask)
		if (istype(wear_mask, /obj/item/clothing/mask))
			var/t1 = wear_mask.icon_state
			overlays += image("icon" = 'mask.dmi', "icon_state" = text("[][]", t1, (!lying ? null : "2")), "layer" = MOB_LAYER)
			if (!istype(wear_mask, /obj/item/clothing/mask/cigarette))
				if (wear_mask.blood_DNA.len)
					var/icon/stain_icon = icon('blood.dmi', "maskblood[!lying ? "" : "2"]")
					overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)
			wear_mask.screen_loc = ui_mask

	if (head)
		var/t1 = head.icon_state
		var/icon/head_icon = icon('head.dmi', text("[][]", t1, (!( lying ) ? null : "2")))
		overlays += image("icon" = head_icon, "layer" = MOB_LAYER)
		if (head.blood_DNA.len)
			var/icon/stain_icon = icon('blood.dmi', "helmetblood[!lying ? "" : "2"]")
			overlays += image("icon" = stain_icon, "layer" = MOB_LAYER)
		head.screen_loc = ui_head

	// Belt
	if (belt)
		var/t1 = belt.item_state
		if (!t1)
			t1 = belt.icon_state
		overlays += image("icon" = 'belt.dmi', "icon_state" = text("[][]", t1, (!( lying ) ? null : "2")), "layer" = MOB_LAYER)
		belt.screen_loc = ui_belt

	if ((wear_mask && !wear_mask.see_face) || (head && !head.see_face) || (head && head.flags_inv & HIDEFACE) || (wear_mask && wear_mask.flags_inv & HIDEFACE)) // can't see the face
		if (wear_id)
			if (istype(wear_id, /obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/id = wear_id
				if (id.registered)
					name = id.registered
				else
					name = "Unknown"
			else if (istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				if (pda.owner)
					name = pda.owner
				else
					name = "Unknown"
		else
			name = "Unknown"
	else
		if (wear_id)
			if (istype(wear_id, /obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/id = wear_id
				if (id.registered != real_name)
					name = "[real_name] (as [id.registered])"


			else if (istype(wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = wear_id
				if (pda.owner)
					if (pda.owner != real_name)
						name = "[real_name] (as [pda.owner])"
		else
			name = real_name

	if (wear_id)
		wear_id.screen_loc = ui_id

	if (l_store)
		l_store.screen_loc = ui_storage1

	if (r_store)
		r_store.screen_loc = ui_storage2

	if (back)
		var/t1 = back.icon_state
		overlays += image("icon" = 'back.dmi', "icon_state" = text("[][]", t1, (!( lying ) ? null : "2")), "layer" = MOB_LAYER)
		back.screen_loc = ui_back

	if (handcuffed)
		pulling = null
		if (!lying)
			overlays += image("icon" = 'mob.dmi', "icon_state" = "handcuff1", "layer" = MOB_LAYER)
		else
			overlays += image("icon" = 'mob.dmi', "icon_state" = "handcuff2", "layer" = MOB_LAYER)

	if (client)
		client.screen -= contents
		client.screen += contents

	if (r_hand)
		overlays += image("icon" = 'items_righthand.dmi', "icon_state" = r_hand.item_state ? r_hand.item_state : r_hand.icon_state, "layer" = MOB_LAYER+0.1)
		r_hand.screen_loc = ui_rhand
	if (l_hand)
		overlays += image("icon" = 'items_lefthand.dmi', "icon_state" = l_hand.item_state ? l_hand.item_state : l_hand.icon_state, "layer" = MOB_LAYER+0.1)
		l_hand.screen_loc = ui_lhand



	var/shielded = 0
	for (var/obj/item/device/shield/S in src)
		if (S.active)
			shielded = 1
			break

	for (var/obj/item/device/cloak/S in src)
		if (S.active)
			shielded = 2
			break

	if(client && client.admin_invis)
		invisibility = 100
	else if (shielded == 2)
		invisibility = 2
	else
		invisibility = 0

	if (shielded)
		overlays += image("icon" = 'mob.dmi', "icon_state" = "shield", "layer" = MOB_LAYER)

	for (var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn (0)
				show_inv(M)
				return

	last_b_state = stat



/mob/living/carbon/human/proc/update_body()
	if(stand_icon)
		del(stand_icon)
	if(lying_icon)
		del(lying_icon)

	var/g = "m"
	if (gender == MALE)
		g = "m"
	else if (gender == FEMALE)
		g = "f"

	stand_icon = new /icon('human.dmi', "body_[g]_s")
	lying_icon = new /icon('human.dmi', "body_[g]_l")

	if(HUSK in mutations)
		stand_icon.Blend(new /icon('human.dmi', "husk_s"), ICON_OVERLAY)
		lying_icon.Blend(new /icon('human.dmi', "husk_l"), ICON_OVERLAY)

	if(underwear > 0)
		stand_icon.Blend(new /icon('human.dmi', "underwear[underwear]_[g]_s"), ICON_OVERLAY)
		lying_icon.Blend(new /icon('human.dmi', "underwear[underwear]_[g]_l"), ICON_OVERLAY)

	if (dna && dna.mutantrace)
		return

	// Skin tone
	if(s_tone >= 0)
		stand_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
		lying_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
	else
		stand_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
		lying_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
	if(zombie)
		stand_icon.Blend(rgb(100,100,100))
		lying_icon.Blend(rgb(100,100,100))
	if(pale)
		stand_icon.Blend(rgb(100,100,100))
		lying_icon.Blend(rgb(100,100,100))



/mob/living/carbon/human/proc/update_face()
	if(organs)
		var/datum/organ/external/org = organs["head"]
		if(org)
			if(!org.status)
				del(face_standing)
				del(face_lying)
				return
	del(face_standing)
	del(face_lying)

	if (dna && dna.mutantrace)
		return

	var/g = "m"
	if (gender == MALE)
		g = "m"
	else if (gender == FEMALE)
		g = "f"

	var/icon/eyes_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_s")
	var/icon/eyes_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "eyes_l")
	eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)
	eyes_l.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

	var/icon/facial_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "[face_icon_state]_s")
	var/icon/facial_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "[face_icon_state]_l")
	facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
	facial_l.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)

	var/icon/mouth_s = new/icon("icon" = 'human_face.dmi', "icon_state" = "mouth_[g]_s")
	var/icon/mouth_l = new/icon("icon" = 'human_face.dmi', "icon_state" = "mouth_[g]_l")

	//eyes_s.Blend(hair_s, ICON_OVERLAY)
	//eyes_l.Blend(hair_l, ICON_OVERLAY)
	eyes_s.Blend(mouth_s, ICON_OVERLAY)
	eyes_l.Blend(mouth_l, ICON_OVERLAY)
	eyes_s.Blend(facial_s, ICON_OVERLAY)
	eyes_l.Blend(facial_l, ICON_OVERLAY)

	face_standing = new /image()
	face_lying = new /image()
	face_standing.icon = eyes_s
	face_lying.icon = eyes_l

	del(mouth_l)
	del(mouth_s)
	del(facial_l)
	del(facial_s)
	del(eyes_l)
	del(eyes_s)