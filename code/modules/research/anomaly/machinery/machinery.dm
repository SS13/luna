/obj/machinery/artifact_device
	icon = 'icons/obj/machines/research.dmi'
	var/open = 0

/obj/machinery/artifact_device/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
		return

	if(stat & NOPOWER)
		icon_state = initial(icon_state) + "_nopower"
		return

	icon_state = initial(icon_state)

/obj/machinery/artifact_device/power_change()
	..()
	sleep(rand(1, 15))
	update_icon()