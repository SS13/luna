/**********************Light************************/

//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light-emtter"
	anchored = 1
	unacidable = 1
	luminosity = 8

/*****************************Pickaxe********************************/

/obj/item/weapon/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/items.dmi'
	icon_state = "pickaxe"
	flags = FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	force = 12.0
	throwforce = 4.0
	item_state = "pickaxe"
	w_class = 4.0
	m_amt = 3750 //one sheet, but where can you make them?
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("hit", "pierced", "sliced", "attacked")

	hammer
		name = "sledgehammer"
		//icon_state = "sledgehammer" Waiting on sprite
		desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."

	silver
		name = "silver pickaxe"
		icon_state = "spickaxe"
		item_state = "spickaxe"
		digspeed = 30
		origin_tech = "materials=3"
		desc = "This makes no metallurgic sense."

	drill
		name = "mining drill" // Can dig sand as well!
		icon_state = "handdrill"
		item_state = "jackhammer"
		digspeed = 30
		force = 15
		slash = 1
		origin_tech = "materials=2;powerstorage=3;engineering=2"
		desc = "Yours is the drill that will pierce through the rock walls."

	jackhammer
		name = "sonic jackhammer"
		icon_state = "jackhammer"
		item_state = "jackhammer"
		force = 17
		slash = 1
		digspeed = 20 //faster than drill, but cannot dig
		origin_tech = "materials=3;powerstorage=2;engineering=2"
		desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."

	gold
		name = "golden pickaxe"
		icon_state = "gpickaxe"
		item_state = "gpickaxe"
		digspeed = 20
		origin_tech = "materials=4"
		desc = "This makes no metallurgic sense."

	diamond
		name = "diamond pickaxe"
		icon_state = "dpickaxe"
		item_state = "dpickaxe"
		digspeed = 10
		origin_tech = "materials=6;engineering=4"
		desc = "A pickaxe with a diamond pick head, this is just like minecraft."

	diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
		name = "diamond mining drill"
		icon_state = "diamonddrill"
		item_state = "jackhammer"
		digspeed = 5 //Digs through walls, girders, and can dig up sand
		force = 20.0
		slash = 1
		origin_tech = "materials=6;powerstorage=4;engineering=5"
		desc = "Yours is the drill that will pierce the heavens!"

	borgdrill
		name = "cyborg mining drill"
		icon_state = "diamonddrill"
		item_state = "jackhammer"
		digspeed = 15
		slash = 1
		desc = ""

/*****************************Shovel********************************/

/obj/item/weapon/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	flags = FPRINT| CONDUCT
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	slash = 1
	w_class = 3.0
	m_amt = 50
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")

/obj/item/weapon/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5.0
	throwforce = 7.0
	w_class = 2.0




