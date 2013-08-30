/obj/item/device/radio/electropack
	name = "Electropack"
	desc = "Dance my monkeys! DANCE!!!"
	icon_state = "electropack0"
	var/code = 2
	var/on = 0
	var/e_pads = 0.0
	frequency = 1449
	w_class = 5.0
	flags = 323
	item_state = "electropack"

/obj/item/device/radio/signaler
	name = "Remote Signaling Device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaler"
	w_class = 1
	frequency = 1457

/obj/item/device/radio/intercom
	name = "Station Intercom (Radio)"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = 1
	var/number = 0
	var/anyai = 1
	var/mob/living/silicon/ai/ai = list()