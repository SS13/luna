/obj/machinery/power/proc/GetPowernet()
	var/datum/UnifiedNetwork/Network = Networks[/obj/cabling/power]
	if (!Network)
		return null
	return Network.Controller

/obj/machinery/power/proc/AddPower(var/amount)
	var/datum/UnifiedNetworkController/PowernetController/Controller = GetPowernet()
	if (!Controller)
		return
	Controller.SupplyPower(amount)
	return

/obj/machinery/power/proc/AddLoad(var/amount)
	var/datum/UnifiedNetworkController/PowernetController/Controller = GetPowernet()
	if (!Controller)
		return
	Controller.DrawPower(amount)
	return

/obj/machinery/power/proc/Surplus()
	var/datum/UnifiedNetworkController/PowernetController/Controller = GetPowernet()
	if (!Controller)
		return 0
	return Controller.SurplusPower()

/obj/machinery/power/proc/PowerAvailable()
	var/datum/UnifiedNetworkController/PowernetController/Controller = GetPowernet()
	if (!Controller)
		return 0
	return Controller.OldPower

