/**********************Input and output plates**************************/

/obj/machinery/mineral
	icon = 'icons/obj/machines/mining_machines.dmi'
	density = 1
	anchored = 1
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null

/obj/machinery/mineral/input
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	name = "Input area"
	density = 0
	New()
		icon_state = "blank"

/obj/machinery/mineral/output
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x"
	name = "Output area"
	density = 0
	New()
		icon_state = "blank"