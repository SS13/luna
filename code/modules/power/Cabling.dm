/obj/cabling/power
	icon = 'power_cond.dmi'

	name = "power cable"

	ConnectableTypes = list(/obj/machinery/power, /obj/structure/grille)
	NetworkControllerType = /datum/UnifiedNetworkController/PowernetController
	DropCablePieceType = /obj/item/weapon/cable_coil
	EquivalentCableType = /obj/cabling/power

/obj/item/weapon/cable_coil/power
	icon_state = "redcoil3"
	CoilColour = "red"
	BaseName  = "Electrical"
	CableType = /obj/cabling/power