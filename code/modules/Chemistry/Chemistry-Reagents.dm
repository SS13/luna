#define SOLID 1
#define LIQUID 2
#define GAS 3

#define	REAGENTS_METABOLISM 0.4	//How many units of reagent are consumed per tick, by default.
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)
// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism

//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

datum
	reagent
		var/name = "Reagent"
		var/id = "reagent"
		var/description = ""
		var/datum/reagents/holder = null
		var/reagent_state = SOLID
		var/list/data = null
		var/volume = 0
		var/red = 255
		var/green = 255
		var/blue = 255
		var/alpha = 255
		var/nutriment_factor = 0
		var/reagent_color = "#000000"
		proc
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
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

			reaction_obj(var/obj/O, var/volume)
			//	var/datum/reagent/self = src
			//	src = null
			//	if(O.reagents)
			//		O.reagents.add_reagent(self.id,self.volume)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				return

			on_mob_life(var/mob/living/M)
				holder.remove_reagent(src.id, 0.4) //By default it slowly disappears.
				return

			on_move(var/mob/living/M)
				return

			// Called after add_reagents creates a new reagent.
			on_new(var/data)
				return

			// Called when two reagents of the same are mixing.
			on_merge(var/data)
				return

			on_update(var/atom/A)
				return

			getcolour()
				return rgb(red,green,blue)


/////////////////////////////////////////////////////////////////CHIM////////////////////////////////////////
		water
			name = "Water"
			id = "water"
			description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
			reagent_state = LIQUID
			reagent_color = "#0064C8" // rgb: 0, 100, 200

			reaction_turf(var/turf/T, var/volume)
				src = null
				for(var/mob/living/carbon/slime/M in T)
					M.adjustToxLoss(rand(15,20))
				if(istype(T, /turf/simulated) && volume >= 3)
					var/turf/simulated/turf = T
					if(turf.wet >= 1) return
					turf.wet = 1
					if(turf.wet_overlay)
						turf.overlays -= T:wet_overlay
						turf.wet_overlay = null
					turf.wet_overlay = image('water.dmi',T,"wet_floor")
					turf.overlays += T:wet_overlay

					spawn(800)
						if(!istype(turf)) return
						if(turf.wet >= 2) return
						turf.wet = 0
						if(turf.wet_overlay)
							turf.overlays -= T:wet_overlay
							turf.wet_overlay = null

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

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(isslime(M))
					M.adjustToxLoss(rand(15,20))

		water/holywater
			name = "Holy Water"
			id = "holywater"
			description = "Water blessed by some deity."
			reagent_color = "#E0E8EF" // rgb: 224, 232, 239

			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				M.jitteriness = max(M.jitteriness-5,0)
				if(data >= 30)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 4
					M.make_dizzy(5)
				if(data >= 30*2.5 && prob(33))
					if (!M.confused) M.confused = 1
					M.confused += 3
				..()
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				..()
				if(!istype(T)) return
				T.Bless()

		blood
			data = new/list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"="A+","resistances"=null,"trace_chem"=null)
			name = "Blood"
			id = "blood"
			reagent_state = LIQUID
			reagent_color = "#C80000" // rgb: 200, 0, 0

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				var/datum/reagent/blood/self = src
				src = null
				if(self.data && self.data["viruses"])
					for(var/datum/disease/D in self.data["viruses"])

						if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS) continue

						if(method == TOUCH)
							M.contract_disease(D)
						else //injected
							M.contract_disease(D, 1, 0)

			on_new(var/list/data)
				if(istype(data))
					SetViruses(src, data)

			on_mob_life(mob/M)
				if (ishuman(M) && data && blood_incompatible(data["blood_type"],M.dna.blood_type))
					if(prob(40)) M:toxloss += 1
					M:oxyloss += 2
				..()
				return

			on_merge(var/list/data)
				if(src.data && data)
					if(src.data["viruses"] || data["viruses"])

						var/list/mix1 = src.data["viruses"]
						var/list/mix2 = data["viruses"]

						// Stop issues with the list changing during mixing.
						var/list/to_mix = list()

						for(var/datum/disease/advance/AD in mix1)
							to_mix += AD
						for(var/datum/disease/advance/AD in mix2)
							to_mix += AD

						var/datum/disease/advance/AD = Advance_Mix(to_mix)
						if(AD)
							var/list/preserve = list(AD)
							for(var/D in src.data["viruses"])
								if(!istype(D, /datum/disease/advance))
									preserve += D
							src.data["viruses"] = preserve
				return 1

		vaccine
			//data must contain virus type
			name = "Vaccine"
			id = "vaccine"
			reagent_state = LIQUID
			reagent_color = "#C81040" // rgb: 200, 16, 64

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				var/datum/reagent/vaccine/self = src
				src = null
				if(islist(self.data) && method == INGEST)
					for(var/datum/disease/D in M.viruses)
						if(D.GetDiseaseID() in self.data)
							D.cure()
					M.resistances |= self.data
				return

			on_merge(var/list/data)
				if(istype(data))
					src.data |= data.Copy()

		lube
			name = "Space Lube"
			id = "lube"
			description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. Giggity."
			reagent_state = LIQUID
			reagent_color = "#009CA8" // rgb: 0, 156, 168

			reaction_turf(var/turf/simulated/T, var/volume)
				if(!istype(T)) return
				src = null
				if(T.wet >= 2) return
				T.wet = 2
				T.wet_overlay = image('effects.dmi', "slube")
				T.overlays += T:wet_overlay
				spawn(1600)
					if(!istype(T)) return
					T.wet = 0
					if(T.wet_overlay)
						T:overlays -= T:wet_overlay

				return

		anti_toxin
			name = "Anti-Toxin (Dylovene)"
			id = "anti_toxin"
			description = "Dylovene is a broad-spectrum antitoxin."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-2, 0)
				if(holder.has_reagent("toxin"))
					holder.remove_reagent("toxin", 2)
				if(holder.has_reagent("stoxin"))
					holder.remove_reagent("stoxin", 2)
				if(holder.has_reagent("plasma"))
					holder.remove_reagent("plasma", 1)
				if(holder.has_reagent("sacid"))
					holder.remove_reagent("sacid", 1)
				if(holder.has_reagent("pacid"))
					holder.remove_reagent("pacid", 1)
				if(holder.has_reagent("cyanide"))
					holder.remove_reagent("cyanide", 1)
				M:toxloss = max(M:toxloss-2,0)
				..()
				return

		cyanide
			name = "Cyanide"
			id = "cyanide"
			description = "A highly toxic chemical."
			reagent_state = LIQUID
			reagent_color = "#CF3600"
			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:toxloss += 4
				M:oxyloss += 7
				..()
				return

		stoxin
			name = "Sleep Toxin"
			id = "stoxin"
			description = "An effective hypnotic used to treat insomnia."
			reagent_state = LIQUID
			reagent_color = "#E895CC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 20)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(20 to 35)
						M:drowsyness  = max(M:drowsyness, 20)
					if(35 to INFINITY)
						M:paralysis = max(M:paralysis, 20)
						M:drowsyness  = max(M:drowsyness, 30)
				data++
				..()
				return

		penstoxin //for Sleepy Pen
			name = "Sleep Toxin"
			id = "penstoxin"
			description = "An effective hypnotic used to treat insomnia."
			reagent_state = LIQUID
			reagent_color = "#E895CC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 8)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(8 to 16)
						M:drowsyness  = max(M:drowsyness, 20)
					if(16 to INFINITY)
						M:paralysis = max(M:paralysis, 20)
						M:drowsyness  = max(M:drowsyness, 30)
				data++
				..()
				return

		srejuvinate
			name = "Sleep Rejuvinate"
			id = "stoxin2"
			description = "Put people to sleep, and heals them."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

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
						M.drowsyness  = max(M.drowsyness, 20)
					if(25 to INFINITY)
						M.sleeping += 1
						M.adjustOxyLoss(-M.getOxyLoss())
						M.SetWeakened(0)
						M.SetStunned(0)
						M.SetParalysis(0)
						M.dizziness = 0
						M.drowsyness = 0
						M.stuttering = 0
						M.confused = 0
						M.jitteriness = 0
				..()
				return

		inaprovaline
			name = "Inaprovaline"
			id = "inaprovaline"
			description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
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
			reagent_color = "#60A584"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 15)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(7)) M:emote(pick("twitch","drool","moan","giggle"))
				holder.remove_reagent(src.id, 0.2)
				return

		serotrotium
			name = "Serotrotium"
			id = "serotrotium"
			description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
			reagent_state = LIQUID
			reagent_color = "#202040"

			on_mob_life(var/mob/living/M as mob)
				if(ishuman(M))
					if(prob(7)) M.emote(pick("twitch","drool","moan","gasp"))
					holder.remove_reagent(src.id, 0.1)
				return

		silicate
			name = "Silicate"
			id = "silicate"
			description = "A compound that can be used to reinforce glass."
			reagent_state = LIQUID
			reagent_color = "#C7FFFF" // rgb: 199, 255, 255

			reaction_obj(var/obj/O, var/volume)
				src = null
				if(istype(O,/obj/structure/window))
					O:health = O:health * 2
					var/icon/I = icon(O.icon,O.icon_state,O.dir)
					I.SetIntensity(1.15,1.50,1.75)
					O.icon = I
				return

		oxygen
			name = "Oxygen"
			id = "oxygen"
			description = "A reagent_colorless, odorless gas."
			reagent_state = GAS
			reagent_color = "#808080" // rgb: 128, 128, 128

		copper
			name = "Copper"
			id = "copper"
			description = "A highly ductile metal."
			reagent_color = "#6E3B08" // rgb: 110, 59, 8

		nitrogen
			name = "Nitrogen"
			id = "nitrogen"
			description = "A reagent_colorless, odorless, tasteless gas."
			reagent_state = GAS
			reagent_color = "#808080" // rgb: 128, 128, 128

		hydrogen
			name = "Hydrogen"
			id = "hydrogen"
			description = "A reagent_colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
			reagent_state = GAS
			reagent_color = "#808080" // rgb: 128, 128, 128

		potassium
			name = "Potassium"
			id = "potassium"
			description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
			reagent_state = SOLID
			reagent_color = "#A0A0A0" // rgb: 160, 160, 160

		mercury
			name = "Mercury"
			id = "mercury"
			description = "A chemical element."
			reagent_state = LIQUID
			reagent_color = "#484848" // rgb: 72, 72, 72

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.canmove && istype(M.loc, /turf/space))
					step(M, pick(cardinal))
				if(prob(5)) M.emote(pick("twitch","drool","moan"))
				..()
				return

		sulfur
			name = "Sulfur"
			id = "sulfur"
			description = "A chemical element."
			reagent_state = SOLID
			reagent_color = "#BF8C00" // rgb: 191, 140, 0

		carbon
			name = "Carbon"
			id = "carbon"
			description = "A chemical element."
			reagent_state = SOLID
			reagent_color = "#1C1300" // rgb: 30, 20, 0

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/effect/decal/cleanable/dirt(T)

		chlorine
			name = "Chlorine"
			id = "chlorine"
			description = "A chemical element."
			reagent_state = GAS
			reagent_color = "#808080" // rgb: 128, 128, 128

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		fluorine
			name = "Fluorine"
			id = "fluorine"
			description = "A highly-reactive chemical element."
			reagent_state = GAS
			reagent_color = "#808080" // rgb: 128, 128, 128
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
			reagent_color = "#808080" // rgb: 128, 128, 128

		phosphorus
			name = "Phosphorus"
			id = "phosphorus"
			description = "A chemical element."
			reagent_state = SOLID
			reagent_color = "#832828" // rgb: 131, 40, 40

		lithium
			name = "Lithium"
			id = "lithium"
			description = "A chemical element."
			reagent_state = SOLID
			reagent_color = "#808080" // rgb: 128, 128, 128

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.canmove && istype(M.loc, /turf/space))
					step(M, pick(cardinal))
				if(prob(5)) M.emote(pick("twitch","drool","moan"))
				..()
				return

		sugar
			name = "Sugar"
			id = "sugar"
			description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
			reagent_state = SOLID
			reagent_color = "#FFFFFF" // rgb: 255, 255, 255

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += 1
				..()
				return

		glycerol
			name = "Glycerol"
			id = "glycerol"
			description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
			reagent_state = LIQUID
			reagent_color = "#808080" // rgb: 128, 128, 128

		nitroglycerin
			name = "Nitroglycerin"
			id = "nitroglycerin"
			description = "Nitroglycerin is a heavy, reagent_colorless, oily, explosive liquid obtained by nitrating glycerol."
			reagent_state = LIQUID
			reagent_color = "#808080" // rgb: 128, 128, 128

		radium
			name = "Radium"
			id = "radium"
			description = "Radium is an alkaline earth metal. It is extremely radioactive."
			reagent_state = SOLID
			reagent_color = "#C7C7C7" // rgb: 199,199,199

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.radiation += 3
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/effect/decal/cleanable/greenglow(T)


		ryetalyn
			name = "Ryetalyn"
			id = "ryetalyn"
			description = "Ryetalyn can cure all genetic abnomalities."
			reagent_state = SOLID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.mutations = list()
				M.disabilities = 0
				M.sdisabilities = 0
				..()
				return

		thermite
			name = "Thermite"
			id = "thermite"
			description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
			reagent_state = SOLID
			reagent_color = "#673910" // rgb: 103, 57, 16

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
			reagent_color = "#13BC5E" // rgb: 19, 188, 94

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(33)) || method==INGEST)
					randmuti(M)
					if(prob(90))
						randmutb(M)
					else
						randmutg(M)
					domutcheck(M, null, 1)
					updateappearance(M,M.dna.uni_identity)
				return
			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.radiation += 2
				..()
				return

		iron
			name = "Iron"
			id = "iron"
			description = "Pure iron is a metal."
			reagent_state = SOLID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

		gold
			name = "Gold"
			id = "gold"
			description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
			reagent_state = SOLID
			reagent_color = "#F7C430" // rgb: 247, 196, 48

		silver
			name = "Silver"
			id = "silver"
			description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
			reagent_state = SOLID
			reagent_color = "#D0D0D0" // rgb: 208, 208, 208

		uranium
			name ="Uranium"
			id = "uranium"
			description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
			reagent_state = SOLID
			reagent_color = "#B8B8C0" // rgb: 184, 184, 192

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.radiation += 2
				..()
				return

		aluminium
			name = "Aluminium"
			id = "aluminium"
			description = "A silvery white and ductile member of the boron group of chemical elements."
			reagent_state = SOLID
			reagent_color = "#A8A8A8" // rgb: 168, 168, 168

		silicon
			name = "Silicon"
			id = "silicon"
			description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
			reagent_state = SOLID
			reagent_color = "#A8A8A8" // rgb: 168, 168, 168

		fuel
			name = "Welding fuel"
			id = "fuel"
			description = "Required for welders. Flamable."
			reagent_state = LIQUID
			reagent_color = "#660000" // rgb: 102, 0, 0

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
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.adjustToxLoss(1)
				..()
				return

		space_cleaner
			name = "Space cleaner"
			id = "cleaner"
			description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
			reagent_state = LIQUID
			reagent_color = "#A5F0EE" // rgb: 165, 240, 238

			reaction_obj(var/obj/O, var/volume)
				if(!O) return
				if(istype(O,/obj/effect/decal/cleanable))
					del(O)
				else
					O.clean_blood()
			reaction_turf(var/turf/T, var/volume)
				T.overlays = null
				T.clean_blood()
				for(var/obj/effect/decal/cleanable/C in src)
					del(C)
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
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
						if(C:glasses)
							C:glasses.clean_blood()
						if(C:head)
							C:head.clean_blood()
						if(C:back)
							C:back.clean_blood()
							C:update_clothing()

		leporazine
			name = "Leporazine"
			id = "leporazine"
			description = "Leporazine can be use to stabilize an individuals body temperature."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (60))
				else if(M.bodytemperature < 311)
					M.bodytemperature = min(310, M.bodytemperature + (60))
				..()
				return

		cryptobiolin
			name = "Cryptobiolin"
			id = "cryptobiolin"
			description = "Cryptobiolin causes confusion and dizzyness."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.make_dizzy(1)
				if(!M.confused) M.confused = 1
				M.confused = max(M.confused, 20)
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		plasma
			name = "Plasma"
			id = "plasma"
			description = "Plasma in its liquid form."
			reagent_state = LIQUID
			reagent_color = "#E71B00" // rgb: 231, 27, 0

			on_mob_life(var/mob/living/M)
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

		lexorin
			name = "Lexorin"
			id = "lexorin"
			description = "Lexorin temporarily stops respiration. Causes tissue damage."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				if(prob(20)) M:adjustBruteLoss(1)
				holder.remove_reagent(src.id, 0.4)
				return

		kelotane
			name = "Kelotane"
			id = "kelotane"
			description = "Kelotane is a drug used to treat burns."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				M.heal_organ_damage(0,2)
				..()
				return

		dermaline
			name = "Dermaline"
			id = "dermaline"
			description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
					return
				if(!M) M = holder.my_atom
				M.heal_organ_damage(0,3)
				..()
				return

		dexalin
			name = "Dexalin"
			id = "dexalin"
			description = "Dexalin is used in the treatment of oxygen deprivation."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.adjustOxyLoss(-3)
				..()
				return

		dexalinp
			name = "Dexalin Plus"
			id = "dexalinp"
			description = "Dexalin Plus is used in the treatment of oxygen deprivation. Its highly effective."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:adjustOxyLoss(-max((M:oxyloss * 0.5), 4))
				..()
				return

		tricordrazine
			name = "Tricordrazine"
			id = "tricordrazine"
			description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.adjustOxyLoss(-1)
				M.heal_organ_damage(1,1)
				M.adjustToxLoss(-1)
				if(prob(20))
					M.adjustOxyLoss(-1)
					M.heal_organ_damage(1,1)
					M.adjustToxLoss(-1)
				..()
				return

/*		adminordrazine //An OP chemical for badmins
			name = "Adminordrazine"
			id = "adminordrazine"
			description = "It's magic. We don't have to explain it."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom ///This can even heal dead people.
				M.radiation = 0
				M.toxloss -= 5
				if(holder.has_reagent("toxin"))
					holder.remove_reagent("toxin", 5)
				if(holder.has_reagent("stoxin"))
					holder.remove_reagent("stoxin", 5)
				if(holder.has_reagent("plasma"))
					holder.remove_reagent("plasma", 5)
				if(holder.has_reagent("sacid"))
					holder.remove_reagent("sacid", 5)
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
				M.brainloss -= 3
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
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-5, 0)
				if(M:paralysis) M:paralysis = 0
				if(M:stunned) M:stunned = 0
				if(M:weakened) M:weakened = 0
				if(holder.has_reagent("LSD"))
					holder.remove_reagent("LSD", 5)
				M.hallucination = max(0, M.hallucination - 10)
				..()
				return

		impedrezene
			name = "Impedrezene"
			id = "impedrezene"
			description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M)
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
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				if(M:radiation) M:radiation--
				if(M:radiation && prob(50)) M:radiation--
				..()
				return

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-7,0)
				if(M:toxloss && prob(50)) M:toxloss--
				if(prob(10)) M:adjustBruteLoss(1)
				..()
				return

		alkysine
			name = "Alkysine"
			id = "alkysine"
			description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.adjustBrainLoss(-3)
				..()
				return

		imidazoline
			name = "Imidazoline"
			id = "imidazoline"
			description = "Heals eye damage"
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1 to 5)
						M:eye_blurry = max(M:eye_blurry-5 , 0)
					if(5 to 10)
						M:eye_blind = max(M:eye_blind-5 , 0)
					if(10 to 20)
						M:eye_stat = max(M:eye_stat-5, 0)
					if(20 to INFINITY)
						M:disabilities &= ~1
						M:eye_stat = max(M:eye_stat-5, 0)
				..()
				return

		bicaridine
			name = "Bicaridine"
			id = "bicaridine"
			description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.adjustBruteLoss(-1)
				..()
				return

		hyperzine
			name = "Hyperzine"
			id = "hyperzine"
			description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				if(prob(2)) M:emote(pick("twitch","blink_r","shiver"))
				holder.remove_reagent(src.id, 0.2)
				return

		cryoxadone
			name = "Cryoxadone"
			id = "cryoxadone"
			description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					M.adjustOxyLoss(-3)
					M.heal_organ_damage(3,3)
					M.adjustToxLoss(-3)
				..()
				return

		clonexadone
			name = "Clonexadone"
			id = "clonexadone"
			description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' clones that get ejected early when used in conjunction with a cryo tube."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC" // rgb: 200, 165, 220

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					M.adjustOxyLoss(-4)
					M.heal_organ_damage(5,5)
					M.adjustToxLoss(-4)
					if(prob(5) && M.face_dmg)
						M.face_dmg = 0
						//M << "\blue You can feel your face again!"
				..()
				return

		spaceacillin
			name = "Spaceacillin"
			id = "spaceacillin"
			description = "An all-purpose antiviral agent."
			reagent_state = LIQUID
			reagent_color = "#C8A5DC"

		carpotoxin
			name = "Carpotoxin"
			id = "carpotoxin"
			description = "A deadly neurotoxin produced by the dreaded spess carp."
			reagent_state = LIQUID
			reagent_color = "#003333"

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 1
				..()
				return

		LSD
			name = "LSD"
			id = "LSD"
			description = "A powerful hallucinogen. Not a thing to be messed with."
			reagent_state = LIQUID
			reagent_color = "#B31008"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M:hallucination += 5
				..()
				return

//////////////////////////Poison stuff///////////////////////

		toxin
			name = "Toxin"
			id = "toxin"
			description = "A toxic chemical."
			reagent_state = LIQUID
			reagent_color = "#CF3600" // rgb: 207, 54, 0
			var/toxpwr = 2

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(toxpwr)
					M.adjustToxLoss(toxpwr)
				..()
				return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

		nanites
			name = "Nanomachines"
			id = "nanites"
			description = "Microscopic construction robots."
			reagent_state = LIQUID
			reagent_color = "#535E66"

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				src = null
				if((prob(50) && method==TOUCH) || method==INGEST)
					M.contract_disease(new /datum/disease/robotic_transformation(0),1)

		xenomicrobes
			name = "Xenomicrobes"
			id = "xenomicrobes"
			description = "Microbes with an entirely alien cellular structure."
			reagent_state = LIQUID
			reagent_color = "#535E66"

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if( (prob(50) && method==TOUCH) || method==INGEST)
					M.contract_disease(new /datum/disease/xeno_transformation(0),1)

		slimetoxin
			name = "Mutation Toxin"
			id = "mutationtoxin"
			description = "A corruptive toxin produced by slimes."
			reagent_state = LIQUID
			reagent_color = "#13BC5E" // rgb: 19, 188, 94

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/human = M
					if(human.dna.mutantrace == null)
						M << "\red Your flesh rapidly mutates!"
						human.dna.mutantrace = "slime"
						human.update_clothing()
				..()
				return

		aslimetoxin
			name = "Advanced Mutation Toxin"
			id = "amutationtoxin"
			description = "An advanced corruptive toxin produced by slimes."
			reagent_state = LIQUID
			reagent_color = "#13BC5E" // rgb: 19, 188, 94

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(istype(M, /mob/living/carbon) && M.stat != DEAD)
					M << "\red Your flesh rapidly mutates!"
					if(M.monkeyizing)	return
					M.monkeyizing = 1
					M.canmove = 0
					M.icon = null
					M.overlays.Cut()
					M.invisibility = 101
					for(var/obj/item/weapon/W in M)
						M.u_equip(W)
						if (M.client)
							M.client.screen -= W
						if (W)
							W.loc = M.loc
							W.dropped(src)
							W.layer = initial(W.layer)
					var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
					new_mob.a_intent = "harm"
					if(M.mind)
						M.mind.transfer_to(new_mob)
					else
						new_mob.key = M.key
					del(M)
				..()
				return
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//foam precursor

		fluorosurfactant
			name = "Fluorosurfactant"
			id = "fluorosurfactant"
			description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
			reagent_state = LIQUID
			reagent_color = "#9E6B38"


// metal foaming agent
// this is lithium hydride. Add other recipies (e.g. LiH + H2O -> LiOH + H2) eventually

		foaming_agent
			name = "Foaming agent"
			id = "foaming_agent"
			description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
			reagent_state = SOLID
			reagent_color = "#664B63"

		nicotine
			name = "Nicotine"
			id = "nicotine"
			description = "A highly addictive stimulant extracted from the tobacco plant."
			reagent_state = LIQUID

		ultraglue
			name = "Ulta Glue"
			id = "glue"
			description = "An extremely powerful bonding agent."

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID
			reagent_color = "#604030"

		ethylredoxrazine						// FUCK YOU, ALCOHOL
			name = "Ethylredoxrazine"
			id = "ethylredoxrazine"
			description = "A powerfuld oxidizer that reacts with ethanol."
			reagent_state = SOLID
			reagent_color = "#605048"

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
			reagent_color = "#000067"

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(2 to 10)
						M.confused += 2
						M.drowsyness += 2
						M.sleeping += 2
					if(11 to 70)
						M.sleeping += 3
					if(71 to INFINITY)
						M.sleeping += 4
						M.toxloss += 3
				..()
				return

		ammonia
			name = "Ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."
			reagent_state = GAS
			reagent_color = "#404030"

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID
			reagent_color = "#604030"

		sacid
			name = "Sulphuric acid"
			id = "sacid"
			description = "A strong mineral acid with the molecular formula H2SO4."
			reagent_state = LIQUID
			reagent_color = "#DB5008"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom

				if(prob(50)) M:toxloss++
				if(prob(50)) M.adjustFireLoss(1)
				..()
				return

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
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
						if(prob(20) && !M.face_dmg)
							var/datum/organ/external/affecting = M:organs["head"]
							if (affecting)
								affecting.take_damage(12, 0)
								M:UpdateDamage()
								M:UpdateDamageIcon()
								M:emote("scream")
								M << "\red Your face has become disfigured!"
								M.face_dmg = 1
						else
							M:adjustFireLoss(14)
				else
					M:adjustFireLoss(5 * max(1, volume / 10))

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item/weapon/ore/artifact))
					O:acid(volume)
					return
				if(istype(O,/obj/item) && prob(10) && !O.unacidable)
					var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/living/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)

		pacid
			name = "Polytrinic acid"
			id = "pacid"
			description = "Polytrinic acid is a an extremely corrosive chemical substance."
			reagent_state = LIQUID
			reagent_color = "#8E18A9"

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom

				if(prob(75)) M:toxloss++
				if(prob(75)) M.adjustFireLoss(1)
				..()
				return

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human) && !M.face_dmg)
						if(M:wear_mask && !M:wear_mask.unacidable)
							del (M:wear_mask)
							M << "\red Your mask melts away!"
						if(M:head && !M:head.unacidable)
							del (M:head)
							M << "\red Your helmet melts into uselessness!"

						var/datum/organ/external/affecting = M:organs["head"]
						if (affecting)
							affecting.take_damage(20, 0)
							M:UpdateDamage()
							M:UpdateDamageIcon()
							M:emote("scream")
							M << "\red Your face has become disfigured!"
							M.face_dmg = 1
					else
						M:adjustFireLoss(22)
				else
					M:adjustFireLoss(5 * max(1, volume / 10))

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item/weapon/ore/artifact))
					O:acid(volume)
					return
				if(istype(O,/obj/item) && !O.unacidable)
					var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/living/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)

		virusfood
			name = "Virus food"
			id = "virusfood"
			description = "A set of specially engineered food for the growth of viral cells"
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
			reagent_color = "#899613" // rgb: 137, 150, 19

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition += nutriment_factor
				..()
				return

		plantbgone
			name = "Plant-B-Gone"
			id = "plantbgone"
			description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
			reagent_state = LIQUID
			reagent_color = "#49002E" // rgb: 73, 0, 46
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

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon))
					if(!M.wear_mask) // If not wearing a mask
						M:toxloss += 4 // 4 toxic damage per application, doubled for some reason
					if(istype(M,/mob/living/carbon/human) && M:dna && M:dna.mutantrace == "plant") //plantmen take a LOT of damage
						M:toxloss += 10
						//if(prob(10))
							//M.make_dizzy(1) doesn't seem to do anything

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

		nutriment
			name = "Nutriment"
			id = "nutriment"
			description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
			reagent_state = SOLID
			nutriment_factor = 15 * REAGENTS_METABOLISM
			reagent_color = "#664330" // rgb: 102, 67, 48

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(prob(50)) M.heal_organ_damage(1,0)
				M.nutrition += nutriment_factor	// For hunger and fatness
				..()
				return


		lipozine
			name = "Lipozine" // The anti-nutriment.
			id = "lipozine"
			description = "A chemical compound that causes a powerful fat-burning reaction."
			reagent_state = LIQUID
			nutriment_factor = 10 * REAGENTS_METABOLISM
			reagent_color = "#BBEDA4" // rgb: 187, 237, 164

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition -= nutriment_factor
				if(M.nutrition < 0)//Prevent from going into negatives.
					M.nutrition = 0
				..()
				return

		soysauce
			name = "Soysauce"
			id = "soysauce"
			description = "A salty sauce made from the soy plant."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
			reagent_color = "#792300" // rgb: 121, 35, 0

		ketchup
			name = "Ketchup"
			id = "ketchup"
			description = "Ketchup, catsup, whatever. It's tomato paste."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			reagent_color = "#731008" // rgb: 115, 16, 8


		capsaicin
			name = "Capsaicin Oil"
			id = "capsaicin"
			description = "This is what makes chilis hot."
			reagent_state = LIQUID
			reagent_color = "#B31008" // rgb: 179, 16, 8

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.bodytemperature += 5 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(holder.has_reagent("frostoil"))
							holder.remove_reagent("frostoil", 5)
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature += rand(5,20)
					if(15 to 25)
						M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature += rand(10,20)
					if(25 to INFINITY)
						M.bodytemperature += 15 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature += rand(15,20)
				data++
				..()
				return

		condensedcapsaicin
			name = "Condensed Capsaicin"
			id = "condensedcapsaicin"
			description = "A chemical agent used for self-defense and in police work."
			reagent_state = LIQUID
			reagent_color = "#B31008" // rgb: 179, 16, 8

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.bodytemperature += 5 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(holder.has_reagent("frostoil"))
							holder.remove_reagent("frostoil", 5)
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature += rand(5,20)
					if(15 to 25)
						M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature += rand(10,20)
					if(25 to INFINITY)
						M.bodytemperature += 15 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature += rand(15,20)
				data++
				..()
				return

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(!istype(M, /mob/living))
					return
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						var/mob/living/carbon/human/victim = M
						var/mouth_covered = 0
						var/eyes_covered = 0
						var/obj/item/safe_thing = null
						if( victim.wear_mask )
							if ( victim.wear_mask.flags & MASKCOVERSEYES )
								eyes_covered = 1
								safe_thing = victim.wear_mask
							if ( victim.wear_mask.flags & MASKCOVERSMOUTH )
								mouth_covered = 1
								safe_thing = victim.wear_mask
						if( victim.head )
							if ( victim.head.flags & MASKCOVERSEYES )
								eyes_covered = 1
								safe_thing = victim.head
							if ( victim.head.flags & MASKCOVERSMOUTH )
								mouth_covered = 1
								safe_thing = victim.head
						if(victim.glasses)
							eyes_covered = 1
							if ( !safe_thing )
								safe_thing = victim.glasses
						if ( eyes_covered && mouth_covered )
							return
						else if(mouth_covered)	// Reduced effects if partially protected
							if(prob(10)) victim.emote("scream")
							victim.eye_blurry = max(M.eye_blurry, 4)
							victim.eye_blind = max(M.eye_blind, 1)
							victim.confused = max(M.confused, 4)
							victim.Weaken(2)
							victim.drop_item()
							return
						else if(eyes_covered) // Eye cover is better than mouth cover
							victim.eye_blurry = max(M.eye_blurry, 3)
							return
						else // Oh dear :D
							if(prob(20)) victim.emote("scream")
							victim.eye_blurry = max(M.eye_blurry, 8)
							victim.eye_blind = max(M.eye_blind, 2)
							victim.confused = max(M.confused, 8)
							victim.Weaken(5)
							victim.drop_item()

		frostoil
			name = "Frost Oil"
			id = "frostoil"
			description = "A special oil that noticably chills the body. Extraced from Icepeppers."
			reagent_state = LIQUID
			reagent_color = "#B31008" // rgb: 139, 166, 233

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.bodytemperature -= 5 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(holder.has_reagent("capsaicin"))
							holder.remove_reagent("capsaicin", 5)
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature -= rand(5,20)
					if(15 to 25)
						M.bodytemperature -= 10 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature -= rand(10,20)
					if(25 to INFINITY)
						M.bodytemperature -= 15 * TEMPERATURE_DAMAGE_COEFFICIENT
						if(prob(1)) M.emote("shiver")
						if(istype(M, /mob/living/carbon/slime))
							M.bodytemperature -= rand(15,20)
				data++
				..()
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				for(var/mob/living/carbon/slime/M in T)
					M.adjustToxLoss(rand(15,30))

		sodiumchloride
			name = "Table Salt"
			id = "sodiumchloride"
			description = "A salt made of sodium chloride. Commonly used to season food."
			reagent_state = SOLID
			reagent_color = "#FFFFFF" // rgb: 255,255,255

		blackpepper
			name = "Black Pepper"
			id = "blackpepper"
			description = "A powder ground from peppercorns. *AAAACHOOO*"
			reagent_state = SOLID
			// no reagent_color (ie, black)

		coco
			name = "Coco Powder"
			id = "coco"
			description = "A fatty, bitter paste made from coco beans."
			reagent_state = SOLID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			reagent_color = "#302000" // rgb: 48, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return

		hot_coco
			name = "Hot Chocolate"
			id = "hot_coco"
			description = "Made with love! And coco beans."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
			reagent_color = "#403010" // rgb: 64, 48, 16

			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.nutrition += nutriment_factor
				..()
				return

		psilocybin
			name = "Psilocybin"
			id = "psilocybin"
			description = "A strong psycotropic derived from certain species of mushroom."
			reagent_color = "#E700E7" // rgb: 231, 0, 231

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 30)
				if(!data) data = 1
				switch(data)
					if(1 to 5)
						if (!M.stuttering) M.stuttering = 1
						M.make_dizzy(5)
						if(prob(10)) M.emote(pick("twitch","giggle"))
					if(5 to 10)
						if (!M.stuttering) M.stuttering = 1
						M.make_jittery(10)
						M.make_dizzy(10)
						M.druggy = max(M.druggy, 35)
						if(prob(20)) M.emote(pick("twitch","giggle"))
					if (10 to INFINITY)
						if (!M.stuttering) M.stuttering = 1
						M.make_jittery(20)
						M.make_dizzy(20)
						M.druggy = max(M.druggy, 40)
						if(prob(30)) M.emote(pick("twitch","giggle"))
				holder.remove_reagent(src.id, 0.2)
				data++
				..()
				return

		sprinkles
			name = "Sprinkles"
			id = "sprinkles"
			description = "Multi-reagent_colored little bits of sugar, commonly found on donuts. Loved by cops."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#FF00FF" // rgb: 255, 0, 255

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden"))
					if(!M) M = holder.my_atom
					M.heal_organ_damage(1,1)
					M.nutrition += nutriment_factor
					..()
					return
				..()

		syndicream
			name = "Cream filling"
			id = "syndicream"
			description = "Delicious cream filling of a mysterious origin. Tastes criminally good."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#AB7878" // rgb: 171, 120, 120

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.mind)
					if(M.mind.special_role)
						if(!M) M = holder.my_atom
						M.heal_organ_damage(2,2)
						M.nutrition += nutriment_factor
						..()
						return
				..()

		cornoil
			name = "Corn Oil"
			id = "cornoil"
			description = "An oil derived from various types of corn."
			reagent_state = LIQUID
			nutriment_factor = 20 * REAGENTS_METABOLISM
			reagent_color = "#302000" // rgb: 48, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return
			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(volume >= 3)
					if(T.wet >= 1) return
					T.wet = 1
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					T.wet_overlay = image('icons/effects/water.dmi',T,"wet_floor")
					T.overlays += T.wet_overlay

					spawn(800)
						if (!istype(T)) return
						if(T.wet >= 2) return
						T.wet = 0
						if(T.wet_overlay)
							T.overlays -= T.wet_overlay
							T.wet_overlay = null
				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot)
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)

		enzyme
			name = "Universal Enzyme"
			id = "enzyme"
			description = "A universal enzyme used in the preperation of certain chemicals and foods."
			reagent_state = LIQUID
			reagent_color = "#365E30" // rgb: 54, 94, 48

		dry_ramen
			name = "Dry Ramen"
			id = "dry_ramen"
			description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#302000" // rgb: 48, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return

		hot_ramen
			name = "Hot Ramen"
			id = "hot_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in school."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			reagent_color = "#302000" // rgb: 48, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature + (10 * TEMPERATURE_DAMAGE_COEFFICIENT))
				..()
				return

		hell_ramen
			name = "Hell Ramen"
			id = "hell_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in school."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			reagent_color = "#302000" // rgb: 48, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
				..()
				return

		flour
			name = "flour"
			id = "flour"
			description = "This is what you rub all over yourself to pretend to be a ghost."
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#FFFFFF" // rgb: 0, 0, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/effect/decal/cleanable/flour(T)

		cherryjelly
			name = "Cherry Jelly"
			id = "cherryjelly"
			description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#801E28" // rgb: 128, 30, 40

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return

/////////////////////////////////////////////////////////DRINKS////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

		orangejuice
			name = "Orange juice"
			id = "orangejuice"
			description = "Both delicious AND rich in Vitamin C, what more do you need?"
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#E78108" // rgb: 231, 129, 8

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				if(M.getOxyLoss() && prob(30)) M.adjustOxyLoss(-1)
				M.nutrition++
				..()
				return

		tomatojuice
			name = "Tomato Juice"
			id = "tomatojuice"
			description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#731008" // rgb: 115, 16, 8

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				if(M.getFireLoss() && prob(20)) M.heal_organ_damage(0,1)
				M.nutrition++
				..()
				return

		limejuice
			name = "Lime Juice"
			id = "limejuice"
			description = "The sweet-sour juice of limes."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#365E30" // rgb: 54, 94, 48

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				if(M.getToxLoss() && prob(20)) M.adjustToxLoss(-1)
				M.nutrition++
				..()
				return

		carrotjuice
			name = "Carrot juice"
			id = "carrotjuice"
			description = "It is just like a carrot but without crunching."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#973800" // rgb: 151, 56, 0

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition += nutriment_factor
				M.eye_blurry = max(M.eye_blurry-1 , 0)
				M.eye_blind = max(M.eye_blind-1 , 0)
				if(!data) data = 1
				switch(data)
					if(1 to 20)
						M.eye_stat--
					if(21 to INFINITY)
						if (prob(data-15))
							M.disabilities &= ~BLIND
				data++
				..()
				return

		berryjuice
			name = "Berry Juice"
			id = "berryjuice"
			description = "A delicious blend of several different kinds of berries."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#863333" // rgb: 134, 51, 51

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition += nutriment_factor
				..()
				return

		poisonberryjuice
			name = "Poison Berry Juice"
			id = "poisonberryjuice"
			description = "A tasty juice blended from various kinds of very deadly and toxic berries."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#863353" // rgb: 134, 51, 83

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition += nutriment_factor
				M.adjustToxLoss(1)
				..()
				return

		watermelonjuice
			name = "Watermelon Juice"
			id = "watermelonjuice"
			description = "Delicious juice made from watermelon."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#863333" // rgb: 134, 51, 51

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition += nutriment_factor
				..()
				return

		lemonjuice
			name = "Lemon Juice"
			id = "lemonjuice"
			description = "This juice is VERY sour."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#863333" // rgb: 175, 175, 0

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.nutrition += nutriment_factor
				..()
				return

		banana
			name = "Banana Juice"
			id = "banana"
			description = "The raw essence of a banana. HONK"
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#863333" // rgb: 175, 175, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Clown"))
					if(!M) M = holder.my_atom
					M.heal_organ_damage(1,1)
					..()
					return
				if(istype(M, /mob/living/carbon/monkey))
					if(!M) M = holder.my_atom
					M.heal_organ_damage(1,1)
					..()
					return
				..()

		nothing
			name = "Nothing"
			id = "nothing"
			description = "Absolutely nothing."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				M.silent += 2

				if(istype(M, /mob/living/carbon/human) && M.job in list("Mime"))
					if(!M) M = holder.my_atom
					M.heal_organ_damage(1,1)
					..()
					return
				..()

		potato_juice
			name = "Potato Juice"
			id = "potato"
			description = "Juice of the potato. Bleh."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
			reagent_color = "#302000" // rgb: 48, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return

		milk
			name = "Milk"
			id = "milk"
			description = "An opaque white liquid produced by the mammary glands of mammals."
			reagent_state = LIQUID
			reagent_color = "#DFDFDF" // rgb: 223, 223, 223

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				if(holder.has_reagent("capsaicin"))
					holder.remove_reagent("capsaicin", 2)
				M.nutrition++
				..()
				return

		soymilk
			name = "Soy Milk"
			id = "soymilk"
			description = "An opaque white liquid made from soybeans."
			reagent_state = LIQUID
			reagent_color = "#DFDFC7" // rgb: 223, 223, 199

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				M.nutrition++
				..()
				return

		cream
			name = "Cream"
			id = "cream"
			description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#DFD7AF" // rgb: 223, 215, 175

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				..()
				return

		coffee
			name = "Coffee"
			id = "coffee"
			description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
			reagent_state = LIQUID
			reagent_color = "#482000" // rgb: 72, 32, 0

			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = max(0,M.sleeping - 2)
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature + (35 * TEMPERATURE_DAMAGE_COEFFICIENT))

				if(prob(20)) M.make_jittery(1)

				if(holder.has_reagent("frostoil"))
					holder.remove_reagent("frostoil", 5)
				..()
				return

		tea
			name = "Tea"
			id = "tea"
			description = "Tasty black tea, it has antioxidants, it's good for you!"
			reagent_state = LIQUID
			reagent_color = "#101000" // rgb: 16, 16, 0

			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-2)
				M.drowsyness = max(0,M.drowsyness-1)
				M.jitteriness = max(0,M.jitteriness-3)
				M.sleeping = max(0,M.sleeping-1)
				if(M.getToxLoss() && prob(20))
					M.adjustToxLoss(-1)
				if (M.bodytemperature < 310)  //310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature + (30 * TEMPERATURE_DAMAGE_COEFFICIENT))
				..()
				return

		icecoffee
			name = "Iced Coffee"
			id = "icecoffee"
			description = "Coffee and ice, refreshing and cool."
			reagent_state = LIQUID
			reagent_color = "#102838" // rgb: 16, 40, 56

			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = max(0,M.sleeping-2)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.make_jittery(5)
				..()
				return

		icetea
			name = "Iced Tea"
			id = "icetea"
			description = "No relation to a certain rap artist/ actor."
			reagent_state = LIQUID
			reagent_color = "#104038" // rgb: 16, 64, 56

			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-2)
				M.drowsyness = max(0,M.drowsyness-1)
				M.sleeping = max(0,M.sleeping-2)
				if(M.getToxLoss() && prob(20))
					M.adjustToxLoss(-1)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				return

		space_cola
			name = "Cola"
			id = "cola"
			description = "A refreshing beverage."
			reagent_state = LIQUID
			reagent_color = "#100800" // rgb: 16, 8, 0

			on_mob_life(var/mob/living/M as mob)
				M.drowsyness = max(0,M.drowsyness-5)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.nutrition += 1
				..()
				return

		nuka_cola
			name = "Nuka Cola"
			id = "nuka_cola"
			description = "Cola, cola never changes."
			reagent_state = LIQUID
			reagent_color = "#100800" // rgb: 16, 8, 0

			on_mob_life(var/mob/living/M as mob)
				M.make_jittery(20)
				M.druggy = max(M.druggy, 30)
				M.dizziness +=5
				M.drowsyness = 0
				M.sleeping = max(0,M.sleeping-2)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.nutrition += 1
				..()
				return

		spacemountainwind
			name = "Space Mountain Wind"
			id = "spacemountainwind"
			description = "Blows right through you like a space wind."
			reagent_state = LIQUID
			reagent_color = "#102000" // rgb: 16, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.drowsyness = max(0,M.drowsyness-7)
				M.sleeping = max(0,M.sleeping-1)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.make_jittery(5)
				M.nutrition += 1
				..()
				return

		dr_gibb
			name = "Dr. Gibb"
			id = "dr_gibb"
			description = "A delicious blend of 42 different flavours"
			reagent_state = LIQUID
			reagent_color = "#102000" // rgb: 16, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.drowsyness = max(0,M.drowsyness-6)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				M.nutrition += 1
				..()
				return

		space_up
			name = "Space-Up"
			id = "space_up"
			description = "Tastes like a hull breach in your mouth."
			reagent_state = LIQUID
			reagent_color = "#00FF00" // rgb: 0, 255, 0

			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (8 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				M.nutrition += 1
				..()
				return

		lemon_lime
			name = "Lemon Lime"
			description = "A tangy substance made of 0.5% natural citrus!"
			id = "lemon_lime"
			reagent_state = LIQUID
			reagent_color = "#8CFF00" // rgb: 135, 255, 0

			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (8 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				M.nutrition += 1
				..()
				return

		sodawater
			name = "Soda Water"
			id = "sodawater"
			description = "A can of club soda. Why not make a scotch and soda?"
			reagent_state = LIQUID
			reagent_color = "#619494" // rgb: 97, 148, 148

			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				..()
				return

		tonic
			name = "Tonic Water"
			id = "tonic"
			description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
			reagent_state = LIQUID
			reagent_color = "#0064C8" // rgb: 0, 100, 200

			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = max(0,M.sleeping-2)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				..()
				return

		ice
			name = "Ice"
			id = "ice"
			description = "Frozen water, your dentist wouldn't like you chewing this."
			reagent_state = SOLID
			reagent_color = "#619494" // rgb: 97, 148, 148

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.bodytemperature -= 5 * TEMPERATURE_DAMAGE_COEFFICIENT
				..()
				return

		soy_latte
			name = "Soy Latte"
			id = "soy_latte"
			description = "A nice and tasty beverage while you are reading your hippie books."
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = 0
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.make_jittery(5)
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				M.nutrition++
				..()
				return

		cafe_latte
			name = "Cafe Latte"
			id = "cafe_latte"
			description = "A nice, strong and tasty beverage while you are reading."
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = 0
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.make_jittery(5)
				if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
				M.nutrition++
				..()
				return

		doctor_delight
			name = "The Doctor's Delight"
			id = "doctorsdelight"
			description = "A gulp a day keeps the MediBot away. That's probably for the best."
			reagent_state = LIQUID
			reagent_color = "#FF8CFF" // rgb: 255, 140, 255

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.getOxyLoss() && prob(90)) M.adjustOxyLoss(-2)
				if(M.getBruteLoss() && prob(90)) M.heal_organ_damage(2,0)
				if(M.getFireLoss() && prob(90)) M.heal_organ_damage(0,2)
				if(M.getToxLoss() && prob(90)) M.adjustToxLoss(-2)
				if(M.dizziness !=0) M.dizziness = max(0,M.dizziness-15)
				if(M.confused !=0) M.confused = max(0,M.confused - 5)
				..()
				return

///////////////////////////////////////////////ALHO////////////////////////////////////////////////////////////
//////////////////////////////////////////////The ten friggen million reagents that get you drunk//////////////////////////////////////////////

		atomicbomb
			name = "Atomic Bomb"
			id = "atomicbomb"
			description = "Nuclear proliferation never tasted so good."
			reagent_state = LIQUID
			reagent_color = "#666300" // rgb: 102, 99, 0

			on_mob_life(var/mob/living/M as mob)
				M.druggy = max(M.druggy, 50)
				M.confused = max(M.confused+2,0)
				M.make_dizzy(10)
				if (!M.stuttering) M.stuttering = 1
				M.stuttering += 3
				if(!data) data = 1
				data++
				switch(data)
					if(51 to INFINITY)
						M.sleeping += 1
				..()
				return

		gargle_blaster
			name = "Pan-Galactic Gargle Blaster"
			id = "gargleblaster"
			description = "Whoah, this stuff looks volatile!"
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				M.dizziness +=6
				if(data >= 15 && data <45)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 45 && prob(50) && data <55)
					M.confused = max(M.confused+3,0)
				else if(data >=55)
					M.druggy = max(M.druggy, 55)
				..()
				return

		neurotoxin
			name = "Neurotoxin"
			id = "neurotoxin"
			description = "A strong neurotoxin that puts the subject into a death-like state."
			reagent_state = LIQUID
			reagent_color = "#2E2E61" // rgb: 46, 46, 97

			on_mob_life(var/mob/living/carbon/M as mob)
				if(!M) M = holder.my_atom
				if(!M.weakened)
					M << "<span class='danger'>Your muscles begin to painfully tighten.</span>"
				M.weakened = max(M.weakened, 6)
				if(!data) data = 1
				data++
				M.dizziness +=6
				if(data >= 15 && data <45)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 45 && prob(50) && data <55)
					M.confused = max(M.confused+3,0)
				else if(data >=55)
					M.druggy = max(M.druggy, 55)
				..()
				return

		hippies_delight
			name = "Hippie's Delight"
			id = "hippiesdelight"
			description = "You just don't get it maaaan."
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 50)
				if(!data) data = 1
				data++
				switch(data)
					if(1 to 5)
						if (!M.stuttering) M.stuttering = 1
						M.make_dizzy(10)
						if(prob(10)) M.emote(pick("twitch","giggle"))
					if(5 to 10)
						if (!M.stuttering) M.stuttering = 1
						M.make_jittery(20)
						M.make_dizzy(20)
						M.druggy = max(M.druggy, 45)
						if(prob(20)) M.emote(pick("twitch","giggle"))
					if (10 to INFINITY)
						if (!M.stuttering) M.stuttering = 1
						M.make_jittery(40)
						M.make_dizzy(40)
						M.druggy = max(M.druggy, 60)
						if(prob(30)) M.emote(pick("twitch","giggle"))
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		ethanol
			name = "Ethanol"
			id = "ethanol"
			description = "A well-known alcohol with a variety of applications."
			reagent_state = LIQUID
			reagent_color = "#404030" // rgb: 64, 64, 48
			var/boozepwr = 35 //lower numbers mean the booze will have an effect faster.

			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				M.jitteriness = max(M.jitteriness-5,0)
				if(data >= boozepwr)
					if (!M.intoxicated) M.intoxicated = 1
					M.intoxicated += 4
					M.make_dizzy(5)
				if(data >= boozepwr*2.5 && prob(33))
					if (!M.confused) M.confused = 1
					M.confused += 3
				..()
				return

		ethanol/beer
			name = "Beer"
			id = "beer"
			description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 55

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += 1
				..()
				return

		ethanol/kahlua
			name = "Kahlua"
			id = "kahlua"
			description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = max(0,M.sleeping-2)
				M.make_jittery(5)
				..()
				return

		ethanol/whiskey
			name = "Whiskey"
			id = "whiskey"
			description = "A superb and well-aged single-malt whiskey. Damn."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/thirteenloko
			name = "Thirteen Loko"
			id = "thirteenloko"
			description = "A potent mixture of caffeine and alcohol."
			reagent_color = "#102000" // rgb: 16, 32, 0

			on_mob_life(var/mob/living/M as mob)
				M.drowsyness = max(0,M.drowsyness-7)
				M.sleeping = max(0,M.sleeping-2)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
				M.make_jittery(5)
				M.nutrition += 1
				..()
				return

		ethanol/vodka
			name = "Vodka"
			id = "vodka"
			description = "Number one drink AND fueling choice for Russians worldwide."
			reagent_color = "#0064C8" // rgb: 0, 100, 200

			on_mob_life(var/mob/living/M as mob)
				M.radiation = max(M.radiation-2,0)
				..()
				return

		ethanol/holywater
			name = "Holy Water"
			id = "holywater"
			description = "Water blessed by some deity."
			reagent_color = "#E0E8EF" // rgb: 224, 232, 239
			boozepwr = 15

		ethanol/bilk
			name = "Bilk"
			id = "bilk"
			description = "This appears to be beer mixed with milk. Disgusting."
			reagent_color = "#895C4C" // rgb: 137, 92, 76

			on_mob_life(var/mob/living/M as mob)
				if(M.getBruteLoss() && prob(10)) M.heal_organ_damage(1,0)
				M.nutrition += 2
				..()
				return

		ethanol/threemileisland
			name = "Three Mile Island Iced Tea"
			id = "threemileisland"
			description = "Made for a woman, strong enough for a man."
			reagent_color = "#666340" // rgb: 102, 99, 64

			on_mob_life(var/mob/living/M as mob)
				M.druggy = max(M.druggy, 50)
				..()
				return

		ethanol/gin
			name = "Gin"
			id = "gin"
			description = "It's gin. In space. I say, good sir."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/rum
			name = "Rum"
			id = "rum"
			description = "Yohoho and all that."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/tequilla
			name = "Tequila"
			id = "tequilla"
			description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
			reagent_color = "#FFFF91" // rgb: 255, 255, 145

		ethanol/vermouth
			name = "Vermouth"
			id = "vermouth"
			description = "You suddenly feel a craving for a martini..."
			reagent_color = "#91FF91" // rgb: 145, 255, 145

		ethanol/wine
			name = "Wine"
			id = "wine"
			description = "An premium alchoholic beverage made from distilled grape juice."
			reagent_color = "#7E4043" // rgb: 126, 64, 67

		ethanol/cognac
			name = "Cognac"
			id = "cognac"
			description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
			reagent_color = "#AB3C05" // rgb: 171, 60, 5

		ethanol/hooch
			name = "Hooch"
			id = "hooch"
			description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 35

		ethanol/ale
			name = "Ale"
			id = "ale"
			description = "A dark alchoholic beverage made by malted barley and yeast."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/goldschlager
			name = "Goldschlager"
			id = "goldschlager"
			description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
			reagent_color = "#FFFF91" // rgb: 255, 255, 145

		ethanol/patron
			name = "Patron"
			id = "patron"
			description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
			reagent_color = "#585840" // rgb: 88, 88, 64

		ethanol/gintonic
			name = "Gin and Tonic"
			id = "gintonic"
			description = "An all time classic, mild cocktail."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 65

		ethanol/cuba_libre
			name = "Cuba Libre"
			id = "cubalibre"
			description = "Rum, mixed with cola. Viva la revolution."
			reagent_color = "#3E1B00" // rgb: 62, 27, 0

		ethanol/whiskey_cola
			name = "Whiskey Cola"
			id = "whiskeycola"
			description = "Whiskey, mixed with cola. Surprisingly refreshing."
			reagent_color = "#3E1B00" // rgb: 62, 27, 0
			boozepwr = 65

		ethanol/martini
			name = "Classic Martini"
			id = "martini"
			description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/vodkamartini
			name = "Vodka Martini"
			id = "vodkamartini"
			description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/white_russian
			name = "White Russian"
			id = "whiterussian"
			description = "That's just, like, your opinion, man..."
			reagent_color = "#A68340" // rgb: 166, 131, 64
			boozepwr = 55

		ethanol/screwdrivercocktail
			name = "Screwdriver"
			id = "screwdrivercocktail"
			description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
			reagent_color = "#A68310" // rgb: 166, 131, 16
			boozepwr = 55

		ethanol/booger
			name = "Booger"
			id = "booger"
			description = "Ewww..."
			reagent_color = "#8CFF8C" // rgb: 140, 255, 140
			boozepwr = 55

		ethanol/bloody_mary
			name = "Bloody Mary"
			id = "bloodymary"
			description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 55

		ethanol/brave_bull
			name = "Brave Bull"
			id = "bravebull"
			description = "It's just as effective as Dutch-Courage!."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/tequilla_sunrise
			name = "Tequila Sunrise"
			id = "tequillasunrise"
			description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
			reagent_color = "#FFE48C" // rgb: 255, 228, 140
			boozepwr = 55

		ethanol/toxins_special
			name = "Toxins Special"
			id = "toxinsspecial"
			description = "This thing is ON FIRE!. CALL THE DAMN SHUTTLE!"
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 330)
					M.bodytemperature = min(330, M.bodytemperature + (15 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				..()
				return

		ethanol/beepsky_smash
			name = "Beepsky Smash"
			id = "beepskysmash"
			description = "Deny drinking this and prepare for THE LAW."
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				M.Stun(2)
				..()
				return

		ethanol/irish_cream
			name = "Irish Cream"
			id = "irishcream"
			description = "Whiskey-imbued cream, what else would you expect from the Irish."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/manly_dorf
			name = "The Manly Dorf"
			id = "manlydorf"
			description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 10

		ethanol/longislandicedtea
			name = "Long Island Iced Tea"
			id = "longislandicedtea"
			description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 55

		ethanol/moonshine
			name = "Moonshine"
			id = "moonshine"
			description = "You've really hit rock bottom now... your liver packed its bags and left last night."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 25

		ethanol/b52
			name = "B-52"
			id = "b52"
			description = "Coffee, Irish Cream, and cognac. You will get bombed."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 25

		ethanol/irishcoffee
			name = "Irish Coffee"
			id = "irishcoffee"
			description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 55

		ethanol/margarita
			name = "Margarita"
			id = "margarita"
			description = "On the rocks with salt on the rim. Arriba~!"
			reagent_color = "#8CFF8C" // rgb: 140, 255, 140
			boozepwr = 55

		ethanol/black_russian
			name = "Black Russian"
			id = "blackrussian"
			description = "For the lactose-intolerant. Still as classy as a White Russian."
			reagent_color = "#360000" // rgb: 54, 0, 0
			boozepwr = 55

		ethanol/manhattan
			name = "Manhattan"
			id = "manhattan"
			description = "The Detective's undercover drink of choice. He never could stomach gin..."
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 55

		ethanol/manhattan_proj
			name = "Manhattan Project"
			id = "manhattan_proj"
			description = "A scientist's drink of choice, for pondering ways to blow up the station."
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				M.druggy = max(M.druggy, 30)
				..()
				return

		ethanol/whiskeysoda
			name = "Whiskey Soda"
			id = "whiskeysoda"
			description = "For the more refined griffon."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/antifreeze
			name = "Anti-freeze"
			id = "antifreeze"
			description = "Ultimate refreshment."
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 330)
					M.bodytemperature = min(330, M.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				..()
				return

		ethanol/barefoot
			name = "Barefoot"
			id = "barefoot"
			description = "Barefoot and pregnant"
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/snowwhite
			name = "Snow White"
			id = "snowwhite"
			description = "A cold refreshment"
			reagent_color = "#FFFFFF" // rgb: 255, 255, 255

		ethanol/demonsblood
			name = "Demons Blood"
			id = "demonsblood"
			description = "AHHHH!!!!"
			reagent_color = "#820000" // rgb: 130, 0, 0

		ethanol/vodkatonic
			name = "Vodka and Tonic"
			id = "vodkatonic"
			description = "For when a gin and tonic isn't russian enough."
			reagent_color = "#0064C8" // rgb: 0, 100, 200

		ethanol/ginfizz
			name = "Gin Fizz"
			id = "ginfizz"
			description = "Refreshingly lemony, deliciously dry."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/bahama_mama
			name = "Bahama mama"
			id = "bahama_mama"
			description = "Tropical cocktail."
			reagent_color = "#FF7F3B" // rgb: 255, 127, 59

		ethanol/singulo
			name = "Singulo"
			id = "singulo"
			description = "A blue-space beverage!"
			reagent_color = "#2E6671" // rgb: 46, 102, 113

		ethanol/sbiten
			name = "Sbiten"
			id = "sbiten"
			description = "A spicy Vodka! Might be a little hot for the little guys!"
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 360)
					M.bodytemperature = min(360, M.bodytemperature + (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				..()
				return

		ethanol/devilskiss
			name = "Devils Kiss"
			id = "devilskiss"
			description = "Creepy time!"
			reagent_color = "#A68310" // rgb: 166, 131, 16

		ethanol/red_mead
			name = "Red Mead"
			id = "red_mead"
			description = "The true Viking drink! Even though it has a strange red reagent_color."
			reagent_color = "#C73C00" // rgb: 199, 60, 0

		ethanol/mead
			name = "Mead"
			id = "mead"
			description = "A Vikings drink, though a cheap one."
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += 1
				..()
				return

		ethanol/iced_beer
			name = "Iced Beer"
			id = "iced_beer"
			description = "A beer which is so cold the air around it freezes."
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				if(M.bodytemperature > 270)
					M.bodytemperature = max(270, M.bodytemperature - (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
				..()
				return

		ethanol/grog
			name = "Grog"
			id = "grog"
			description = "Watered down rum, Nanotrasen approves!"
			reagent_color = "#664300" // rgb: 102, 67, 0
			boozepwr = 90

		ethanol/aloe
			name = "Aloe"
			id = "aloe"
			description = "So very, very, very good."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/andalusia
			name = "Andalusia"
			id = "andalusia"
			description = "A nice, strange named drink."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/alliescocktail
			name = "Allies Cocktail"
			id = "alliescocktail"
			description = "A drink made from your allies, not as sweet as when made from your enemies."
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/acid_spit
			name = "Acid Spit"
			id = "acidspit"
			description = "A drink for the daring, can be deadly if incorrectly prepared!"
			reagent_state = LIQUID
			reagent_color = "#365000" // rgb: 54, 80, 0

		ethanol/amasec
			name = "Amasec"
			id = "amasec"
			description = "Official drink of the Nanotrasen Gun-Club!"
			reagent_state = LIQUID
			reagent_color = "#664300" // rgb: 102, 67, 0

		ethanol/changelingsting
			name = "Changeling Sting"
			id = "changelingsting"
			description = "You take a tiny sip and feel a burning sensation..."
			reagent_color = "#2E6671" // rgb: 46, 102, 113

			on_mob_life(var/mob/living/M as mob)
				if(!M.weakened)
					M << "<span class='danger'>Your muscles begin to painfully tighten.</span>"
				M.weakened = max(M.weakened, 4)

		ethanol/irishcarbomb
			name = "Irish Car Bomb"
			id = "irishcarbomb"
			description = "Mmm, tastes like chocolate cake..."
			reagent_color = "#2E6671" // rgb: 46, 102, 113

		ethanol/syndicatebomb
			name = "Syndicate Bomb"
			id = "syndicatebomb"
			description = "Tastes like terrorism!"
			reagent_color = "#2E6671" // rgb: 46, 102, 113

		ethanol/erikasurprise
			name = "Erika Surprise"
			id = "erikasurprise"
			description = "The surprise is, it's green!"
			reagent_color = "#2E6671" // rgb: 46, 102, 113

		ethanol/driestmartini
			name = "Driest Martini"
			id = "driestmartini"
			description = "Only for the experienced. You think you see sand floating in the glass."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#2E6671" // rgb: 46, 102, 113
			boozepwr = 25

		ethanol/bananahonk
			name = "Banana Mama"
			id = "bananahonk"
			description = "A drink from Clown Heaven."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#FFFF91" // rgb: 255, 255, 140

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Clown") || istype(M, /mob/living/carbon/monkey))
					if(!M) M = holder.my_atom
					M.heal_organ_damage(1,1)
				..()
				return

		ethanol/silencer
			name = "Silencer"
			id = "silencer"
			description = "A drink from Mime Heaven."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			reagent_color = "#664300" // rgb: 102, 67, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor

				M.silent += 2

				if(istype(M, /mob/living/carbon/human) && M.job in list("Mime"))
					if(!M) M = holder.my_atom
					M.heal_organ_damage(1,1)
					..()
					return