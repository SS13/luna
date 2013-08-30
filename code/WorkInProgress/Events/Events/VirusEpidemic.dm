/datum/event/viralinfection
	Announce()
		for(var/mob/living/carbon/human/H in world)

			var/virus_type = pick(/datum/disease/advance/flu, /datum/disease/advance/cold, /datum/disease/advance/heal)
			var/foundAlready = 0	// don't infect someone that already has the virus

			for(var/datum/disease/D in H.viruses)
				foundAlready = 1
				break
			if(H.stat == DEAD || foundAlready || prob(70))
				continue

			var/datum/disease/advance/D = new virus_type()
			D.SetSpread(pick(CONTACT_GENERAL, AIRBORNE))
			D.Evolve(2)

			if(prob(90)) D.Evolve(2)
			if(prob(80)) D.Evolve(3)
			if(prob(70)) D.Evolve(4)
			if(prob(60)) D.Evolve(5)
			if(prob(50)) D.Evolve(6)

			D.Devolve()

			H.contract_disease(D)

			if(prob(90))
				command_alert("An unknown virus has been detected onboard the ship.", "Virus Alert")
			break
	Tick()
		ActiveFor = Lifetime //killme