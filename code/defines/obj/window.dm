/obj/structure/window
	name = "window"
	icon = 'structures.dmi'
	icon_state = "window"
	desc = "A window."
	density = 1
	var/health = 14.0
	var/ini_dir = null
	var/state = 0
	var/reinf = 0
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER

// Prefab windows to make it easy...

// Basic

/obj/structure/window/basic/north
	dir = NORTH

/obj/structure/window/basic/east
	dir = EAST

/obj/structure/window/basic/west
	dir = WEST

/obj/structure/window/basic/south
	dir = SOUTH

/obj/structure/window/basic/northwest
	dir = NORTHWEST

/obj/structure/window/basic/northeast
	dir = NORTHEAST

/obj/structure/window/basic/southwest
	dir = SOUTHWEST

/obj/structure/window/basic/southeast
	dir = SOUTHEAST

// Pod
/obj/structure/window_pod
	name = "window"
	icon = 'shuttle.dmi'
	icon_state = "window1"
	desc = "A thick window secured into its frame."
	dir = 2
	anchored = 1
	density = 1

/obj/structure/window_pod/CanPass(atom/movable/mover, turf/source, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	return 0

/obj/structure/window_pod/attack_hand()
	return

/obj/structure/window_pod/attack_paw()
	return

/obj/structure/window_pod/blob_act()
	return

/obj/structure/window_pod/ex_act(severity)
	return

/obj/structure/window_pod/hitby(AM as mob|obj)
	..()
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	playsound(src.loc, 'Glasshit.ogg', 100, 1)
	return

/obj/structure/window/meteorhit()
	return

/obj/structure/window_pod/Move()
	return 0

// Reinforced

/obj/structure/window/reinforced
	reinf = 1
	explosionstrength = 1
	icon_state = "rwindow"
	name = "reinforced window"

/obj/structure/window/reinforced/north
	dir = NORTH

/obj/structure/window/reinforced/east
	dir = EAST

/obj/structure/window/reinforced/west
	dir = WEST

/obj/structure/window/reinforced/south
	dir = SOUTH

/obj/structure/window/reinforced/northwest
	dir = NORTHWEST

/obj/structure/window/reinforced/northeast
	dir = NORTHEAST

/obj/structure/window/reinforced/southwest
	dir = SOUTHWEST

/obj/structure/window/reinforced/southeast
	dir = SOUTHEAST
/*/obj/structure/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/pressure = air.return_pressure() //DERP22
	if(pressure >= 200)
		del src
*/