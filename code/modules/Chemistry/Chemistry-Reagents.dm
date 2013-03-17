#define SOLID 1
#define LIQUID 2
#define GAS 3

//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

datum
	reagent
		var/name = "Reagent"
		var/id = "reagent"
		var/description = ""
		var/datum/reagents/holder = null
		var/reagent_state = SOLID
		var/data = null
		var/volume = 0
		var/red = 255
		var/green = 255
		var/blue = 255
		var/alpha = 255
		var/nutriment_factor = null
		proc
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
				var/datum/reagent/self = src
				src = null										  //of the reagent to the mob on TOUCHING it.
				if(method == TOUCH)

					var/chance = 1
					for(var/obj/item/clothing/C in M.get_equipped_items())
						if(C.permeability_coefficient < chance) chance = C.permeability_coefficient
					chance = chance * 100

					if(prob(chance))
						if(M.reagents)
							M.reagents.add_reagent(self.id,self.volume/2)
				return

			reaction_obj(var/obj/O, var/volume) //By default we transfer a small part of the reagent to the object				//if it can hold reagents. nope!
				var/datum/reagent/self = src
				src = null
				if(O.reagents)
					O.reagents.add_reagent(self.id,self.volume)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				return

			on_mob_life(var/mob/M)
				holder.remove_reagent(src.id, 0.4) //By default it slowly disappears.
				return

			getcolour()
				return rgb(red,green,blue)


/////////////////////////////////////////////////////////////////CHIM////////////////////////////////////////
		water
			name = "Water"
			id = "water"
			description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
			reagent_state = LIQUID
			red = 0
			green = 150
			blue = 255
			alpha = 100
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(istype(T, /turf/simulated) && volume >= 3)
					if(T:wet >= 1) return
					T:wet = 1
					if(T:wet_overlay)
						T:overlays -= T:wet_overlay
						T:wet_overlay = null
					T:wet_overlay = image('water.dmi',T,"wet_floor")
					T:overlays += T:wet_overlay

					spawn(800)
						if(T:wet >= 2) return
						T:wet = 0
						if(T:wet_overlay)
							T:overlays -= T:wet_overlay
							T:wet_overlay = null

				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot)
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/T = get_turf(O)
				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot)
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)
				return

		blood
			name = "Blood"
			id = "blood"
			description = "Carrier of oxygen and various other things essential for life."
			reagent_state = LIQUID
			red = 200
			green = 0
			blue = 0
			var
				blood_type = "A+"
				blood_DNA = "unknown"
				mob/taken_from
				virus
			var/datum/disease2/disease/virus2

			on_mob_life(mob/M)
				if (ishuman(M) && blood_incompatible(blood_type,M:b_type))
					M:toxloss += 1.5
					M:oxyloss += 1.5
					M:toxins_alert = max(1,M:toxins_alert)
					..()
				return

			reaction_mob(mob/M,method)
				if(virus) M.contract_disease(virus)
				if(method == TOUCH)
					var/mob/living/carbon/human/H = M
					if(istype(H))
						if(H.wear_suit)
							H.wear_suit.add_blood(taken_from)
						else if(H.w_uniform)
							H.w_uniform.add_blood(taken_from)
					else
						H.add_blood(taken_from)
				..()
				return
			reaction_turf(turf/T)
				T.add_blood(taken_from)
				return
			reaction_obj(obj/O)
				O.add_blood(taken_from)
				return

			proc/copy_from(mob/living/carbon/human/M)
				if(istype(M,/datum/reagent/blood))
					var/datum/reagent/blood/other = M
					blood_type = other.blood_type
					blood_DNA = other.blood_DNA
					id = other.id
					taken_from = other.taken_from
					virus = other.virus
					if(other.virus2)
						virus2 = other.virus2.getcopy()
					description = other.description
				if(!istype(M))
					if(istype(M,/mob/living/carbon/monkey))
						blood_type = "O+"
						blood_DNA = M.dna.unique_enzymes
						id = "blood-[M.dna.unique_enzymes]"
						taken_from = M
						virus = M.virus
						description = "Type: [blood_type]<br>DNA: [blood_DNA]"
						if(M.virus2)
							virus2 = M.virus2.getcopy()
					return 0
				blood_type = M.b_type
				blood_DNA = M.dna.unique_enzymes
				id = "blood"
				taken_from = M
				virus = M.virus
				description = "Type: [blood_type]<br>DNA: [blood_DNA]"
				if(M.virus2)
					virus2 = M.virus2.getcopy()
				return 1

		lube
			name = "Space Lube"
			id = "lube"
			description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. Giggity."
			reagent_state = LIQUID
			alpha = 50
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(T:wet >= 2) return
				T:wet = 2
				T:wet_overlay = image('effects.dmi', "slube")
				T:overlays += T:wet_overlay
				spawn(800)
					T:wet = 0
					if(T:wet_overlay)
						T:overlays -= T:wet_overlay

				return
/*
		bilk
			name = "Bilk"
			id = "bilk"
			description = "This appears to be beer mixed with milk. Disgusting."
			reagent_state = LIQUID
*/
		anti_toxin
			name = "Anti-Toxin (Dylovene)"
			id = "anti_toxin"
			description = "Dylovene is a broad-spectrum antitoxin."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-2, 0)
				if(holder.has_reagent("toxin"))
					holder.remove_reagent("toxin", 2)
				if(holder.has_reagent("stoxin"))
					holder.remove_reagent("stoxin", 2)
				if(holder.has_reagent("plasma"))
					holder.remove_reagent("plasma", 1)
				if(holder.has_reagent("acid"))
					holder.remove_reagent("acid", 1)
				if(holder.has_reagent("cyanide"))
					holder.remove_reagent("cyanide", 1)
				M:toxloss = max(M:toxloss-2,0)
				..()
				return

		toxin
			name = "Toxin"
			id = "toxin"
			description = "A Toxic chemical."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss += 1.5
				if(!data) data = 1.5
				if(data > 15)
					//Do Toxin Shit
					M:toxins_alert = max(M:toxins_alert,1)
					M:toxloss += 2.5
				..()
				return

		cyanide
			name = "Cyanide"
			id = "cyanide"
			description = "A highly toxic chemical."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss += 3
				M:oxyloss += 3
				..()
				return

		stoxin
			name = "Sleep Toxin"
			id = "stoxin"
			description = "An effective hypnotic used to treat insomnia."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(15 to 25)
						M:drowsyness  = max(M:drowsyness, 20)
					if(25 to INFINITY)
						M:paralysis = max(M:paralysis, 20)
						M:drowsyness  = max(M:drowsyness, 30)
				data++
				..()
				return

		srejuvinate
			name = "Sleep Rejuvinate"
			id = "stoxin"
			description = "Put people to sleep, and heals them."
			reagent_state = LIQUID
			red = 200
			green = 165
			blue = 220

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				if(M.losebreath >= 10)
					M.losebreath = max(10, M.losebreath-10)
				holder.remove_reagent(src.id, 0.2)
				switch(data)
					if(1 to 15)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(15 to 25)
						M:drowsyness  = max(M:drowsyness, 20)
					if(25 to INFINITY)
						M.sleeping += 1
						M.dizziness = 0
						M.drowsyness = 0
						M.stuttering = 0
						M.confused = 0
						M.jitteriness = 0
//					if(125 to INFINITY)
//						M:adjustToxLoss(0.1)
				..()
				return


		inaprovaline
			name = "Inaprovaline"
			id = "inaprovaline"
			description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 10)
					M.losebreath = max(5, M.losebreath-5)
				holder.remove_reagent(src.id, 0.2)
				return

		space_drugs
			name = "Space drugs"
			id = "space_drugs"
			description = "An illegal chemical compound used as drug."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 15)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(7)) M:emote(pick("twitch","drool","moan","giggle"))
				holder.remove_reagent(src.id, 0.2)
				return

		silicate
			name = "Silicate"
			id = "silicate"
			description = "A compound that can be used to reinforce glass."
			reagent_state = LIQUID
			reaction_obj(var/obj/O, var/volume)
				src = null
				if(istype(O,/obj/window))
					O:health = O:health * 2
					var/icon/I = icon(O.icon,O.icon_state,O.dir)
					I.SetIntensity(1.15,1.50,1.75)
					O.icon = I
				return

		copper
			name = "Copper"
			id = "copper"
			description = "A highly ductile metal."
			red = 110
			green = 59
			blue = 8


		oxygen
			name = "Oxygen"
			id = "oxygen"
			description = "A colorless, odorless gas."
			reagent_state = GAS
			red = 128
			green = 128
			blue = 128

		nitrogen
			name = "Nitrogen"
			id = "nitrogen"
			description = "A colorless, odorless, tasteless gas."
			reagent_state = GAS
			red = 128
			green = 128
			blue = 128


		hydrogen
			name = "Hydrogen"
			id = "hydrogen"
			description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
			reagent_state = GAS

		potassium
			name = "Potassium"
			id = "potassium"
			description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
			reagent_state = SOLID

		mercury
			name = "Mercury"
			id = "mercury"
			description = "A chemical element."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.canmove) step(M, pick(cardinal))
				if(prob(5)) M:emote(pick("twitch","drool","moan"))
				..()
				return

		sulfur
			name = "Sulfur"
			id = "sulfur"
			description = "A chemical element."
			reagent_state = SOLID

		carbon
			name = "Carbon"
			id = "carbon"
			description = "A chemical element."
			reagent_state = SOLID

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/dirt(T)

		chlorine
			name = "Chlorine"
			id = "chlorine"
			description = "A chemical element."
			reagent_state = GAS
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		fluorine
			name = "Fluorine"
			id = "fluorine"
			description = "A highly-reactive chemical element."
			reagent_state = GAS
			on_mob_life(var/mob.M)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		sodium
			name = "Sodium"
			id = "sodium"
			description = "A chemical element."
			reagent_state = SOLID

		phosphorus
			name = "Phosphorus"
			id = "phosphorus"
			description = "A chemical element."
			reagent_state = SOLID

		lithium
			name = "Lithium"
			id = "lithium"
			description = "A chemical element."
			reagent_state = SOLID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.canmove) step(M, pick(cardinal))
				if(prob(5)) M:emote(pick("twitch","drool","moan"))
				..()
				return

		sugar
			name = "Sugar"
			id = "sugar"
			description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
			reagent_state = SOLID

		acid
			name = "Sulphuric acid"
			id = "acid"
			description = "A strong mineral acid with the molecular formula H2SO4."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss++
				if(istype(M, /mob/living/carbon/human))
					var/datum/organ/external/affecting = M:organs["chest"]
					if (affecting)
						affecting.take_damage(0, 1)
				else
					M:fireloss++
				..()
				return
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M:wear_mask)
							del (M:wear_mask)
							M << "\red Your mask melts away but protects you from the acid!"
							return
						if(M:head)
							del (M:head)
							M << "\red Your helmet melts into uselessness but protects you from the acid!"
							return

					if(prob(20))
						var/datum/organ/external/affecting = M:organs["head"]
						if (affecting)
							affecting.take_damage(25, 0)
							M:UpdateDamage()
							M:UpdateDamageIcon()
							M:emote("scream")
							M << "\red Your face has become disfigured!"
							M.face_dmg = 1
						else
							M:fireloss += 15
					else
						M:fireloss += 15
				else
					M:fireloss += 15

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item/weapon/artifact))
					O:acid(volume)
					return
				if(istype(O,/obj/item) && prob(40))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)


		pacid
			name = "Polytrinic acid"
			id = "pacid"
			description = "Polytrinic acid is a an extremely corrosive chemical substance."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(75))
					M:toxloss++
				if(prob(75))
					M:fireloss++
				..()
				return
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M:wear_mask)
							del (M:wear_mask)
							M << "\red Your mask melts away!"
							return
						if(M:head)
							del (M:head)
							M << "\red Your helmet melts into uselessness!"
							return
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage((30 * max(1, volume / 15)), 0)
						M:UpdateDamage()
						M:UpdateDamageIcon()
						M:emote("scream")
						M << "\red Your face has become disfigured!"
						M.face_dmg = 1
					else
						M:fireloss += 15
				else
					if(istype(M, /mob/living/carbon/human) && prob(25))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage((30 * max(1, volume / 30)), 0)
						M:UpdateDamage()
						M:UpdateDamageIcon()
						M:emote("scream")
						M << "\red Your face has become disfigured!"
						M.face_dmg = 1
					else
						M:fireloss += (30 * max(1, volume / 30))

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item/weapon/artifact))
					O:acid(volume)
					return
				if(istype(O,/obj/item))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)

		glycerol
			name = "Glycerol"
			id = "glycerol"
			description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
			reagent_state = LIQUID

		nitroglycerin
			name = "Nitroglycerin"
			id = "nitroglycerin"
			description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
			reagent_state = LIQUID

		radium
			name = "Radium"
			id = "radium"
			description = "Radium is an alkaline earth metal. It is extremely radioactive."
			reagent_state = SOLID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.radiation += 3
				..()
				return


			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/greenglow(T)


		ryetalyn
			name = "Ryetalyn"
			id = "ryetalyn"
			description = "Ryetalyn can cure all genetic abnomalities."
			reagent_state = SOLID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.mutations = 0
				M.disabilities = 0
				M.sdisabilities = 0
				..()
				return

		thermite
			name = "Thermite"
			id = "thermite"
			description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
			reagent_state = SOLID
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(istype(T, /turf/simulated/wall))
					T:thermite = 1
					T.overlays = null
					T.overlays = image('effects.dmi',icon_state = "thermite")
				return

		mutagen
			name = "Unstable mutagen"
			id = "mutagen"
			description = "Might cause unpredictable mutations. Keep away from children."
			reagent_state = LIQUID
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(33)) || method==INGEST)
					randmuti(M)
					if(prob(98))
						randmutb(M)
					else
						randmutg(M)
					domutcheck(M, null, 1)
					updateappearance(M,M.dna.uni_identity)
				return
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.radiation += 2
				..()
				return




		iron
			name = "Iron"
			id = "iron"
			description = "Pure iron is a metal."
			reagent_state = SOLID
			red = 200
			green = 165
			blue = 220
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(33)) || method==INGEST)
					randmuti(M)
					if(prob(98))
						randmutb(M)
					else
						randmutg(M)
					domutcheck(M, null, 1)
					updateappearance(M,M.dna.uni_identity)
				return
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.radiation += 2
				..()
				return

		gold
			name = "Gold"
			id = "gold"
			description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
			reagent_state = SOLID
			red = 247
			green = 196
			blue = 48

		silver
			name = "Silver"
			id = "silver"
			description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
			reagent_state = SOLID
			red = 208
			green = 208
			blue = 208

		uranium
			name ="Uranium"
			id = "uranium"
			description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
			reagent_state = SOLID
			red = 184
			green = 184
			blue = 192

		aluminium
			name = "Aluminium"
			id = "aluminium"
			description = "A silvery white and ductile member of the boron group of chemical elements."
			reagent_state = SOLID
			red = 168
			green = 168
			blue = 168

		silicon
			name = "Silicon"
			id = "silicon"
			description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
			reagent_state = SOLID
			red = 168
			green = 168
			blue = 168

		fuel
			name = "Welding fuel"
			id = "fuel"
			description = "Required for welders. Flamable."
			reagent_state = LIQUID
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/the_turf = get_turf(O)
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 15
				napalm.trace_gases += fuel
				the_turf.assume_air(napalm)
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 15
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				return

		coffee
			name = "Coffee"
			id = "coffee"
			description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				M.bodytemperature = min(310, M.bodytemperature+5) //310 is the normal bodytemp. 310.055
				if(!data) data = 1
				if(data > 15)
					M.make_jittery(5)
				..()

		space_cleaner
			name = "Space cleaner"
			id = "cleaner"
			description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
			reagent_state = LIQUID
			reaction_obj(var/obj/O, var/volume)
				if(!O) return
				if(istype(O,/obj/decal/cleanable))
					del(O)
				else
					O.clean_blood()
			reaction_turf(var/turf/T, var/volume)
				T.overlays = null
				T.clean_blood()
				for(var/obj/decal/cleanable/C in src)
					del(C)
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				M.clean_blood()
				if(istype(M, /mob/living/carbon))
					var/mob/living/carbon/C = M
					if(C.r_hand)
						C.r_hand.clean_blood()
					if(C.l_hand)
						C.l_hand.clean_blood()
					if(C.wear_mask)
						C.wear_mask.clean_blood()
					if(istype(M, /mob/living/carbon/human))
						if(C:w_uniform)
							C:w_uniform.clean_blood()
						if(C:wear_suit)
							C:wear_suit.clean_blood()
						if(C:shoes)
							C:shoes.clean_blood()
						if(C:gloves)
							C:gloves.clean_blood()
						if(C:head)
							C:head.clean_blood()

		plantbgone
			name = "Plant-B-Gone"
			id = "plantbgone"
			description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
			reagent_state = LIQUID
			red = 73
			green = 0
			blue = 46
			/* Don't know if this is necessary.
			on_mob_life(var/mob/living/carbon/M)
				if(!M) M = holder.my_atom
				M:adjustToxLoss(3.0)
				..()
				return
			*/
			reaction_obj(var/obj/O, var/volume)
		//		if(istype(O,/obj/plant/vine/))
		//			O:life -= rand(15,35) // Kills vines nicely // Not tested as vines don't work in R41
				if(istype(O,/obj/alien/weeds/))
					O:health -= rand(15,35) // Kills alien weeds pretty fast
					O:healthcheck()
					del(O)
				// Damage that is done to growing plants is separately
				// at code/game/machinery/hydroponics at obj/item/hydroponics

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon))
					if(!M.wear_mask) // If not wearing a mask
						M:toxloss += 4 // 4 toxic damage per application, doubled for some reason
					if(istype(M,/mob/living/carbon/human) && M:mutantrace == "plant") //plantmen take a LOT of damage
						M:toxloss += 10
						//if(prob(10))
							//M.make_dizzy(1) doesn't seem to do anything


		space_cola
			name = "Cola"
			id = "cola"
			description = "A refreshing beverage."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M:drowsyness = max(0,M:drowsyness-5)
				M.bodytemperature = max(310, M.bodytemperature-5) //310 is the normal bodytemp. 310.055
				M:nutrition += 2
				..()

		plasma
			name = "Plasma"
			id = "plasma"
			description = "Plasma in its liquid form."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("inaprovaline"))
					holder.remove_reagent("inaprovaline", 2)
				M:toxloss++
				..()
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/the_turf = get_turf(O)
				if(the_turf)
					var/datum/gas_mixture/napalm = new
					var/datum/gas/volatile_fuel/fuel = new
					fuel.moles = 5
					napalm.trace_gases += fuel
					the_turf.assume_air(napalm)
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 5
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				return

		leporazine
			name = "Leporazine"
			id = "leporazine"
			description = "Leporazine can be use to stabilize an individuals body temperature."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature = max(310, M.bodytemperature-10)
				else if(M.bodytemperature > 311)
					M.bodytemperature = min(310, M.bodytemperature+10)
				..()
				return

		cryptobiolin
			name = "Cryptobiolin"
			id = "cryptobiolin"
			description = "Cryptobiolin causes confusion and dizzyness."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.make_dizzy(1)
				if(!M.confused) M.confused = 1
				M.confused = max(M.confused, 20)
				holder.remove_reagent(src.id, 0.2)
				return

		lexorin
			name = "Lexorin"
			id = "lexorin"
			description = "Lexorin temporarily stops respiration. Causes tissue damage."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(istype(M,/mob/living/carbon/human/))
					var/datum/organ/external/org = pick(M:organs2)
					org.take_damage(2,0,0,0)
				else
					M:bruteloss += 1
				holder.remove_reagent(src.id, 0.3)
				return

		kelotane
			name = "Kelotane"
			id = "kelotane"
			description = "Kelotane is a drug used to treat burns."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:fireloss = max(M:fireloss-2,0)
				..()
				return

		dexalin
			name = "Dexalin"
			id = "dexalin"
			description = "Dexalin is used in the treatment of oxygen deprivation."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:oxyloss = max(M:oxyloss-2, 0)
				..()
				return

		dexalinp
			name = "Dexalin Plus"
			id = "dexalinp"
			description = "Dexalin Plus is used in the treatment of oxygen deprivation. Its highly effective."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:oxyloss -= max((M:oxyloss * 0.10),5)
				..()
				return

		tricordrazine
			name = "Tricordrazine"
			id = "tricordrazine"
			description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(istype(M,/mob/living/carbon/human))
					for(var/datum/organ/external/org in M:organs2)
						if(org.brute_dam && prob(40)) org.brute_dam--
						if(org.burn_dam && prob(40)) org.burn_dam--
					if(M:oxyloss && prob(40)) M:oxyloss--
					if(M:toxloss && prob(40)) M:toxloss--
				else
					if(M:oxyloss && prob(40)) M:oxyloss--
					if(M:bruteloss && prob(40)) M:bruteloss--
					if(M:fireloss && prob(40)) M:fireloss--
					if(M:toxloss && prob(40)) M:toxloss--
				..()
				return

/*		adminordrazine //An OP chemical for adminis
			name = "Adminordrazine"
			id = "adminordrazine"
			description = "It's magic. We don't have to explain it."
			reagent_state = LIQUID
			red = 200
			green = 165
			blue = 220
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom ///This can even heal dead people.
				M.radiation = 0
				M.toxloss += -5
				if(holder.has_reagent("toxin"))
					holder.remove_reagent("toxin", 5)
				if(holder.has_reagent("stoxin"))
					holder.remove_reagent("stoxin", 5)
				if(holder.has_reagent("plasma"))
					holder.remove_reagent("plasma", 5)
				if(holder.has_reagent("acid"))
					holder.remove_reagent("acid", 5)
				if(holder.has_reagent("pacid"))
					holder.remove_reagent("pacid", 5)
				if(holder.has_reagent("cyanide"))
					holder.remove_reagent("cyanide", 5)
				if(holder.has_reagent("lexorin"))
					holder.remove_reagent("lexorin", 5)
				if(holder.has_reagent("amatoxin"))
					holder.remove_reagent("amatoxin", 5)
				if(holder.has_reagent("chloralhydrate"))
					holder.remove_reagent("chloralhydrate", 5)
				if(holder.has_reagent("carpotoxin"))
					holder.remove_reagent("carpotoxin", 5)
				if(holder.has_reagent("zombiepowder"))
					holder.remove_reagent("zombiepowder", 5)
				M.brainloss += -3
				M.disabilities = 0
				M.eye_blurry = 0
				M.eye_blind = 0
				M.disabilities &= ~1
				M.dizziness = 0
				M.drowsyness = 0
				M.stuttering = 0
				M.confused = 0
				M.weakened=0
				M.stunned=0
				M.paralysis=0
				M.jitteriness = 0
				..()
				return */

		synaptizine
			name = "Synaptizine"
			id = "synaptizine"
			description = "Synaptizine is used to treat neuroleptic shock. Can be used to help remove disabling symptoms such as paralysis."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-5, 0)
				if(M:paralysis) M:paralysis=0
				if(M:stunned) M:stunned=0
				if(M:weakened) M:weakened=0
				..()
				return

		impedrezene
			name = "Impedrezene"
			id = "impedrezene"
			description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:jitteriness = max(M:jitteriness-5,0)
				if(prob(80)) M:brainloss++
				if(prob(50)) M:drowsyness = max(M:drowsyness, 3)
				if(prob(10)) M:emote("drool")
				..()
				return

		hyronalin
			name = "Hyronalin"
			id = "hyronalin"
			description = "Hyronalin is a medicinal drug used to counter the effects of radiation poisoning."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:radiation && prob(80)) M:radiation--
				..()
				return

		alkysine
			name = "Alkysine"
			id = "alkysine"
			description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:brainloss = max(M:brainloss-3 , 0)
				..()
				return

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-3,0)
				if(M:toxloss && prob(50)) M:toxloss--
				if(prob(15)) M:bruteloss++
				..()
				return

		imidazoline
			name = "Imidazoline"
			id = "imidazoline"
			description = "Heals eye damage"
			reagent_state = LIQUID
			red = 200
			green = 165
			blue = 220

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				M:eye_blurry = max(M:eye_blurry-5 , 0)
				M:eye_blind = max(M:eye_blind-5 , 0)
				M:disabilities &= ~1
				M:eye_stat = max(M:eye_stat-5, 0)
//				if(data >= 100)
//					M:adjustToxLoss(0.2)
				..()
				return

		bicaridine
			name = "Bicaridine"
			id = "bicaridine"
			description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(istype(M,/mob/living/carbon/human))
					for(var/datum/organ/external/org in M:organs2)
						if(org.brute_dam && prob(40)) org.brute_dam--
				else
					if(M:bruteloss && prob(40)) M:bruteloss--
				..()
				return

		hyperzine
			name = "Hyperzine"
			id = "hyperzine"
			description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(5)) M:emote(pick("twitch","blink_r","shiver"))
				holder.remove_reagent(src.id, 0.2)
				return

		cryoxadone
			name = "Cryoxadone"
			id = "cryoxadone"
			description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-3)
					if(M:bruteloss) M:bruteloss = max(0, M:bruteloss-3)
					if(M:fireloss) M:fireloss = max(0, M:fireloss-3)
					if(M:toxloss) M:toxloss = max(0, M:toxloss-3)
				..()
				return

		spaceacillin
			name = "Spaceacillin"
			id = "spaceacillin"
			description = "An all-purpose antiviral agent."
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if((M.virus) && (prob(8)))
					if(M.virus.spread == "Airborne")
						M.virus.spread = "Remissive"
					M.virus.stage--
					if(M.virus.stage <= 0)
						M.resistances += M.virus.type
						M.virus = null
				if(prob(5))
					holder.remove_reagent(src.id, 0.2)
				return

		carpotoxin
			name = "Carpotoxin"
			id = "carpotoxin"
			description = "A deadly neurotoxin produced by the dreaded spess carp."
			reagent_state = LIQUID
			red = 0
			green = 51
			blue = 51
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += -1
				..()
				return

		LSD
			name = "LSD"
			id = "LSD"
			description = "A hallucinogen"
			reagent_state = LIQUID

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:hallucination += 5
				..()
				return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

		nanites
			name = "Nanomachines"
			id = "nanites"
			description = "Microscopic construction robots."
			reagent_state = LIQUID
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if( (prob(10) && method==TOUCH) || method==INGEST)
					if(!M.virus)
						M.virus = new /datum/disease/robotic_transformation
						M.virus.affected_mob = M

//foam precursor

		fluorosurfactant
			name = "Fluorosurfactant"
			id = "fluorosurfactant"
			description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
			reagent_state = LIQUID


// metal foaming agent
// this is lithium hydride. Add other recipies (e.g. LiH + H2O -> LiOH + H2) eventually

		foaming_agent
			name = "Foaming agent"
			id = "foaming_agent"
			description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
			reagent_state = SOLID

		nicotine
			name = "Nicotine"
			id = "nicotine"
			description = "A highly addictive stimulant extracted from the tobacco plant."
			reagent_state = LIQUID

		ethanol
			name = "Ethanol"
			id = "ethanol"
			description = "A well-known alcohol with a variety of applications."
			reagent_state = LIQUID
			red = 64
			green = 64
			blue = 48
			var/dizzy_adj = 3
			var/confused_adj = 5
			var/intox_adj = 5
			var/confused_start = 100
			var/pass_out = 250
			var/blur_start = 100
			var/dizzy_start = 15
			var/intox_start = 30
			on_mob_life(var/mob/living/M as mob)
				if(!src.data) data = 1
				src.data++
				var/d = data
				for(var/datum/reagent/ethanol/A in holder.reagent_list)
				M:jitteriness = max(M:jitteriness-3,0)
				M:nutrition += 2
				if(d >= dizzy_start)
					M.make_dizzy(dizzy_adj)
				if(d >= intox_start)
					if (!M:intoxicated) M:intoxicated = 1
					M:intoxicated += intox_adj
				if(d >= confused_start && prob(33))
					if (!M:confused) M:confused = 1
					M.confused = max(M:confused+confused_adj,0)
				if(d >= blur_start)
					M.eye_blurry = max(M.eye_blurry, 10)
					M:drowsyness  = max(M:drowsyness, 0)
				if(d >= pass_out)
					M:paralysis = max(M:paralysis, 20)
					M:drowsyness  = max(M:drowsyness, 30)

				holder.remove_reagent(src.id, 0.4)
				..()
				return
		ultraglue
			name = "Ulta Glue"
			id = "glue"
			description = "An extremely powerful bonding agent."

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID
			red = 96
			green = 64
			blue = 64

		ethylredoxrazine						// FUCK YOU, ALCOHOL
			name = "Ethylredoxrazine"
			id = "ethylredoxrazine"
			description = "A powerfuld oxidizer that reacts with ethanol."
			reagent_state = SOLID
			red = 96
			green = 80
			blue = 72
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.dizziness = 0
				M:drowsyness = 0
				M:confused = 0
				M.eye_blurry = 0
				..()
				return

		chloralhydrate							//Otherwise known as a "Mickey Finn"
			name = "Chloral Hydrate"
			id = "chloralhydrate"
			description = "A powerful sedative."
			reagent_state = SOLID
			red = 0
			green = 0
			blue = 103
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(5 to 10)
						M:confused += 2
						M:drowsyness += 2
						M:sleeping += 2
					if(11 to 50)
						M:sleeping += 3
					if(51 to INFINITY)
						M:sleeping += 4
						M:toxloss += -2
				holder.remove_reagent(src.id, 0.07)
				..()
				return

		ammonia
			name = "Ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."
			reagent_state = GAS

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID





/*
		cure
			name = "Experimental cure"
			id = "cure"
			description = "An experimental set of antibodies designed to fight disease"
			reagent_state = LIQUID
			var/works = 0
			var/datum/disease2/resistance/resistance = null
			on_mob_life(var/mob/living/carbon/M)
				if(works == 0)
					M.resistances2 += resistance
					if(M.virus2)
						M.virus2.cure_added(resistance)
					holder.remove_reagent(src.id,9999999)
				else if(works == 1)
					M.toxloss += 5
				else if(works == 2)
					M.gib()
				else if(works == 3)
					M.bruteloss += 15
				..()*/


		virusfood
			name = "Virus food"
			id = "virusfood"
			description = "A set of specially engineered food for the growth of viral cells"
			reagent_state = LIQUID

		weedkiller
			name = "Atrazine"
			id = "weedkiller"
			description = "A chemical, poisonous to weeds."
			reagent_state = LIQUID

/////////////////////////////////////////////////////FOODS////////////////////////////
		amatoxin
			name = "Amatoxin"
			id = "amatoxin"
			description = "A powerful poison derived from certain species of mushroom."
			red = 121
			green = 35
			blue = 0
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 1
				..()
				return

   /////////////////////////////////////////////////////////DRINKS////////////////////////////////////////////////////////

		milk
			name = "Milk"
			id = "milk"
			description = "An opaque white liquid produced by the mammary glands of mammals."
			reagent_state = LIQUID
			red = 240
			green = 240
			blue = 240
			nutriment_factor = 1
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return


		orangejuice
			name = "Orange juice"
			id = "orangejuice"
			description = "Both delicious AND rich in Vitamin C, what more do you need?"
			reagent_state = LIQUID
			red = 255
			green = 117
			blue = 56
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M:oxyloss = max(M:oxyloss-1, 0)
				..()
				return

		tomatojuice
			name = "Tomato juice"
			id = "tomatojuice"
			description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
			reagent_state = LIQUID
			red = 115
			green = 16
			blue = 8
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M:fireloss = max(M:fireloss-1,0)
				..()
				return

		limejuice
			name = "Lime juice"
			id = "limejuice"
			description = "The sweet-sour juice of limes."
			reagent_state = LIQUID
			red = 54
			green = 94
			blue = 48
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M:toxloss = max(M:toxloss-1,0)
				..()
				return

		carrotjuice
			name = "Carrot juice"
			id = "carrotjuice"
			description = "It is just like a carrot but without crunching."
			reagent_state = LIQUID
			red = 151
			green = 56
			blue = 0
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M.eye_blurry = max(M:eye_blurry-1,0)
				M:eye_blind = max(M:eye_blind-1 , 0)
				..()
				return

		grapejuice
			name = "Grape juice"
			id = "grapejuice"
			description = "The sweet-sour juice of limes."
			reagent_state = LIQUID
			red = 51
			green = 51
			blue = 134
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return

		berryjuice
			name = "Berry Juice"
			id = "berryjuice"
			description = "A delicious blend of several different kinds of berries."
			reagent_state = LIQUID
			red = 134
			green = 51
			blue = 51
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return

		lemonjuice
			name = "Lemon Juice"
			id = "lemonjuice"
			description = "This juice is VERY sour."
			reagent_state = LIQUID
			red = 175
			green = 175
			blue = 0
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return

		bananajuice
			name = "Banana Juice"
			id = "bananajuice"
			description = "The raw essence of a banana. HONK"
			reagent_state = LIQUID
			red = 175
			green = 175
			blue = 0
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Clown"))
					for(var/datum/organ/external/org in M:organs2)
						if(org.brute_dam && prob(40)) org.brute_dam--
					..()
					return
				if(istype(M, /mob/living/carbon/monkey))
					for(var/datum/organ/external/org in M:organs2)
						if(org.brute_dam && prob(40)) org.brute_dam--
					..()
					return
				..()
		cream
			name = "Cream"
			id = "cream"
			description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
			reagent_state = LIQUID
			red = 223
			green = 215
			blue = 175
			nutriment_factor = 1
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M.bruteloss = max(M:bruteloss-1,0)
				..()
				return

		tea
			name = "Tea"
			id = "tea"
			description = "Tasty black tea, it has antioxidants, it's good for you!"
			reagent_state = LIQUID
			red = 16
			green = 16
			blue = 0
			nutriment_factor = 1
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M:toxloss = max(M:toxloss-1,0)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature+5)
				..()
				return

		icetea
			name = "Iced Tea"
			id = "icetea"
			description = "No relation to a certain rap artist/actor."
			reagent_state = LIQUID
			red = 16
			green = 64
			blue = 56
			alpha = 50
			nutriment_factor = 1

			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				M.dizziness = max(0,M.dizziness-2)
				M:drowsyness = max(0,M:drowsyness-1)
				if(!M) M = holder.my_atom
				M:toxloss = max(M:toxloss-1,0)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature-5)
				..()
				return

		ice
			name = "Ice"
			id = "ice"
			description = "Frozen water, your dentist wouldn't like you chewing this."
			reagent_state = SOLID
			red = 255
			green = 255
			blue = 255
			alpha = 50
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				..()
				return

		tonic
			name = "Tonic Water"
			id = "tonic"
			description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
			reagent_state = LIQUID
			red = 152
			green = 255
			blue = 152
			alpha = 40
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				..()
				return

		hot_coco
			name = "Hot Chocolate"
			id = "hot_coco"
			description = "Made with love! And coco beans."
			reagent_state = LIQUID
			red = 64
			green = 48
			blue = 16
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				..()
				return

		dry_ramen
			name = "Dry Ramen"
			id = "dry_ramen"
			description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
			reagent_state = SOLID
			red = 48
			green = 32
			blue = 0
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return
///////////////////////////////////////////////ALHO////////////////////////////////////////////////////////////

		ethanol
			name = "Ethanol"
			id = "ethanol"
			description = "A well-known alcohol with a variety of applications."
			reagent_state = LIQUID
			red = 64
			green = 64
			blue = 48
			alpha = 50
			nutriment_factor = 2
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!src.data) data = 1
				src.data++
				var/d = data
				for(var/datum/reagent/ethanol/A in holder.reagent_list)
				M:jitteriness = max(M:jitteriness-3,0)
				if(d >= dizzy_start)
					M.make_dizzy(dizzy_adj)
				if(d >= intox_start)
					if (!M:intoxicated) M:intoxicated = 1
					M:intoxicated += intox_adj
				if(d >= confused_start && prob(33))
					if (!M:confused) M:confused = 1
					M.confused = max(M:confused+confused_adj,0)
				if(d >= blur_start)
					M.eye_blurry = max(M.eye_blurry, 10)
					M:drowsyness  = max(M:drowsyness, 0)
				if(d >= pass_out)
					M:paralysis = max(M:paralysis, 20)
					M:drowsyness  = max(M:drowsyness, 30)

				holder.remove_reagent(src.id, 0.4)
				..()
				return

			beer	//It's really much more stronger than other drinks.
				name = "Beer"
				id = "beer"
				description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
				red = 150
				green = 75
				blue = 0
				nutriment_factor = 2
				confused_start = 120
				blur_start = 120
				dizzy_start = 30
				intox_start = 40


			vodka
				name = "Vodka"
				id = "vodka"
				description = "Number one drink AND fueling choice for Russians worldwide."
				alpha = 50
				nutriment_factor = 2
				confused_start = 70
				pass_out = 190
				blur_start = 80
				dizzy_start = 10
				intox_start = 20

			dwine
				name = "Dwarven Wine"
				id = "dwine"
				description = "Strike the planet! Celebratory NanoTrasen drink, limited edition."
				red = 128
				green = 0
				blue = 128
				dizzy_adj = 2
				confused_start = 145
				nutriment_factor = 2

			whiskey
				name = "Whiskey"
				id = "whiskey"
				description = "A superb and well-aged single-malt whiskey. Damn."
				red = 102
				green = 67
				blue = 0
				dizzy_adj = 4
				nutriment_factor = 2
				confused_start = 70
				pass_out = 190
				blur_start = 80
				dizzy_start = 12
				intox_start = 20

			gin
				name = "Gin"
				id = "gin"
				description = "It's gin. In space. I say, good sir."
				red = 218
				green = 216
				blue = 205
				alpha = 50
				dizzy_adj = 3
				nutriment_factor = 2
				pass_out = 220
				blur_start = 100
				dizzy_start = 20
				intox_start = 40

			rum
				name = "Rum"
				id = "rum"
				description = "Yohoho and all that."
				red = 102
				green = 67
				blue = 0
				nutriment_factor = 2
				confused_start = 100
				pass_out = 200
				blur_start = 90
				dizzy_start = 15
				intox_start = 30

			tequilla
				name = "Tequilla"
				id = "tequilla"
				description = "A strong and mildly flavoured, mexican produced ethanol. Feeling thirsty hombre?"
				red = 168
				green = 176
				blue = 183
				alpha = 60
				nutriment_factor = 2
				confused_start = 100
				pass_out = 210
				blur_start = 110

			cognac
				name = "Cognac"
				id = "cognac"
				description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
				red = 102
				green = 67
				blue = 0
				dizzy_adj = 4
				confused_start = 115
				nutriment_factor = 2
				confused_start = 100
				pass_out = 200
				blur_start = 90
				dizzy_start = 15
				intox_start = 20

			vermouth
				name = "Vermouth"
				id = "vermouth"
				description = "You suddenly feel a craving for a martini..."
				red = 132
				green = 47
				blue = 47
				alpha = 60
				nutriment_factor = 2
				confused_start = 100
				pass_out = 200
				blur_start = 90
				dizzy_start = 15
				intox_start = 25

			hooch
				name = "Hooch"
				id = "hooch"
				description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
				red = 102
				green = 67
				blue = 0
				dizzy_adj = 6
				confused_start = 90
				nutriment_factor = 2
				pass_out = 200
				blur_start = 90
				dizzy_start = 15
				intox_start = 30

			absinthe
				name = "Absinthe"
				id = "absinthe"
				description = "Watch out that the Green Fairy doesn't come for you!"
				red = 115
				green = 211
				blue = 20
				dizzy_adj = 5
				confused_start = 100
				nutriment_factor = 2
				pass_out = 200
				blur_start = 90
				dizzy_start = 15
				intox_start = 10
				on_mob_life(var/mob/M)
					if(!M) M = holder.my_atom
					if(!data) data = 1
					data++
					M:hallucination += 5
					..()
					return
//////////////////////////////////////////////////////cocktail entities/////////////////////////////////////////////////

			atomicbomb
				name = "Atomic Bomb"
				id = "atomicbomb"
				description = "Nuclear proliferation never tasted so good."
				reagent_state = LIQUID
				red = 102
				green = 99
				blue = 0

			goldschlager
				name = "Goldschlager"
				id = "goldschlager"
				description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			patron
				name = "Patron"
				id = "patron"
				description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
				reagent_state = LIQUID
				red = 88
				green = 88
				blue = 64

			gintonic
				name = "Gin and Tonic"
				id = "gintonic"
				description = "An all time classic, mild cocktail."
				reagent_state = LIQUID
				alpha = 50

			cuba_libre
				name = "Cuba Libre"
				id = "cubalibre"
				description = "Rum, mixed with cola. Viva la revolution."
				reagent_state = LIQUID
				red = 62
				green = 27
				blue = 0

			whiskey_cola
				name = "Whiskey Cola"
				id = "whiskeycola"
				description = "Whiskey, mixed with cola. Surprisingly refreshing."
				reagent_state = LIQUID
				red = 62
				green = 27
				blue = 0

			martini
				name = "Classic Martini"
				id = "martini"
				description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
				reagent_state = LIQUID
				alpha = 50

			vodkamartini
				name = "Vodka Martini"
				id = "vodkamartini"
				description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
				reagent_state = LIQUID
				alpha = 50

			white_russian
				name = "White Russian"
				id = "whiterussian"
				description = "That's just, like, your opinion, man..."
				reagent_state = LIQUID
				red = 166
				green = 131
				blue = 64

			screwdrivercocktail
				name = "Screwdriver"
				id = "screwdrivercocktail"
				description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
				reagent_state = LIQUID
				red = 166
				green = 131
				blue = 16

			booger
				name = "Booger"
				id = "booger"
				description = "Ewww..."
				reagent_state = LIQUID
				red = 166
				green = 131
				blue = 16

			bloody_mary
				name = "Bloody Mary"
				id = "bloodymary"
				description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
				reagent_state = LIQUID
				red = 150
				green = 0
				blue = 24

			gargle_blaster
				name = "Pan-Galactic Gargle Blaster"
				id = "gargleblaster"
				description = "Whoah, this stuff looks volatile!"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			brave_bull
				name = "Brave Bull"
				id = "bravebull"
				description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			tequilla_sunrise
				name = "Tequila Sunrise"
				id = "tequillasunrise"
				description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			toxins_special
				name = "Toxins Special"
				id = "toxinsspecial"
				description = "This thing is FLAMING!. CALL THE DAMN SHUTTLE!"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			beepsky_smash
				name = "Beepsky Smash"
				id = "beepskysmash"
				description = "Deny drinking this and prepare for THE LAW."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			doctor_delight
				name = "The Doctor's Delight"
				id = "doctorsdelight"
				description = "A gulp a day keeps the MediBot away. That's probably for the best."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

				on_mob_life(var/mob/living/M as mob)
					if(!M) M = holder.my_atom
					M:toxloss = max(M:toxloss-1,0)
					M:fireloss = max(M:fireloss-1,0)
					M:oxyloss = max(M:oxyloss-1,0)
					for(var/datum/organ/external/org in M:organs2)
						if(org.brute_dam && prob(40)) org.brute_dam--
					..()
					return

			irish_cream
				name = "Irish Cream"
				id = "irishcream"
				description = "Whiskey-imbued cream, what else would you expect from the Irish."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			manly_dorf
				name = "The Manly Dorf"
				id = "manlydorf"
				description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			longislandicedtea
				name = "Long Island Iced Tea"
				id = "longislandicedtea"
				description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			moonshine
				name = "Moonshine"
				id = "moonshine"
				description = "You've really hit rock bottom now... your liver packed its bags and left last night."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			b52
				name = "B-52"
				id = "b52"
				description = "Coffee, Irish Cream, and congac. You will get bombed."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			irishcoffee
				name = "Irish Coffee"
				id = "irishcoffee"
				description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			margarita
				name = "Margarita"
				id = "margarita"
				description = "On the rocks with salt on the rim. Arriba~!"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			black_russian
				name = "Black Russian"
				id = "blackrussian"
				description = "For the lactose-intolerant. Still as classy as a White Russian."
				reagent_state = LIQUID
				red = 57
				green = 0
				blue = 0

			manhattan
				name = "Manhattan"
				id = "manhattan"
				description = "The Detective's undercover drink of choice. He never could stomach gin..."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			manhattan_proj
				name = "Manhattan Project"
				id = "manhattan_proj"
				description = "A scienitst's drink of choice, for pondering ways to blow up the station."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			whiskeysoda
				name = "Whiskey Soda"
				id = "whiskeysoda"
				description = "Ultimate refreshment."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			antifreeze
				name = "Anti-freeze"
				id = "antifreeze"
				description = "Ultimate refreshment."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			barefoot
				name = "Barefoot"
				id = "barefoot"
				description = "Barefoot and pregnant"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			snowwhite
				name = "Snow White"
				id = "snowwhite"
				description = "A cold refreshment"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			demonsblood
				name = "Demons Blood"
				id = "demonsblood"
				description = "AHHHH!!!!"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0
				dizzy_adj = 10

			vodkatonic
				name = "Vodka and Tonic"
				id = "vodkatonic"
				description = "For when a gin and tonic isn't russian enough."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0
				dizzy_adj = 4

			ginfizz
				name = "Gin Fizz"
				id = "ginfizz"
				description = "Refreshingly lemony, deliciously dry."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0
				dizzy_adj = 4

			bahama_mama
				name = "Bahama mama"
				id = "bahama_mama"
				description = "Tropic cocktail."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			singulo
				name = "Singulo"
				id = "singulo"
				description = "A blue-space beverage!"
				reagent_state = LIQUID
				red = 46
				green = 102
				blue = 113
				dizzy_adj = 15

			sbiten
				name = "Sbiten"
				id = "sbiten"
				description = "A spicy Vodka! Might be a little hot for the little guys!"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			devilskiss
				name = "Devils Kiss"
				id = "devilskiss"
				description = "Creepy time!"
				reagent_state = LIQUID
				red = 166
				green = 131
				blue = 16

			iced_beer
				name = "Iced Beer"
				id = "iced_beer"
				description = "A beer which is so cold the air around it freezes."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			cafe_latte
				name = "Cafe Latte"
				id = "cafe_latte"
				description = "A nice, strong and tasty beverage while you are reading."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			amasec
				name = "Amasec"
				id = "amasec"
				description = "Always before COMBAT!!!"
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			thirteenloko
				name = "Thirteen Loko"
				id = "thirteenloko"
				description = "A potent mixture of caffeine and alcohol."
				reagent_state = LIQUID
				red = 16
				green = 32
				blue = 0

				on_mob_life(var/mob/living/M as mob)
					M:drowsyness = max(0,M:drowsyness-7)
					if (M.bodytemperature > 310)
						M.bodytemperature = max(310, M.bodytemperature-5)
					M.make_jittery(1)
					return

			ale
				name = "Ale"
				id = "ale"
				description = "A dark alchoholic beverage made by malted barley and yeast."
				reagent_state = LIQUID
				red = 102
				green = 67
				blue = 0

			sodawater
				name = "Soda Water"
				id = "sodawater"
				description = "A can of club soda. Why not make a scotch and soda?"
				reagent_state = LIQUID
				red = 97
				green = 148
				blue = 148
				on_mob_life(var/mob/living/M as mob)
					M.dizziness = max(0,M.dizziness-5)
					M:drowsyness = max(0,M:drowsyness-3)
					..()
					return
			wine
				name = "Wine"
				id = "wine"
				description = "An premium alchoholic beverage made from distilled grape juice."
				red = 126
				green = 64
				blue = 67
				dizzy_adj = 2
				confused_start = 145
